import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../models/cloud_error.dart';
import '../../models/cloud_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/transfer_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_cloud_dialog.dart';
import '../widgets/breadcrumbs_bar.dart';
import '../widgets/expandable_error_box.dart';
import '../widgets/file_context_menu.dart';
import '../widgets/file_type_icon.dart';

/// Full-featured file explorer screen with breadcrumb navigation, search,
/// sorting, grid/list presentation, pull-to-refresh, and contextual actions.
class FileExplorerScreen extends ConsumerStatefulWidget {
  const FileExplorerScreen({super.key});

  @override
  ConsumerState<FileExplorerScreen> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends ConsumerState<FileExplorerScreen> {
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
            .read(fileExplorerProvider.notifier)
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileExplorerProvider);
    final remotesState = ref.watch(cloudAccountsProvider);

    // If no remote is currently selected, pick the first available or show empty state
    if (state.currentRemote == null && remotesState.remotes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(fileExplorerProvider.notifier)
            .openRemote(remotesState.remotes.first.name);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cerca file o cartelle...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  ref.read(fileExplorerProvider.notifier).setSearchQuery(val);
                },
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.currentRemote,
                  hint: const Text('Seleziona Cloud'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: remotesState.remotes.map((r) {
                    return DropdownMenuItem<String>(
                      value: r.name,
                      child: Text(
                        r.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(fileExplorerProvider.notifier).openRemote(val);
                    }
                  },
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  ref.read(fileExplorerProvider.notifier).setSearchQuery('');
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          PopupMenuButton<FileSortMode>(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordina per',
            initialValue: state.sortMode,
            onSelected: (mode) {
              ref.read(fileExplorerProvider.notifier).setSortMode(mode);
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
            icon: Icon(
              state.viewMode == FileViewMode.list
                  ? Icons.grid_view_outlined
                  : Icons.view_list_outlined,
            ),
            tooltip: state.viewMode == FileViewMode.list
                ? 'Vista Griglia'
                : 'Vista Lista',
            onPressed: () {
              final next = state.viewMode == FileViewMode.list
                  ? FileViewMode.grid
                  : FileViewMode.list;
              ref.read(fileExplorerProvider.notifier).setViewMode(next);
            },
          ),
            IconButton(
              icon: const Icon(Icons.upload_file_outlined),
              tooltip: 'Carica File dal dispositivo',
              onPressed: state.currentRemote == null
                  ? null
                  : () async {
                      final jobs = await ref
                          .read(transferProvider.notifier)
                          .pickAndUploadFiles(
                            dstRemote: state.currentRemote!,
                            dstPath: state.currentPath,
                          );
                      if (context.mounted && jobs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${jobs.length} ${jobs.length == 1 ? "file aggiunto" : "file aggiunti"} alla coda di caricamento',
                            ),
                          ),
                        );
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              tooltip: 'Nuova Cartella',
              onPressed: state.currentRemote == null ? null : _showNewFolderDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            // Breadcrumbs Bar
            const BreadcrumbsBar(),

            // Cloud-to-Cloud Clipboard Paste Banner
            _buildClipboardBanner(context, ref, state),

            // Top progress indicator if loading with existing items
            if (state.isLoading && state.items.isNotEmpty)
              const LinearProgressIndicator(minHeight: 3),

            // Main files area
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(fileExplorerProvider.notifier).refresh(),
                child: _buildContent(context, state),
              ),
            ),
          ],
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

      return MaterialBanner(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
        leading: Icon(
          clipboard.isCut ? Icons.cut_rounded : Icons.copy_rounded,
          color: AppTheme.primaryColor,
        ),
        content: Text(
          '${clipboard.actionLabel}: "${clipboard.item!.name}" da [${clipboard.sourceRemote}]',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(clipboardProvider.notifier).clear(),
            child: const Text('Annulla'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.paste_rounded, size: 16),
            label: const Text('Incolla qui'),
            onPressed: state.currentRemote == null
                ? null
                : () async {
                    final job = await ref
                        .read(clipboardProvider.notifier)
                        .pasteTo(
                          targetRemote: state.currentRemote!,
                          targetPath: state.currentPath,
                        );
                    if (context.mounted && job != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Trasferimento avviato per "${job.fileName}" (${job.id})',
                          ),
                        ),
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
            Icon(Icons.cloud_off, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            const Text(
              'Nessun Cloud Selezionato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Configura un cloud nella schermata Home per iniziare.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
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
                  ? 'Caricamento file da ${state.currentRemote ?? "Cloud"}...'
                  : 'Caricamento ${p.basename(state.currentPath)}...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
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
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  errorType.icon,
                  size: 36,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorType == CloudErrorType.network
                    ? 'Connessione Assente'
                    : errorType == CloudErrorType.diskSpace
                        ? 'Spazio Insufficiente'
                        : isAuth
                            ? 'Autenticazione Richiesta'
                            : 'Impossibile caricare i file',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  errorType.userFriendlyMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ExpandableErrorBox(
                error: state.error.toString(),
                accentColor: accentColor,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  if (isAuth)
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const AddCloudDialog(),
                        );
                      },
                      icon: const Icon(Icons.vpn_key_rounded),
                      label: const Text('Riconnetti Account'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(fileExplorerProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      errorType == CloudErrorType.network
                          ? 'Riprova connessione'
                          : 'Riprova',
                    ),
                  ),
                ],
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
            Icon(Icons.folder_open_outlined,
                size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Nessun file trovato per "${state.searchQuery}"'
                  : 'Questa cartella è vuota',
              style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
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
          return FileContextMenuRegion(
            item: item,
            child: ListTile(
              leading: FileTypeIcon(
                fileName: item.name,
                isDir: item.isDir,
                size: 28,
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
              trailing: _buildItemMenu(context, ref, item, state),
              onTap: () {
                if (item.isDir) {
                  ref.read(fileExplorerProvider.notifier).navigateTo(item.path);
                }
              },
            ),
          );
        },
      );
    }

    // Grid View
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FileContextMenuRegion(
          item: item,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (item.isDir) {
                  ref.read(fileExplorerProvider.notifier).navigateTo(item.path);
                }
              },
              child: Stack(
                children: [
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
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  item.isDir ? FontWeight.bold : FontWeight.normal,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.isDir ? 'Cartella' : _formatBytes(item.size),
                            style: TextStyle(
                              fontSize: 11,
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
      },
    );
  }

  Widget _buildItemMenu(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
    FileExplorerState state,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      tooltip: 'Opzioni per ${item.name}',
      onSelected: (action) =>
          _handleItemAction(context, ref, item, state, action),
      itemBuilder: (context) => [
        if (!item.isDir)
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(Icons.download_outlined),
              title: Text('Scarica in locale'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        const PopupMenuItem(
          value: 'copy',
          child: ListTile(
            leading: Icon(Icons.copy_rounded),
            title: Text('Copia'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'cut',
          child: ListTile(
            leading: Icon(Icons.cut_rounded),
            title: Text('Taglia (Sposta)'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Rinomina'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'copy_path',
          child: ListTile(
            leading: Icon(Icons.content_copy_outlined),
            title: Text('Copia percorso'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'info',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Informazioni'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
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
    final fullSrcPath = (state.currentPath.isNotEmpty && !item.path.startsWith(state.currentPath))
        ? '${state.currentPath}/${item.path}'
        : item.path;

    switch (action) {
      case 'download':
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text('Download avviato per "${item.name}"...')),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        try {
          final job = await ref.read(transferProvider.notifier).downloadFile(
                srcRemote: currentRemote,
                srcPath: fullSrcPath,
              );
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Download avviato: salvataggio in ${job.dstPath}',
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Errore durante l\'avvio del download: $e')),
          );
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
            controller.text.trim() != item.name) {
          try {
            await ref
                .read(fileExplorerProvider.notifier)
                .renameItem(item, controller.text.trim());
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Errore durante la ridenominazione: $e')),
              );
            }
          }
        }
        break;

      case 'copy_path':
        await Clipboard.setData(ClipboardData(text: fullSrcPath));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Percorso copiato negli appunti')),
          );
        }
        break;

      case 'info':
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(item.isDir ? Icons.folder : Icons.insert_drive_file),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item.name, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Percorso: $fullSrcPath'),
                const SizedBox(height: 8),
                Text('Tipo: ${item.isDir ? "Cartella" : (item.mimeType ?? "File")}'),
                if (!item.isDir) ...[
                  const SizedBox(height: 8),
                  Text('Dimensione: ${_formatBytes(item.size)} (${item.size} bytes)'),
                ],
                if (item.modTime != null) ...[
                  const SizedBox(height: 8),
                  Text('Ultima modifica: ${item.modTime!.toLocal().toString().split(".")[0]}'),
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
        break;

      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Elimina ${item.isDir ? "cartella" : "file"}?'),
            content: Text(
              'Sei sicuro di voler eliminare definitivamente "${item.name}"?',
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

        if (confirmed == true) {
          try {
            await ref.read(fileExplorerProvider.notifier).deleteItem(item);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Errore durante l\'eliminazione: $e')),
              );
            }
          }
        }
        break;
    }
  }
}
