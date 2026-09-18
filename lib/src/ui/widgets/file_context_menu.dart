import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cloud_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/transfer_provider.dart';

/// Wraps a file or folder tile with context menu support (Desktop right-click & Mobile long-press).
class FileContextMenuRegion extends ConsumerWidget {
  final CloudItem item;
  final Widget child;

  const FileContextMenuRegion({
    super.key,
    required this.item,
    required this.child,
  });

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
            leading: Icon(Icons.check_circle_outline),
            title: Text('Seleziona'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
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

    if (!context.mounted || result == null) return;

    final currentRemote = ref.read(fileExplorerProvider).currentRemote ?? '';

    switch (result) {
      case 'select':
        ref.read(fileExplorerProvider.notifier).toggleSelection(item.path);
        break;
      case 'download':
        _handleDownload(context, ref, currentRemote);
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

  void _handleDownload(BuildContext context, WidgetRef ref, String currentRemote) async {
    final messenger = ScaffoldMessenger.of(context);
    final currentPath = ref.read(fileExplorerProvider).currentPath;
    final fullSrcPath = (currentPath.isNotEmpty && !item.path.startsWith(currentPath))
        ? '$currentPath/${item.path}'
        : item.path;

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
        await ref.read(fileExplorerProvider.notifier).renameItem(item, controller.text.trim());
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
        await ref.read(fileExplorerProvider.notifier).deleteItem(item);
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
            Icon(item.isDir ? Icons.folder : Icons.insert_drive_file),
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
        ref.read(fileExplorerProvider.notifier).toggleSelection(item.path);
      },
      child: child,
    );
  }
}
