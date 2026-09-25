import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/transfer_panel.dart';

/// Root scaffold providing an adaptive responsive layout:
/// - Desktop (> 768px): NavigationRail (side rail)
/// - Mobile (<= 768px): NavigationBar (bottom bar)
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  extended: constraints.maxWidth > 1000,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Icon(
                      Icons.cloud_sync,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: Text(l10n.home),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.folder_outlined),
                      selectedIcon: const Icon(Icons.folder),
                      label: Text(l10n.explorer),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.sync_outlined),
                      selectedIcon: const Icon(Icons.sync),
                      label: Text(l10n.sync),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(l10n.settings),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: navigationShell),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: TransferFloatingBar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile Layout
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: navigationShell),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TransferFloatingBar(),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder),
                label: l10n.explorer,
              ),
              NavigationDestination(
                icon: const Icon(Icons.sync_outlined),
                selectedIcon: const Icon(Icons.sync),
                label: l10n.sync,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: l10n.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
