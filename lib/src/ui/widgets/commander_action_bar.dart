import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/l10n_extension.dart';
import '../../models/cloud_models.dart';
import '../../providers/file_explorer_provider.dart';

/// Quick action toolbar at the bottom of the dual-pane Commander view,
/// providing direct transfer (Copy, Move, Swap, Refresh) between the two panes.
class CommanderActionBar extends ConsumerWidget {

  const CommanderActionBar({
    super.key,
    required this.leftProvider,
    required this.rightProvider,
  });
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> leftProvider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> rightProvider;

  void _handleTransfer({
    required BuildContext context,
    required WidgetRef ref,
    required bool isMove,
    required bool leftToRight,
  }) async {
    final l10n = context.l10n;
    final srcProvider = leftToRight ? leftProvider : rightProvider;
    final dstProvider = leftToRight ? rightProvider : leftProvider;

    final srcState = ref.read(srcProvider);
    final dstState = ref.read(dstProvider);

    final srcRemote = srcState.currentRemote ?? '';
    final dstRemote = dstState.currentRemote ?? '';

    if (srcRemote.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            leftToRight ? l10n.selectCloudFirstLeft : l10n.selectCloudFirstRight,
          ),
        ),
      );
      return;
    }

    if (dstRemote.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            leftToRight
                ? l10n.selectDestinationCloudRight
                : l10n.selectDestinationCloudLeft,
          ),
        ),
      );
      return;
    }

    // Determine items to transfer: selected items or all display items
    List<CloudItem> itemsToTransfer = srcState.selectedItems;
    if (itemsToTransfer.isEmpty) {
      itemsToTransfer = srcState.displayItems;
    }

    if (itemsToTransfer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noFilesToTransfer),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final count = itemsToTransfer.length;
    final actionLabel = isMove ? l10n.moveAction : l10n.copyAction;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.transferStarted(actionLabel, count, srcRemote, dstRemote),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref.read(srcProvider.notifier).transferItemsDirectly(
            items: itemsToTransfer,
            dstRemote: dstRemote,
            dstPath: dstState.currentPath,
            isMove: isMove,
          );
      ref.read(srcProvider.notifier).clearSelection();
      await ref.read(dstProvider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorTransferring(e.toString()))),
      );
    }
  }

  void _handleSwapPanes(WidgetRef ref) {
    final leftState = ref.read(leftProvider);
    final rightState = ref.read(rightProvider);

    final leftRemote = leftState.currentRemote;
    final leftPath = leftState.currentPath;

    final rightRemote = rightState.currentRemote;
    final rightPath = rightState.currentPath;

    if (rightRemote != null) {
      ref.read(leftProvider.notifier).openRemote(rightRemote, path: rightPath);
    }
    if (leftRemote != null) {
      ref.read(rightProvider.notifier).openRemote(leftRemote, path: leftPath);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final leftState = ref.watch(leftProvider);
    final rightState = ref.watch(rightProvider);

    final hasLeftSelection = leftState.selectedCount > 0;
    final hasRightSelection = rightState.selectedCount > 0;

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 950;
          final isVeryCompact = constraints.maxWidth < 680;

          final copyRightLabel = hasLeftSelection
              ? (isCompact
                  ? l10n.copyRightCountCompact(leftState.selectedCount)
                  : l10n.copyRightWithCount(leftState.selectedCount))
              : (isCompact ? l10n.copyRightCompact : l10n.copyRight);

          final moveRightLabel = hasLeftSelection
              ? (isCompact
                  ? l10n.moveRightCountCompact(leftState.selectedCount)
                  : l10n.moveRightWithCount(leftState.selectedCount))
              : (isCompact ? l10n.moveRightCompact : l10n.moveRight);

          final moveLeftLabel = hasRightSelection
              ? (isCompact
                  ? l10n.moveLeftCountCompact(rightState.selectedCount)
                  : l10n.moveLeftWithCount(rightState.selectedCount))
              : (isCompact ? l10n.moveLeftCompact : l10n.moveLeft);

          final copyLeftLabel = hasRightSelection
              ? (isCompact
                  ? l10n.copyLeftCountCompact(rightState.selectedCount)
                  : l10n.copyLeftWithCount(rightState.selectedCount))
              : (isCompact ? l10n.copyLeftCompact : l10n.copyLeft);

          final Widget leftActions = Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isVeryCompact)
                IconButton.filledTonal(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  tooltip: copyRightLabel,
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: false,
                    leftToRight: true,
                  ),
                )
              else
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(
                    copyRightLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: false,
                    leftToRight: true,
                  ),
                ),
              if (isVeryCompact)
                IconButton.outlined(
                  icon: const Icon(Icons.drive_file_move_outlined, size: 16),
                  tooltip: moveRightLabel,
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: true,
                    leftToRight: true,
                  ),
                )
              else
                OutlinedButton.icon(
                  icon: const Icon(Icons.drive_file_move_outlined, size: 16),
                  label: Text(
                    moveRightLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: true,
                    leftToRight: true,
                  ),
                ),
            ],
          );

          final Widget centerActions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                tooltip: l10n.swapPanesTooltip,
                onPressed: () => _handleSwapPanes(ref),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const Icon(Icons.sync_rounded, size: 20),
                tooltip: l10n.refreshBothPanesTooltip,
                onPressed: () {
                  ref.read(leftProvider.notifier).refresh();
                  ref.read(rightProvider.notifier).refresh();
                },
              ),
            ],
          );

          final Widget rightActions = Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isVeryCompact)
                IconButton.outlined(
                  icon: const Icon(Icons.drive_file_move_rtl_outlined, size: 16),
                  tooltip: moveLeftLabel,
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: true,
                    leftToRight: false,
                  ),
                )
              else
                OutlinedButton.icon(
                  icon: const Icon(Icons.drive_file_move_rtl_outlined, size: 16),
                  label: Text(
                    moveLeftLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: true,
                    leftToRight: false,
                  ),
                ),
              if (isVeryCompact)
                IconButton.filledTonal(
                  icon: const Icon(Icons.arrow_back, size: 16),
                  tooltip: copyLeftLabel,
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: false,
                    leftToRight: false,
                  ),
                )
              else
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: Text(
                    copyLeftLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => _handleTransfer(
                    context: context,
                    ref: ref,
                    isMove: false,
                    leftToRight: false,
                  ),
                ),
            ],
          );

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leftActions,
                  const SizedBox(width: 8),
                  centerActions,
                  const SizedBox(width: 8),
                  rightActions,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
