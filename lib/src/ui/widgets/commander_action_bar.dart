import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cloud_models.dart';
import '../../providers/file_explorer_provider.dart';
import '../theme/cosmic_icons.dart';

/// Quick action toolbar at the bottom of the dual-pane Commander view,
/// providing direct transfer (Copy, Move, Swap, Refresh) between the two panes.
class CommanderActionBar extends ConsumerWidget {
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> leftProvider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> rightProvider;

  const CommanderActionBar({
    super.key,
    required this.leftProvider,
    required this.rightProvider,
  });

  void _handleTransfer({
    required BuildContext context,
    required WidgetRef ref,
    required bool isMove,
    required bool leftToRight,
  }) async {
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
            'Seleziona prima un cloud nel pannello ${leftToRight ? "sinistro" : "destro"}.',
          ),
        ),
      );
      return;
    }

    if (dstRemote.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Seleziona prima un cloud di destinazione nel pannello ${leftToRight ? "destro" : "sinistro"}.',
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
        const SnackBar(
          content: Text('Nessun file presente o selezionato da trasferire.'),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final count = itemsToTransfer.length;
    final actionLabel = isMove ? 'Spostamento' : 'Copia';

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '$actionLabel di $count ${count == 1 ? "elemento" : "elementi"} da [$srcRemote] a [$dstRemote] avviato...',
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
      ref.read(dstProvider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante il trasferimento: $e')),
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
              ? (isCompact ? 'Copia (${leftState.selectedCount}) ->' : 'Copia a destra (${leftState.selectedCount})')
              : (isCompact ? 'Copia ->' : 'Copia a destra ->');

          final moveRightLabel = hasLeftSelection
              ? (isCompact ? 'Sposta (${leftState.selectedCount}) ->' : 'Sposta a destra (${leftState.selectedCount})')
              : (isCompact ? 'Sposta ->' : 'Sposta a destra ->');

          final moveLeftLabel = hasRightSelection
              ? (isCompact ? '<- Sposta (${rightState.selectedCount})' : '<- Sposta a sinistra (${rightState.selectedCount})')
              : (isCompact ? '<- Sposta' : '<- Sposta a sinistra');

          final copyLeftLabel = hasRightSelection
              ? (isCompact ? '<- Copia (${rightState.selectedCount})' : '<- Copia a sinistra (${rightState.selectedCount})')
              : (isCompact ? '<- Copia' : '<- Copia a sinistra');

          Widget leftActions = Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isVeryCompact)
                IconButton.filledTonal(
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronRightSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.arrow_forward,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronRightSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.arrow_forward,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronRightSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.drive_file_move_outlined,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronRightSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.drive_file_move_outlined,
                  ),
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

          Widget centerActions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                icon: const CosmicSvgIcon(
                  CosmicIcons.splitScreenSvg,
                  size: 20,
                  fallbackMaterialIcon: Icons.swap_horiz_rounded,
                ),
                tooltip: 'Scambia pannelli (<->)',
                onPressed: () => _handleSwapPanes(ref),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const CosmicSvgIcon(
                  CosmicIcons.syncSvg,
                  size: 20,
                  fallbackMaterialIcon: Icons.sync_rounded,
                ),
                tooltip: 'Aggiorna entrambi i pannelli',
                onPressed: () {
                  ref.read(leftProvider.notifier).refresh();
                  ref.read(rightProvider.notifier).refresh();
                },
              ),
            ],
          );

          Widget rightActions = Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isVeryCompact)
                IconButton.outlined(
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronLeftSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.drive_file_move_rtl_outlined,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronLeftSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.drive_file_move_rtl_outlined,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronLeftSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.arrow_back,
                  ),
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
                  icon: const CosmicSvgIcon(
                    CosmicIcons.chevronLeftSvg,
                    size: 16,
                    fallbackMaterialIcon: Icons.arrow_back,
                  ),
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

