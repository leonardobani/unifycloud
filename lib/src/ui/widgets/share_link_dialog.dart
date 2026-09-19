import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cloud_models.dart';

/// A Material 3 dialog displaying a generated public shareable link for a file or folder.
class ShareLinkDialog extends StatelessWidget {
  final CloudItem item;
  final String link;

  const ShareLinkDialog({
    super.key,
    required this.item,
    required this.link,
  });

  /// Displays the [ShareLinkDialog].
  static Future<void> show(
    BuildContext context, {
    required CloudItem item,
    required String link,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ShareLinkDialog(item: item, link: link),
    );
  }

  void _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copiato negli appunti!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _openInBrowser(BuildContext context) async {
    try {
      final uri = Uri.parse(link);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossibile aprire il browser: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.link_rounded, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Link Condivisibile'),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  item.isDir ? Icons.folder_rounded : Icons.insert_drive_file_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Chiunque abbia questo link potrà accedere a ${item.isDir ? "questa cartella" : "questo file"}:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: link,
              readOnly: true,
              maxLines: 2,
              minLines: 1,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.public, size: 20),
                suffixIcon: IconButton(
                  tooltip: 'Copia link',
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  onPressed: () => _copyToClipboard(context),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Chiudi'),
        ),
        OutlinedButton.icon(
          onPressed: () => _openInBrowser(context),
          icon: const Icon(Icons.open_in_browser_rounded, size: 18),
          label: const Text('Apri'),
        ),
        FilledButton.icon(
          onPressed: () {
            _copyToClipboard(context);
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Copia Link'),
        ),
      ],
    );
  }
}
