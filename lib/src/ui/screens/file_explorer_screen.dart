import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/l10n_extension.dart';
import '../../providers/file_explorer_provider.dart';
import '../widgets/commander_action_bar.dart';
import '../widgets/file_explorer_pane_view.dart';

/// Full-featured file explorer screen with responsive adaptive layout:
/// - Wide screen (>= 900px) & dual-pane active: displays dual-pane Commander view
///   with Left and Right panes, cross-pane drag & drop, and Commander action bar.
/// - Narrow screen (< 900px) or dual-pane toggled off: displays classic single-pane view.
class FileExplorerScreen extends ConsumerWidget {
  const FileExplorerScreen({super.key});

  void _handleBackNavigation(WidgetRef ref, {required bool isDualPane}) {
    final primaryState = ref.read(fileExplorerProvider);
    final primaryNotifier = ref.read(fileExplorerProvider.notifier);

    if (primaryState.isSelectionMode) {
      primaryNotifier.clearSelection();
      return;
    }
    if (primaryState.isSearching) {
      primaryNotifier.setSearching(false);
      return;
    }

    if (isDualPane) {
      final secondaryState = ref.read(secondaryFileExplorerProvider);
      final secondaryNotifier = ref.read(secondaryFileExplorerProvider.notifier);
      if (secondaryState.isSelectionMode) {
        secondaryNotifier.clearSelection();
        return;
      }
      if (secondaryState.isSearching) {
        secondaryNotifier.setSearching(false);
        return;
      }
    }

    if (primaryState.currentPath.isNotEmpty) {
      primaryNotifier.navigateUp();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isDualPaneActive = ref.watch(dualPaneActiveProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 900;
        final showDualPane = isWideScreen && isDualPaneActive;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBackNavigation(ref, isDualPane: showDualPane);
          },
          child: showDualPane
              ? Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Left Pane
                            Expanded(
                              child: FileExplorerPaneView(
                                provider: fileExplorerProvider,
                                oppositeProvider: secondaryFileExplorerProvider,
                                paneTitle: l10n.paneLeft,
                                isDualPane: true,
                                showDualPaneToggle: isWideScreen,
                              ),
                            ),
                            const VerticalDivider(width: 1, thickness: 1),
                            // Right Pane
                            Expanded(
                              child: FileExplorerPaneView(
                                provider: secondaryFileExplorerProvider,
                                oppositeProvider: fileExplorerProvider,
                                paneTitle: l10n.paneRight,
                                isDualPane: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Commander Bar
                      CommanderActionBar(
                        leftProvider: fileExplorerProvider,
                        rightProvider: secondaryFileExplorerProvider,
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  body: FileExplorerPaneView(
                    provider: fileExplorerProvider,
                    oppositeProvider: secondaryFileExplorerProvider,
                    showDualPaneToggle: isWideScreen,
                  ),
                ),
        );
      },
    );
  }
}
