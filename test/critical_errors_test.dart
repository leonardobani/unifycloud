import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_error.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';

class MockRcloneService extends Fake implements RcloneService {
  final List<TransferJob> _jobs = [];
  int _counter = 0;

  @override
  Future<List<TransferJob>> getAllTransfers() async => List.unmodifiable(_jobs);

  @override
  Future<TransferJob> startTransfer({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    _counter++;
    final job = TransferJob(
      id: 'job_$_counter',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
      status: TransferStatus.running,
      totalBytes: 1000,
    );
    _jobs.add(job);
    return job;
  }

  void failJob(String id, String error) {
    final idx = _jobs.indexWhere((j) => j.id == id);
    if (idx != -1) {
      _jobs[idx] = _jobs[idx].copyWith(
        status: TransferStatus.failed,
        error: error,
      );
    }
  }

  @override
  Future<bool> cancelTransfer(String jobId) async {
    final idx = _jobs.indexWhere((j) => j.id == jobId);
    if (idx != -1) {
      _jobs[idx] = _jobs[idx].copyWith(status: TransferStatus.cancelled);
      return true;
    }
    return false;
  }

  @override
  Future<void> clearCompletedTransfers() async {
    _jobs.removeWhere((j) => !j.isActive);
  }
}

void main() {
  group('Critical Errors Classification (CloudErrorType)', () {
    test('Classifies network disconnection and timeout errors correctly', () {
      final samples = [
        'dial tcp: lookup oauth2.googleapis.com: no such host',
        'read tcp 192.168.1.5:43212->142.250.180.170:443: i/o timeout',
        'connect: connection refused',
        'SocketException: OS Error: Network is unreachable, errno = 101',
        'context deadline exceeded (Client.Timeout exceeded while awaiting headers)',
        'failed host lookup: drive.google.com',
      ];

      for (final error in samples) {
        final classified = CloudErrorType.fromError(error);
        expect(
          classified,
          equals(CloudErrorType.network),
          reason: 'Failed for error message: $error',
        );
        expect(classified.canRetry, isTrue);
        expect(classified.userFriendlyMessage, contains('Connessione assente'));
      }
    });

    test('Classifies disk space and storage quota errors correctly', () {
      final samples = [
        'write /home/user/Downloads/big_file.zip: no space left on device',
        'failed to write chunk: ENOSPC',
        'Google Drive API error: storage quota exceeded for user',
        'insufficient storage to complete operation',
        'device disk full, cannot allocate 1048576 bytes',
      ];

      for (final error in samples) {
        final classified = CloudErrorType.fromError(error);
        expect(
          classified,
          equals(CloudErrorType.diskSpace),
          reason: 'Failed for error message: $error',
        );
        expect(classified.canRetry, isFalse);
        expect(classified.userFriendlyMessage, contains('insufficiente'));
      }
    });

    test('Classifies revoked or expired auth tokens correctly', () {
      final samples = [
        'oauth2: cannot fetch token: 400 Bad Request Response: {"error": "invalid_grant"}',
        'token has been revoked by the user or administrator',
        'HTTP 401 Unauthorized: token expired',
        'dropbox api: access denied, re-authenticate account',
      ];

      for (final error in samples) {
        final classified = CloudErrorType.fromError(error);
        expect(
          classified,
          equals(CloudErrorType.authExpired),
          reason: 'Failed for error message: $error',
        );
        expect(classified.canRetry, isFalse);
        expect(classified.userFriendlyMessage, contains('Riconnetti'));
      }
    });

    test('Classifies not found, permission denied, and generic errors', () {
      expect(
        CloudErrorType.fromError('directory not found on remote'),
        equals(CloudErrorType.notFound),
      );
      expect(
        CloudErrorType.fromError('403 Forbidden: access denied to resource'),
        equals(CloudErrorType.permissionDenied),
      );
      expect(
        CloudErrorType.fromError('unexpected nil pointer in backend logic'),
        equals(CloudErrorType.generic),
      );
    });
  });

  group('TransferJob Error Getters', () {
    test('TransferJob exposes correct error classification and retry hints', () {
      final networkJob = TransferJob(
        id: 'job_net',
        srcRemote: 'gdrive',
        srcPath: 'docs/test.pdf',
        dstRemote: '',
        dstPath: '/local/test.pdf',
        status: TransferStatus.failed,
        error: 'dial tcp: i/o timeout while downloading',
      );

      expect(networkJob.errorType, equals(CloudErrorType.network));
      expect(networkJob.canRetry, isTrue);
      expect(networkJob.friendlyErrorMessage, contains('Connessione assente'));

      final quotaJob = TransferJob(
        id: 'job_disk',
        srcRemote: 'gdrive',
        srcPath: 'movies/video.mkv',
        dstRemote: '',
        dstPath: '/local/video.mkv',
        status: TransferStatus.failed,
        error: 'write /local/video.mkv: no space left on device',
      );

      expect(quotaJob.errorType, equals(CloudErrorType.diskSpace));
      expect(quotaJob.canRetry, isFalse);
      expect(quotaJob.friendlyErrorMessage, contains('insufficiente'));

      final authJob = TransferJob(
        id: 'job_auth',
        srcRemote: 'onedrive',
        srcPath: 'sheet.xlsx',
        dstRemote: '',
        dstPath: '/local/sheet.xlsx',
        status: TransferStatus.failed,
        error: 'invalid_grant: refresh token expired',
      );

      expect(authJob.errorType, equals(CloudErrorType.authExpired));
      expect(authJob.canRetry, isFalse);
      expect(authJob.friendlyErrorMessage, contains('Riconnetti'));
    });
  });

  group('TransferNotifier Retry Functionality', () {
    test('retryTransfer restarts a failed job with identical parameters', () async {
      final mockRclone = MockRcloneService();
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(mockRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);

      // Start initial job
      final job = await notifier.startTransfer(
        srcRemote: 'gdrive',
        srcPath: 'photos/vacation.jpg',
        dstRemote: 'dropbox',
        dstPath: 'backup/vacation.jpg',
        isMove: true,
      );

      expect(job.id, equals('job_1'));

      // Fail the job with network error
      mockRclone.failJob('job_1', 'no such host: connectivity lost');
      await notifier.loadTransfers();

      final stateAfterFailure = container.read(transferProvider);
      final failedJob = stateAfterFailure.transfers.first;
      expect(failedJob.status, equals(TransferStatus.failed));
      expect(failedJob.canRetry, isTrue);

      // Retry the transfer
      final retriedJob = await notifier.retryTransfer(failedJob.id);
      expect(retriedJob, isNotNull);
      expect(retriedJob!.id, equals('job_2'));
      expect(retriedJob.srcRemote, equals('gdrive'));
      expect(retriedJob.srcPath, equals('photos/vacation.jpg'));
      expect(retriedJob.dstRemote, equals('dropbox'));
      expect(retriedJob.dstPath, equals('backup/vacation.jpg'));
      expect(retriedJob.isMove, isTrue);
      expect(retriedJob.status, equals(TransferStatus.running));
    });

    test('retryTransfer returns null for non-existent job', () async {
      final mockRclone = MockRcloneService();
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(mockRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final res = await notifier.retryTransfer('non_existent_id');
      expect(res, isNull);
    });
  });
}
