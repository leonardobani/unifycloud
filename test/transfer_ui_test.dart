import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/clipboard_provider.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/widgets/transfer_panel.dart';

class TransferNotifierMock extends Notifier<TransferState>
    implements TransferNotifier {
  TransferNotifierMock(this._initial);
  final TransferState _initial;

  @override
  TransferState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ClipboardNotifierMock extends Notifier<ClipboardState>
    implements ClipboardNotifier {
  ClipboardNotifierMock(this._initial);
  final ClipboardState _initial;

  @override
  ClipboardState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CloudAccountsNotifierMock extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  CloudAccountsNotifierMock(this._initial);
  final CloudAccountsState _initial;

  @override
  CloudAccountsState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FileExplorerNotifierMock extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  FileExplorerNotifierMock(this._initial);
  final FileExplorerState _initial;

  @override
  FileExplorerState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Fase 6: Transfer UI & Clipboard Tests', () {
    testWidgets('TransferFloatingBar is hidden when active transfers count is 0',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                const TransferState(),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TransferFloatingBar(),
            ),
          ),
        ),
      );

      expect(find.textContaining('transfer'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('TransferFloatingBar renders active transfers, speed and progress',
        (tester) async {
      const job = TransferJob(
        id: 'job_42',
        srcRemote: 'GoogleDrive',
        srcPath: 'Documents/presentation.pdf',
        dstRemote: 'Dropbox',
        dstPath: 'Work/presentation.pdf',
        status: TransferStatus.running,
        bytes: 2097152, // 2 MB
        totalBytes: 10485760, // 10 MB
        percentage: 20,
        speed: 1048576, // 1 MB/s
        eta: 8,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                const TransferState(transfers: [job]),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TransferFloatingBar(),
            ),
          ),
        ),
      );

      expect(find.text('1 active transfer'), findsOneWidget);
      expect(find.text('1.0 MB/s'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('TransferSheet lists active, completed and failed transfers',
        (tester) async {
      const runningJob = TransferJob(
        id: 'job_1',
        srcRemote: 'Drive',
        srcPath: 'video.mp4',
        dstRemote: '',
        dstPath: '/Downloads/video.mp4',
        status: TransferStatus.running,
        bytes: 52428800,
        totalBytes: 104857600,
        percentage: 50,
        speed: 2097152,
        eta: 25,
      );

      const completedJob = TransferJob(
        id: 'job_2',
        srcRemote: '',
        srcPath: '/Local/photo.jpg',
        dstRemote: 'OneDrive',
        dstPath: 'Pictures/photo.jpg',
        status: TransferStatus.completed,
        bytes: 1048576,
        totalBytes: 1048576,
        percentage: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                const TransferState(transfers: [runningJob, completedJob]),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TransferSheet(),
            ),
          ),
        ),
      );

      expect(find.text('Transfer Queue (2)'), findsOneWidget);
      expect(find.text('video.mp4'), findsOneWidget);
      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('FileExplorerScreen shows Upload button and Clipboard paste banner',
        (tester) async {
      const clipboardItem = CloudItem(
        name: 'budget_2026.xlsx',
        path: 'Finances/budget_2026.xlsx',
        isDir: false,
        size: 45000,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'GoogleDrive', type: 'drive'),
                    CloudRemote(name: 'WorkDropbox', type: 'dropbox'),
                  ],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(
              () => FileExplorerNotifierMock(
                const FileExplorerState(
                  currentRemote: 'WorkDropbox',
                  currentPath: 'Projects',
                ),
              ),
            ),
            clipboardProvider.overrideWith(
              () => ClipboardNotifierMock(
                const ClipboardState(
                  item: clipboardItem,
                  sourceRemote: 'GoogleDrive',
                ),
              ),
            ),
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                const TransferState(),
              ),
            ),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      // Verify Upload action in AppBar
      expect(find.byIcon(Icons.upload_file_outlined), findsOneWidget);

      // Verify Cloud-to-Cloud Clipboard Banner
      expect(find.text('Paste here'), findsOneWidget);
      expect(
        find.textContaining('Copy: "budget_2026.xlsx" from [GoogleDrive]'),
        findsOneWidget,
      );
    });
  });
}
