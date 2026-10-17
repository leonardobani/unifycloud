import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../theme/cosmic_icons.dart';
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
                      CosmicIcons.cloudSync,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(CosmicIcons.home),
                      selectedIcon: const Icon(CosmicIcons.homeFilled),
                      label: Text(l10n.home),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(CosmicIcons.explorer),
                      selectedIcon: const Icon(CosmicIcons.explorerFilled),
                      label: Text(l10n.explorer),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(CosmicIcons.sync),
                      selectedIcon: const Icon(CosmicIcons.syncFilled),
                      label: Text(l10n.sync),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(CosmicIcons.settings),
                      selectedIcon: const Icon(CosmicIcons.settingsFilled),
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
                icon: const Icon(CosmicIcons.home),
                selectedIcon: const Icon(CosmicIcons.homeFilled),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(CosmicIcons.explorer),
                selectedIcon: const Icon(CosmicIcons.explorerFilled),
                label: l10n.explorer,
              ),
              NavigationDestination(
                icon: const Icon(CosmicIcons.sync),
                selectedIcon: const Icon(CosmicIcons.syncFilled),
                label: l10n.sync,
              ),
              NavigationDestination(
                icon: const Icon(CosmicIcons.settings),
                selectedIcon: const Icon(CosmicIcons.settingsFilled),
                label: l10n.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
