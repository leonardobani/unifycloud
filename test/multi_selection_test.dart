import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/clipboard_provider.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/theme/cosmic_icons.dart';

class RcloneServiceMock implements RcloneService {
  final List<String> deletedPaths = [];
  final List<CloudItem> itemsToReturn;

  RcloneServiceMock({this.itemsToReturn = const []});

  @override
  Future<void> deleteFile({required String remote, required String filePath}) async {
    deletedPaths.add(filePath);
  }

  @override
  Future<List<CloudItem>> listDirectory({required String remote, String path = ''}) async {
    return itemsToReturn;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TransferNotifierMock extends Notifier<TransferState> implements TransferNotifier {
  final List<String> transferredPaths = [];

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
    transferredPaths.add(srcPath);
    return TransferJob(
      id: 'job_test_${transferredPaths.length}',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
      status: TransferStatus.running,
      totalBytes: 1000,
      bytes: 0,
      speed: 100,
      percentage: 0,
      startTime: DateTime.now(),
    );
  }

  @override
  Future<TransferJob> downloadFile({
    required String srcRemote,
    required String srcPath,
    String? customTargetDir,
  }) async {
    transferredPaths.add(srcPath);
    return TransferJob(
      id: 'download_${transferredPaths.length}',
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: '',
      dstPath: '/downloads/$srcPath',
      isMove: false,
      status: TransferStatus.running,
      totalBytes: 2000,
      bytes: 0,
      speed: 200,
      percentage: 0,
      startTime: DateTime.now(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class InteractiveFileExplorerNotifier extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  final FileExplorerState _initialState;
  final List<CloudItem> deletedItems = [];

  InteractiveFileExplorerNotifier(this._initialState);

  @override
  FileExplorerState build() => _initialState;

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
  void selectAll() {
    final allPaths = state.displayItems.map((e) => e.path).toSet();
    state = state.copyWith(selectedPaths: allPaths);
  }

  @override
  void clearSelection() {
    state = state.copyWith(selectedPaths: const {});
  }

  @override
  Future<void> deleteSelected() async {
    deletedItems.addAll(state.selectedItems);
    clearSelection();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Multi-Selection Unit Tests', () {
    test('FileExplorerState calculates isSelectionMode, selectedCount, and selectedItems', () {
      const item1 = CloudItem(name: 'file1.txt', path: 'Docs/file1.txt', isDir: false, size: 100);
      const item2 = CloudItem(name: 'file2.txt', path: 'Docs/file2.txt', isDir: false, size: 200);
      const folder = CloudItem(name: 'Folder', path: 'Docs/Folder', isDir: true, size: 0);

      const emptyState = FileExplorerState(
        items: [item1, item2, folder],
        selectedPaths: {},
      );
      expect(emptyState.isSelectionMode, isFalse);
      expect(emptyState.selectedCount, 0);
      expect(emptyState.selectedItems, isEmpty);

      final selectedState = FileExplorerState(
        items: [item1, item2, folder],
        selectedPaths: {'Docs/file1.txt', 'Docs/Folder'},
      );
      expect(selectedState.isSelectionMode, isTrue);
      expect(selectedState.selectedCount, 2);
      expect(selectedState.selectedItems.length, 2);
      expect(selectedState.selectedItems.map((e) => e.name), containsAll(['file1.txt', 'Folder']));
    });

    test('FileExplorerNotifier toggles, selects all, clears and deletes selected', () async {
      const item1 = CloudItem(name: 'doc1.pdf', path: 'doc1.pdf', isDir: false, size: 500);
      const item2 = CloudItem(name: 'doc2.pdf', path: 'doc2.pdf', isDir: false, size: 600);
      const item3 = CloudItem(name: 'subfolder', path: 'subfolder', isDir: true, size: 0);

      final mockRclone = RcloneServiceMock(itemsToReturn: [item1, item2, item3]);

      final containerRef = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(mockRclone),
        ],
      );

      final notifier = containerRef.read(fileExplorerProvider.notifier);
      await notifier.openRemote('TestDrive');

      expect(containerRef.read(fileExplorerProvider).items.length, 3);
      expect(containerRef.read(fileExplorerProvider).isSelectionMode, isFalse);

      // Toggle selection
      notifier.toggleSelection('doc1.pdf');
      expect(containerRef.read(fileExplorerProvider).isSelectionMode, isTrue);
      expect(containerRef.read(fileExplorerProvider).selectedPaths, contains('doc1.pdf'));
      expect(containerRef.read(fileExplorerProvider).selectedCount, 1);

      // Toggle again removes it
      notifier.toggleSelection('doc1.pdf');
      expect(containerRef.read(fileExplorerProvider).isSelectionMode, isFalse);
      expect(containerRef.read(fileExplorerProvider).selectedCount, 0);

      // Select all
      notifier.selectAll();
      expect(containerRef.read(fileExplorerProvider).selectedCount, 3);
      expect(containerRef.read(fileExplorerProvider).selectedPaths,
          containsAll(['doc1.pdf', 'doc2.pdf', 'subfolder']));

      // Clear selection
      notifier.clearSelection();
      expect(containerRef.read(fileExplorerProvider).selectedCount, 0);
      expect(containerRef.read(fileExplorerProvider).isSelectionMode, isFalse);

      // Delete selected
      notifier.toggleSelection('doc1.pdf');
      notifier.toggleSelection('subfolder');
      await notifier.deleteSelected();

      expect(mockRclone.deletedPaths, containsAll(['doc1.pdf', 'subfolder']));
      expect(containerRef.read(fileExplorerProvider).isSelectionMode, isFalse);
    });

    test('ClipboardNotifier copyAll, cutAll, and multi-pasteTo', () async {
      const itemA = CloudItem(name: 'a.txt', path: 'a.txt', isDir: false, size: 10);
      const itemB = CloudItem(name: 'b.txt', path: 'b.txt', isDir: false, size: 20);

      final transferMock = TransferNotifierMock();
      final container = ProviderContainer(
        overrides: [
          transferProvider.overrideWith(() => transferMock),
        ],
      );

      final clipboardNotifier = container.read(clipboardProvider.notifier);

      // Test copyAll
      clipboardNotifier.copyAll([itemA, itemB], 'CloudSrc');
      var state = container.read(clipboardProvider);
      expect(state.hasItem, isTrue);
      expect(state.count, 2);
      expect(state.isCut, isFalse);
      expect(state.actionLabel, 'Copia');

      // Paste
      final copyJobs = await clipboardNotifier.pasteTo(
        targetRemote: 'CloudDst',
        targetPath: 'TargetFolder',
      );
      expect(copyJobs.length, 2);
      expect(transferMock.transferredPaths, containsAll(['a.txt', 'b.txt']));
      // After copy, clipboard remains populated
      expect(container.read(clipboardProvider).hasItem, isTrue);

      // Test cutAll
      transferMock.transferredPaths.clear();
      clipboardNotifier.cutAll([itemA, itemB], 'CloudSrc');
      state = container.read(clipboardProvider);
      expect(state.isCut, isTrue);
      expect(state.actionLabel, 'Sposta');

      // Paste cut items
      final cutJobs = await clipboardNotifier.pasteTo(
        targetRemote: 'CloudDst',
        targetPath: '',
      );
      expect(cutJobs.length, 2);
      // After cut, clipboard is cleared
      expect(container.read(clipboardProvider).hasItem, isFalse);
    });
  });

  group('Multi-Selection Widget & CAB Tests', () {
    const item1 = CloudItem(name: 'photo.jpg', path: 'Photos/photo.jpg', isDir: false, size: 1024);
    const item2 = CloudItem(name: 'video.mp4', path: 'Photos/video.mp4', isDir: false, size: 5000000);
    const folder = CloudItem(name: 'Albums', path: 'Photos/Albums', isDir: true, size: 0);

    testWidgets('Renders Contextual Action Bar when items are selected', (tester) async {
      final notifier = InteractiveFileExplorerNotifier(
        FileExplorerState(
          currentRemote: 'MyDrive',
          currentPath: 'Photos',
          items: const [item1, item2, folder],
          selectedPaths: {'Photos/photo.jpg'},
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      // Check CAB header
      expect(find.text('1 selezionati'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.closeSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.selectAllSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.downloadSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.copySvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.cutSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.deleteSvg,
        ),
        findsOneWidget,
      );

      // Normal mode action buttons should NOT be in the AppBar
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.uploadSvg,
        ),
        findsNothing,
      );

      // Check Checkbox is rendered on list items
      expect(find.byType(Checkbox), findsNWidgets(3));
    });

    testWidgets('Tapping Close button in CAB clears selection', (tester) async {
      final notifier = InteractiveFileExplorerNotifier(
        FileExplorerState(
          currentRemote: 'MyDrive',
          currentPath: 'Photos',
          items: const [item1, item2, folder],
          selectedPaths: {'Photos/photo.jpg', 'Photos/video.mp4'},
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      expect(find.text('2 selezionati'), findsOneWidget);

      // Tap close button
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.closeSvg,
        ),
      );
      await tester.pumpAndSettle();

      // Should return to normal AppBar
      expect(find.text('2 selezionati'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.uploadSvg,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Tapping Select All selects all items and updates icon to deselect', (tester) async {
      final notifier = InteractiveFileExplorerNotifier(
        FileExplorerState(
          currentRemote: 'MyDrive',
          currentPath: 'Photos',
          items: const [item1, item2, folder],
          selectedPaths: {'Photos/photo.jpg'},
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      expect(find.text('1 selezionati'), findsOneWidget);

      // Tap select all
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.selectAllSvg,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 selezionati'), findsOneWidget);
      // When all are selected, the button has tooltip 'Deseleziona tutti' and closeSvg icon
      final deselectBtn = find.byTooltip('Deseleziona tutti');
      expect(deselectBtn, findsOneWidget);

      // Tap deselect all
      await tester.tap(deselectBtn);
      await tester.pumpAndSettle();

      expect(find.text('3 selezionati'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.uploadSvg,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Tapping an item in selection mode toggles selection', (tester) async {
      final notifier = InteractiveFileExplorerNotifier(
        FileExplorerState(
          currentRemote: 'MyDrive',
          currentPath: 'Photos',
          items: const [item1, item2],
          selectedPaths: {'Photos/photo.jpg'},
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      expect(find.text('1 selezionati'), findsOneWidget);

      // Tap second item (video.mp4) to select it as well
      await tester.tap(find.text('video.mp4'));
      await tester.pumpAndSettle();

      expect(find.text('2 selezionati'), findsOneWidget);

      // Tap photo.jpg to deselect it
      await tester.tap(find.text('photo.jpg'));
      await tester.pumpAndSettle();

      expect(find.text('1 selezionati'), findsOneWidget);
    });

    testWidgets('Grid view renders checkboxes in selection mode', (tester) async {
      final notifier = InteractiveFileExplorerNotifier(
        FileExplorerState(
          currentRemote: 'MyDrive',
          currentPath: 'Photos',
          items: const [item1, item2],
          viewMode: FileViewMode.grid,
          selectedPaths: {'Photos/photo.jpg'},
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      // Grid items should have Checkbox widgets rendered
      expect(find.byType(Checkbox), findsNWidgets(2));
      expect(find.text('1 selezionati'), findsOneWidget);
    });
  });
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
