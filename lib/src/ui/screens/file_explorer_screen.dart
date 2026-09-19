import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/file_explorer_provider.dart';
import '../widgets/commander_action_bar.dart';
import '../widgets/file_explorer_pane_view.dart';

/// Full-featured file explorer screen with responsive adaptive layout:
/// - Wide screen (>= 900px) & dual-pane active: displays dual-pane Commander view
///   with Left and Right panes, cross-pane drag & drop, and Commander action bar.
/// - Narrow screen (< 900px) or dual-pane toggled off: displays classic single-pane view.
class FileExplorerScreen extends ConsumerWidget {
  const FileExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDualPaneActive = ref.watch(dualPaneActiveProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 900;
        final showDualPane = isWideScreen && isDualPaneActive;

        if (showDualPane) {
          return Scaffold(
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
                          paneTitle: 'Sinistra',
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
                          paneTitle: 'Destra',
                          isDualPane: true,
                          showDualPaneToggle: false,
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
          );
        }

        // Single Pane Mode
        return Scaffold(
          body: FileExplorerPaneView(
            provider: fileExplorerProvider,
            oppositeProvider: secondaryFileExplorerProvider,
            isDualPane: false,
            showDualPaneToggle: isWideScreen,
          ),
        );
      },
    );
  }
}
