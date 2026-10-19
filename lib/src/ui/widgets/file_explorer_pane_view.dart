import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../models/cloud_error.dart';
import '../../models/cloud_models.dart';
import '../../models/pane_drag_data.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/transfer_provider.dart';
import '../../services/file_opener_service.dart';
import '../../services/rclone_service.dart';
import '../theme/app_theme.dart';
import '../theme/cosmic_icons.dart';
import 'adaptive_draggable.dart';
import 'breadcrumbs_bar.dart';
import 'expandable_error_box.dart';
import 'file_context_menu.dart';
import 'file_type_icon.dart';
import 'share_link_dialog.dart';

/// Reusable explorer pane view supporting independent navigation, selection,
/// drag-and-drop file transfer, and direct cross-pane actions.
class FileExplorerPaneView extends ConsumerStatefulWidget {
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> provider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? oppositeProvider;
  final String? paneTitle;
  final bool isDualPane;
  final bool showDualPaneToggle;

  const FileExplorerPaneView({
    super.key,
    required this.provider,
    this.oppositeProvider,
    this.paneTitle,
    this.isDualPane = false,
    this.showDualPaneToggle = false,
  });

  @override
  ConsumerState<FileExplorerPaneView> createState() =>
      _FileExplorerPaneViewState();
}

