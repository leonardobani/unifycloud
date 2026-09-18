import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';

class FakeRcloneServiceForUpload extends RcloneService {
  final List<Map<String, dynamic>> recordedTransfers = [];
  final List<Map<String, String>> recordedMakeDirs = [];

  @override
  Future<List<TransferJob>> getAllTransfers() async => [];

  @override
  Future<void> makeDir({required String remote, required String dirPath}) async {
    recordedMakeDirs.add({'remote': remote, 'dirPath': dirPath});
  }

  @override
  Future<TransferJob> startTransfer({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    recordedTransfers.add({
      'srcRemote': srcRemote,
      'srcPath': srcPath,
      'dstRemote': dstRemote,
      'dstPath': dstPath,
      'isMove': isMove,
    });

    return TransferJob(
      id: 'job_upload_${recordedTransfers.length}',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
      status: TransferStatus.queued,
      bytes: 0,
      totalBytes: 2048,
      percentage: 0,
      speed: 0,
      eta: 0,
    );
  }
}

class FakeFileExplorerNotifier extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  final FileExplorerState _initial;
  FakeFileExplorerNotifier(this._initial);

  @override
  FileExplorerState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCloudAccountsNotifier extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  final CloudAccountsState _initial;
  FakeCloudAccountsNotifier(this._initial);

  @override
  CloudAccountsState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TransferNotifier.uploadDirectory Tests', () {
    late Directory tempBaseDir;
    late FakeRcloneServiceForUpload fakeRclone;

    setUp(() async {
      tempBaseDir = await Directory.systemTemp.createTemp('unify_upload_folder_');
      fakeRclone = FakeRcloneServiceForUpload();
    });

