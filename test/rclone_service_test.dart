import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/services/rclone_service.dart';

void main() {
  group('RcloneService FFI Bridge Tests', () {
    late RcloneService service;
    late Directory tempDir;

    setUpAll(() async {
      service = RcloneService();
      tempDir = await Directory.systemTemp.createTemp('unifycloud_ffi_test_');
    });

    tearDownAll(() async {
      if (tempDir.existsSync()) {
        try {
          tempDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('InitRclone() connects to native Go core and returns memory mode config', () async {
      final res = await service.init();
      expect(res, isNotNull);
      expect(res.containsKey('config_path'), isTrue);
      expect(res['mode'], equals('memory'));
    });

    test('LoadConfigInMemory() and ExportConfigInMemory() manage INI in RAM', () async {
      const sampleIni = '''
[test_ffi_drive]
type = drive
client_id = ffi_client_123

[test_ffi_sftp]
type = sftp
host = ffi.example.com
''';
      final remotes = await service.loadConfigInMemory(sampleIni);
      expect(remotes, contains('test_ffi_drive'));
      expect(remotes, contains('test_ffi_sftp'));

      final exported = await service.exportConfigInMemory();
      expect(exported, contains('[test_ffi_drive]'));
      expect(exported, contains('type = drive'));
      expect(exported, contains('[test_ffi_sftp]'));
    });

    test('SetRemoteConfig(), ListRemotes() and DeleteRemote() perform dynamic CRUD', () async {
      await service.setRemoteConfig(
        remoteName: 'dynamic_dropbox_ffi',
        remoteType: 'dropbox',
        options: {'token': 'db_token_xyz'},
      );

      final remotes = await service.listRemotes();
      final found = remotes.any((r) => r.name == 'dynamic_dropbox_ffi' && r.type == 'dropbox');
      expect(found, isTrue);

      await service.deleteRemote('dynamic_dropbox_ffi');
      final remotesAfter = await service.listRemotes();
      final stillExists = remotesAfter.any((r) => r.name == 'dynamic_dropbox_ffi');
      expect(stillExists, isFalse);
    });

    test('ListDirectory() lists local files and parses CloudItem metadata', () async {
      final items = await service.listDirectory(remote: '', path: 'go_backend');
      expect(items.isNotEmpty, isTrue);

      final names = items.map((i) => i.name).toList();
      expect(names, contains('main.go'));
      expect(names, contains('librclone_wrapper.so'));
      expect(names, contains('go.mod'));

      final mainGo = items.firstWhere((i) => i.name == 'main.go');
      expect(mainGo.isDir, isFalse);
      expect(mainGo.size, greaterThan(0));
    });

    test('MakeDir(), CopyFile() and DeleteFile() execute CRUD on local filesystem', () async {
      final subDirPath = '${tempDir.path}/sub_dir';
      await service.makeDir(remote: '', dirPath: subDirPath);
      expect(Directory(subDirPath).existsSync(), isTrue);

      final sampleFile = File('${tempDir.path}/sample.txt');
      sampleFile.writeAsStringSync('FFI Bridge Test Data');

      final copiedFilePath = '$subDirPath/copied_sample.txt';
      await service.copyFile(
        srcRemote: '',
        srcPath: sampleFile.path,
        dstRemote: '',
        dstPath: copiedFilePath,
      );

      expect(File(copiedFilePath).existsSync(), isTrue);
      expect(File(copiedFilePath).readAsStringSync(), equals('FFI Bridge Test Data'));

      await service.deleteFile(remote: '', filePath: copiedFilePath);
      expect(File(copiedFilePath).existsSync(), isFalse);

      await service.deleteFile(remote: '', filePath: subDirPath);
      expect(Directory(subDirPath).existsSync(), isFalse);
    });

    test('StartTransfer(), GetTransferProgress(), and ClearCompletedTransfers() manage transfer lifecycle', () async {
      final srcFile = File('${tempDir.path}/large_src.dat');
      srcFile.writeAsBytesSync(List.filled(1024 * 50, 65)); // 50 KB

      final dstFile = File('${tempDir.path}/large_dst.dat');

      final job = await service.startTransfer(
        srcRemote: '',
        srcPath: srcFile.path,
        dstRemote: '',
        dstPath: dstFile.path,
        isMove: false,
      );

      expect(job.id, startsWith('job_'));
      expect(job.status, isA<TransferStatus>());

      // Give worker a moment to complete
      await Future.delayed(const Duration(milliseconds: 150));

      final progress = await service.getTransferProgress(job.id);
      expect(progress, isNotNull);
      expect(progress!.id, equals(job.id));

      final allJobs = await service.getAllTransfers();
      expect(allJobs.any((j) => j.id == job.id), isTrue);

      await service.clearCompletedTransfers();
    });

    test('CancelTransfer() cancels an initiated transfer', () async {
      final srcFile = File('${tempDir.path}/cancel_src.dat');
      srcFile.writeAsBytesSync(List.filled(1024 * 10, 66));
      final dstFile = File('${tempDir.path}/cancel_dst.dat');

      final job = await service.startTransfer(
        srcRemote: '',
        srcPath: srcFile.path,
        dstRemote: '',
        dstPath: dstFile.path,
        isMove: false,
      );

      final success = await service.cancelTransfer(job.id);
      expect(success, isTrue);

      final updated = await service.getTransferProgress(job.id);
      expect(updated?.status, anyOf(TransferStatus.cancelled, TransferStatus.completed));
    });

    test('getRemoteAbout() and local remote root browsing work correctly', () async {
      await service.setRemoteConfig(
        remoteName: 'DiscoLocaleTest',
        remoteType: 'local',
        options: {},
      );

      final quota = await service.getRemoteAbout('DiscoLocaleTest');
      expect(quota, isNotNull);
      expect(quota!.total, greaterThan(0));
      expect(quota.free, greaterThan(0));
      expect(quota.hasData, isTrue);

      final rootItems = await service.listDirectory(remote: 'DiscoLocaleTest', path: '');
      expect(rootItems.isNotEmpty, isTrue);
      final rootNames = rootItems.map((i) => i.name).toList();
      expect(
        rootNames.any((n) => n == 'usr' || n == 'etc' || n == 'var' || n == 'home'),
        isTrue,
      );

      await service.deleteRemote('DiscoLocaleTest');
    });

    test('Error handling throws informative Exceptions on invalid targets', () async {
      expect(
        () => service.listDirectory(remote: 'non_existent_remote_12345'),
        throwsA(isA<Exception>()),
      );

      expect(
        () => service.copyFile(
          srcRemote: '',
          srcPath: '${tempDir.path}/not_found_file.txt',
          dstRemote: '',
          dstPath: '${tempDir.path}/dst.txt',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('createPublicLink() fails gracefully on local/unsupported remotes', () async {
      expect(
        () => service.createPublicLink(
          remote: '',
          filePath: 'go_backend/main.go',
        ),
        throwsA(
          predicate((e) =>
              e is Exception &&
              (e.toString().contains("doesn't support") ||
                  e.toString().contains("failed"))),
        ),
      );
    });
  });
}
