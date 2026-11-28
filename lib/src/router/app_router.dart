import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../ui/screens/file_explorer_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/main_scaffold.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/sync_rules_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
final _shellNavigatorExplorer = GlobalKey<NavigatorState>(debugLabel: 'explorerNav');
final _shellNavigatorSync = GlobalKey<NavigatorState>(debugLabel: 'syncNav');

/// GoRouter configuration with persistent stateful shell branches.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHome,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),

        // File Explorer Branch
        StatefulShellBranch(
          navigatorKey: _shellNavigatorExplorer,
          routes: [
            GoRoute(
              path: '/explorer',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FileExplorerScreen(),
              ),
            ),
          ],
        ),

        // Sync & Backup Branch
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSync,
          routes: [
            GoRoute(
              path: '/sync',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SyncRulesScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
