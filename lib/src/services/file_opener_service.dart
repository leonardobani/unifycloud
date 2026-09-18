import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cloud_models.dart';
import '../providers/cloud_accounts_provider.dart';
import '../providers/file_explorer_provider.dart';
import 'rclone_service.dart';

/// Riverpod provider for [FileOpenerService].
final fileOpenerServiceProvider = Provider<FileOpenerService>((ref) {
  return FileOpenerService(
    rcloneService: ref.watch(rcloneServiceProvider),
    ref: ref,
  );
});

/// Resolves the canonical remote path for a file item given the current directory path.
///
/// Ensures no redundant leading slashes, and avoids duplicating folder prefixes
/// (e.g. currentPath="/Photos" and item.path="Photos/img.png" remains "Photos/img.png").
String resolveRemoteItemPath(String itemPath, [String? currentPath]) {
  final cleanItem = itemPath.replaceAll(RegExp(r'^/+'), '');
  if (currentPath == null || currentPath.trim().isEmpty) {
    return cleanItem;
  }
  final cleanCurrent =
      currentPath.replaceAll(RegExp(r'^/+'), '').replaceAll(RegExp(r'/+$'), '');
  if (cleanCurrent.isEmpty) {
    return cleanItem;
  }
  if (cleanItem.startsWith('$cleanCurrent/') || cleanItem == cleanCurrent) {
    return cleanItem;
  }
  return '$cleanCurrent/$cleanItem';
}

/// Service responsible for downloading files to a local preview cache and opening them
/// using the host platform's default application.
class FileOpenerService {
  final RcloneService rcloneService;
  final Ref? ref;
  final Future<Directory> Function() _getTempDir;
  final Future<OpenResult> Function(String filePath) _openFile;

  FileOpenerService({
    required this.rcloneService,
    this.ref,
    Future<Directory> Function()? getTempDir,
    Future<OpenResult> Function(String filePath)? openFile,
  })  : _getTempDir = getTempDir ?? getTemporaryDirectory,
        _openFile = openFile ?? openSystemFile;

  /// Opens a file with the system default application across platforms.
  ///
  /// On Linux:
  /// 1. Tries `launchUrl(Uri.file(filePath))` (GTK / GIO / Freedesktop Portal via url_launcher).
  /// 2. Tries direct system process openers (`/usr/bin/gio open`, `/usr/bin/xdg-open`, `gio open`, `xdg-open`),
  ///    prioritizing `/usr/bin` to bypass broken container wrappers.
  /// 3. Falls back to [OpenFilex.open].
  ///
  /// On other platforms (Android, iOS, macOS, Windows):
  /// Uses [OpenFilex.open] to trigger the platform's native intent / controller / handler.
  static Future<OpenResult> openSystemFile(String filePath) async {
    if (Platform.isLinux) {
      // 1. Try url_launcher (native GTK/GIO/Portal)
      try {
        final fileUri = Uri.file(filePath);
        final launched = await launchUrl(
          fileUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          return OpenResult(type: ResultType.done, message: 'done');
        }
      } catch (_) {}

      // 2. Direct process execution prioritizing /usr/bin to avoid broken container wrappers
      final candidates = [
        ('/usr/bin/gio', ['open', filePath]),
        ('/usr/bin/xdg-open', [filePath]),
        ('gio', ['open', filePath]),
        ('xdg-open', [filePath]),
      ];

      for (final candidate in candidates) {
        final binary = candidate.$1;
        final args = candidate.$2;
        try {
          final process = await Process.start(binary, args);
          final exitCode = await process.exitCode.timeout(
            const Duration(milliseconds: 1500),
            onTimeout: () => 0, // App launched and running in foreground
          );
          if (exitCode == 0) {
            return OpenResult(type: ResultType.done, message: 'done');
          }
        } catch (_) {}
      }
    }

    try {
      return await OpenFilex.open(filePath);
    } catch (e) {
      return OpenResult(type: ResultType.error, message: e.toString());
    }
  }

  /// Returns the target cached file in the temporary directory for a given remote and item.
  Future<File> getCachedFile({
    required String remote,
    required CloudItem item,
  }) async {
    final tempDir = await _getTempDir();
    final sanitizedRemote = remote.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final previewDir = Directory(p.join(tempDir.path, 'unifycloud_previews', sanitizedRemote));
    if (!previewDir.existsSync()) {
      previewDir.createSync(recursive: true);
    }
    return File(p.join(previewDir.path, item.name));
  }

