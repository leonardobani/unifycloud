import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

import '../../../l10n/l10n_extension.dart';
import '../../models/cloud_error.dart';
import '../../models/cloud_models.dart';
import '../../models/pane_drag_data.dart';
import '../../models/settings_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/transfer_provider.dart';
import '../../services/file_opener_service.dart';
import '../../services/rclone_service.dart';
import '../theme/app_theme.dart';
import 'adaptive_draggable.dart';
import 'breadcrumbs_bar.dart';
import 'expandable_error_box.dart';
import 'file_context_menu.dart';
import 'file_type_icon.dart';
import 'share_link_dialog.dart';

/// Reusable explorer pane view supporting independent navigation, selection,
/// drag-and-drop file transfer, and direct cross-pane actions.
class FileExplorerPaneView extends ConsumerStatefulWidget {

  const FileExplorerPaneView({
    super.key,
    required this.provider,
    this.oppositeProvider,
    this.paneTitle,
    this.isDualPane = false,
    this.showDualPaneToggle = false,
  });
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> provider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? oppositeProvider;
  final String? paneTitle;
  final bool isDualPane;
  final bool showDualPaneToggle;

  @override
  ConsumerState<FileExplorerPaneView> createState() =>
      _FileExplorerPaneViewState();
}

class _FileExplorerPaneViewState extends ConsumerState<FileExplorerPaneView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '--';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '--';
    final local = dt.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  void _showNewFolderDialog() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newFolder),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.folderName,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.create),
          ),
        ],
      ),
    );

    if (created == true && controller.text.trim().isNotEmpty) {
      try {
        await ref
            .read(widget.provider.notifier)
            .createDirectory(controller.text.trim());
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorCreatingFolder(e.toString()))),
          );
        }
      }
    }
  }

  void _handleBatchTransferToOpposite({required bool isMove}) async {
    if (widget.oppositeProvider == null) return;
    final l10n = context.l10n;
    final srcState = ref.read(widget.provider);
    final dstState = ref.read(widget.oppositeProvider!);

    final srcRemote = srcState.currentRemote ?? '';
    final dstRemote = dstState.currentRemote ?? '';
    final items = srcState.selectedItems;

    if (srcRemote.isEmpty || dstRemote.isEmpty || items.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final actionLabel = isMove ? l10n.moveAction : l10n.copyAction;
    final count = items.length;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.transferBatchStarted(actionLabel, count, dstRemote),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref.read(widget.provider.notifier).transferItemsDirectly(
            items: items,
            dstRemote: dstRemote,
            dstPath: dstState.currentPath,
            isMove: isMove,
          );
      ref.read(widget.provider.notifier).clearSelection();
      await ref.read(widget.oppositeProvider!.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorTransferring(e.toString()))),
      );
    }
  }

  void _handleBatchCopy(FileExplorerState state) {
    final l10n = context.l10n;
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    ref.read(clipboardProvider.notifier).copyAll(items, currentRemote);
    ref.read(widget.provider.notifier).clearSelection();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          items.length == 1
              ? l10n.itemCopiedToClipboard(items.first.name)
              : l10n.itemsCopiedToClipboard(items.length),
        ),
      ),
    );
  }

  void _handleBatchCut(FileExplorerState state) {
    final l10n = context.l10n;
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    ref.read(clipboardProvider.notifier).cutAll(items, currentRemote);
    ref.read(widget.provider.notifier).clearSelection();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          items.length == 1
              ? l10n.itemCutToClipboard(items.first.name)
              : l10n.itemsCutToClipboard(items.length),
        ),
      ),
    );
  }

  void _handleBatchDownload(FileExplorerState state) async {
    final l10n = context.l10n;
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    final filesToDownload = items.where((i) => !i.isDir).toList();
    final dirCount = items.length - filesToDownload.length;

    if (filesToDownload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.folderDownloadUnsupported),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                filesToDownload.length == 1
                    ? l10n.downloadingSingleItem(filesToDownload.first.name)
                    : l10n.downloadingMultipleItems(filesToDownload.length),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    final paths = filesToDownload.map((i) {
      return (state.currentPath.isNotEmpty &&
              !i.path.startsWith(state.currentPath))
          ? '${state.currentPath}/${i.path}'
          : i.path;
    }).toList();

    try {
      final jobs = await ref.read(transferProvider.notifier).downloadFiles(
            srcRemote: currentRemote,
            srcPaths: paths,
          );
      ref.read(widget.provider.notifier).clearSelection();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            dirCount > 0
                ? l10n.filesAddedToDownloadQueueWithSkipped(jobs.length, dirCount)
                : l10n.filesAddedToDownloadQueue(jobs.length),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorStartingDownload(e.toString()))),
      );
    }
  }

  void _handleBatchDelete(FileExplorerState state) async {
    final l10n = context.l10n;
    final items = state.selectedItems;
    if (items.isEmpty) return;

    final confirmDelete = ref.read(settingsProvider).confirmDelete;
    bool shouldDelete = true;

    if (confirmDelete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            items.length == 1
                ? (items.first.isDir
                    ? l10n.deleteSingleFolderTitle
                    : l10n.deleteSingleFileTitle)
                : l10n.deleteItemsConfirmTitle(items.length),
          ),
          content: Text(
            items.length == 1
                ? l10n.deleteSingleItemPrompt(items.first.name)
                : l10n.deleteItemsConfirmPrompt(items.length),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      shouldDelete = confirmed == true;
    }

    if (shouldDelete) {
      try {
        await ref.read(widget.provider.notifier).deleteSelected();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                items.length == 1
                    ? l10n.itemDeletedSuccess
                    : l10n.itemsDeletedSuccess(items.length),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorDeleting(e.toString()))),
          );
        }
      }
    }
  }

  String _sortModeLabel(FileSortMode mode, AppLocalizations l10n) {
    switch (mode) {
      case FileSortMode.nameAsc:
        return l10n.sortNameAsc;
      case FileSortMode.nameDesc:
        return l10n.sortNameDesc;
      case FileSortMode.sizeDesc:
        return l10n.sortSizeDesc;
      case FileSortMode.sizeAsc:
        return l10n.sortSizeAsc;
      case FileSortMode.dateDesc:
        return l10n.sortDateDesc;
      case FileSortMode.dateAsc:
        return l10n.sortDateAsc;
    }
  }

  Widget _buildUploadButton(FileExplorerState state) {
    final l10n = context.l10n;
    return IconButton(
      icon: const Icon(Icons.upload_rounded, size: 20),
      tooltip: l10n.uploadFromDevice,
      visualDensity: widget.isDualPane ? VisualDensity.compact : null,
      onPressed: state.currentRemote == null
          ? null
          : () => _showUploadTypeDialog(state),
    );
  }

  Future<void> _showUploadTypeDialog(FileExplorerState state) async {
    final l10n = context.l10n;
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.upload_rounded),
            const SizedBox(width: 10),
            Expanded(child: Text(l10n.uploadFromDevice)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.uploadChooseTypePrompt),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: Text(l10n.uploadFile),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(ctx).colorScheme.outlineVariant,
                ),
              ),
              onTap: () => Navigator.of(ctx).pop('files'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.drive_folder_upload_outlined),
              title: Text(l10n.uploadFolder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(ctx).colorScheme.outlineVariant,
                ),
              ),
              onTap: () => Navigator.of(ctx).pop('folder'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );

    if (choice != null && mounted) {
      await _handleUploadChoice(choice, state);
    }
  }

  Future<void> _handleUploadChoice(String choice, FileExplorerState state) async {
    final l10n = context.l10n;
    if (choice == 'files') {
      try {
        final jobs = await ref
            .read(transferProvider.notifier)
            .pickAndUploadFiles(
              dstRemote: state.currentRemote!,
              dstPath: state.currentPath,
              dialogTitle: l10n.selectFilesToUpload,
            );
        if (mounted && jobs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.filesAddedToUploadQueue(jobs.length)),
            ),
          );
          await ref.read(widget.provider.notifier).refresh();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorUploading(e.toString()))),
          );
        }
      }
    } else if (choice == 'folder') {
      try {
        final jobs = await ref
            .read(transferProvider.notifier)
            .pickAndUploadFolder(
              dstRemote: state.currentRemote!,
              dstPath: state.currentPath,
              dialogTitle: l10n.selectFolderToUpload,
            );
        if (mounted) {
          if (jobs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.folderAddedToUploadQueue(jobs.length)),
              ),
            );
          }
          await ref.read(widget.provider.notifier).refresh();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorFolderUploading(e.toString())),
            ),
          );
        }
      }
    }
  }

  void _handleDroppedData(PaneDragData data, {String? targetFolderPath}) async {
    final l10n = context.l10n;
    final targetState = ref.read(widget.provider);
    final targetRemote = targetState.currentRemote;
    if (targetRemote == null || targetRemote.isEmpty) return;

    final targetPath = targetFolderPath ?? targetState.currentPath;

    // Check if dropping onto the exact same folder
    if (data.sourceRemote == targetRemote && data.sourcePath == targetPath) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.filesAlreadyInDirectory),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final count = data.items.length;
    final actionLabel = data.isMove ? l10n.moveAction : l10n.copyAction;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.dragDropInProgress(actionLabel, count, data.sourceRemote, targetRemote),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref.read(data.sourceProvider.notifier).transferItemsDirectly(
            items: data.items,
            dstRemote: targetRemote,
            dstPath: targetPath,
            isMove: data.isMove,
          );
      await ref.read(widget.provider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorDragDrop(e.toString()))),
      );
    }
  }

  Widget _buildDragFeedback(PaneDragData data) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FileTypeIcon(
              fileName: data.primaryName,
              isDir: data.items.isNotEmpty && data.items.first.isDir,
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                data.primaryName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (data.count > 1) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+${data.count - 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(widget.provider);
    final remotesState = ref.watch(cloudAccountsProvider);
    final longPressAction =
        ref.watch(settingsProvider.select((s) => s.longPressAction));
    final oppositeState = widget.oppositeProvider != null
        ? ref.watch(widget.oppositeProvider!)
        : null;
    final hasOppositeRemote = oppositeState?.currentRemote != null &&
        oppositeState!.currentRemote!.trim().isNotEmpty;
    final currentRemoteObj = remotesState.remotes
        .where((r) => r.name == state.currentRemote)
        .firstOrNull;
    final isCurrentCrypt = currentRemoteObj?.isCrypt ?? false;

    ref.listen<bool>(
      widget.provider.select((s) => s.isSearching),
      (previous, next) {
        if (!next && _searchController.text.isNotEmpty) {
          _searchController.clear();
        }
      },
    );

    // Auto-select remote if none selected yet
    if (state.currentRemote == null && remotesState.remotes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // If secondary pane, try picking a remote different from primary if available
        if (widget.oppositeProvider != null) {
          final oppRemote = ref.read(widget.oppositeProvider!).currentRemote;
          final alternative = remotesState.remotes
              .where((r) => r.name != oppRemote)
              .firstOrNull;
          if (alternative != null) {
            ref.read(widget.provider.notifier).openRemote(alternative.name);
            return;
          }
        }
        ref
            .read(widget.provider.notifier)
            .openRemote(remotesState.remotes.first.name);
      });
    }

    final isSelectionMode = state.isSelectionMode;
    final allSelected = state.selectedCount == state.displayItems.length &&
        state.displayItems.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonExtent = widget.isDualPane ? 40.0 : kMinInteractiveDimension;
        final expandedActionCount = 6 + (widget.showDualPaneToggle ? 1 : 0);
        final compactActions =
            expandedActionCount * buttonExtent > constraints.maxWidth * 0.5;

        final header = isSelectionMode
            ? AppBar(
                titleSpacing: widget.isDualPane ? 8.0 : null,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.closeSelection,
                  visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                  onPressed: () {
                    ref.read(widget.provider.notifier).clearSelection();
                  },
                ),
                title: Text(
                  l10n.itemsSelectedCount(state.selectedCount),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  IconButton(
                    icon: Icon(allSelected ? Icons.deselect : Icons.select_all, size: 20),
                    tooltip: allSelected ? l10n.deselectAll : l10n.selectAll,
                    visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                    onPressed: () {
                      if (allSelected) {
                        ref.read(widget.provider.notifier).clearSelection();
                      } else {
                        ref.read(widget.provider.notifier).selectAll();
                      }
                    },
                  ),
                  if (hasOppositeRemote) ...[
                    IconButton(
                      icon: const Icon(Icons.drive_file_move_rtl_outlined, size: 20),
                      tooltip: l10n.copyToRemote(oppositeState.currentRemote ?? ''),
                      visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                      onPressed: () => _handleBatchTransferToOpposite(isMove: false),
                    ),
                    IconButton(
                      icon: const Icon(Icons.drive_file_move_outlined, size: 20),
                      tooltip: l10n.moveToRemote(oppositeState.currentRemote ?? ''),
                      visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                      onPressed: () => _handleBatchTransferToOpposite(isMove: true),
                    ),
                  ],
                  if (widget.isDualPane) ...[
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      tooltip: l10n.moreActions,
                      padding: EdgeInsets.zero,
                      onSelected: (action) {
                        switch (action) {
                          case 'download':
                            _handleBatchDownload(state);
                          case 'copy':
                            _handleBatchCopy(state);
                          case 'cut':
                            _handleBatchCut(state);
                          case 'delete':
                            _handleBatchDelete(state);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'download',
                          child: Row(
                            children: [
                              const Icon(Icons.download_outlined, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.downloadSelected),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'copy',
                          child: Row(
                            children: [
                              const Icon(Icons.copy_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.copyToClipboard),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cut',
                          child: Row(
                            children: [
                              const Icon(Icons.cut_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.cutToClipboard),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                l10n.deleteSelected,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.download_outlined, size: 20),
                      tooltip: l10n.downloadSelected,
                      onPressed: () => _handleBatchDownload(state),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      tooltip: l10n.copySelected,
                      onPressed: () => _handleBatchCopy(state),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cut_rounded, size: 20),
                      tooltip: l10n.cutSelected,
                      onPressed: () => _handleBatchCut(state),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      tooltip: l10n.deleteSelected,
                      onPressed: () => _handleBatchDelete(state),
                    ),
                  ],
                ],
              )
            : AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: widget.isDualPane ? 8.0 : null,
                title: state.isSearching
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: l10n.searchFilesHint,
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          ref
                              .read(widget.provider.notifier)
                              .setSearchQuery(val);
                        },
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.paneTitle != null) ...[
                            Text(
                              '${widget.paneTitle}: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                          Flexible(
                            child: PopupMenuButton<String>(
                              key: const ValueKey('disk_chooser_button'),
                              tooltip: l10n.selectCloud,
                              enabled: remotesState.remotes.isNotEmpty,
                              initialValue: state.currentRemote,
                              onSelected: (val) {
                                ref.read(widget.provider.notifier).openRemote(val);
                              },
                              itemBuilder: (ctx) => remotesState.remotes.map((r) {
                                final isSelected = r.name == state.currentRemote;
                                return PopupMenuItem<String>(
                                  value: r.name,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check
                                            : (r.isCrypt
                                                ? Icons.lock_rounded
                                                : Icons.cloud_outlined),
                                        size: 18,
                                        color: isSelected
                                            ? Theme.of(ctx).colorScheme.primary
                                            : (r.isCrypt
                                                ? const Color(0xFF00BFA5)
                                                : null),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          r.name,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isCurrentCrypt) ...[
                                      const Icon(
                                        Icons.lock_rounded,
                                        size: 14,
                                        color: Color(0xFF00BFA5),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Flexible(
                                      child: Text(
                                        state.currentRemote ?? l10n.selectCloud,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(Icons.keyboard_arrow_down, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (isCurrentCrypt) ...[
                            const SizedBox(width: 6),
                            Tooltip(
                              message: l10n.e2eActiveTooltip,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00BFA5)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF00BFA5)
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 12,
                                      color: Color(0xFF00BFA5),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'AES-256',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00BFA5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                actions: [
                  IconButton(
                    icon: Icon(
                      state.isSearching ? Icons.close : Icons.search,
                      size: 20,
                    ),
                    tooltip: state.isSearching ? l10n.closeSearch : l10n.search,
                    visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                    onPressed: () {
                      final next = !state.isSearching;
                      if (!next) {
                        _searchController.clear();
                      }
                      ref.read(widget.provider.notifier).setSearching(next);
                    },
                  ),
                  if (!state.isSearching) ...[
                    if (compactActions) ...[
                      _buildUploadButton(state),
                      PopupMenuButton<String>(
                        key: const ValueKey('explorer_overflow_menu'),
                        icon: const Icon(Icons.more_vert, size: 20),
                        tooltip: l10n.moreOptions,
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'toggle_view') {
                            final next = state.viewMode == FileViewMode.list
                                ? FileViewMode.grid
                                : FileViewMode.list;
                            ref.read(widget.provider.notifier).setViewMode(next);
                          } else if (value == 'select') {
                            ref
                                .read(widget.provider.notifier)
                                .enterSelectionMode();
                          } else if (value == 'new_folder') {
                            _showNewFolderDialog();
                          } else if (value.startsWith('sort_')) {
                            final sortName = value.substring(5);
                            final mode = FileSortMode.values
                                .firstWhere((e) => e.name == sortName);
                            ref.read(widget.provider.notifier).setSortMode(mode);
                          } else if (value == 'toggle_dual') {
                            ref.read(dualPaneActiveProvider.notifier).toggle();
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 'select',
                            enabled: state.displayItems.isNotEmpty,
                            child: Row(
                              children: [
                                const Icon(Icons.checklist_rounded, size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    l10n.multiSelection,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'toggle_view',
                            child: Row(
                              children: [
                                Icon(
                                  state.viewMode == FileViewMode.list
                                      ? Icons.grid_view_outlined
                                      : Icons.view_list_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    state.viewMode == FileViewMode.list
                                        ? l10n.viewGrid
                                        : l10n.viewList,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'new_folder',
                            enabled: state.currentRemote != null,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.create_new_folder_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    l10n.newFolder,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.showDualPaneToggle)
                            PopupMenuItem(
                              value: 'toggle_dual',
                              child: Row(
                                children: [
                                  Icon(
                                    ref.read(dualPaneActiveProvider)
                                        ? Icons.splitscreen
                                        : Icons.view_sidebar_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      ref.read(dualPaneActiveProvider)
                                          ? l10n.disableDualPaneTooltip
                                          : l10n.enableDualPaneTooltip,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const PopupMenuDivider(),
                          ...FileSortMode.values.map((mode) {
                            return PopupMenuItem(
                              value: 'sort_${mode.name}',
                              child: Row(
                                children: [
                                  Icon(
                                    state.sortMode == mode
                                        ? Icons.check
                                        : Icons.sort,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _sortModeLabel(mode, l10n),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ] else ...[
                      IconButton(
                        icon: const Icon(Icons.checklist_rounded, size: 20),
                        tooltip: l10n.multiSelection,
                        onPressed: state.displayItems.isEmpty
                            ? null
                            : () {
                                ref
                                    .read(widget.provider.notifier)
                                    .enterSelectionMode();
                              },
                      ),
                      PopupMenuButton<FileSortMode>(
                        icon: const Icon(Icons.sort, size: 20),
                        tooltip: l10n.sortByTooltip,
                        initialValue: state.sortMode,
                        onSelected: (mode) {
                          ref.read(widget.provider.notifier).setSortMode(mode);
                        },
                        itemBuilder: (ctx) => FileSortMode.values.map((mode) {
                          return PopupMenuItem(
                            value: mode,
                            child: Text(_sortModeLabel(mode, l10n)),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: Icon(
                          state.viewMode == FileViewMode.list
                              ? Icons.grid_view_outlined
                              : Icons.view_list_outlined,
                          size: 20,
                        ),
                        tooltip: state.viewMode == FileViewMode.list
                            ? l10n.viewGrid
                            : l10n.viewList,
                        onPressed: () {
                          final next = state.viewMode == FileViewMode.list
                              ? FileViewMode.grid
                              : FileViewMode.list;
                          ref.read(widget.provider.notifier).setViewMode(next);
                        },
                      ),
                      _buildUploadButton(state),
                      IconButton(
                        icon: const Icon(Icons.create_new_folder_outlined, size: 20),
                        tooltip: l10n.newFolder,
                        onPressed:
                            state.currentRemote == null ? null : _showNewFolderDialog,
                      ),
                      if (widget.showDualPaneToggle)
                        IconButton(
                          icon: Icon(
                            ref.watch(dualPaneActiveProvider)
                                ? Icons.splitscreen
                                : Icons.view_sidebar_outlined,
                            size: 20,
                          ),
                          tooltip: ref.watch(dualPaneActiveProvider)
                              ? l10n.disableDualPaneTooltip
                              : l10n.enableDualPaneTooltip,
                          visualDensity:
                              widget.isDualPane ? VisualDensity.compact : null,
                          onPressed: () {
                            ref.read(dualPaneActiveProvider.notifier).toggle();
                          },
                        ),
                    ],
                  ],
                ],
              );

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: header,
          ),
          body: DragTarget<PaneDragData>(
            onWillAcceptWithDetails: (details) {
              // Accept drops from any other pane or remote
              return state.currentRemote != null;
            },
            onAcceptWithDetails: (details) {
              _handleDroppedData(details.data);
            },
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;

              return Stack(
                children: [
                  Column(
                    children: [
                      BreadcrumbsBar(provider: widget.provider),
                      _buildClipboardBanner(context, ref, state),
                      if (state.isLoading && state.items.isNotEmpty)
                        const LinearProgressIndicator(minHeight: 3),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              ref.read(widget.provider.notifier).refresh(),
                          child: _buildContent(context, state, longPressAction),
                        ),
                      ),
                    ],
                  ),
                  if (isHovered)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Card(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.file_download_outlined,
                                    color: AppTheme.primaryColor,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      l10n.dropToCopyTo(
                                        state.currentRemote ?? l10n.destinationFallback,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildClipboardBanner(
    BuildContext context,
    WidgetRef ref,
    FileExplorerState state,
  ) {
    final l10n = context.l10n;
    final clipboard = ref.watch(clipboardProvider);
    if (!clipboard.hasItem) return const SizedBox.shrink();

    final actionText = clipboard.localizedActionLabel(l10n);
    final label = clipboard.items.length == 1
        ? l10n.clipboardBannerSingle(
            actionText,
            clipboard.item!.name,
            clipboard.sourceRemote!,
          )
        : l10n.clipboardBannerMultiple(
            actionText,
            clipboard.items.length,
            clipboard.sourceRemote!,
          );

    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
      leading: Icon(
        clipboard.isCut ? Icons.cut_rounded : Icons.copy_rounded,
        color: AppTheme.primaryColor,
      ),
      content: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => ref.read(clipboardProvider.notifier).clear(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.paste_rounded, size: 16),
          label: Text(l10n.pasteHere),
          onPressed: state.currentRemote == null
              ? null
              : () async {
                  final jobs = await ref
                      .read(clipboardProvider.notifier)
                      .pasteTo(
                        targetRemote: state.currentRemote!,
                        targetPath: state.currentPath,
                      );
                  if (context.mounted && jobs.isNotEmpty) {
                    final msg = jobs.length == 1
                        ? l10n.transferStartedSingle(jobs.first.fileName)
                        : l10n.transfersStartedCount(jobs.length);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }
                },
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    FileExplorerState state,
    LongPressAction longPressAction,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    if (state.currentRemote == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noCloudSelectedTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noCloudSelectedSubtitle,
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              state.currentPath.isEmpty
                  ? l10n.loadingFilesFromRemote(state.currentRemote!)
                  : l10n.loadingFolder(p.basename(state.currentPath)),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.readingDirectory,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      final errorType = CloudErrorType.fromError(state.error);
      final isAuth = errorType == CloudErrorType.authExpired;
      final accentColor = isAuth ? Colors.orange : Colors.red;

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  errorType.icon,
                  size: 32,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorType.localizedMessage(l10n),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ExpandableErrorBox(
                error: state.error.toString(),
                accentColor: accentColor,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(widget.provider.notifier).refresh(),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final items = state.displayItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? l10n.noMatchingResults(state.searchQuery)
                  : l10n.emptyFolder,
              style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (state.viewMode == FileViewMode.list) {
      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = state.selectedPaths.contains(item.path);

          final dragItems = isSelected && state.selectedItems.isNotEmpty
              ? state.selectedItems
              : [item];

          final dragData = PaneDragData(
            sourceRemote: state.currentRemote!,
            sourcePath: state.currentPath,
            items: dragItems,
            sourceProvider: widget.provider,
            isMove: longPressAction == LongPressAction.move,
          );

          final itemTile = FileContextMenuRegion(
            item: item,
            provider: widget.provider,
            oppositeProvider: widget.oppositeProvider,
            child: ListTile(
              selected: isSelected,
              selectedTileColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.35),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isSelectionMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) {
                        ref
                            .read(widget.provider.notifier)
                            .toggleSelection(item.path);
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                  FileTypeIcon(
                    fileName: item.name,
                    isDir: item.isDir,
                    size: 28,
                  ),
                ],
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  fontWeight:
                      item.isDir ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${item.isDir ? l10n.folder : _formatBytes(item.size)} • ${_formatDate(item.modTime)}',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
              trailing: state.isSelectionMode
                  ? null
                  : _buildItemMenu(context, ref, item, state),
              onTap: () {
                if (state.isSelectionMode) {
                  ref
                      .read(widget.provider.notifier)
                      .toggleSelection(item.path);
                } else if (item.isDir) {
                  ref.read(widget.provider.notifier).navigateTo(item.path);
                } else {
                  ref.read(fileOpenerServiceProvider).openCloudItem(
                        context: context,
                        item: item,
                        remote: state.currentRemote,
                        currentPath: state.currentPath,
                      );
                }
              },
            ),
          );

          final draggableItem = AdaptiveDraggable<PaneDragData>(
            data: dragData,
            touchDragEnabled: longPressAction == LongPressAction.move,
            feedback: _buildDragFeedback(dragData),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: itemTile,
            ),
            child: itemTile,
          );

          // If the item is a directory, wrap it with a DragTarget to allow dropping files into it
          if (item.isDir) {
            return DragTarget<PaneDragData>(
              onWillAcceptWithDetails: (details) {
                return details.data.sourceRemote != state.currentRemote ||
                    !details.data.items.any((i) => i.path == item.path);
              },
              onAcceptWithDetails: (details) {
                _handleDroppedData(details.data, targetFolderPath: item.path);
              },
              builder: (context, candidateData, rejectedData) {
                final isFolderHovered = candidateData.isNotEmpty;
                return Material(
                  color: isFolderHovered
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  child: draggableItem,
                );
              },
            );
          }

          return draggableItem;
        },
      );
    }

    // Grid View
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 170,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = state.selectedPaths.contains(item.path);

        final dragItems = isSelected && state.selectedItems.isNotEmpty
            ? state.selectedItems
            : [item];

        final dragData = PaneDragData(
          sourceRemote: state.currentRemote!,
          sourcePath: state.currentPath,
          items: dragItems,
          sourceProvider: widget.provider,
          isMove: longPressAction == LongPressAction.move,
        );

        final gridCard = FileContextMenuRegion(
          item: item,
          provider: widget.provider,
          oppositeProvider: widget.oppositeProvider,
          child: Card(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(color: colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (state.isSelectionMode) {
                  ref
                      .read(widget.provider.notifier)
                      .toggleSelection(item.path);
                } else if (item.isDir) {
                  ref.read(widget.provider.notifier).navigateTo(item.path);
                } else {
                  ref.read(fileOpenerServiceProvider).openCloudItem(
                        context: context,
                        item: item,
                        remote: state.currentRemote,
                        currentPath: state.currentPath,
                      );
                }
              },
              child: Stack(
                children: [
                  if (state.isSelectionMode)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) {
                          ref
                              .read(widget.provider.notifier)
                              .toggleSelection(item.path);
                        },
                      ),
                    ),
                  if (!state.isSelectionMode)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: _buildItemMenu(context, ref, item, state),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FileTypeIcon(
                            fileName: item.name,
                            isDir: item.isDir,
                            size: 42,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: item.isDir
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.isDir ? l10n.folder : _formatBytes(item.size),
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final draggableGrid = AdaptiveDraggable<PaneDragData>(
          data: dragData,
          touchDragEnabled: longPressAction == LongPressAction.move,
          feedback: _buildDragFeedback(dragData),
          childWhenDragging: Opacity(opacity: 0.4, child: gridCard),
          child: gridCard,
        );

        if (item.isDir) {
          return DragTarget<PaneDragData>(
            onWillAcceptWithDetails: (details) {
              return details.data.sourceRemote != state.currentRemote ||
                  !details.data.items.any((i) => i.path == item.path);
            },
            onAcceptWithDetails: (details) {
              _handleDroppedData(details.data, targetFolderPath: item.path);
            },
            builder: (context, candidateData, rejectedData) {
              final isFolderHovered = candidateData.isNotEmpty;
              if (!isFolderHovered) {
                return draggableGrid;
              }
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: draggableGrid,
              );
            },
          );
        }

        return draggableGrid;
      },
    );
  }

  Widget _buildItemMenu(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
    FileExplorerState state,
  ) {
    final l10n = context.l10n;
    final currentRemote = state.currentRemote ?? '';
    final isPinned = currentRemote.isNotEmpty &&
        ref.read(favoritesProvider.notifier).isPinned(
              currentRemote,
              item.path,
              currentPath: state.currentPath,
            );
    final oppositeState = widget.oppositeProvider != null
        ? ref.read(widget.oppositeProvider!)
        : null;
    final hasOppositeRemote = oppositeState?.currentRemote != null &&
        oppositeState!.currentRemote!.trim().isNotEmpty;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      tooltip: l10n.optionsForItem(item.name),
      onSelected: (action) =>
          _handleItemAction(context, ref, item, state, action),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'select',
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(l10n.select),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (!item.isDir) ...[
          PopupMenuItem(
            value: 'open_with',
            child: ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: Text(l10n.openWithSystemApp),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(l10n.downloadToLocal),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        if (currentRemote.isNotEmpty)
          PopupMenuItem(
            value: 'toggle_favorite',
            child: ListTile(
              leading: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(isPinned ? l10n.unpinFromHome : l10n.pinToHome),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        PopupMenuItem(
          value: 'share_link',
          child: ListTile(
            leading: const Icon(Icons.share_outlined),
            title: Text(l10n.createShareLink),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (hasOppositeRemote) ...[
          PopupMenuItem(
            value: 'copy_to_opposite',
            child: ListTile(
              leading: const Icon(Icons.drive_file_move_rtl_outlined),
              title: Text(l10n.copyToRemote(oppositeState.currentRemote!)),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'move_to_opposite',
            child: ListTile(
              leading: const Icon(Icons.drive_file_move_outlined),
              title: Text(l10n.moveToRemote(oppositeState.currentRemote!)),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        PopupMenuItem(
          value: 'copy',
          child: ListTile(
            leading: const Icon(Icons.copy_rounded),
            title: Text(l10n.copy),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'cut',
          child: ListTile(
            leading: const Icon(Icons.cut_rounded),
            title: Text(l10n.cut),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.rename),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'copy_path',
          child: ListTile(
            leading: const Icon(Icons.content_copy_outlined),
            title: Text(l10n.copyPath),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'info',
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.info),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  void _handleItemAction(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
    FileExplorerState state,
    String action,
  ) async {
    final l10n = context.l10n;
    final currentRemote = state.currentRemote ?? '';
    final oppositeState = widget.oppositeProvider != null
        ? ref.read(widget.oppositeProvider!)
        : null;

    switch (action) {
      case 'select':
        ref.read(widget.provider.notifier).toggleSelection(item.path);
      case 'open_with':
        await ref.read(fileOpenerServiceProvider).openCloudItem(
              context: context,
              item: item,
              remote: state.currentRemote,
              currentPath: state.currentPath,
            );
      case 'download':
        _handleBatchDownload(state.copyWith(selectedPaths: {item.path}));
      case 'toggle_favorite':
        final pinned = await ref.read(favoritesProvider.notifier).toggleFavorite(
              remote: currentRemote,
              item: item,
              currentPath: state.currentPath,
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                pinned
                    ? l10n.pinnedToHomeFeedback(item.name)
                    : l10n.unpinnedFromHomeFeedback(item.name),
              ),
            ),
          );
        }
      case 'share_link':
        final fullSrcPath = resolveRemoteItemPath(item.path, state.currentPath);
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.generatingShareLink(item.name)),
            duration: const Duration(seconds: 2),
          ),
        );
        try {
          final link = await ref
              .read(rcloneServiceProvider)
              .createPublicLink(remote: currentRemote, filePath: fullSrcPath);
          if (context.mounted && link.isNotEmpty) {
            await ShareLinkDialog.show(context, item: item, link: link);
          }
        } catch (e) {
          if (context.mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.errorPublicLink(e.toString()))),
            );
          }
        }
      case 'copy_to_opposite':
        if (oppositeState?.currentRemote != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.transferBatchStarted(
                  l10n.copyAction,
                  1,
                  oppositeState!.currentRemote!,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          await ref.read(widget.provider.notifier).transferItemsDirectly(
                items: [item],
                dstRemote: oppositeState.currentRemote!,
                dstPath: oppositeState.currentPath,
              );
          await ref.read(widget.oppositeProvider!.notifier).refresh();
        }
      case 'move_to_opposite':
        if (oppositeState?.currentRemote != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.transferBatchStarted(
                  l10n.moveAction,
                  1,
                  oppositeState!.currentRemote!,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          await ref.read(widget.provider.notifier).transferItemsDirectly(
                items: [item],
                dstRemote: oppositeState.currentRemote!,
                dstPath: oppositeState.currentPath,
                isMove: true,
              );
          await ref.read(widget.oppositeProvider!.notifier).refresh();
        }
      case 'copy':
        ref.read(clipboardProvider.notifier).copy(item, currentRemote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.itemCopiedToClipboard(item.name))),
        );
      case 'cut':
        ref.read(clipboardProvider.notifier).cut(item, currentRemote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.itemCutToClipboard(item.name))),
        );
      case 'rename':
        final controller = TextEditingController(text: item.name);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(item.isDir ? l10n.renameFolderTitle : l10n.renameFileTitle),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.newNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.rename),
              ),
            ],
          ),
        );
        if (confirmed == true &&
            controller.text.trim().isNotEmpty &&
            controller.text != item.name) {
          try {
            await ref
                .read(widget.provider.notifier)
                .renameItem(item, controller.text.trim());
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorRenaming(e.toString()))),
              );
            }
          }
        }
      case 'copy_path':
        await Clipboard.setData(ClipboardData(text: item.path));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.pathCopiedToClipboard)),
          );
        }
      case 'info':
        _showItemInfoDialog(context, item);
      case 'delete':
        _handleBatchDelete(state.copyWith(selectedPaths: {item.path}));
    }
  }

  void _showItemInfoDialog(BuildContext context, CloudItem item) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(item.isDir ? Icons.folder : Icons.insert_drive_file),
            const SizedBox(width: 8),
            Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.itemDetailsPath(item.path)),
            const SizedBox(height: 8),
            Text(l10n.itemDetailsType(item.isDir ? l10n.folder : (item.mimeType ?? l10n.file))),
            if (!item.isDir) ...[
              const SizedBox(height: 8),
              Text(l10n.itemDetailsSize(_formatBytes(item.size))),
            ],
            if (item.modTime != null) ...[
              const SizedBox(height: 8),
              Text(l10n.itemDetailsModified(_formatDate(item.modTime))),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
