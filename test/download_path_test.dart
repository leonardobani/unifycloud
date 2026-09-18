import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';

class FakeRcloneService extends RcloneService {
  final List<Map<String, dynamic>> recordedCalls = [];

  @override
  Future<List<TransferJob>> getAllTransfers() async => [];

  @override
  Future<TransferJob> startTransfer({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    recordedCalls.add({
      'srcRemote': srcRemote,
      'srcPath': srcPath,
      'dstRemote': dstRemote,
      'dstPath': dstPath,
      'isMove': isMove,
    });

    return TransferJob(
      id: 'job_test_${recordedCalls.length}',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
      status: TransferStatus.queued,
      bytes: 0,
      totalBytes: 1024,
      percentage: 0,
      speed: 0,
      eta: 0,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Custom Download Path Integration in TransferNotifier', () {
    late Directory tempBaseDir;
    late FakeRcloneService fakeRclone;

    setUp(() async {
      tempBaseDir = await Directory.systemTemp.createTemp('unify_download_test_');
      fakeRclone = FakeRcloneService();
    });

    tearDown(() async {
      if (tempBaseDir.existsSync()) {
        try {
          tempBaseDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('downloadFile uses settingsProvider.customDownloadPath when configured',
        () async {
      final customDir = Directory(p.join(tempBaseDir.path, 'MyCustomDownloads'));
      expect(customDir.existsSync(), isFalse);

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              AppSettings(customDownloadPath: customDir.path),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final job = await notifier.downloadFile(
        srcRemote: 'GoogleDrive',
        srcPath: 'Documents/Report.pdf',
      );

      // Verify directory was created on disk
      expect(customDir.existsSync(), isTrue);

      // Verify destination path was joined with filename
      final expectedDstPath = p.join(customDir.path, 'Report.pdf');
      expect(job.dstPath, equals(expectedDstPath));

      // Verify fake rclone received correct parameters
      expect(fakeRclone.recordedCalls, hasLength(1));
      expect(fakeRclone.recordedCalls.first['srcRemote'], equals('GoogleDrive'));
      expect(fakeRclone.recordedCalls.first['srcPath'], equals('Documents/Report.pdf'));
      expect(fakeRclone.recordedCalls.first['dstRemote'], equals(''));
      expect(fakeRclone.recordedCalls.first['dstPath'], equals(expectedDstPath));
    });

    test('downloadFile falls back to system download path when customDownloadPath is null',
        () async {
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings(customDownloadPath: null)),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final job = await notifier.downloadFile(
        srcRemote: 'Dropbox',
        srcPath: '/Photos/Vacation.jpg',
      );

      expect(fakeRclone.recordedCalls, hasLength(1));
      expect(job.dstPath, endsWith('Vacation.jpg'));
      expect(job.srcRemote, equals('Dropbox'));
    });

    test('downloadFile respects customTargetDir override parameter over settings',
        () async {
      final settingsDir = Directory(p.join(tempBaseDir.path, 'SettingsDir'));
      final overrideDir = Directory(p.join(tempBaseDir.path, 'OverrideDir'));

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              AppSettings(customDownloadPath: settingsDir.path),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final job = await notifier.downloadFile(
        srcRemote: 'OneDrive',
        srcPath: 'archive.zip',
        customTargetDir: overrideDir.path,
      );

      expect(overrideDir.existsSync(), isTrue);
      expect(job.dstPath, equals(p.join(overrideDir.path, 'archive.zip')));
    });

    test('downloadFiles batches downloads to the custom download folder',
        () async {
      final customDir = Directory(p.join(tempBaseDir.path, 'BatchDownloads'));

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              AppSettings(customDownloadPath: customDir.path),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final jobs = await notifier.downloadFiles(
        srcRemote: 'GoogleDrive',
        srcPaths: [
          'Docs/file1.txt',
          'Docs/file2.png',
          'Docs/file3.pdf',
        ],
      );

      expect(jobs, hasLength(3));
      expect(customDir.existsSync(), isTrue);
      expect(jobs[0].dstPath, equals(p.join(customDir.path, 'file1.txt')));
      expect(jobs[1].dstPath, equals(p.join(customDir.path, 'file2.png')));
      expect(jobs[2].dstPath, equals(p.join(customDir.path, 'file3.pdf')));
      expect(fakeRclone.recordedCalls, hasLength(3));
    });
  });
}

