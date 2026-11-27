import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unifycloud/l10n/l10n_extension.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/providers/clipboard_provider.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/screens/home_screen.dart';
import 'package:unifycloud/src/ui/screens/main_scaffold.dart';

class _FakeRcloneService extends RcloneService {
  @override
  Future<List<CloudItem>> listDirectory({
    required String remote,
    String path = '',
  }) async {
    return const [
      CloudItem(name: 'Sub', path: 'Sub', isDir: true, size: 0),
      CloudItem(name: 'doc.txt', path: 'doc.txt', isDir: false, size: 128),
    ];
  }
}

class _TestFileExplorerNotifier extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  _TestFileExplorerNotifier(this._initial);
  final FileExplorerState _initial;
  int navigateUpCount = 0;

  @override
  FileExplorerState build() => _initial;

  @override
  Future<void> navigateUp() async {
    navigateUpCount++;
    if (state.currentPath.isEmpty) return;
    final parts = state.currentPath.split('/')..removeLast();
    state = state.copyWith(currentPath: parts.join('/'));
  }

  @override
  void setSearching(bool isSearching) {
    state = state.copyWith(
      isSearching: isSearching,
      searchQuery: isSearching ? state.searchQuery : '',
    );
  }

  @override
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  @override
  void enterSelectionMode() {
    state = state.copyWith(selectionModeActive: true, selectedPaths: const {});
  }

  @override
  void toggleSelection(String path) {
    final next = Set<String>.from(state.selectedPaths);
    if (next.contains(path)) {
      next.remove(path);
    } else {
      next.add(path);
    }
    state = state.copyWith(selectedPaths: next);
  }

  @override
  void clearSelection() {
    state = state.copyWith(selectionModeActive: false, selectedPaths: const {});
  }

  @override
  Future<void> openRemote(String remote, {String path = ''}) async {
    state = state.copyWith(
      currentRemote: remote,
      currentPath: path,
      isSearching: false,
      searchQuery: '',
      selectionModeActive: false,
      selectedPaths: const {},
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestCloudAccountsNotifier extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  _TestCloudAccountsNotifier(this._initial);
  final CloudAccountsState _initial;

  @override
  CloudAccountsState build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GoRouter _buildTestRouter({String initialLocation = '/explorer'}) {
  final rootKey = GlobalKey<NavigatorState>();
  final homeKey = GlobalKey<NavigatorState>();
  final explorerKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: homeKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: explorerKey,
            routes: [
              GoRoute(
                path: '/explorer',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FileExplorerScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

void main() {
  const sampleItems = [
    CloudItem(name: 'Photos', path: 'Photos', isDir: true, size: 0),
    CloudItem(name: 'notes.txt', path: 'notes.txt', isDir: false, size: 512),
  ];

  group('FileExplorerNotifier search & selection state tests', () {
    test('setSearching toggles search and clears query when closing', () async {
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(_FakeRcloneService()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(fileExplorerProvider.notifier);
      await notifier.openRemote('Drive');

      notifier.setSearching(true);
      notifier.setSearchQuery('doc');
      expect(container.read(fileExplorerProvider).isSearching, isTrue);
      expect(container.read(fileExplorerProvider).searchQuery, equals('doc'));

      notifier.setSearching(false);
      expect(container.read(fileExplorerProvider).isSearching, isFalse);
      expect(container.read(fileExplorerProvider).searchQuery, isEmpty);
    });

    test('enterSelectionMode starts with 0 items and clearSelection exits', () async {
      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(_FakeRcloneService()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(fileExplorerProvider.notifier);
      await notifier.openRemote('Drive');

      notifier.enterSelectionMode();
      final state = container.read(fileExplorerProvider);
      expect(state.isSelectionMode, isTrue);
      expect(state.selectedCount, equals(0));

      notifier.clearSelection();
      expect(container.read(fileExplorerProvider).isSelectionMode, isFalse);
    });
  });

  group('Explore Back Button Protection Tests', () {
    testWidgets('System back at Explore root does not exit app and stays on Explore',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );
      final router = _buildTestRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: appLocalizationsDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FileExplorerScreen), findsOneWidget);

      // Simulate Android system back button press
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(handled, isTrue);
      expect(find.byType(FileExplorerScreen), findsOneWidget);
      expect(explorerNotifier.navigateUpCount, equals(0));
    });

    testWidgets('System back navigates up, clears selection, and closes search in order',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          currentPath: 'Work/2026',
          items: sampleItems,
          isSearching: true,
          searchQuery: 'notes',
          selectionModeActive: true,
          selectedPaths: {'notes.txt'},
        ),
      );
      final router = _buildTestRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: appLocalizationsDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1st back: clears selection without closing search or navigating up
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(explorerNotifier.state.isSelectionMode, isFalse);
      expect(explorerNotifier.state.isSearching, isTrue);
      expect(explorerNotifier.state.currentPath, equals('Work/2026'));

      // 2nd back: closes search without navigating up
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(explorerNotifier.state.isSearching, isFalse);
      expect(explorerNotifier.state.searchQuery, isEmpty);
      expect(explorerNotifier.state.currentPath, equals('Work/2026'));

      // 3rd back: navigates up to parent folder
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(explorerNotifier.navigateUpCount, equals(1));
      expect(explorerNotifier.state.currentPath, equals('Work'));

      // 4th back: navigates up to root
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(explorerNotifier.state.currentPath, isEmpty);

      // 5th back at root: stays on Explore and does not pop/exit
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(handled, isTrue);
      expect(find.byType(FileExplorerScreen), findsOneWidget);
    });

    testWidgets('Explore PopScope in IndexedStack does not block Home branch back behavior',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          currentPath: 'Work',
          items: sampleItems,
        ),
      );
      final router = _buildTestRouter(initialLocation: '/');
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(
                      name: 'Drive',
                      type: 'drive',
                      quota: StorageQuota(
                        total: 1000,
                        used: 200,
                        free: 800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: appLocalizationsDelegates,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Explorer briefly so its branch mounts in IndexedStack, then back to Home
      router.go('/explorer');
      await tester.pumpAndSettle();
      router.go('/');
      await tester.pumpAndSettle();

      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // Home has no PopScope(canPop: false), and Explore's navigateUp was NOT triggered
      expect(handled, isFalse);
      expect(explorerNotifier.navigateUpCount, equals(0));
    });
  });

  group('AppBar Compaction & Disk Chooser Width Tests', () {
    testWidgets('Narrow AppBar compacts Select, Sort, and Grid into overflow menu leaving Search and Upload outside',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
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

      // Only Search, Upload, and overflow menu are outside
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.upload_rounded), findsOneWidget);
      expect(find.byKey(const ValueKey('explorer_overflow_menu')), findsOneWidget);

      // Select, Sort, View, and New Folder are compacted into the overflow menu
      expect(find.byIcon(Icons.checklist_rounded), findsNothing);
      expect(find.byIcon(Icons.sort), findsNothing);
      expect(find.byIcon(Icons.grid_view_outlined), findsNothing);
      expect(find.byIcon(Icons.create_new_folder_outlined), findsNothing);

      // Open overflow menu and tap Multiple selection
      await tester.tap(find.byKey(const ValueKey('explorer_overflow_menu')));
      await tester.pumpAndSettle();

      expect(find.text('Multiple selection'), findsOneWidget);
      expect(find.text('Grid view'), findsOneWidget);
      expect(find.text('New Folder'), findsOneWidget);

      await tester.tap(find.text('Multiple selection'));
      await tester.pumpAndSettle();

      // Selection starts from 0
      expect(find.text('0 selected'), findsOneWidget);
    });

    testWidgets('Wide AppBar keeps Search, Select, Sort, Grid, Upload, and New Folder outside',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
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

      expect(find.byKey(const ValueKey('explorer_overflow_menu')), findsNothing);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_outlined), findsOneWidget);
      expect(find.byIcon(Icons.upload_rounded), findsOneWidget);
      expect(find.byIcon(Icons.create_new_folder_outlined), findsOneWidget);
    });

    testWidgets('Disk chooser button wraps tightly around active disk name instead of filling AppBar',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [
                    CloudRemote(name: 'Drive', type: 'drive'),
                    CloudRemote(
                      name: 'VeryLongCorporateBackupServerName',
                      type: 'sftp',
                    ),
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

      final chooserSize =
          tester.getSize(find.byKey(const ValueKey('disk_chooser_button')));
      // Must stay compact around "Drive" rather than stretching across the 800px AppBar
      expect(chooserSize.width, lessThan(180));
    });
  });

  group('Long Press Action Setting Integration Tests', () {
    testWidgets('Long press opens context menu when configured to contextMenu',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(
                const AppSettings(longPressAction: LongPressAction.contextMenu),
              ),
            ),
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
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

      await tester.longPress(find.text('notes.txt'));
      await tester.pumpAndSettle();

      expect(find.text('Download to local'), findsOneWidget);
      expect(find.text('Rename'), findsOneWidget);
      expect(explorerNotifier.state.isSelectionMode, isFalse);
    });

    testWidgets('Long press cuts item to clipboard when configured to cut',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(
                const AppSettings(longPressAction: LongPressAction.cut),
              ),
            ),
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
                ),
              ),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              container = ProviderScope.containerOf(context);
              return const MaterialApp(home: FileExplorerScreen());
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.text('notes.txt'));
      await tester.pumpAndSettle();

      final clipboard = container.read(clipboardProvider);
      expect(clipboard.hasItem, isTrue);
      expect(clipboard.isCut, isTrue);
      expect(clipboard.item?.name, equals('notes.txt'));
      expect(find.text('Paste here'), findsOneWidget);
    });

    testWidgets('Long press toggles selection when configured to select',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final explorerNotifier = _TestFileExplorerNotifier(
        const FileExplorerState(
          currentRemote: 'Drive',
          items: sampleItems,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(
                const AppSettings(),
              ),
            ),
            fileExplorerProvider.overrideWith(() => explorerNotifier),
            cloudAccountsProvider.overrideWith(
              () => _TestCloudAccountsNotifier(
                const CloudAccountsState(
                  remotes: [CloudRemote(name: 'Drive', type: 'drive')],
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

      await tester.longPress(find.text('notes.txt'));
      await tester.pumpAndSettle();

      expect(explorerNotifier.state.isSelectionMode, isTrue);
      expect(explorerNotifier.state.selectedPaths, contains('notes.txt'));
    });
  });
}
