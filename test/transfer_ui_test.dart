import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  final TransferState _initial;
  TransferNotifierMock(this._initial);

  @override
  TransferState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ClipboardNotifierMock extends Notifier<ClipboardState>
    implements ClipboardNotifier {
  final ClipboardState _initial;
  ClipboardNotifierMock(this._initial);

  @override
  ClipboardState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CloudAccountsNotifierMock extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  final CloudAccountsState _initial;
  CloudAccountsNotifierMock(this._initial);

  @override
  CloudAccountsState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FileExplorerNotifierMock extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  final FileExplorerState _initial;
  FileExplorerNotifierMock(this._initial);

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
                const TransferState(transfers: []),
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

      expect(find.textContaining('trasferimento'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('TransferFloatingBar renders active transfers, speed and progress',
        (tester) async {
      final job = TransferJob(
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
                TransferState(transfers: [job]),
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

      expect(find.text('1 trasferimento attivo'), findsOneWidget);
      expect(find.text('1.0 MB/s'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('TransferSheet lists active, completed and failed transfers',
        (tester) async {
      final runningJob = TransferJob(
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

      final completedJob = TransferJob(
        id: 'job_2',
        srcRemote: '',
        srcPath: '/Local/photo.jpg',
        dstRemote: 'OneDrive',
        dstPath: 'Pictures/photo.jpg',
        status: TransferStatus.completed,
        bytes: 1048576,
        totalBytes: 1048576,
        percentage: 100,
        speed: 0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                TransferState(transfers: [runningJob, completedJob]),
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

      expect(find.text('Coda Trasferimenti (2)'), findsOneWidget);
      expect(find.text('video.mp4'), findsOneWidget);
      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.text('Pulisci'), findsOneWidget);
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
                  isLoading: false,
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
                  items: [],
                ),
              ),
            ),
            clipboardProvider.overrideWith(
              () => ClipboardNotifierMock(
                const ClipboardState(
                  item: clipboardItem,
                  sourceRemote: 'GoogleDrive',
                  isCut: false,
                ),
              ),
            ),
            transferProvider.overrideWith(
              () => TransferNotifierMock(
                const TransferState(transfers: []),
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
      expect(find.text('Incolla qui'), findsOneWidget);
      expect(
        find.textContaining('Copia: "budget_2026.xlsx" da [GoogleDrive]'),
        findsOneWidget,
      );
    });
  });
}

