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
  FakeFileExplorerNotifier(this._initial);
  final FileExplorerState _initial;

  @override
  FileExplorerState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCloudAccountsNotifier extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  FakeCloudAccountsNotifier(this._initial);
  final CloudAccountsState _initial;

  @override
  CloudAccountsState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ShareLinkDialog Widget Tests', () {
    const testFile = CloudItem(
      path: 'documents/presentation.pdf',
      name: 'presentation.pdf',
      size: 2048,
      isDir: false,
    );

    const testFolder = CloudItem(
      path: 'shared_photos',
      name: 'shared_photos',
      size: 0,
      isDir: true,
    );

    testWidgets('renders file information, link, and buttons correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShareLinkDialog(
              item: testFile,
              link: 'https://drive.google.com/file/d/abc123xyz',
            ),
          ),
        ),
      );

      expect(find.text('Shareable Link'), findsOneWidget);
      expect(find.text('presentation.pdf'), findsOneWidget);
      expect(find.text('Anyone with this link will be able to access this file:'), findsOneWidget);
      expect(find.text('https://drive.google.com/file/d/abc123xyz'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Copy Link'), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file_rounded), findsOneWidget);
    });

    testWidgets('renders folder information correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShareLinkDialog(
              item: testFolder,
              link: 'https://onedrive.live.com/?id=folder123',
            ),
          ),
        ),
      );

      expect(find.text('Shareable Link'), findsOneWidget);
      expect(find.text('shared_photos'), findsOneWidget);
      expect(find.text('Anyone with this link will be able to access this folder:'), findsOneWidget);
      expect(find.text('https://onedrive.live.com/?id=folder123'), findsOneWidget);
      expect(find.byIcon(Icons.folder_rounded), findsOneWidget);
    });

    testWidgets('tapping "Copy Link" copies link to clipboard, shows SnackBar and closes dialog', (tester) async {
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

      await tester.tap(find.widgetWithText(FilledButton, 'Copy Link'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);

      final copyCall = clipboardCalls.firstWhere((c) => c.method == 'Clipboard.setData');
      expect((copyCall.arguments as Map)['text'], equals('https://dropbox.com/s/sample_link'));

      expect(find.text('Link copied to clipboard!'), findsOneWidget);
    });

    testWidgets('tapping "Close" closes dialog without modifying clipboard', (tester) async {
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

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);
      expect(clipboardCalls.any((c) => c.method == 'Clipboard.setData'), isFalse);
    });
  });

  group('FileContextMenu Share Link Tests', () {
    const testFile = CloudItem(
      path: 'contracts/document.pdf',
      name: 'document.pdf',
      size: 4096,
      isDir: false,
    );

    testWidgets('shows "Create shareable link" in right-click context menu and handles success', (tester) async {
      final mockRclone = MockShareRcloneService();
      mockRclone.mockLinkToReturn = 'https://drive.google.com/file/d/test-doc-123';

      const fileExplorerState = FileExplorerState(
        currentRemote: 'gdrive_work',
        currentPath: 'contracts',
        items: [testFile],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(fileExplorerState)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FileContextMenuRegion(
                item: testFile,
                child: Text('Right click target'),
              ),
            ),
          ),
        ),
      );

      // Trigger secondary tap (right click)
      await tester.tap(find.text('Right click target'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      expect(find.text('Create shareable link'), findsOneWidget);

      // Tap the share link menu option
      await tester.tap(find.text('Create shareable link'));
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

      const fileExplorerState = FileExplorerState(
        currentRemote: 'local_disk',
        items: [testFile],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rcloneServiceProvider.overrideWithValue(mockRclone),
            fileExplorerProvider.overrideWith(() => FakeFileExplorerNotifier(fileExplorerState)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FileContextMenuRegion(
                item: testFile,
                child: Text('Right click target'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Right click target'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create shareable link'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareLinkDialog), findsNothing);
      expect(find.text('This cloud provider does not support creating public links.'), findsOneWidget);
    });
  });

  group('FileExplorerScreen 3-Dots Menu Share Link Tests', () {
    const testFile = CloudItem(
      path: 'notes.txt',
      name: 'notes.txt',
      size: 512,
      isDir: false,
    );

    testWidgets('3-dots menu contains "Create shareable link" and creates link', (tester) async {
      final mockRclone = MockShareRcloneService();
      mockRclone.mockLinkToReturn = 'https://onedrive.live.com/redir?resid=notes-file';

      const fileExplorerState = FileExplorerState(
        currentRemote: 'my_onedrive',
        items: [testFile],
      );

      const cloudAccountsState = CloudAccountsState(
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
      final moreButton = find.byTooltip('Options for notes.txt');
      expect(moreButton, findsOneWidget);

      await tester.tap(moreButton);
      await tester.pumpAndSettle();

      expect(find.text('Create shareable link'), findsOneWidget);

      await tester.tap(find.text('Create shareable link'));
      await tester.pumpAndSettle();

      expect(mockRclone.lastRemote, equals('my_onedrive'));
      expect(mockRclone.lastFilePath, equals('notes.txt'));

      expect(find.byType(ShareLinkDialog), findsOneWidget);
      expect(find.text('https://onedrive.live.com/redir?resid=notes-file'), findsOneWidget);
    });
  });
}
