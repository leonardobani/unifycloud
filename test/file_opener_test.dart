import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/services/file_opener_service.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';

class MockRcloneService extends RcloneService {
  final List<Map<String, dynamic>> copyCalls = [];

  @override
  Future<void> copyFile({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
  }) async {
    copyCalls.add({
      'srcRemote': srcRemote,
      'srcPath': srcPath,
      'dstRemote': dstRemote,
      'dstPath': dstPath,
    });
    final f = File(dstPath);
    if (!f.existsSync()) {
      f.createSync(recursive: true);
      f.writeAsBytesSync(List.filled(100, 1));
    }
  }
}

class FakeFileOpenerService extends FileOpenerService {
  final List<CloudItem> recordedOpens = [];

  FakeFileOpenerService({required super.rcloneService});

  @override
  Future<void> openCloudItem({
    BuildContext? context,
    required CloudItem item,
    String? remote,
    String? currentPath,
    bool isQuickPeek = false,
  }) async {
    recordedOpens.add(item);
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
  group('FileOpenerService Unit Tests', () {
    late Directory tempDir;
    late MockRcloneService mockRclone;
    late List<String> openedFiles;
    late OpenResult mockResult;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('unify_file_opener_unit_');
      mockRclone = MockRcloneService();
      openedFiles = [];
      mockResult = OpenResult(type: ResultType.done, message: 'done');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        try {
          tempDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('Opens file without downloading if already cached with matching size', () async {
      final cachedDir = Directory(p.join(tempDir.path, 'unifycloud_previews', 'MyDrive'));
      cachedDir.createSync(recursive: true);
      final cachedFile = File(p.join(cachedDir.path, 'document.pdf'));
      cachedFile.writeAsBytesSync(List.filled(256, 0));

      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'document.pdf',
        path: 'document.pdf',
        size: 256,
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'MyDrive',
      );

      // No download should occur because it is cached
      expect(mockRclone.copyCalls, isEmpty);
      // File should have been opened
      expect(openedFiles, contains(cachedFile.path));
    });

    test('Downloads file to preview cache before opening if not cached', () async {
      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'photo.jpg',
        path: 'vacation/photo.jpg',
        size: 100,
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'MyDrive',
        currentPath: 'vacation',
      );

      expect(mockRclone.copyCalls.length, equals(1));
      expect(mockRclone.copyCalls.first['srcRemote'], equals('MyDrive'));
      expect(mockRclone.copyCalls.first['srcPath'], equals('vacation/photo.jpg'));
      expect(mockRclone.copyCalls.first['dstRemote'], equals(''));

      final expectedCachedPath = p.join(
        tempDir.path,
        'unifycloud_previews',
        'MyDrive',
        'photo.jpg',
      );
      expect(mockRclone.copyCalls.first['dstPath'], equals(expectedCachedPath));
      expect(openedFiles, contains(expectedCachedPath));
    });

    test('Ignores directories when openCloudItem is called', () async {
      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final dirItem = CloudItem(
        name: 'MyFolder',
        path: 'MyFolder',
        size: 0,
        isDir: true,
      );

      await service.openCloudItem(
        item: dirItem,
        remote: 'MyDrive',
      );

      expect(mockRclone.copyCalls, isEmpty);
      expect(openedFiles, isEmpty);
    });

    test('Re-downloads if cached file size does not match item size', () async {
      final cachedDir = Directory(p.join(tempDir.path, 'unifycloud_previews', 'MyDrive'));
      cachedDir.createSync(recursive: true);
      final cachedFile = File(p.join(cachedDir.path, 'document.pdf'));
      cachedFile.writeAsBytesSync(List.filled(50, 0)); // Old size 50

      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'document.pdf',
        path: 'document.pdf',
        size: 256, // New size 256
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'MyDrive',
      );

      // Should have triggered copyFile due to size mismatch
      expect(mockRclone.copyCalls.length, equals(1));
      expect(openedFiles, contains(cachedFile.path));
    });

    test('Sanitizes remote name for local preview folder path', () async {
      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'notes.txt',
        path: 'notes.txt',
        size: 100,
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'My Drive (Work) / 2026',
      );

      expect(mockRclone.copyCalls.length, equals(1));
      final dstPath = mockRclone.copyCalls.first['dstPath'] as String;
      // Should sanitize special chars with underscore
      expect(dstPath, contains('My_Drive__Work____2026'));
    });

