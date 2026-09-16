import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/services/rclone_service.dart';

void main() {
  group('Fase 6: Transfer Models & Logic Tests', () {
    test('TransferJob helper properties format speed, progress and ETA correctly', () {
      final job = TransferJob(
        id: 'job_123',
        srcRemote: 'Drive',
        srcPath: 'Projects/Design/logo.png',
        dstRemote: 'Dropbox',
        dstPath: 'Backup/logo.png',
        status: TransferStatus.running,
        bytes: 5242880, // 5 MB
        totalBytes: 10485760, // 10 MB
        percentage: 50,
        speed: 1048576, // 1 MB/s
        eta: 5,
      );

      expect(job.fileName, 'logo.png');
      expect(job.isActive, isTrue);
      expect(job.formattedSpeed, '1.0 MB/s');
      expect(job.formattedProgress, '5.0 MB / 10.0 MB');
      expect(job.formattedEta, '5s');
    });

    test('TransferJob JSON serialization & deserialization', () {
      final json = {
        'id': 'test_job_1',
        'src_remote': 'MyDrive',
        'src_path': 'Documents/report.pdf',
        'dst_remote': '',
        'dst_path': '/home/user/Downloads/report.pdf',
        'is_move': false,
        'status': 'completed',
        'bytes': 2048,
        'total_bytes': 2048,
        'percentage': 100,
        'speed': 512.0,
        'eta': 0,
        'start_time': '2026-09-14T20:00:00.000Z',
        'end_time': '2026-09-14T20:00:04.000Z',
      };

      final job = TransferJob.fromJson(json);
      expect(job.id, 'test_job_1');
      expect(job.fileName, 'report.pdf');
      expect(job.status, TransferStatus.completed);
      expect(job.isActive, isFalse);
      expect(job.percentage, 100);

      final encoded = job.toJson();
      expect(encoded['id'], 'test_job_1');
      expect(encoded['status'], 'completed');
    });
  });

  group('Fase 6: FFI Transfer Engine Integration Tests', () {
    late RcloneService service;
    late Directory tempDir;

    setUpAll(() async {
      service = RcloneService();
      await service.init();
      tempDir = Directory.systemTemp.createTempSync('unifycloud_test_');
    });

    tearDownAll(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('startTransfer initiates transfer and getAllTransfers lists active/recent jobs', () async {
      final srcFile = File('go_backend/main.go');
      expect(srcFile.existsSync(), isTrue);

      final dstPath = '${tempDir.path}/main_copy.go';

      final job = await service.startTransfer(
        srcRemote: '',
        srcPath: srcFile.absolute.path,
        dstRemote: '',
        dstPath: dstPath,
        isMove: false,
      );

      expect(job.id, isNotEmpty);
      expect(job.srcPath, srcFile.absolute.path);

      // Wait a moment for background copy to complete
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final allJobs = await service.getAllTransfers();
      expect(allJobs.any((j) => j.id == job.id), isTrue);

      final updatedJob = await service.getTransferProgress(job.id);
      // ignore: avoid_print
      print('>>> [Transfer Test] updatedJob status: ${updatedJob?.status}, error: ${updatedJob?.error}');
      expect(updatedJob, isNotNull);
      expect(updatedJob!.status, isIn([TransferStatus.running, TransferStatus.completed]));

      // Verify copied file exists
      final copiedFile = File(dstPath);
      expect(copiedFile.existsSync(), isTrue);
      expect(copiedFile.lengthSync(), equals(srcFile.lengthSync()));
    });

    test('cancelTransfer cancels an active or queued transfer', () async {
      final job = await service.startTransfer(
        srcRemote: '',
        srcPath: 'go_backend/main.go',
        dstRemote: '',
        dstPath: '${tempDir.path}/cancelled_copy.go',
      );

      final success = await service.cancelTransfer(job.id);
      expect(success, isTrue);

      final status = await service.getTransferProgress(job.id);
      expect(status?.status, isIn([TransferStatus.cancelled, TransferStatus.completed]));
    });

    test('clearCompletedTransfers clears finished jobs', () async {
      await service.clearCompletedTransfers();
      final jobsAfter = await service.getAllTransfers();
      expect(jobsAfter.where((j) => j.status == TransferStatus.completed), isEmpty);
    });
  });
}
