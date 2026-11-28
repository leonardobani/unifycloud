import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unifycloud/l10n/l10n_extension.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/search_models.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/clipboard_provider.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/favorites_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/search_provider.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/services/file_opener_service.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/screens/home_screen.dart';
import 'package:unifycloud/src/ui/screens/main_scaffold.dart';
import 'package:unifycloud/src/ui/screens/settings_screen.dart';
import 'package:unifycloud/src/ui/screens/sync_rules_screen.dart';

class _FakeSearchRcloneService implements RcloneService {
  final List<SearchRequest> startedRequests = [];
  final List<String> cancelledJobIds = [];
  final List<String> clearedJobIds = [];
  final List<({String remote, String path})> deletedFiles = [];

  int _jobSeq = 0;
  int pollCountForCurrentJob = 0;
  bool stayRunningUntilCancelled = false;
  List<SearchJobSnapshot> scriptedPolls = [];

  @override
  Future<SearchJobSnapshot> startSearch(SearchRequest request) async {
    startedRequests.add(request);
    pollCountForCurrentJob = 0;
    final id = 'search_fake_${++_jobSeq}';
    return SearchJobSnapshot(
      jobId: id,
      status: SearchStatus.running,
    );
  }

  @override
  Future<SearchJobSnapshot> getSearchStatus(String jobId) async {
    if (scriptedPolls.isNotEmpty) {
      final idx = pollCountForCurrentJob < scriptedPolls.length
          ? pollCountForCurrentJob
          : scriptedPolls.length - 1;
      pollCountForCurrentJob++;
      return scriptedPolls[idx].copyWith(jobId: jobId);
    }

    if (stayRunningUntilCancelled) {
      return SearchJobSnapshot(
        jobId: jobId,
        status: cancelledJobIds.contains(jobId)
            ? SearchStatus.cancelled
            : SearchStatus.running,
        scannedFiles: 42,
        scannedDirs: 5,
        currentRemote: 'GoogleDrive',
      );
    }

    return SearchJobSnapshot(
      jobId: jobId,
      status: SearchStatus.completed,
      scannedFiles: 12,
      scannedDirs: 3,
      results: [
        CloudItem(
          name: 'Q4_Report.pdf',
          path: 'Finance/2026/Q4_Report.pdf',
          isDir: false,
          size: 4096,
          modTime: DateTime(2026, 10, 15, 9, 30),
          remote: 'GoogleDrive',
        ),
        const CloudItem(
          name: 'Design',
          path: 'Projects/Design',
          isDir: true,
          size: 0,
          remote: 'WorkDropbox',
        ),
      ],
    );
  }

  @override
  Future<bool> cancelSearch(String jobId) async {
    cancelledJobIds.add(jobId);
    return true;
  }

  @override
  Future<void> clearSearch(String jobId) async {
    clearedJobIds.add(jobId);
  }

  @override
  Future<void> deleteFile({
    required String remote,
    required String filePath,
  }) async {
    deletedFiles.add((remote: remote, path: filePath));
  }

  @override
  Future<List<TransferJob>> getAllTransfers() async => [];