    test('resolveRemoteItemPath correctly resolves relative and subfolder paths without duplication', () {
      expect(resolveRemoteItemPath('doc.pdf', ''), equals('doc.pdf'));
      expect(resolveRemoteItemPath('doc.pdf', '/'), equals('doc.pdf'));
      expect(resolveRemoteItemPath('doc.pdf', 'folder'), equals('folder/doc.pdf'));
      expect(resolveRemoteItemPath('folder/doc.pdf', 'folder'), equals('folder/doc.pdf'));
      expect(resolveRemoteItemPath('folder/doc.pdf', '/folder'), equals('folder/doc.pdf'));
      expect(resolveRemoteItemPath('/folder/doc.pdf', '/folder/'), equals('folder/doc.pdf'));
      expect(resolveRemoteItemPath('a/b/c.pdf', '/a/b'), equals('a/b/c.pdf'));
      expect(resolveRemoteItemPath('c.pdf', '/a/b'), equals('a/b/c.pdf'));
    });

    test('Opens local file directly in place without downloading or copying', () async {
      final localFile = File(p.join(tempDir.path, 'local_doc.txt'));
      localFile.writeAsStringSync('Local content');

      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'local_doc.txt',
        path: localFile.path,
        size: localFile.lengthSync(),
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'DiscoLocale',
      );

      // Should open directly in place
      expect(mockRclone.copyCalls, isEmpty);
      expect(openedFiles, contains(localFile.path));
    });

    test('Does not duplicate path when currentPath has leading slashes', () async {
      final service = FileOpenerService(
        rcloneService: mockRclone,
        getTempDir: () async => tempDir,
        openFile: (path) async {
          openedFiles.add(path);
          return mockResult;
        },
      );

      final testItem = CloudItem(
        name: 'presentation.pdf',
        path: 'Work/presentation.pdf',
        size: 500,
        isDir: false,
      );

      await service.openCloudItem(
        item: testItem,
        remote: 'MyDrive',
        currentPath: '/Work',
      );

      expect(mockRclone.copyCalls.length, equals(1));
      // Crucial: srcPath must NOT be /Work/Work/presentation.pdf
      expect(mockRclone.copyCalls.first['srcPath'], equals('Work/presentation.pdf'));
    });
  });

  group('FileExplorerScreen Integration Tests', () {
    testWidgets('Tapping on a file opens it via FileOpenerService', (tester) async {
      final mockRclone = MockRcloneService();
      final fakeFileOpener = FakeFileOpenerService(rcloneService: mockRclone);

      final testItem = CloudItem(
        name: 'presentation.key',
        path: 'presentation.key',
        size: 100,
        isDir: false,
      );

      final initialState = FileExplorerState(
        currentRemote: 'MyDrive',
        currentPath: '',
        items: [testItem],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileOpenerServiceProvider.overrideWithValue(fakeFileOpener),
            fileExplorerProvider.overrideWith(
              () => FakeFileExplorerNotifier(initialState),
            ),
            cloudAccountsProvider.overrideWith(
              () => FakeCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'MyDrive', type: 'drive'),
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

      expect(find.text('presentation.key'), findsOneWidget);

      // Tap on file
      await tester.tap(find.text('presentation.key'));
      await tester.pumpAndSettle();

      // Verify file was opened
      expect(fakeFileOpener.recordedOpens.length, equals(1));
      expect(fakeFileOpener.recordedOpens.first.name, equals('presentation.key'));
    });

    testWidgets('3-dots menu contains "Apri con app di sistema" and calls FileOpenerService',
        (tester) async {
      final mockRclone = MockRcloneService();
      final fakeFileOpener = FakeFileOpenerService(rcloneService: mockRclone);

      final testItem = CloudItem(
        name: 'report.pdf',
        path: 'report.pdf',
        size: 100,
        isDir: false,
      );

      final initialState = FileExplorerState(
        currentRemote: 'MyDrive',
        currentPath: '',
        items: [testItem],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileOpenerServiceProvider.overrideWithValue(fakeFileOpener),
            fileExplorerProvider.overrideWith(
              () => FakeFileExplorerNotifier(initialState),
            ),
            cloudAccountsProvider.overrideWith(
              () => FakeCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'MyDrive', type: 'drive'),
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

      // Open 3-dots menu
      final moreButton = find.byTooltip('Opzioni per report.pdf');
      expect(moreButton, findsOneWidget);
      await tester.tap(moreButton);
      await tester.pumpAndSettle();

      // Verify "Apri con app di sistema" is present
      expect(find.text('Apri con app di sistema'), findsOneWidget);

      // Tap "Apri con app di sistema"
      await tester.tap(find.text('Apri con app di sistema'));
      await tester.pumpAndSettle();

      // Verify opened
      expect(fakeFileOpener.recordedOpens.length, equals(1));
      expect(fakeFileOpener.recordedOpens.first.name, equals('report.pdf'));
    });

    testWidgets('Right-click context menu contains "Apri con app di sistema" and opens file',
        (tester) async {
      final mockRclone = MockRcloneService();
      final fakeFileOpener = FakeFileOpenerService(rcloneService: mockRclone);

      final testItem = CloudItem(
        name: 'document.docx',
        path: 'document.docx',
        size: 200,
        isDir: false,
      );

      final initialState = FileExplorerState(
        currentRemote: 'MyDrive',
        currentPath: '',
        items: [testItem],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileOpenerServiceProvider.overrideWithValue(fakeFileOpener),
            fileExplorerProvider.overrideWith(
              () => FakeFileExplorerNotifier(initialState),
            ),
            cloudAccountsProvider.overrideWith(
              () => FakeCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'MyDrive', type: 'drive'),
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

      // Right-click on file tile
      await tester.tap(find.text('document.docx'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      expect(find.text('Apri con app di sistema'), findsOneWidget);

      await tester.tap(find.text('Apri con app di sistema'));
      await tester.pumpAndSettle();

      expect(fakeFileOpener.recordedOpens.length, equals(1));
      expect(fakeFileOpener.recordedOpens.first.name, equals('document.docx'));
    });

    testWidgets('Tapping on a .pdf file DOES open it in quick peek',
        (tester) async {
      final mockRclone = MockRcloneService();
      final fakeFileOpener = FakeFileOpenerService(rcloneService: mockRclone);

      final pdfItem = CloudItem(
        name: 'manual.pdf',
        path: 'manual.pdf',
        size: 5000,
        isDir: false,
      );
      final txtItem = CloudItem(
        name: 'notes.txt',
        path: 'notes.txt',
        size: 200,
        isDir: false,
      );

      final initialState = FileExplorerState(
        currentRemote: 'MyDrive',
        currentPath: '',
        items: [pdfItem, txtItem],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileOpenerServiceProvider.overrideWithValue(fakeFileOpener),
            fileExplorerProvider.overrideWith(
              () => FakeFileExplorerNotifier(initialState),
            ),
            cloudAccountsProvider.overrideWith(
              () => FakeCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'MyDrive', type: 'drive'),
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

      // Tap on the PDF item
      await tester.tap(find.text('manual.pdf'));
      await tester.pumpAndSettle();

      // PDF must be opened in quick peek
      expect(fakeFileOpener.recordedOpens.length, equals(1));
      expect(fakeFileOpener.recordedOpens.first.name, equals('manual.pdf'));

      // Tap on the text item
      await tester.tap(find.text('notes.txt'));
      await tester.pumpAndSettle();

      // Both items are opened
      expect(fakeFileOpener.recordedOpens.length, equals(2));
      expect(fakeFileOpener.recordedOpens.last.name, equals('notes.txt'));
    });

    test('isPdf accurately detects PDF files by extension or mimeType', () {
      expect(
        FileOpenerService.isPdf(
          CloudItem(name: 'doc.pdf', path: 'doc.pdf', size: 10, isDir: false),
        ),
        isTrue,
      );
      expect(
        FileOpenerService.isPdf(
          CloudItem(name: 'REPORT.PDF', path: 'REPORT.PDF', size: 10, isDir: false),
        ),
        isTrue,
      );
      expect(
        FileOpenerService.isPdf(
          CloudItem(
            name: 'unknown_ext',
            path: 'unknown_ext',
            size: 10,
            isDir: false,
            mimeType: 'application/pdf',
          ),
        ),
        isTrue,
      );
      expect(
        FileOpenerService.isPdf(
          CloudItem(name: 'photo.jpg', path: 'photo.jpg', size: 10, isDir: false),
        ),
        isFalse,
      );
      expect(
        FileOpenerService.isPdf(
          CloudItem(name: 'code.dart', path: 'code.dart', size: 10, isDir: false),
        ),
        isFalse,
      );
    });
  });
}