class _FileExplorerPaneViewState extends ConsumerState<FileExplorerPaneView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

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
    final controller = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuova Cartella'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome cartella',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Crea'),
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
            SnackBar(content: Text('Errore creazione cartella: $e')),
          );
        }
      }
    }
  }

  void _handleBatchTransferToOpposite({required bool isMove}) async {
    if (widget.oppositeProvider == null) return;
    final srcState = ref.read(widget.provider);
    final dstState = ref.read(widget.oppositeProvider!);

    final srcRemote = srcState.currentRemote ?? '';
    final dstRemote = dstState.currentRemote ?? '';
    final items = srcState.selectedItems;

    if (srcRemote.isEmpty || dstRemote.isEmpty || items.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final actionLabel = isMove ? 'Spostamento' : 'Copia';
    final count = items.length;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '$actionLabel di $count ${count == 1 ? "elemento" : "elementi"} verso [$dstRemote] avviato...',
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
      ref.read(widget.oppositeProvider!.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante il trasferimento: $e')),
      );
    }
  }

  void _handleBatchCopy(FileExplorerState state) {
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    ref.read(clipboardProvider.notifier).copyAll(items, currentRemote);
    ref.read(widget.provider.notifier).clearSelection();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          items.length == 1
              ? '"${items.first.name}" copiato negli appunti'
              : '${items.length} elementi copiati negli appunti',
        ),
      ),
    );
  }

  void _handleBatchCut(FileExplorerState state) {
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    ref.read(clipboardProvider.notifier).cutAll(items, currentRemote);
    ref.read(widget.provider.notifier).clearSelection();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          items.length == 1
              ? '"${items.first.name}" tagliato (pronto per lo spostamento)'
              : '${items.length} elementi tagliati (pronti per lo spostamento)',
        ),
      ),
    );
  }

  void _handleBatchDownload(FileExplorerState state) async {
    final items = state.selectedItems;
    final currentRemote = state.currentRemote ?? '';
    if (items.isEmpty || currentRemote.isEmpty) return;

    final filesToDownload = items.where((i) => !i.isDir).toList();
    final dirCount = items.length - filesToDownload.length;

    if (filesToDownload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Il download diretto delle cartelle non è supportato. Seleziona singoli file.'),
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
                    ? 'Download avviato per "${filesToDownload.first.name}"...'
                    : 'Avvio download per ${filesToDownload.length} file...',
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

      final dirNote = dirCount > 0 ? ' ($dirCount cartelle escluse)' : '';
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${jobs.length} file aggiunti alla coda di download$dirNote.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante l\'avvio del download: $e')),
      );
    }
  }

  void _handleBatchDelete(FileExplorerState state) async {
    final items = state.selectedItems;
    if (items.isEmpty) return;

    final confirmDelete = ref.read(settingsProvider).confirmDelete;
    bool shouldDelete = true;

    if (confirmDelete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Elimina ${items.length == 1 ? (items.first.isDir ? "cartella" : "file") : "${items.length} elementi"}?',
          ),
          content: Text(
            items.length == 1
                ? 'Sei sicuro di voler eliminare definitivamente "${items.first.name}"?'
                : 'Sei sicuro di voler eliminare definitivamente i ${items.length} elementi selezionati?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Elimina'),
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
                    ? 'Elemento eliminato'
                    : '${items.length} elementi eliminati',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore durante l\'eliminazione: $e')),
          );
        }
      }
    }
  }

  String _sortModeLabel(FileSortMode mode) {
    switch (mode) {
      case FileSortMode.nameAsc:
        return 'Nome (A-Z)';
      case FileSortMode.nameDesc:
        return 'Nome (Z-A)';
      case FileSortMode.sizeDesc:
        return 'Dimensione (Grande -> Piccolo)';
      case FileSortMode.sizeAsc:
        return 'Dimensione (Piccolo -> Grande)';
      case FileSortMode.dateDesc:
        return 'Data (Recente prima)';
      case FileSortMode.dateAsc:
        return 'Data (Meno recente prima)';
    }
  }

  Future<void> _handleUploadChoice(String choice, FileExplorerState state) async {
    if (choice == 'files') {
      try {
        final jobs = await ref
            .read(transferProvider.notifier)
            .pickAndUploadFiles(
              dstRemote: state.currentRemote!,
              dstPath: state.currentPath,
            );
        if (mounted && jobs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${jobs.length} ${jobs.length == 1 ? "file aggiunto" : "file aggiunti"} alla coda di caricamento',
              ),
            ),
          );
          ref.read(widget.provider.notifier).refresh();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore durante il caricamento: $e')),
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
            );
        if (mounted) {
          if (jobs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Cartella aggiunta al caricamento (${jobs.length} ${jobs.length == 1 ? "file" : "file"} in coda)',
                ),
              ),
            );
          }
          ref.read(widget.provider.notifier).refresh();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Errore durante il caricamento della cartella: $e',
              ),
            ),
          );
        }
      }
    }
  }

  void _handleDroppedData(PaneDragData data, {String? targetFolderPath}) async {
    final targetState = ref.read(widget.provider);
    final targetRemote = targetState.currentRemote;
    if (targetRemote == null || targetRemote.isEmpty) return;

    final targetPath = targetFolderPath ?? targetState.currentPath;

    // Check if dropping onto the exact same folder
    if (data.sourceRemote == targetRemote && data.sourcePath == targetPath) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('I file si trovano già in questa cartella.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final count = data.items.length;
    final actionLabel = data.isMove ? 'Spostamento' : 'Copia';

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '$actionLabel di $count ${count == 1 ? "elemento" : "elementi"} da [${data.sourceRemote}] a [$targetRemote] in corso...',
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
      ref.read(widget.provider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante il trasferimento drag-and-drop: $e')),
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
              size: 24,
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
    final state = ref.watch(widget.provider);
    final remotesState = ref.watch(cloudAccountsProvider);
    final oppositeState = widget.oppositeProvider != null
        ? ref.watch(widget.oppositeProvider!)
        : null;
    final hasOppositeRemote = oppositeState?.currentRemote != null &&
        oppositeState!.currentRemote!.trim().isNotEmpty;
    final currentRemoteObj = remotesState.remotes
        .where((r) => r.name == state.currentRemote)
        .firstOrNull;
    final isCurrentCrypt = currentRemoteObj?.isCrypt ?? false;

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

    final header = isSelectionMode
        ? AppBar(
            titleSpacing: widget.isDualPane ? 8.0 : null,
            leading: IconButton(
              icon: const CosmicSvgIcon(CosmicIcons.closeSvg),
              tooltip: 'Chiudi selezione',
              visualDensity: widget.isDualPane ? VisualDensity.compact : null,
              onPressed: () {
                ref.read(widget.provider.notifier).clearSelection();
              },
            ),
            title: Text(
              '${state.selectedCount} selezionati',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: CosmicSvgIcon(allSelected ? CosmicIcons.closeSvg : CosmicIcons.selectAllSvg, size: 20),
                tooltip: allSelected ? 'Deseleziona tutti' : 'Seleziona tutti',
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
                  icon: const CosmicSvgIcon(CosmicIcons.chevronLeftSvg, size: 20),
                  tooltip: 'Copia in ${oppositeState.currentRemote}',
                  visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                  onPressed: () => _handleBatchTransferToOpposite(isMove: false),
                ),
                IconButton(
                  icon: const CosmicSvgIcon(CosmicIcons.chevronRightSvg, size: 20),
                  tooltip: 'Sposta in ${oppositeState.currentRemote}',
                  visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                  onPressed: () => _handleBatchTransferToOpposite(isMove: true),
                ),
              ],
              if (widget.isDualPane) ...[
                PopupMenuButton<String>(
                  icon: const CosmicSvgIcon(CosmicIcons.moreVertSvg, size: 20),
                  tooltip: 'Altre azioni',
                  padding: EdgeInsets.zero,
                  onSelected: (action) {
                    switch (action) {
                      case 'download':
                        _handleBatchDownload(state);
                        break;
                      case 'copy':
                        _handleBatchCopy(state);
                        break;
                      case 'cut':
                        _handleBatchCut(state);
                        break;
                      case 'delete':
                        _handleBatchDelete(state);
                        break;
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          CosmicSvgIcon(CosmicIcons.downloadSvg, size: 20),
                          SizedBox(width: 8),
                          Text('Scarica selezionati'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'copy',
                      child: Row(
                        children: [
                          CosmicSvgIcon(CosmicIcons.copySvg, size: 20),
                          SizedBox(width: 8),
                          Text('Copia negli appunti'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cut',
                      child: Row(
                        children: [
                          CosmicSvgIcon(CosmicIcons.cutSvg, size: 20),
                          SizedBox(width: 8),
                          Text('Taglia negli appunti'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          CosmicSvgIcon(CosmicIcons.deleteSvg, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Elimina selezionati', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                IconButton(
                  icon: const CosmicSvgIcon(CosmicIcons.downloadSvg, size: 20),
                  tooltip: 'Scarica selezionati',
                  onPressed: () => _handleBatchDownload(state),
                ),
                IconButton(
                  icon: const CosmicSvgIcon(CosmicIcons.copySvg, size: 20),
                  tooltip: 'Copia selezionati',
                  onPressed: () => _handleBatchCopy(state),
                ),
                IconButton(
                  icon: const CosmicSvgIcon(CosmicIcons.cutSvg, size: 20),
                  tooltip: 'Taglia selezionati',
                  onPressed: () => _handleBatchCut(state),
                ),
                IconButton(
                  icon: const CosmicSvgIcon(CosmicIcons.deleteSvg, size: 20, color: Colors.red),
                  tooltip: 'Elimina selezionati',
                  onPressed: () => _handleBatchDelete(state),
                ),
              ],
            ],
          )
        : AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: widget.isDualPane ? 8.0 : null,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Cerca file o cartelle...',
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.currentRemote,
                            hint: const Text('Seleziona Cloud'),
                            icon: const CosmicSvgIcon(CosmicIcons.panDownSvg, size: 20),
                            isDense: true,
                            isExpanded: true,
                            items: remotesState.remotes.map((r) {
                              return DropdownMenuItem<String>(
                                value: r.name,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (r.isCrypt) ...[
                                      const CosmicSvgIcon(
                                        CosmicIcons.lockSvg,
                                        size: 14,
                                        color: Color(0xFF00BFA5),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Flexible(
                                      child: Text(
                                        r.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(widget.provider.notifier)
                                    .openRemote(val);
                              }
                            },
                          ),
                        ),
                      ),
                      if (isCurrentCrypt) ...[
                        const SizedBox(width: 6),
                        Tooltip(
                          message:
                              'Crittografia End-to-End attiva (AES-256)\nFile e cartelle cifrati client-side',
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
                                CosmicSvgIcon(
                                  CosmicIcons.lockSvg,
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
                icon: CosmicSvgIcon(_isSearching ? CosmicIcons.closeSvg : CosmicIcons.searchSvg, size: 20),
                tooltip: _isSearching ? 'Chiudi ricerca' : 'Cerca',
                visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                      ref
                          .read(widget.provider.notifier)
                          .setSearchQuery('');
                    } else {
                      _isSearching = true;
                    }
                  });
                },
              ),
              if (!_isSearching) ...[
                if (widget.isDualPane) ...[
                  PopupMenuButton<String>(
                    icon: const CosmicSvgIcon(CosmicIcons.uploadSvg, size: 20),
                    tooltip: 'Carica dal dispositivo',
                    padding: EdgeInsets.zero,
                    enabled: state.currentRemote != null,
                    onSelected: (choice) => _handleUploadChoice(choice, state),
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'files',
                        child: Row(
                          children: [
                            CosmicSvgIcon(CosmicIcons.uploadSvg, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Text('Carica file')),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'folder',
                        child: Row(
                          children: [
                            CosmicSvgIcon(CosmicIcons.folderOpenSvg, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Text('Carica intera cartella')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const CosmicSvgIcon(CosmicIcons.folderNewSvg, size: 20),
                    tooltip: 'Nuova Cartella',
                    visualDensity: VisualDensity.compact,
                    onPressed: state.currentRemote == null ? null : _showNewFolderDialog,
                  ),
                  PopupMenuButton<String>(
                    icon: const CosmicSvgIcon(CosmicIcons.moreVertSvg, size: 20),
                    tooltip: 'Altre opzioni',
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'toggle_view') {
                        final next = state.viewMode == FileViewMode.list
                            ? FileViewMode.grid
                            : FileViewMode.list;
                        ref.read(widget.provider.notifier).setViewMode(next);
                      } else if (value == 'select_all') {
                        ref.read(widget.provider.notifier).selectAll();
                      } else if (value.startsWith('sort_')) {
                        final sortName = value.substring(5);
                        final mode = FileSortMode.values.firstWhere((e) => e.name == sortName);
                        ref.read(widget.provider.notifier).setSortMode(mode);
                      } else if (value == 'toggle_dual') {
                        ref.read(dualPaneActiveProvider.notifier).toggle();
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'toggle_view',
                        child: Row(
                          children: [
                            CosmicSvgIcon(
                              state.viewMode == FileViewMode.list
                                  ? CosmicIcons.viewGridSvg
                                  : CosmicIcons.viewListSvg,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.viewMode == FileViewMode.list
                                  ? 'Vista Griglia'
                                  : 'Vista Lista',
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'select_all',
                        child: Row(
                          children: [
                            CosmicSvgIcon(CosmicIcons.selectAllSvg, size: 20),
                            SizedBox(width: 8),
                            Text('Selezione multipla'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      ...FileSortMode.values.map((mode) {
                        return PopupMenuItem(
                          value: 'sort_${mode.name}',
                          child: Row(
                            children: [
                              CosmicSvgIcon(
                                state.sortMode == mode
                                    ? CosmicIcons.checkCircleSvg
                                    : CosmicIcons.sortSvg,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(_sortModeLabel(mode)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ] else ...[
                  IconButton(
                    icon: const CosmicSvgIcon(CosmicIcons.selectAllSvg, size: 20),
                    tooltip: 'Selezione multipla',
                    onPressed: state.displayItems.isEmpty
                        ? null
                        : () {
                            ref.read(widget.provider.notifier).selectAll();
                          },
                  ),
                  PopupMenuButton<FileSortMode>(
                    icon: const CosmicSvgIcon(CosmicIcons.sortSvg, size: 20),
                    tooltip: 'Ordina per',
                    initialValue: state.sortMode,
                    onSelected: (mode) {
                      ref.read(widget.provider.notifier).setSortMode(mode);
                    },
                    itemBuilder: (ctx) => const [
                      PopupMenuItem(
                        value: FileSortMode.nameAsc,
                        child: Text('Nome (A-Z)'),
                      ),
                      PopupMenuItem(
                        value: FileSortMode.nameDesc,
                        child: Text('Nome (Z-A)'),
                      ),
                      PopupMenuItem(
                        value: FileSortMode.sizeDesc,
                        child: Text('Dimensione (Grande -> Piccolo)'),
                      ),
                      PopupMenuItem(
                        value: FileSortMode.sizeAsc,
                        child: Text('Dimensione (Piccolo -> Grande)'),
                      ),
                      PopupMenuItem(
                        value: FileSortMode.dateDesc,
                        child: Text('Data (Recente prima)'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: CosmicSvgIcon(
                      state.viewMode == FileViewMode.list
                          ? CosmicIcons.viewGridSvg
                          : CosmicIcons.viewListSvg,
                      size: 20,
                    ),
                    tooltip: state.viewMode == FileViewMode.list
                        ? 'Vista Griglia'
                        : 'Vista Lista',
                    onPressed: () {
                      final next = state.viewMode == FileViewMode.list
                          ? FileViewMode.grid
                          : FileViewMode.list;
                      ref.read(widget.provider.notifier).setViewMode(next);
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: const CosmicSvgIcon(CosmicIcons.uploadSvg, size: 20),
                    tooltip: 'Carica dal dispositivo',
                    enabled: state.currentRemote != null,
                    onSelected: (choice) => _handleUploadChoice(choice, state),
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'files',
                        child: Row(
                          children: [
                            CosmicSvgIcon(CosmicIcons.uploadSvg, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Text('Carica file')),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'folder',
                        child: Row(
                          children: [
                            CosmicSvgIcon(CosmicIcons.folderOpenSvg, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Text('Carica intera cartella')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const CosmicSvgIcon(CosmicIcons.folderNewSvg, size: 20),
                    tooltip: 'Nuova Cartella',
                    onPressed: state.currentRemote == null ? null : _showNewFolderDialog,
                  ),
                ],
                if (widget.showDualPaneToggle)
                  IconButton(
                    icon: CosmicSvgIcon(
                      ref.watch(dualPaneActiveProvider)
                          ? CosmicIcons.splitScreenSvg
                          : CosmicIcons.desktopSvg,
                      size: 20,
                    ),
                    tooltip: ref.watch(dualPaneActiveProvider)
                        ? 'Disattiva doppio pannello'
                        : 'Attiva doppio pannello (Commander)',
                    visualDensity: widget.isDualPane ? VisualDensity.compact : null,
                    onPressed: () {
                      ref.read(dualPaneActiveProvider.notifier).toggle();
                    },
                  ),
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
                      child: _buildContent(context, state),
                    ),
                  ),
                ],
              ),
              if (isHovered)
                Positioned.fill(
                  child: Container(
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
                              const CosmicSvgIcon(
                                CosmicIcons.downloadSvg,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Rilascia per copiare in [${state.currentRemote ?? "destinazione"}]',
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
  }

  Widget _buildClipboardBanner(
    BuildContext context,
    WidgetRef ref,
    FileExplorerState state,
  ) {
    final clipboard = ref.watch(clipboardProvider);
    if (!clipboard.hasItem) return const SizedBox.shrink();

    final label = clipboard.items.length == 1
        ? '${clipboard.actionLabel}: "${clipboard.item!.name}" da [${clipboard.sourceRemote}]'
        : '${clipboard.actionLabel}: ${clipboard.items.length} elementi da [${clipboard.sourceRemote}]';

    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
      leading: CosmicSvgIcon(
        clipboard.isCut ? CosmicIcons.cutSvg : CosmicIcons.copySvg,
        color: AppTheme.primaryColor,
        size: 22,
      ),
      content: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => ref.read(clipboardProvider.notifier).clear(),
          child: const Text('Annulla'),
        ),
        FilledButton.icon(
          icon: const CosmicSvgIcon(CosmicIcons.pasteSvg, size: 16),
          label: const Text('Incolla qui'),
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
                        ? 'Trasferimento avviato per "${jobs.first.fileName}"'
                        : '${jobs.length} trasferimenti avviati';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }
                },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, FileExplorerState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state.currentRemote == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CosmicSvgIcon(
              CosmicIcons.cloudSvg,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nessun Cloud Selezionato',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleziona un cloud dal menu in alto.',
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
                  ? 'Caricamento file da ${state.currentRemote}...'
                  : 'Caricamento ${p.basename(state.currentPath)}...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lettura directory in corso...',
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
                child: CosmicSvgIcon(
                  errorType.svgAsset,
                  size: 32,
                  color: accentColor,
                  fallbackMaterialIcon: errorType.icon,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorType.userFriendlyMessage,
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
                icon: const CosmicSvgIcon(CosmicIcons.refreshSvg, size: 18),
                label: const Text('Riprova'),
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
            CosmicSvgIcon(
              CosmicIcons.folderOpenSvg,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Nessun file trovato per "${state.searchQuery}"'
                  : 'Questa cartella è vuota',
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
                '${item.isDir ? "Cartella" : _formatBytes(item.size)} • ${_formatDate(item.modTime)}',
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
              onLongPress: () {
                ref
                    .read(widget.provider.notifier)
                    .toggleSelection(item.path);
              },
            ),
          );

          final draggableItem = AdaptiveDraggable<PaneDragData>(
            data: dragData,
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
              onLongPress: () {
                ref
                    .read(widget.provider.notifier)
                    .toggleSelection(item.path);
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
                            item.isDir ? 'Cartella' : _formatBytes(item.size),
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
              return Container(
                decoration: isFolderHovered
                    ? BoxDecoration(
                        border: Border.all(color: AppTheme.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
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
    final oppositeState = widget.oppositeProvider != null
        ? ref.read(widget.oppositeProvider!)
        : null;
    final hasOppositeRemote = oppositeState?.currentRemote != null &&
        oppositeState!.currentRemote!.trim().isNotEmpty;

    return PopupMenuButton<String>(
      icon: const CosmicSvgIcon(CosmicIcons.moreVertSvg, size: 18),
      tooltip: 'Opzioni per ${item.name}',
      onSelected: (action) =>
          _handleItemAction(context, ref, item, state, action),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'select',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.checkCircleSvg, size: 20),
            title: Text('Seleziona'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (!item.isDir) ...[
          const PopupMenuItem(
            value: 'open_with',
            child: ListTile(
              leading: CosmicSvgIcon(CosmicIcons.openWithSvg, size: 20),
              title: Text('Apri con app di sistema'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: CosmicSvgIcon(CosmicIcons.downloadSvg, size: 20),
              title: Text('Scarica in locale'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        const PopupMenuItem(
          value: 'share_link',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.shareSvg, size: 20),
            title: Text('Crea link condivisibile'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (hasOppositeRemote) ...[
          PopupMenuItem(
            value: 'copy_to_opposite',
            child: ListTile(
              leading: const CosmicSvgIcon(CosmicIcons.splitScreenSvg, size: 20),
              title: Text('Copia in ${oppositeState.currentRemote}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'move_to_opposite',
            child: ListTile(
              leading: const CosmicSvgIcon(CosmicIcons.splitScreenSvg, size: 20),
              title: Text('Sposta in ${oppositeState.currentRemote}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        const PopupMenuItem(
          value: 'copy',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.copySvg, size: 20),
            title: Text('Copia'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'cut',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.cutSvg, size: 20),
            title: Text('Taglia (Sposta)'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.editSvg, size: 20),
            title: Text('Rinomina'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'copy_path',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.copySvg, size: 20),
            title: Text('Copia percorso'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'info',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.infoSvg, size: 20),
            title: Text('Informazioni'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.deleteSvg, size: 20, color: Colors.red),
            title: Text('Elimina', style: TextStyle(color: Colors.red)),
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
    final currentRemote = state.currentRemote ?? '';
    final oppositeState = widget.oppositeProvider != null
        ? ref.read(widget.oppositeProvider!)
        : null;

    switch (action) {
      case 'select':
        ref.read(widget.provider.notifier).toggleSelection(item.path);
        break;
      case 'open_with':
        ref.read(fileOpenerServiceProvider).openCloudItem(
              context: context,
              item: item,
              remote: state.currentRemote,
              currentPath: state.currentPath,
            );
        break;
      case 'download':
        _handleBatchDownload(state.copyWith(selectedPaths: {item.path}));
        break;
      case 'share_link':
        final fullSrcPath = resolveRemoteItemPath(item.path, state.currentPath);
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Generazione del link per "${item.name}"...'),
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
              SnackBar(content: Text('Errore link pubblico: $e')),
            );
          }
        }
        break;
      case 'copy_to_opposite':
        if (oppositeState?.currentRemote != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Copia di "${item.name}" verso [${oppositeState!.currentRemote}] avviata...',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          await ref.read(widget.provider.notifier).transferItemsDirectly(
                items: [item],
                dstRemote: oppositeState.currentRemote!,
                dstPath: oppositeState.currentPath,
                isMove: false,
              );
          ref.read(widget.oppositeProvider!.notifier).refresh();
        }
        break;
      case 'move_to_opposite':
        if (oppositeState?.currentRemote != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Spostamento di "${item.name}" verso [${oppositeState!.currentRemote}] avviato...',
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
          ref.read(widget.oppositeProvider!.notifier).refresh();
        }
        break;
      case 'copy':
        ref.read(clipboardProvider.notifier).copy(item, currentRemote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item.name}" copiato negli appunti')),
        );
        break;
      case 'cut':
        ref.read(clipboardProvider.notifier).cut(item, currentRemote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item.name}" tagliato (pronto per lo spostamento)')),
        );
        break;
      case 'rename':
        final controller = TextEditingController(text: item.name);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Rinomina ${item.isDir ? "cartella" : "file"}'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nuovo nome',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Annulla'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Rinomina'),
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
                SnackBar(content: Text('Errore ridenominazione: $e')),
              );
            }
          }
        }
        break;
      case 'copy_path':
        Clipboard.setData(ClipboardData(text: item.path));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Percorso copiato negli appunti')),
          );
        }
        break;
      case 'info':
        _showItemInfoDialog(context, item);
        break;
      case 'delete':
        _handleBatchDelete(state.copyWith(selectedPaths: {item.path}));
        break;
    }
  }

  void _showItemInfoDialog(BuildContext context, CloudItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            CosmicSvgIcon(
              item.isDir ? CosmicIcons.folderOpenSvg : CosmicIcons.fileSvg,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Percorso: ${item.path}'),
            const SizedBox(height: 8),
            Text('Tipo: ${item.isDir ? "Cartella" : (item.mimeType ?? "File")}'),
            if (!item.isDir) ...[
              const SizedBox(height: 8),
              Text('Dimensione: ${_formatBytes(item.size)}'),
            ],
            if (item.modTime != null) ...[
              const SizedBox(height: 8),
              Text('Data modifica: ${_formatDate(item.modTime)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}
