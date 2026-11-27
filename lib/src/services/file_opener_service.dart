import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/l10n_extension.dart';
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
  final cleanItem = itemPath.replaceAll(RegExp('^/+'), '');
  if (currentPath == null || currentPath.trim().isEmpty) {
    return cleanItem;
  }
  final cleanCurrent =
      currentPath.replaceAll(RegExp('^/+'), '').replaceAll(RegExp(r'/+$'), '');
  if (cleanCurrent.isEmpty) {
    return cleanItem;
  }
  if (cleanItem.startsWith('$cleanCurrent/') || cleanItem == cleanCurrent) {
    return cleanItem;
  }
  return '$cleanCurrent/$cleanItem';
}

/// Extracts a safe single filename from a remote path or item name, preventing
/// path traversal (`../`), null bytes, or directory escape.
String sanitizeLocalFileName(String rawName, {String fallback = 'file'}) {
  final normalized = rawName.replaceAll('\x00', '').replaceAll(r'\', '/');
  final stripped = normalized.replaceAll(RegExp(r'/+$'), '');
  final base = p.posix.basename(stripped).trim();
  if (base.isEmpty || base == '.' || base == '..') {
    return fallback;
  }
  return base;
}

/// Service responsible for downloading files to a local preview cache and opening them
/// using the host platform's default application.
class FileOpenerService {

  FileOpenerService({
    required this.rcloneService,
    this.ref,
    Future<Directory> Function()? getTempDir,
    Future<OpenResult> Function(String filePath)? openFile,
  })  : _getTempDir = getTempDir ?? _defaultCacheDir,
        _openFile = openFile ?? openSystemFile;
  final RcloneService rcloneService;
  final Ref? ref;
  final Future<Directory> Function() _getTempDir;
  final Future<OpenResult> Function(String filePath) _openFile;

  static Future<Directory> _defaultCacheDir() async {
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '';
      if (home.isNotEmpty && Directory(home).existsSync()) {
        final cacheDir = Directory(p.join(home, '.cache'));
        if (cacheDir.existsSync()) {
          return cacheDir;
        }
      }
    }
    return getTemporaryDirectory();
  }

  /// Checks whether a [CloudItem] is a PDF file based on its name or mimeType.
  static bool isPdf(CloudItem item) {
    final name = item.name.toLowerCase();
    final ext = p.extension(name).toLowerCase();
    return ext == '.pdf' ||
        name.endsWith('.pdf') ||
        item.mimeType?.toLowerCase() == 'application/pdf';
  }

  static Future<bool> _tryLaunchProcess(String executable, List<String> arguments) async {
    try {
      final process = await Process.start(executable, arguments);
      final exitCode = await process.exitCode.timeout(
        const Duration(milliseconds: 700),
        onTimeout: () => 0, // Process stayed running (GUI application launched)
      );
      return exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Opens a file with the system default application across platforms.
  ///
  /// On Linux:
  /// 1. Tries desktop launchers (`/usr/local/bin/xdg-open`, `/usr/bin/distrobox-host-exec xdg-open`,
  ///    `/usr/bin/gio open`, `gio open`, `xdg-open`).
  /// 2. Tries `launchUrl(Uri.file(filePath))` (GTK / Portal via url_launcher).
  /// 3. For PDF files (or when desktop has no default registered PDF handler), automatically
  ///    falls back to installed system web browsers or standalone viewers (Chrome, Chromium,
  ///    Firefox, Brave, Edge, Evince, Okular, etc., natively and via host-spawn).
  /// 4. Falls back to [OpenFilex.open].
  ///
  /// On other platforms (Android, iOS, macOS, Windows):
  /// Uses [OpenFilex.open] to trigger the platform's native intent / controller / handler.
  static Future<OpenResult> openSystemFile(String filePath) async {
    if (Platform.isLinux) {
      final safePath = p.canonicalize(filePath);
      final isPdfFile = safePath.toLowerCase().endsWith('.pdf');

      // 1. Desktop launchers
      final desktopLaunchers = [
        ('/usr/local/bin/xdg-open', [safePath]),
        ('/usr/bin/distrobox-host-exec', ['xdg-open', safePath]),
        ('/usr/bin/gio', ['open', safePath]),
        ('gio', ['open', safePath]),
        ('/usr/bin/xdg-open', [safePath]),
        ('xdg-open', [safePath]),
      ];

      for (final launcher in desktopLaunchers) {
        if (await _tryLaunchProcess(launcher.$1, launcher.$2)) {
          return OpenResult();
        }
      }

      // 2. Try url_launcher (Portal / GTK)
      try {
        final fileUri = Uri.file(safePath);
        final launched = await launchUrl(
          fileUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          return OpenResult();
        }
      } catch (_) {}

      // 3. For PDF files: fallback to dedicated viewers and web browsers
      // (web browsers have built-in high performance PDF viewers)
      if (isPdfFile) {
        final pdfViewers = [
          'evince',
          'okular',
          'firefox',
          'google-chrome',
          'google-chrome-stable',
          'chromium',
          'chromium-browser',
          'brave-browser',
          'brave',
          'microsoft-edge',
          'microsoft-edge-stable',
          'zathura',
          'qpdfview',
          'atril',
          'xreader',
        ];

        for (final viewer in pdfViewers) {
          if (await _tryLaunchProcess(viewer, [safePath])) {
            return OpenResult();
          }
          if (await _tryLaunchProcess('/usr/bin/distrobox-host-exec', [viewer, safePath])) {
            return OpenResult();
          }
        }

        // Also try flatpak browsers/viewers on host
        final flatpaks = [
          ['flatpak', 'run', 'org.mozilla.firefox', safePath],
          ['flatpak', 'run', 'org.gnome.Evince', safePath],
          ['flatpak', 'run', 'com.google.Chrome', safePath],
          ['flatpak', 'run', 'org.kde.okular', safePath],
        ];
        for (final fp in flatpaks) {
          if (await _tryLaunchProcess('/usr/bin/distrobox-host-exec', fp)) {
            return OpenResult();
          }
        }
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
    final sanitizedRemote = remote.replaceAll(RegExp('[^a-zA-Z0-9_-]'), '_');
    final previewDir = Directory(p.join(tempDir.path, 'unifycloud_previews', sanitizedRemote));
    if (!previewDir.existsSync()) {
      previewDir.createSync(recursive: true);
    }
    final safeName = sanitizeLocalFileName(item.name, fallback: 'preview_file');
    final candidatePath = p.normalize(p.join(previewDir.path, safeName));
    if (!p.isWithin(previewDir.path, candidatePath)) {
      throw ArgumentError('Invalid file name for preview cache: ${item.name}');
    }
    return File(candidatePath);
  }

  bool _isLocalRemote(String remote) {
    final trimmed = remote.trim();
    if (trimmed.isEmpty ||
        trimmed.toLowerCase() == 'local' ||
        trimmed.toLowerCase() == 'localdisk' ||
        trimmed.toLowerCase() == 'local disk' ||
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

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    switch (result.type) {
      case ResultType.done:
        break;
      case ResultType.noAppToOpen:
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.noAppToOpenFile(item.name),
            ),
          ),
        );
      case ResultType.permissionDenied:
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.permissionDeniedOpenFile),
          ),
        );
      case ResultType.fileNotFound:
      case ResultType.error:
        final rawMsg = result.message;
        final displayMsg = (rawMsg.contains('there are some errors') || rawMsg.isEmpty)
            ? l10n.noDefaultAppFound
            : rawMsg;
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.unableToOpenFile(displayMsg)),
          ),
        );
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
    bool isQuickPeek = false,
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
          SnackBar(content: Text(context.l10n.noCloudSelected)),
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
                    child: Text(
                      context.l10n.downloadingForExternalOpen(item.name),
                    ),
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
            content: Text(context.l10n.errorOpeningFile(e.toString())),
          ),
        );
      }
    }
  }
}
