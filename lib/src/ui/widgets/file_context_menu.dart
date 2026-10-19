import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cloud_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/transfer_provider.dart';
import '../../services/file_opener_service.dart';
import '../../services/rclone_service.dart';
import '../theme/cosmic_icons.dart';
import 'share_link_dialog.dart';

/// Wraps a file or folder tile with context menu support (Desktop right-click & Mobile long-press).
class FileContextMenuRegion extends ConsumerWidget {
  final CloudItem item;
  final Widget child;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? provider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? oppositeProvider;

  const FileContextMenuRegion({
    super.key,
    required this.item,
    required this.child,
    this.provider,
    this.oppositeProvider,
  });

  NotifierProvider<FileExplorerNotifier, FileExplorerState> get _provider =>
      provider ?? fileExplorerProvider;

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(1)} ${suffixes[i]}';
  }

  void _showContextMenu(BuildContext context, WidgetRef ref, Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    final oppositeState = oppositeProvider != null ? ref.read(oppositeProvider!) : null;
    final hasOppositeRemote = oppositeState?.currentRemote != null &&
        oppositeState!.currentRemote!.trim().isNotEmpty;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
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
              leading: const CosmicSvgIcon(CosmicIcons.chevronLeftSvg, size: 20),
              title: Text('Copia in ${oppositeState.currentRemote}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'move_to_opposite',
            child: ListTile(
              leading: const CosmicSvgIcon(CosmicIcons.chevronRightSvg, size: 20),
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
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: CosmicSvgIcon(CosmicIcons.deleteSvg, color: Colors.red, size: 20),
            title: Text('Elimina', style: TextStyle(color: Colors.red)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );

    if (!context.mounted || result == null) return;

    final currentRemote = ref.read(_provider).currentRemote ?? '';

    switch (result) {
      case 'select':
        ref.read(_provider.notifier).toggleSelection(item.path);
        break;
      case 'open_with':
        ref.read(fileOpenerServiceProvider).openCloudItem(
              context: context,
              item: item,
              remote: ref.read(_provider).currentRemote,
              currentPath: ref.read(_provider).currentPath,
            );
        break;
      case 'copy_to_opposite':
        _handleDirectTransfer(context, ref, isMove: false);
        break;
      case 'move_to_opposite':
        _handleDirectTransfer(context, ref, isMove: true);
        break;
      case 'download':
        _handleDownload(context, ref, currentRemote);
        break;
      case 'share_link':
        _handleShareLink(context, ref, currentRemote);
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
        _handleRename(context, ref);
        break;
      case 'copy_path':
        await Clipboard.setData(ClipboardData(text: item.path));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Percorso copiato negli appunti')),
          );
        }
        break;
      case 'info':
        _showInfoDialog(context);
        break;
      case 'delete':
        _handleDelete(context, ref);
        break;
    }
  }

  void _handleDirectTransfer(
    BuildContext context,
    WidgetRef ref, {
    required bool isMove,
  }) async {
    if (oppositeProvider == null) return;
    final srcState = ref.read(_provider);
    final dstState = ref.read(oppositeProvider!);
    final srcRemote = srcState.currentRemote ?? '';
    final dstRemote = dstState.currentRemote ?? '';
    if (srcRemote.isEmpty || dstRemote.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final actionLabel = isMove ? 'Spostamento' : 'Copia';
    messenger.showSnackBar(
      SnackBar(
        content: Text('$actionLabel di "${item.name}" verso $dstRemote avviato...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref.read(_provider.notifier).transferItemsDirectly(
            items: [item],
            dstRemote: dstRemote,
            dstPath: dstState.currentPath,
            isMove: isMove,
          );
      ref.read(oppositeProvider!.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante il trasferimento: $e')),
      );
    }
  }

  void _handleDownload(BuildContext context, WidgetRef ref, String currentRemote) async {
    final messenger = ScaffoldMessenger.of(context);
    final currentPath = ref.read(_provider).currentPath;
    final fullSrcPath = resolveRemoteItemPath(item.path, currentPath);

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
          content: Text('Download avviato: salvataggio in ${job.dstPath}'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Errore durante l\'avvio del download: $e')),
      );
    }
  }

  void _handleShareLink(BuildContext context, WidgetRef ref, String currentRemote) async {
    final messenger = ScaffoldMessenger.of(context);
    final currentPath = ref.read(_provider).currentPath;
    final fullSrcPath = resolveRemoteItemPath(item.path, currentPath);

    if (currentRemote.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Nessun cloud selezionato.')),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Generazione del link per "${item.name}"...')),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final link = await ref.read(rcloneServiceProvider).createPublicLink(
            remote: currentRemote,
            filePath: fullSrcPath,
          );

      if (!context.mounted) return;

      if (link.trim().isEmpty) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Nessun link restituito dal provider.')),
        );
        return;
      }

      await ShareLinkDialog.show(context, item: item, link: link);
    } catch (e) {
      if (!context.mounted) return;
      final errorStr = e.toString();
      final msg = errorStr.contains("doesn't support public links") ||
              errorStr.contains('not supported')
          ? 'Questo provider cloud non supporta la creazione di link pubblici.'
          : 'Errore durante la creazione del link: $e';
      messenger.showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  void _handleRename(BuildContext context, WidgetRef ref) async {
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

    if (confirmed == true && controller.text.trim().isNotEmpty && controller.text != item.name) {
      try {
        await ref.read(_provider.notifier).renameItem(item, controller.text.trim());
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore durante la ridenominazione: $e')),
          );
        }
      }
    }
  }

  void _handleDelete(BuildContext context, WidgetRef ref) async {
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
        await ref.read(_provider.notifier).deleteItem(item);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore durante l\'eliminazione: $e')),
          );
        }
      }
    }
  }

  void _showInfoDialog(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) {
        _showContextMenu(context, ref, details.globalPosition);
      },
      onLongPress: () {
        ref.read(_provider.notifier).toggleSelection(item.path);
      },
      child: child,
    );
  }
}