    tearDown(() async {
      if (tempBaseDir.existsSync()) {
        try {
          tempBaseDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('uploadDirectory scans recursively and transfers all files with preserved hierarchy',
        () async {
      // Create test directory tree:
      // ProjectFolder/
      //   readme.txt
      //   src/
      //     main.dart
      //     assets/
      //       icon.png
      //   empty_sub/
      final projectDir = Directory(p.join(tempBaseDir.path, 'ProjectFolder'));
      projectDir.createSync(recursive: true);

      final readme = File(p.join(projectDir.path, 'readme.txt'))..writeAsStringSync('Hello World');

      final srcDir = Directory(p.join(projectDir.path, 'src'))..createSync(recursive: true);
      final mainDart = File(p.join(srcDir.path, 'main.dart'))..writeAsStringSync('void main() {}');

      final assetsDir = Directory(p.join(srcDir.path, 'assets'))..createSync(recursive: true);
      final iconPng = File(p.join(assetsDir.path, 'icon.png'))..writeAsStringSync('PNG_DATA');

      Directory(p.join(projectDir.path, 'empty_sub')).createSync(recursive: true);

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final jobs = await notifier.uploadDirectory(
        directory: projectDir,
        dstRemote: 'GoogleDrive',
        dstPath: 'WorkDocs',
      );

      // 3 files should have been queued
      expect(jobs, hasLength(3));
      expect(fakeRclone.recordedTransfers, hasLength(3));

      // Check root and sub directories creation via makeDir
      expect(
        fakeRclone.recordedMakeDirs.any((d) => d['dirPath'] == 'WorkDocs/ProjectFolder'),
        isTrue,
      );
      expect(
        fakeRclone.recordedMakeDirs.any((d) => d['dirPath'] == 'WorkDocs/ProjectFolder/empty_sub'),
        isTrue,
      );

      // Verify file paths preserve relative hierarchy
      final dstPaths = fakeRclone.recordedTransfers.map((t) => t['dstPath']).toList();
      expect(dstPaths, contains('WorkDocs/ProjectFolder/readme.txt'));
      expect(dstPaths, contains('WorkDocs/ProjectFolder/src/main.dart'));
      expect(dstPaths, contains('WorkDocs/ProjectFolder/src/assets/icon.png'));

      final srcPaths = fakeRclone.recordedTransfers.map((t) => t['srcPath']).toList();
      expect(srcPaths, contains(readme.path));
      expect(srcPaths, contains(mainDart.path));
      expect(srcPaths, contains(iconPng.path));
    });

    test('uploadDirectory with empty folder creates remote directory and returns empty list',
        () async {
      final emptyDir = Directory(p.join(tempBaseDir.path, 'EmptyFolder'));
      emptyDir.createSync(recursive: true);

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final jobs = await notifier.uploadDirectory(
        directory: emptyDir,
        dstRemote: 'OneDrive',
        dstPath: '',
      );

      expect(jobs, isEmpty);
      expect(fakeRclone.recordedTransfers, isEmpty);
      expect(
        fakeRclone.recordedMakeDirs.any((d) => d['remote'] == 'OneDrive' && d['dirPath'] == 'EmptyFolder'),
        isTrue,
      );
    });

    test('uploadDirectory throws FileSystemException if directory does not exist',
        () async {
      final nonExistent = Directory(p.join(tempBaseDir.path, 'NonExistent'));

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      expect(
        () => notifier.uploadDirectory(
          directory: nonExistent,
          dstRemote: 'Dropbox',
          dstPath: 'Backups',
        ),
        throwsA(isA<FileSystemException>()),
      );
    });
  });

  group('TransferNotifier.uploadFile and uploadFiles Tests', () {
    late Directory tempBaseDir;
    late FakeRcloneServiceForUpload fakeRclone;

    setUp(() async {
      tempBaseDir = await Directory.systemTemp.createTemp('unify_upload_files_');
      fakeRclone = FakeRcloneServiceForUpload();
    });

    tearDown(() async {
      if (tempBaseDir.existsSync()) {
        try {
          tempBaseDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('uploadFile in root path sets dstPath to filename', () async {
      final file = File(p.join(tempBaseDir.path, 'notes.pdf'))..writeAsStringSync('PDF_CONTENT');

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final job = await notifier.uploadFile(
        file: file,
        dstRemote: 'GoogleDrive',
        dstPath: '',
      );

      expect(job.dstPath, equals('notes.pdf'));
      expect(fakeRclone.recordedTransfers, hasLength(1));
      expect(fakeRclone.recordedTransfers.first['dstPath'], equals('notes.pdf'));
      expect(fakeRclone.recordedTransfers.first['dstRemote'], equals('GoogleDrive'));
    });

    test('uploadFile in subfolder path joins folder with filename', () async {
      final file = File(p.join(tempBaseDir.path, 'invoice.xlsx'))..writeAsStringSync('EXCEL_CONTENT');

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final job = await notifier.uploadFile(
        file: file,
        dstRemote: 'OneDrive',
        dstPath: 'Finance/2026',
      );

      expect(job.dstPath, equals('Finance/2026/invoice.xlsx'));
      expect(fakeRclone.recordedTransfers, hasLength(1));
      expect(fakeRclone.recordedTransfers.first['dstPath'], equals('Finance/2026/invoice.xlsx'));
    });

    test('uploadFiles uploads multiple files with correct target paths', () async {
      final file1 = File(p.join(tempBaseDir.path, 'a.txt'))..writeAsStringSync('A');
      final file2 = File(p.join(tempBaseDir.path, 'b.png'))..writeAsStringSync('B');

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transferProvider.notifier);
      final jobs = await notifier.uploadFiles(
        files: [file1, file2],
        dstRemote: 'Dropbox',
        dstPath: 'Photos',
      );

      expect(jobs, hasLength(2));
      expect(jobs[0].dstPath, equals('Photos/a.txt'));
      expect(jobs[1].dstPath, equals('Photos/b.png'));
      expect(fakeRclone.recordedTransfers, hasLength(2));
    });
  });

  group('FileExplorerScreen Upload Menu Widget Tests', () {
    testWidgets('Renders upload PopupMenuButton with "Carica file" and "Carica intera cartella"',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final testState = FileExplorerState(
        currentRemote: 'GoogleDrive',
        currentPath: '',
        items: [
          CloudItem(name: 'File1.txt', path: 'File1.txt', isDir: false, size: 100),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(testState)),
            cloudAccountsProvider.overrideWith(
              () => FakeCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'GoogleDrive', type: 'drive'),
                  ],
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the upload PopupMenuButton
      final uploadButton = find.byTooltip('Carica dal dispositivo');
      expect(uploadButton, findsOneWidget);

      // Tap on the upload button to open menu
      await tester.tap(uploadButton);
      await tester.pumpAndSettle();

      // Verify menu items are displayed
      expect(find.text('Carica file'), findsOneWidget);
      expect(find.text('Carica intera cartella'), findsOneWidget);
      expect(find.byIcon(Icons.upload_file_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.drive_folder_upload_outlined), findsOneWidget);
    });
  });
}