  bool _isLocalRemote(String remote) {
    final trimmed = remote.trim();
    if (trimmed.isEmpty ||
        trimmed.toLowerCase() == 'local' ||
        trimmed.toLowerCase() == 'discolocale' ||
        trimmed.toLowerCase() == 'disco locale') {
      return true;
    }
    if (ref != null) {
      try {
        final remotes = ref!.read(cloudAccountsProvider).remotes;
        final match = remotes.where((r) => r.name == trimmed).firstOrNull;
        if (match != null && match.type.toLowerCase() == 'local') {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  void _handleOpenResult(BuildContext? context, CloudItem item, OpenResult result) {
    if (context == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    switch (result.type) {
      case ResultType.done:
        break;
      case ResultType.noAppToOpen:
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Nessuna applicazione installata per aprire "${item.name}".',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        break;
      case ResultType.permissionDenied:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Permesso negato per aprire il file con l\'app di sistema.'),
          ),
        );
        break;
      case ResultType.fileNotFound:
      case ResultType.error:
        final rawMsg = result.message;
        final displayMsg = (rawMsg.contains('there are some errors') || rawMsg.isEmpty)
            ? 'Nessuna applicazione predefinita trovata per aprire questo file.'
            : rawMsg;
        messenger.showSnackBar(
          SnackBar(
            content: Text('Impossibile aprire il file: $displayMsg'),
          ),
        );
        break;
    }
  }

  /// Opens [item] using the system's preferred app.
  /// If the item is already on local disk, it opens it directly without copying.
  /// If the item is on a remote cloud, it downloads it to the temporary preview cache first.
  Future<void> openCloudItem({
    BuildContext? context,
    required CloudItem item,
    String? remote,
    String? currentPath,
  }) async {
    if (item.isDir) return;

    final effectiveRemote = remote ?? ref?.read(fileExplorerProvider).currentRemote ?? '';

    // 1. Check if item exists directly on local disk
    String? localPath;
    if (File(item.path).existsSync()) {
      localPath = item.path;
    } else if (Platform.isLinux || Platform.isMacOS) {
      if (File('/${item.path}').existsSync()) {
        localPath = '/${item.path}';
      }
    }

    final isLocal = _isLocalRemote(effectiveRemote);

    // If local remote and path is relative, check if it's relative to currentPath
    if (localPath == null && isLocal) {
      final activePath = currentPath ?? ref?.read(fileExplorerProvider).currentPath ?? '';
      if (activePath.isNotEmpty) {
        final combined = p.join(activePath, item.name);
        if (File(combined).existsSync()) {
          localPath = combined;
        } else {
          final combinedFullPath = p.join(activePath, item.path);
          if (File(combinedFullPath).existsSync()) {
            localPath = combinedFullPath;
          }
        }
      }
    }

    // If found on local disk, open directly without copying or downloading
    if (localPath != null) {
      final result = await _openFile(localPath);
      if (context != null && context.mounted) {
        _handleOpenResult(context, item, result);
      }
      return;
    }

    if (effectiveRemote.isEmpty) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nessun cloud selezionato.')),
        );
      }
      return;
    }

    final activePath = currentPath ?? ref?.read(fileExplorerProvider).currentPath ?? '';
    final fullSrcPath = resolveRemoteItemPath(item.path, activePath);

    try {
      final cachedFile = await getCachedFile(remote: effectiveRemote, item: item);

      // Check if file is already cached with identical size
      final isCached = cachedFile.existsSync() && cachedFile.lengthSync() == item.size;

      if (!isCached) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Download di "${item.name}" per apertura esterna...'),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        await rcloneService.copyFile(
          srcRemote: effectiveRemote,
          srcPath: fullSrcPath,
          dstRemote: '',
          dstPath: cachedFile.path,
        );
      }

      // Open with system application
      final result = await _openFile(cachedFile.path);
      if (context != null && context.mounted) {
        _handleOpenResult(context, item, result);
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante l\'apertura del file: $e'),
          ),
        );
      }
    }
  }
}
