import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/pane_drag_data.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/clipboard_provider.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/widgets/commander_action_bar.dart';
import 'package:unifycloud/src/ui/widgets/file_explorer_pane_view.dart';

class RcloneServiceMock implements RcloneService {
  @override
  Future<List<TransferJob>> getAllTransfers() async => [];

  @override
  Future<List<CloudItem>> listDirectory({required String remote, String path = ''}) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TransferNotifierMock extends Notifier<TransferState>
    implements TransferNotifier {
  final List<Map<String, dynamic>> recordedTransfers = [];

  @override
  TransferState build() => const TransferState();

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
      id: 'job_dual_pane_${recordedTransfers.length}',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
      status: TransferStatus.running,
      totalBytes: 1024,
      bytes: 0,
      speed: 100,
      percentage: 0,
      startTime: DateTime.now(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CloudAccountsNotifierMock extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  final CloudAccountsState _state;
  CloudAccountsNotifierMock(this._state);

  @override
  CloudAccountsState build() => _state;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePaneNotifier extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  final FileExplorerState _initial;
  final List<Map<String, dynamic>> directTransfers = [];

  FakePaneNotifier(this._initial);

  @override
  FileExplorerState build() => _initial;

  @override
  Future<List<TransferJob>> transferItemsDirectly({
    required List<CloudItem> items,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    for (final item in items) {
      directTransfers.add({
        'item': item,
        'dstRemote': dstRemote,
        'dstPath': dstPath,
        'isMove': isMove,
      });
      // Also invoke transferProvider to simulate real behavior
      await ref.read(transferProvider.notifier).startTransfer(
            srcRemote: state.currentRemote ?? '',
            srcPath: item.path,
            dstRemote: dstRemote,
            dstPath: dstPath.isEmpty ? item.name : '$dstPath/${item.name}',
            isMove: isMove,
          );
    }
    return [];
  }

  @override
  void toggleSelection(String path) {
    final current = Set<String>.from(state.selectedPaths);
    if (current.contains(path)) {
      current.remove(path);
    } else {
      current.add(path);
    }
    state = state.copyWith(selectedPaths: current);
  }

  @override
  void clearSelection() {
    state = state.copyWith(selectedPaths: const {});
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<void> openRemote(String remote, {String path = ''}) async {
    state = state.copyWith(currentRemote: remote, currentPath: path);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const item1 = CloudItem(name: 'photo.jpg', path: 'photo.jpg', isDir: false, size: 5000);
  const folder1 = CloudItem(name: 'Backup', path: 'Backup', isDir: true, size: 0);

  const remoteDrive = CloudRemote(name: 'GoogleDrive', type: 'drive');
  const remoteOneDrive = CloudRemote(name: 'OneDrive', type: 'onedrive');
  const remoteLocal = CloudRemote(name: 'Disco Locale', type: 'local');

  group('Dual-Pane & Commander View Unit & State Tests', () {
    test('secondaryFileExplorerProvider maintains independent state from primary', () {
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(RcloneServiceMock()),
        ],
      );

      final leftNotifier = container.read(fileExplorerProvider.notifier);
      final rightNotifier = container.read(secondaryFileExplorerProvider.notifier);

      expect(container.read(fileExplorerProvider).currentRemote, isNull);
      expect(container.read(secondaryFileExplorerProvider).currentRemote, isNull);

      leftNotifier.openRemote('GoogleDrive', path: 'Work');
      rightNotifier.openRemote('OneDrive', path: 'Personal');

      expect(container.read(fileExplorerProvider).currentRemote, 'GoogleDrive');
      expect(container.read(fileExplorerProvider).currentPath, 'Work');

      expect(container.read(secondaryFileExplorerProvider).currentRemote, 'OneDrive');
      expect(container.read(secondaryFileExplorerProvider).currentPath, 'Personal');
    });

    test('dualPaneActiveProvider defaults to settings.dualPaneEnabled and toggles correctly', () {
      final container = ProviderContainer();
      expect(container.read(dualPaneActiveProvider), isTrue);

      container.read(dualPaneActiveProvider.notifier).toggle();
      expect(container.read(dualPaneActiveProvider), isFalse);

      container.read(dualPaneActiveProvider.notifier).toggle();
      expect(container.read(dualPaneActiveProvider), isTrue);
    });

    test('AppSettings includes dualPaneEnabled with serialization support', () {
      const defaultSettings = AppSettings();
      expect(defaultSettings.dualPaneEnabled, isTrue);

      final json = defaultSettings.toJson();
      expect(json['dual_pane_enabled'], isTrue);

      final deserialized = AppSettings.fromJson(json);
      expect(deserialized.dualPaneEnabled, isTrue);

      final modified = defaultSettings.copyWith(dualPaneEnabled: false);
      expect(modified.dualPaneEnabled, isFalse);
    });
  });

  group('Dual-Pane Responsive & Widget Tests', () {
    testWidgets('Renders dual panes and CommanderActionBar on wide screens (>= 900px)',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final leftNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'GoogleDrive',
          currentPath: 'Projects',
          items: [item1],
        ),
      );

      final rightNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'OneDrive',
          currentPath: 'Archives',
          items: [folder1],
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [remoteDrive, remoteOneDrive, remoteLocal],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => leftNotifier),
            secondaryFileExplorerProvider.overrideWith(() => rightNotifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Expect both pane views to be rendered
      expect(find.byType(FileExplorerPaneView), findsNWidgets(2));
      expect(find.text('Sinistra: '), findsOneWidget);
      expect(find.text('Destra: '), findsOneWidget);

      // Expect items from both panes
      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.text('Backup'), findsOneWidget);

      // Expect Commander action bar at the bottom
      expect(find.byType(CommanderActionBar), findsOneWidget);
      expect(find.text('Copia a destra ->'), findsOneWidget);
      expect(find.text('<- Copia a sinistra'), findsOneWidget);
    });

    testWidgets('Renders single pane on narrow screens (< 900px)', (tester) async {
      tester.view.physicalSize = const Size(750, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final leftNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'GoogleDrive',
          currentPath: 'Projects',
          items: [item1],
        ),
      );

      final rightNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'OneDrive',
          currentPath: 'Archives',
          items: [folder1],
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [remoteDrive, remoteOneDrive],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => leftNotifier),
            secondaryFileExplorerProvider.overrideWith(() => rightNotifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Expect ONLY single pane view
      expect(find.byType(FileExplorerPaneView), findsOneWidget);
      expect(find.byType(CommanderActionBar), findsNothing);
      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.text('Backup'), findsNothing);
    });

    testWidgets('Commander action bar transfers items directly without touching clipboard',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final transferMock = TransferNotifierMock();

      final leftNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'GoogleDrive',
          currentPath: 'Work',
          items: [item1],
          selectedPaths: {'photo.jpg'},
        ),
      );

      final rightNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'OneDrive',
          currentPath: 'BackupDest',
          items: [],
        ),
      );

      late ProviderContainer containerRef;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(() => transferMock),
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [remoteDrive, remoteOneDrive],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => leftNotifier),
            secondaryFileExplorerProvider.overrideWith(() => rightNotifier),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              containerRef = ProviderScope.containerOf(context);
              return const MaterialApp(
                home: FileExplorerScreen(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap 'Copia a destra' button in CommanderActionBar
      final copyBtn = find.text('Copia a destra (1)');
      expect(copyBtn, findsOneWidget);

      await tester.tap(copyBtn);
      await tester.pump();

      // Check transfer was dispatched via TransferProvider
      expect(transferMock.recordedTransfers.length, 1);
      final recorded = transferMock.recordedTransfers.first;
      expect(recorded['srcRemote'], 'GoogleDrive');
      expect(recorded['srcPath'], 'photo.jpg');
      expect(recorded['dstRemote'], 'OneDrive');
      expect(recorded['dstPath'], 'BackupDest/photo.jpg');
      expect(recorded['isMove'], isFalse);

      // Verify that clipboard was completely UNTOUCHED
      final clipboardState = containerRef.read(clipboardProvider);
      expect(clipboardState.hasItem, isFalse);
      expect(clipboardState.items, isEmpty);
    });

    testWidgets('Drag-and-drop between panes dispatches direct cloud transfer',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final transferMock = TransferNotifierMock();

      final leftNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'GoogleDrive',
          currentPath: '',
          items: [item1],
        ),
      );

      final rightNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'OneDrive',
          currentPath: 'DestinationFolder',
          items: [folder1],
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferProvider.overrideWith(() => transferMock),
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [remoteDrive, remoteOneDrive],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => leftNotifier),
            secondaryFileExplorerProvider.overrideWith(() => rightNotifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the draggable item in left pane
      final draggableFinder = find.byWidgetPredicate(
        (w) => w is Draggable<PaneDragData>,
      );
      expect(draggableFinder, findsAtLeastNWidgets(1));

      // Find the drag target in the right pane
      final dragTargets = find.byWidgetPredicate(
        (w) => w is DragTarget<PaneDragData>,
      );
      expect(dragTargets, findsAtLeastNWidgets(2)); // Pane targets + folder targets

      // Drag from item to right pane center
      final rightPaneCenter = tester.getCenter(dragTargets.last);
      final itemCenter = tester.getCenter(draggableFinder.first);

      final gesture = await tester.startGesture(itemCenter, kind: PointerDeviceKind.mouse);
      await gesture.moveTo(rightPaneCenter);
      await tester.pump();
      await gesture.up();
      await tester.pump();

      // Expect transfer to have been dispatched
      expect(transferMock.recordedTransfers.isNotEmpty, isTrue);
      final transfer = transferMock.recordedTransfers.first;
      expect(transfer['srcRemote'], 'GoogleDrive');
      expect(transfer['dstRemote'], 'OneDrive');
    });

    testWidgets('AppBar toggle button toggles between single-pane and dual-pane on wide screens',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final leftNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'GoogleDrive',
          items: [item1],
        ),
      );

      final rightNotifier = FakePaneNotifier(
        const FileExplorerState(
          currentRemote: 'OneDrive',
          items: [folder1],
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [remoteDrive, remoteOneDrive],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => leftNotifier),
            secondaryFileExplorerProvider.overrideWith(() => rightNotifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially dual pane is active
      expect(find.byType(FileExplorerPaneView), findsNWidgets(2));

      // Find the toggle icon button
      final toggleButton = find.byIcon(Icons.splitscreen);
      expect(toggleButton, findsAtLeastNWidgets(1));

      // Tap to toggle off
      await tester.tap(toggleButton.first);
      await tester.pumpAndSettle();

      // Now single pane is rendered
      expect(find.byType(FileExplorerPaneView), findsOneWidget);

      // Tap to toggle back on
      final toggleOnButton = find.byIcon(Icons.view_sidebar_outlined);
      expect(toggleOnButton, findsOneWidget);
      await tester.tap(toggleOnButton);
      await tester.pumpAndSettle();

      // Dual pane is back
      expect(find.byType(FileExplorerPaneView), findsNWidgets(2));
    });
  });
}

