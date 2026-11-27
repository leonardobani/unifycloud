import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/l10n_extension.dart';
import '../../models/cloud_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/transfer_provider.dart';
import '../../services/file_opener_service.dart';
import '../../services/rclone_service.dart';
import 'share_link_dialog.dart';

/// Wraps a file or folder tile with context menu support (Desktop right-click & Mobile long-press).
class FileContextMenuRegion extends ConsumerWidget {

  const FileContextMenuRegion({
    super.key,
    required this.item,
    required this.child,
    this.provider,
    this.oppositeProvider,
  });
  final CloudItem item;
  final Widget child;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? provider;
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? oppositeProvider;

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
    final l10n = context.l10n;
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
        const PopupMenuDivider(),
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

    if (!context.mounted || result == null) return;

    final currentRemote = ref.read(_provider).currentRemote ?? '';

    switch (result) {
      case 'select':
        ref.read(_provider.notifier).toggleSelection(item.path);
      case 'open_with':
        await ref.read(fileOpenerServiceProvider).openCloudItem(
              context: context,
              item: item,
              remote: ref.read(_provider).currentRemote,
              currentPath: ref.read(_provider).currentPath,
            );
      case 'copy_to_opposite':
        _handleDirectTransfer(context, ref, isMove: false);
      case 'move_to_opposite':
        _handleDirectTransfer(context, ref, isMove: true);
      case 'download':
        _handleDownload(context, ref, currentRemote);
      case 'share_link':
        _handleShareLink(context, ref, currentRemote);
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
        _handleRename(context, ref);
      case 'copy_path':
        await Clipboard.setData(ClipboardData(text: item.path));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.pathCopiedToClipboard)),
          );
        }
      case 'info':
        _showInfoDialog(context);
      case 'delete':
        _handleDelete(context, ref);
    }
  }

  void _handleDirectTransfer(
    BuildContext context,
    WidgetRef ref, {
    required bool isMove,
  }) async {
    if (oppositeProvider == null) return;
    final l10n = context.l10n;
    final srcState = ref.read(_provider);
    final dstState = ref.read(oppositeProvider!);
    final srcRemote = srcState.currentRemote ?? '';
    final dstRemote = dstState.currentRemote ?? '';
    if (srcRemote.isEmpty || dstRemote.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final actionLabel = isMove ? l10n.moveAction : l10n.copyAction;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.transferBatchStarted(actionLabel, 1, dstRemote)),
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
      await ref.read(oppositeProvider!.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorTransferring(e.toString()))),
      );
    }
  }

  void _handleDownload(BuildContext context, WidgetRef ref, String currentRemote) async {
    final l10n = context.l10n;
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
            Expanded(child: Text(l10n.downloadingSingleItem(item.name))),
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
          content: Text(l10n.downloadStartedSavedTo(job.dstPath)),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorStartingDownload(e.toString()))),
      );
    }
  }

  void _handleShareLink(BuildContext context, WidgetRef ref, String currentRemote) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final currentPath = ref.read(_provider).currentPath;
    final fullSrcPath = resolveRemoteItemPath(item.path, currentPath);

    if (currentRemote.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.noCloudSelected)),
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
            Expanded(child: Text(l10n.generatingShareLink(item.name))),
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
          SnackBar(content: Text(l10n.noLinkReturnedByProvider)),
        );
        return;
      }

      await ShareLinkDialog.show(context, item: item, link: link);
    } catch (e) {
      if (!context.mounted) return;
      final errorStr = e.toString();
      final msg = errorStr.contains("doesn't support public links") ||
              errorStr.contains('not supported')
          ? l10n.publicLinksNotSupported
          : l10n.errorCreatingShareLink(e.toString());
      messenger.showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  void _handleRename(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
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

    if (confirmed == true && controller.text.trim().isNotEmpty && controller.text != item.name) {
      try {
        await ref.read(_provider.notifier).renameItem(item, controller.text.trim());
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorRenaming(e.toString()))),
          );
        }
      }
    }
  }

  void _handleDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          item.isDir ? l10n.deleteSingleFolderTitle : l10n.deleteSingleFileTitle,
        ),
        content: Text(l10n.deleteSingleItemPrompt(item.name)),
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

    if (confirmed == true) {
      try {
        await ref.read(_provider.notifier).deleteItem(item);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorDeleting(e.toString()))),
          );
        }
      }
    }
  }

  void _showInfoDialog(BuildContext context) {
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
              Text(l10n.itemDetailsSizeWithBytes(_formatBytes(item.size), item.size)),
            ],
            if (item.modTime != null) ...[
              const SizedBox(height: 8),
              Text(l10n.itemDetailsModified(item.modTime!.toLocal().toString().split('.')[0])),
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
