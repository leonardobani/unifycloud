import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/widgets/file_context_menu.dart';
import 'package:unifycloud/src/ui/widgets/share_link_dialog.dart';

class MockShareRcloneService extends RcloneService {
  String? mockLinkToReturn;
  Exception? errorToThrow;
  String? lastRemote;
  String? lastFilePath;

  @override
  Future<String> createPublicLink({
    required String remote,
    required String filePath,
    bool unlink = false,
  }) async {
    lastRemote = remote;
    lastFilePath = filePath;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return mockLinkToReturn ?? 'https://drive.google.com/file/d/test12345/view';
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
  group('ShareLinkDialog Widget Tests', () {
    final testFile = CloudItem(
      path: 'documents/presentation.pdf',
      name: 'presentation.pdf',
      size: 2048,
      isDir: false,
    );

    final testFolder = CloudItem(
      path: 'shared_photos',
      name: 'shared_photos',
      size: 0,
      isDir: true,
    );

    testWidgets('renders file information, link, and buttons correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShareLinkDialog(
              item: testFile,
              link: 'https://drive.google.com/file/d/abc123xyz',
            ),
          ),
        ),
      );

      expect(find.text('Link Condivisibile'), findsOneWidget);
      expect(find.text('presentation.pdf'), findsOneWidget);
      expect(find.text('Chiunque abbia questo link potrà accedere a questo file:'), findsOneWidget);
      expect(find.text('https://drive.google.com/file/d/abc123xyz'), findsOneWidget);
      expect(find.text('Chiudi'), findsOneWidget);
      expect(find.text('Apri'), findsOneWidget);
      expect(find.text('Copia Link'), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file_rounded), findsOneWidget);
    });

    testWidgets('renders folder information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShareLinkDialog(
              item: testFolder,
              link: 'https://onedrive.live.com/?id=folder123',
            ),
          ),
        ),
      );

      expect(find.text('Link Condivisibile'), findsOneWidget);
      expect(find.text('shared_photos'), findsOneWidget);
      expect(find.text('Chiunque abbia questo link potrà accedere a questa cartella:'), findsOneWidget);
      expect(find.text('https://onedrive.live.com/?id=folder123'), findsOneWidget);
      expect(find.byIcon(Icons.folder_rounded), findsOneWidget);
    });

    testWidgets('tapping "Copia Link" copies link to clipboard, shows SnackBar and closes dialog', (tester) async {
      final List<MethodCall> clipboardCalls = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          clipboardCalls.add(methodCall);
          return null;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ShareLinkDialog.show(
                  context,
                  item: testFile,
                  link: 'https://dropbox.com/s/sample_link',
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Copia Link'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);

      final copyCall = clipboardCalls.firstWhere((c) => c.method == 'Clipboard.setData');
      expect((copyCall.arguments as Map)['text'], equals('https://dropbox.com/s/sample_link'));

      expect(find.text('Link copiato negli appunti!'), findsOneWidget);
    });

    testWidgets('tapping "Chiudi" closes dialog without modifying clipboard', (tester) async {
      final List<MethodCall> clipboardCalls = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          clipboardCalls.add(methodCall);
          return null;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ShareLinkDialog.show(
                  context,
                  item: testFile,
                  link: 'https://dropbox.com/s/sample_link',
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsOneWidget);

      await tester.tap(find.text('Chiudi'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);
      expect(clipboardCalls.any((c) => c.method == 'Clipboard.setData'), isFalse);
    });
  });

  group('FileContextMenu Share Link Tests', () {
    final testFile = CloudItem(
      path: 'contracts/document.pdf',
      name: 'document.pdf',
      size: 4096,
      isDir: false,
    );

    testWidgets('shows "Crea link condivisibile" in right-click context menu and handles success', (tester) async {
      final mockRclone = MockShareRcloneService();
      mockRclone.mockLinkToReturn = 'https://drive.google.com/file/d/test-doc-123';

      final fileExplorerState = FileExplorerState(
        currentRemote: 'gdrive_work',
        currentPath: 'contracts',
        items: [testFile],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(fileExplorerState)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FileContextMenuRegion(
                item: testFile,
                child: const Text('Right click target'),
              ),
            ),
          ),
        ),
      );

      // Trigger secondary tap (right click)
      await tester.tap(find.text('Right click target'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      expect(find.text('Crea link condivisibile'), findsOneWidget);

      // Tap the share link menu option
      await tester.tap(find.text('Crea link condivisibile'));
      await tester.pumpAndSettle();

      // Verify RcloneService was called with expected parameters
      expect(mockRclone.lastRemote, equals('gdrive_work'));
      expect(mockRclone.lastFilePath, equals('contracts/document.pdf'));

      // Verify ShareLinkDialog appeared
      expect(find.byType(ShareLinkDialog), findsOneWidget);
      expect(find.text('https://drive.google.com/file/d/test-doc-123'), findsOneWidget);
    });

    testWidgets('shows informative message when provider does not support public links', (tester) async {
      final mockRclone = MockShareRcloneService();
      mockRclone.errorToThrow = Exception("local doesn't support public links");

      final fileExplorerState = FileExplorerState(
        currentRemote: 'local_disk',
        currentPath: '',
        items: [testFile],
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(fileExplorerState)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FileContextMenuRegion(
                item: testFile,
                child: const Text('Right click target'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Right click target'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crea link condivisibile'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);
      expect(find.text('Questo provider cloud non supporta la creazione di link pubblici.'), findsOneWidget);
    });
  });

  group('FileExplorerScreen 3-Dots Menu Share Link Tests', () {
    final testFile = CloudItem(
      path: 'notes.txt',
      name: 'notes.txt',
      size: 512,
      isDir: false,
    );

    testWidgets('3-dots menu contains "Crea link condivisibile" and creates link', (tester) async {
      final mockRclone = MockShareRcloneService();
      mockRclone.mockLinkToReturn = 'https://onedrive.live.com/redir?resid=notes-file';

      final fileExplorerState = FileExplorerState(
        currentRemote: 'my_onedrive',
        currentPath: '',
        items: [testFile],
        isLoading: false,
      );

      final cloudAccountsState = const CloudAccountsState(
        remotes: [
          CloudRemote(name: 'my_onedrive', type: 'onedrive'),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(fileExplorerState)),
            cloudAccountsProvider.overrideWith(() => FakeCloudAccountsNotifier(cloudAccountsState)),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the 3-dots popup menu button for notes.txt
      final moreButton = find.byTooltip('Opzioni per notes.txt');
      expect(moreButton, findsOneWidget);

      await tester.tap(moreButton);
      await tester.pumpAndSettle();

      expect(find.text('Crea link condivisibile'), findsOneWidget);

      await tester.tap(find.text('Crea link condivisibile'));
      await tester.pumpAndSettle();

      expect(mockRclone.lastRemote, equals('my_onedrive'));
      expect(mockRclone.lastFilePath, equals('notes.txt'));

      expect(find.byType(ShareLinkDialog), findsOneWidget);
      expect(find.text('https://onedrive.live.com/redir?resid=notes-file'), findsOneWidget);
    });
  });
}

