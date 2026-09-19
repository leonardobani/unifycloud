import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.folder_outlined),
                      selectedIcon: Icon(Icons.folder),
                      label: Text('File Explorer'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sync_outlined),
                      selectedIcon: Icon(Icons.sync),
                      label: Text('Sincronizzazione'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Impostazioni'),
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
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: 'File',
              ),
              NavigationDestination(
                icon: Icon(Icons.sync_outlined),
                selectedIcon: Icon(Icons.sync),
                label: 'Backup',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Impostazioni',
              ),
            ],
          ),
        );
      },
    );
  }
}