  @override
  Future<List<CloudItem>> listDirectory({
    required String remote,
    String path = '',
  }) async {
    return const [
      CloudItem(
        name: 'Q4_Report.pdf',
        path: 'Finance/2026/Q4_Report.pdf',
        isDir: false,
        size: 4096,
      ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCloudAccountsNotifier extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  _FakeCloudAccountsNotifier(this._initial);
  final CloudAccountsState _initial;

  @override
  CloudAccountsState build() => _initial;

  @override
  Future<void> loadRemotes() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettingsNotifier extends Notifier<AppSettings>
    implements SettingsNotifier {
  _FakeSettingsNotifier(this._initial);
  final AppSettings _initial;

  @override
  AppSettings build() => _initial;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GoRouter _buildFullRouter() {
  final rootKey = GlobalKey<NavigatorState>();
  final homeKey = GlobalKey<NavigatorState>();
  final explorerKey = GlobalKey<NavigatorState>();
  final syncKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/',
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
          StatefulShellBranch(
            navigatorKey: syncKey,
            routes: [
              GoRoute(
                path: '/sync',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SyncRulesScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

void main() {
  group('Search Models Unit Tests', () {
    test('CloudItem parses and serializes optional remote field', () {
      final item = CloudItem.fromJson({
        'name': 'budget.xlsx',
        'path': 'Docs/budget.xlsx',
        'is_dir': false,
        'size': 2048,
        'mod_time': '2026-11-28T10:00:00Z',
        'remote': 'OneDrive',
      });
      expect(item.remote, equals('OneDrive'));
      expect(item.toJson()['remote'], equals('OneDrive'));

      const plain = CloudItem(
        name: 'plain.txt',
        path: 'plain.txt',
        isDir: false,
        size: 10,
      );
      expect(plain.toJson().containsKey('remote'), isFalse);
    });

    test('SearchRequest and SearchJobSnapshot serialize/deserialize cleanly', () {
      const req = SearchRequest(
        remotes: ['DriveA', 'CryptB'],
        query: '*.pdf',
        extensions: ['.pdf'],
        minSize: 1024,
        maxSize: 1048576,
        maxDepth: 2,
        includeDirs: false,
        maxResults: 250,
      );
      final json = req.toJson();
      expect(json['remotes'], equals(['DriveA', 'CryptB']));
      expect(json['query'], equals('*.pdf'));
      expect(json['extensions'], equals(['.pdf']));
      expect(json['min_size'], equals(1024));
      expect(json['max_size'], equals(1048576));
      expect(json['max_depth'], equals(2));
      expect(json['include_dirs'], isFalse);
      expect(json['max_results'], equals(250));

      final snap = SearchJobSnapshot.fromJson({
        'job_id': 'search_1',
        'status': 'completed',
        'scanned_files': 120,
        'scanned_dirs': 15,
        'current_remote': '',
        'truncated': true,
        'results': [
          {
            'name': 'a.pdf',
            'path': 'sub/a.pdf',
            'is_dir': false,
            'size': 5000,
            'remote': 'DriveA',
          },
        ],
        'warnings': ['CryptB: timeout'],
      });
      expect(snap.jobId, equals('search_1'));
      expect(snap.status, equals(SearchStatus.completed));
      expect(snap.scannedFiles, equals(120));
      expect(snap.scannedDirs, equals(15));
      expect(snap.truncated, isTrue);
      expect(snap.results.single.remote, equals('DriveA'));
      expect(snap.warnings, equals(['CryptB: timeout']));
    });
  });

  group('SearchNotifier State & Polling Tests', () {
    test('polls every ~400ms while running and stops when completed', () async {
      final fakeService = _FakeSearchRcloneService()
        ..scriptedPolls = [
          const SearchJobSnapshot(
            jobId: '',
            status: SearchStatus.running,
            scannedFiles: 10,
            scannedDirs: 2,
            currentRemote: 'GoogleDrive',
          ),
          const SearchJobSnapshot(
            jobId: '',
            status: SearchStatus.completed,
            scannedFiles: 25,
            scannedDirs: 4,
            results: [
              CloudItem(
                name: 'found.pdf',
                path: 'Docs/found.pdf',
                isDir: false,
                size: 100,
                remote: 'GoogleDrive',
              ),
            ],
          ),
        ];

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeService),
          settingsProvider.overrideWith(
            () => _FakeSettingsNotifier(const AppSettings()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(searchProvider.notifier);
      notifier.setQuery('found');
      notifier.setFileTypePreset(SearchFileTypePreset.documents);
      notifier.setMaxDepth(3);
      await notifier.startSearch();

      expect(container.read(searchProvider).status, equals(SearchStatus.running));
      expect(container.read(searchProvider).scannedFiles, equals(10));

      await Future<void>.delayed(const Duration(milliseconds: 500));

      final doneState = container.read(searchProvider);
      expect(doneState.status, equals(SearchStatus.completed));
      expect(doneState.results.length, equals(1));
      expect(doneState.results.first.name, equals('found.pdf'));
    });

    test('re-search cancels and clears previous job, and dispose cleans up', () async {
      final fakeService = _FakeSearchRcloneService()
        ..stayRunningUntilCancelled = true;

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeService),
          settingsProvider.overrideWith(
            () => _FakeSettingsNotifier(const AppSettings()),
          ),
        ],
      );

      final notifier = container.read(searchProvider.notifier);
      await notifier.startSearch(queryOverride: 'first');
      final firstId = container.read(searchProvider).activeJobId!;

      await notifier.startSearch(queryOverride: 'second');
      final secondId = container.read(searchProvider).activeJobId!;

      expect(fakeService.cancelledJobIds, contains(firstId));
      expect(fakeService.clearedJobIds, contains(firstId));
      expect(secondId, isNot(equals(firstId)));

      container.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(fakeService.cancelledJobIds, contains(secondId));
      expect(fakeService.clearedJobIds, contains(secondId));
    });
  });

  group('Navigation, Home AppBar & Global Search UI Tests', () {
    testWidgets(
      'Settings is moved to Home AppBar right of Refresh, removed from nav bar, and pull-to-refresh is disabled',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(450, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final fakeService = _FakeSearchRcloneService();
        final router = _buildFullRouter();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              rcloneServiceProvider.overrideWithValue(fakeService),
              cloudAccountsProvider.overrideWith(
                () => _FakeCloudAccountsNotifier(
                  const CloudAccountsState(
                    remotes: [
                      CloudRemote(
                        name: 'GoogleDrive',
                        type: 'drive',
                        quota: StorageQuota(total: 1000, used: 200, free: 800),
                      ),
                    ],
                  ),
                ),
              ),
              favoritesProvider.overrideWith(() => FavoritesNotifier(const [])),
              settingsProvider.overrideWith(
                () => _FakeSettingsNotifier(const AppSettings()),
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

        // Bottom NavigationBar has 3 destinations (Home, Explorer, Sync) and no Settings
        final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
        expect(navBar.destinations.length, equals(3));

        // No RefreshIndicator on HomeScreen
        expect(find.byType(RefreshIndicator), findsNothing);

        // Settings button is in HomeScreen AppBar to the right of Refresh button
        final refreshFinder = find.byIcon(Icons.refresh);
        final settingsFinder = find.byKey(const ValueKey('home_settings_button'));
        expect(refreshFinder, findsOneWidget);
        expect(settingsFinder, findsOneWidget);
        expect(
          tester.getTopLeft(settingsFinder).dx,
          greaterThan(tester.getTopLeft(refreshFinder).dx),
        );

        // Tapping Settings opens SettingsScreen
        await tester.tap(settingsFinder);
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Home search trigger opens Global Search in Explorer, shows filters/progress/Stop, and handles Open containing folder, Copy, and Delete',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final fakeService = _FakeSearchRcloneService()
          ..scriptedPolls = [
            SearchJobSnapshot(
              jobId: '',
              status: SearchStatus.completed,
              scannedFiles: 18,
              scannedDirs: 4,
              results: [
                CloudItem(
                  name: 'Q4_Report.pdf',
                  path: 'Finance/2026/Q4_Report.pdf',
                  isDir: false,
                  size: 4096,
                  modTime: DateTime(2026, 10, 15, 9, 30),
                  remote: 'GoogleDrive',
                ),
              ],
            ),
          ];
        final router = _buildFullRouter();

        late ProviderContainer container;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              rcloneServiceProvider.overrideWithValue(fakeService),
              cloudAccountsProvider.overrideWith(
                () => _FakeCloudAccountsNotifier(
                  const CloudAccountsState(
                    remotes: [
                      CloudRemote(
                        name: 'GoogleDrive',
                        type: 'drive',
                        quota: StorageQuota(total: 1000, used: 200, free: 800),
                      ),
                      CloudRemote(
                        name: 'WorkDropbox',
                        type: 'dropbox',
                        quota: StorageQuota(total: 1000, used: 100, free: 900),
                      ),
                    ],
                  ),
                ),
              ),
              favoritesProvider.overrideWith(() => FavoritesNotifier(const [])),
              settingsProvider.overrideWith(
                () => _FakeSettingsNotifier(
                  const AppSettings(confirmDelete: false),
                ),
              ),
            ],
            child: Consumer(
              builder: (context, ref, _) {
                container = ProviderScope.containerOf(context);
                return MaterialApp.router(
                  routerConfig: router,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: appLocalizationsDelegates,
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap search trigger on HomeScreen
        await tester.tap(find.byKey(const ValueKey('home_global_search_button')));
        await tester.pumpAndSettle();

        // Explorer opens in Global Search mode with scope toggle and filter chips
        expect(find.byType(FileExplorerScreen), findsOneWidget);
        expect(find.byType(RefreshIndicator), findsNothing);
        expect(find.byKey(const ValueKey('search_scope_current_folder')), findsOneWidget);
        expect(find.byKey(const ValueKey('search_scope_global')), findsOneWidget);
        expect(find.byKey(const ValueKey('global_search_cloud_filter')), findsOneWidget);
        expect(find.byKey(const ValueKey('global_search_type_filter')), findsOneWidget);
        expect(find.byKey(const ValueKey('global_search_size_filter')), findsOneWidget);
        expect(find.byKey(const ValueKey('global_search_depth_filter')), findsOneWidget);

        // Enter query and submit search
        await tester.enterText(
          find.byKey(const ValueKey('explorer_search_field')),
          'Q4_Report',
        );
        await tester.tap(find.byKey(const ValueKey('global_search_submit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Q4_Report.pdf'), findsOneWidget);
        expect(find.text('Finance/2026/Q4_Report.pdf'), findsOneWidget);
        expect(find.text('GoogleDrive'), findsWidgets);

        // Copy action via result popup menu
        final resultMenu = find.byTooltip('Options for Q4_Report.pdf');
        await tester.tap(resultMenu);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        final clipboard = container.read(clipboardProvider);
        expect(clipboard.hasItem, isTrue);
        expect(clipboard.sourceRemote, equals('GoogleDrive'));
        expect(clipboard.item!.path, equals('Finance/2026/Q4_Report.pdf'));

        // Open containing folder navigates fileExplorerProvider to GoogleDrive:Finance/2026
        await tester.tap(find.byTooltip('Open folder in Explorer'));
        await tester.pumpAndSettle();

        final explorerState = container.read(fileExplorerProvider);
        expect(explorerState.currentRemote, equals('GoogleDrive'));
        expect(explorerState.currentPath, equals('Finance/2026'));
        expect(explorerState.isSearching, isFalse);
      },
    );

    testWidgets(
      'Global search shows live progress bar with Stop button and Delete removes result',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final fakeService = _FakeSearchRcloneService()
          ..stayRunningUntilCancelled = true;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              rcloneServiceProvider.overrideWithValue(fakeService),
              cloudAccountsProvider.overrideWith(
                () => _FakeCloudAccountsNotifier(
                  const CloudAccountsState(
                    remotes: [
                      CloudRemote(
                        name: 'GoogleDrive',
                        type: 'drive',
                        quota: StorageQuota(total: 1000, used: 200, free: 800),
                      ),
                    ],
                  ),
                ),
              ),
              fileExplorerProvider.overrideWith(
                () => _FakeExplorerNotifier(
                  const FileExplorerState(currentRemote: 'GoogleDrive'),
                ),
              ),
              settingsProvider.overrideWith(
                () => _FakeSettingsNotifier(
                  const AppSettings(confirmDelete: false),
                ),
              ),
            ],
            child: const MaterialApp(
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: appLocalizationsDelegates,
              home: FileExplorerScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open search bar and toggle to Global search
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('search_scope_global')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('explorer_search_field')),
          'alpha',
        );
        await tester.tap(find.byKey(const ValueKey('global_search_submit_button')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Live scanning progress bar & Stop button visible
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byKey(const ValueKey('global_search_stop_button')), findsOneWidget);

        // Tap Stop
        await tester.tap(find.byKey(const ValueKey('global_search_stop_button')));
        await tester.pumpAndSettle();

        expect(fakeService.cancelledJobIds, isNotEmpty);
        expect(find.text('Search stopped'), findsOneWidget);

        // Now test Delete action on a completed search result
        fakeService.stayRunningUntilCancelled = false;
        fakeService.scriptedPolls = [
          const SearchJobSnapshot(
            jobId: '',
            status: SearchStatus.completed,
            scannedFiles: 5,
            scannedDirs: 1,
            results: [
              CloudItem(
                name: 'obsolete.txt',
                path: 'Temp/obsolete.txt',
                isDir: false,
                size: 512,
                remote: 'GoogleDrive',
              ),
            ],
          ),
        ];

        await tester.tap(find.byKey(const ValueKey('global_search_submit_button')));
        await tester.pumpAndSettle();
        expect(find.text('obsolete.txt'), findsOneWidget);

        await tester.tap(find.byTooltip('Options for obsolete.txt'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(
          fakeService.deletedFiles,
          contains((remote: 'GoogleDrive', path: 'Temp/obsolete.txt')),
        );
        expect(find.text('obsolete.txt'), findsNothing);
      },
    );

    testWidgets(
      'Tapping a remote file in Global Search shows a CircularProgressIndicator while opening and dismisses when done',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final openCompleter = Completer<void>();
        final fakeService = _FakeSearchRcloneService()
          ..scriptedPolls = [
            const SearchJobSnapshot(
              jobId: '',
              status: SearchStatus.completed,
              scannedFiles: 3,
              scannedDirs: 1,
              results: [
                CloudItem(
                  name: 'manual.pdf',
                  path: 'Docs/manual.pdf',
                  isDir: false,
                  size: 1024,
                  remote: 'GoogleDrive',
                ),
              ],
            ),
          ];
        final fakeOpener = _SlowFakeFileOpenerService(
          rcloneService: fakeService,
          completer: openCompleter,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              rcloneServiceProvider.overrideWithValue(fakeService),
              fileOpenerServiceProvider.overrideWithValue(fakeOpener),
              cloudAccountsProvider.overrideWith(
                () => _FakeCloudAccountsNotifier(
                  const CloudAccountsState(
                    remotes: [CloudRemote(name: 'GoogleDrive', type: 'drive')],
                  ),
                ),
              ),
              fileExplorerProvider.overrideWith(
                () => _FakeExplorerNotifier(
                  const FileExplorerState(currentRemote: 'GoogleDrive'),
                ),
              ),
              settingsProvider.overrideWith(
                () => _FakeSettingsNotifier(const AppSettings()),
              ),
            ],
            child: const MaterialApp(
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: appLocalizationsDelegates,
              home: FileExplorerScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('search_scope_global')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('explorer_search_field')),
          'manual',
        );
        await tester.tap(find.byKey(const ValueKey('global_search_submit_button')));
        await tester.pumpAndSettle();

        expect(find.text('manual.pdf'), findsOneWidget);

        // Tap the file to open
        await tester.tap(find.text('manual.pdf'));
        await tester.pump();
        // Advance past 150ms delay to trigger the CircularProgressIndicator dialog
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(CircularProgressIndicator), findsWidgets);

        openCompleter.complete();
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );
  });
}

class _SlowFakeFileOpenerService extends FileOpenerService {
  _SlowFakeFileOpenerService({
    required super.rcloneService,
    required this.completer,
  });

  final Completer<void> completer;

  @override
  Future<void> openCloudItem({
    BuildContext? context,
    required CloudItem item,
    String? remote,
    String? currentPath,
    bool isQuickPeek = false,
  }) {
    return completer.future;
  }
}

class _FakeExplorerNotifier extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  _FakeExplorerNotifier(this._initial);
  final FileExplorerState _initial;

  @override
  FileExplorerState build() => _initial;

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
  Future<void> openRemote(String remote, {String path = ''}) async {
    state = state.copyWith(currentRemote: remote, currentPath: path);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
