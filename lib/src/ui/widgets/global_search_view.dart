import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

import '../../../l10n/l10n_extension.dart';
import '../../models/cloud_models.dart';
import '../../models/search_models.dart';
import '../../providers/clipboard_provider.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/file_opener_service.dart';
import '../../services/rclone_service.dart';
import '../theme/app_theme.dart';
import 'expandable_error_box.dart';
import 'file_type_icon.dart';

/// Displays global cross-cloud search filters, live scanning progress,
/// and matched result rows with navigation and file actions.
class GlobalSearchView extends ConsumerStatefulWidget {
  const GlobalSearchView({
    super.key,
    required this.targetProvider,
    required this.onCloseSearch,
  });

  final NotifierProvider<FileExplorerNotifier, FileExplorerState> targetProvider;
  final VoidCallback onCloseSearch;

  @override
  ConsumerState<GlobalSearchView> createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends ConsumerState<GlobalSearchView> {
  static const String _allCloudsSentinel = '__all_clouds__';
  String? _openingItemKey;

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '--';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    var d = bytes.toDouble();
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

  String _fileTypeLabel(GlobalSearchState state, AppLocalizations l10n) {
    switch (state.fileTypePreset) {
      case SearchFileTypePreset.all:
        return l10n.fileTypeAll;
      case SearchFileTypePreset.documents:
        return l10n.fileTypeDocuments;
      case SearchFileTypePreset.images:
        return l10n.fileTypeImages;
      case SearchFileTypePreset.videos:
        return l10n.fileTypeVideos;
      case SearchFileTypePreset.audio:
        return l10n.fileTypeAudio;
      case SearchFileTypePreset.archives:
        return l10n.fileTypeArchives;
      case SearchFileTypePreset.custom:
        if (state.customExtensions.isEmpty) {
          return l10n.fileTypeCustom;
        }
        return state.customExtensions.join(', ');
    }
  }

  String _sizeLabel(SearchSizePreset preset, AppLocalizations l10n) {
    switch (preset) {
      case SearchSizePreset.any:
        return l10n.sizeAny;
      case SearchSizePreset.under1Mb:
        return l10n.sizeUnder1Mb;
      case SearchSizePreset.from1To100Mb:
        return l10n.size1To100Mb;
      case SearchSizePreset.over100Mb:
        return l10n.sizeOver100Mb;
      case SearchSizePreset.over1Gb:
        return l10n.sizeOver1Gb;
    }
  }

  String _depthLabel(int maxDepth, AppLocalizations l10n) {
    if (maxDepth <= 0) return l10n.depthUnlimited;
    return l10n.depthLevel(maxDepth);
  }

  void _maybeRerunSearch(WidgetRef ref) {
    final s = ref.read(searchProvider);
    if (s.activeJobId != null ||
        s.query.trim().isNotEmpty ||
        s.effectiveExtensions.isNotEmpty ||
        s.sizePreset != SearchSizePreset.any ||
        s.maxDepth > 0) {
      unawaited(ref.read(searchProvider.notifier).startSearch());
    }
  }

  Future<void> _showCustomExtensionsDialog(
    BuildContext context,
    WidgetRef ref,
    GlobalSearchState searchState,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController(
      text: searchState.customExtensions.join(', '),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customExtensionsTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.customExtensionsHint,
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
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    controller.dispose();

    if (confirmed == true) {
      final exts = controller.text
          .split(RegExp(r'[\s,;]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => e.startsWith('.') ? e.toLowerCase() : '.${e.toLowerCase()}')
          .toList();
      if (exts.isEmpty) {
        ref
            .read(searchProvider.notifier)
            .setFileTypePreset(SearchFileTypePreset.all, customExtensions: const []);
      } else {
        ref
            .read(searchProvider.notifier)
            .setFileTypePreset(SearchFileTypePreset.custom, customExtensions: exts);
      }
      _maybeRerunSearch(ref);
    }
  }

  Future<void> _openContainingFolder(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
  ) async {
    final remote = item.remote ?? '';
    if (remote.isEmpty) return;

    final dir = p.posix.dirname(item.path);
    final parentPath = (dir == '.' || dir == '/') ? '' : dir;
    widget.onCloseSearch();
    await ref.read(widget.targetProvider.notifier).openRemote(remote, path: parentPath);
  }

  Future<void> _openItem(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
  ) async {
    final remote = item.remote ?? '';
    if (item.isDir) {
      if (remote.isEmpty) return;
      widget.onCloseSearch();
      await ref.read(widget.targetProvider.notifier).openRemote(remote, path: item.path);
      return;
    }

    final itemKey = '$remote:${item.path}';
    if (_openingItemKey != null) return;

    setState(() => _openingItemKey = itemKey);

    BuildContext? dialogContext;
    var dialogOpen = false;
    final indicatorTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted || _openingItemKey != itemKey) return;
      dialogOpen = true;
      unawaited(
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            dialogContext = ctx;
            return PopScope(
              canPop: false,
              child: AlertDialog(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        ctx.l10n.downloadingForExternalOpen(item.name),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });

    try {
      await ref.read(fileOpenerServiceProvider).openCloudItem(
            context: context,
            item: item,
            remote: remote,
            currentPath: '',
          );
    } finally {
      indicatorTimer.cancel();
      if (dialogOpen && dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!).pop();
      }
      if (mounted) {
        setState(() => _openingItemKey = null);
      }
    }
  }

  Future<void> _deleteItem(
    BuildContext context,
    WidgetRef ref,
    CloudItem item,
  ) async {
    final l10n = context.l10n;
    final remote = item.remote ?? '';
    if (remote.isEmpty) return;

    final confirmDelete = ref.read(settingsProvider).confirmDelete;
    var shouldDelete = true;
    if (confirmDelete) {
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
      shouldDelete = confirmed == true;
    }

    if (!shouldDelete) return;

    try {
      await ref
          .read(rcloneServiceProvider)
          .deleteFile(remote: remote, filePath: item.path);
      ref.read(searchProvider.notifier).removeResult(item);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.itemDeletedSuccess)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorDeleting(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchState = ref.watch(searchProvider);
    final remotes = ref.watch(cloudAccountsProvider).remotes;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final results = searchState.visibleResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter Chips Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Cloud scope selector
                PopupMenuButton<String>(
                  key: const ValueKey('global_search_cloud_filter'),
                  tooltip: l10n.selectCloud,
                  onSelected: (value) {
                    final remote = value == _allCloudsSentinel ? null : value;
                    ref.read(searchProvider.notifier).setSelectedRemote(remote);
                    _maybeRerunSearch(ref);
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: _allCloudsSentinel,
                      child: Row(
                        children: [
                          Icon(
                            searchState.selectedRemote == null
                                ? Icons.check
                                : Icons.cloud_done_outlined,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.allClouds),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    ...remotes.map(
                      (r) => PopupMenuItem(
                        value: r.name,
                        child: Row(
                          children: [
                            Icon(
                              searchState.selectedRemote == r.name
                                  ? Icons.check
                                  : (r.isCrypt
                                      ? Icons.lock_rounded
                                      : AppTheme.getProviderIcon(r.type)),
                              size: 18,
                              color: r.isCrypt
                                  ? const Color(0xFF00BFA5)
                                  : AppTheme.getProviderColor(r.type),
                            ),
                            const SizedBox(width: 8),
                            Text(r.name),
                          ],
                        ),
                      ),
                    ),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.cloud_outlined, size: 16),
                    label: Text(searchState.selectedRemote ?? l10n.allClouds),
                    backgroundColor: searchState.selectedRemote != null
                        ? colorScheme.primaryContainer
                        : null,
                  ),
                ),
                const SizedBox(width: 8),

                // File type / extension preset selector
                PopupMenuButton<SearchFileTypePreset>(
                  key: const ValueKey('global_search_type_filter'),
                  tooltip: l10n.fileTypeFilter,
                  onSelected: (preset) {
                    if (preset == SearchFileTypePreset.custom) {
                      unawaited(
                        _showCustomExtensionsDialog(context, ref, searchState),
                      );
                      return;
                    }
                    ref.read(searchProvider.notifier).setFileTypePreset(preset);
                    _maybeRerunSearch(ref);
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: SearchFileTypePreset.all,
                      child: Text(l10n.fileTypeAll),
                    ),
                    PopupMenuItem(
                      value: SearchFileTypePreset.documents,
                      child: Text(l10n.fileTypeDocuments),
                    ),
                    PopupMenuItem(
                      value: SearchFileTypePreset.images,
                      child: Text(l10n.fileTypeImages),
                    ),
                    PopupMenuItem(
                      value: SearchFileTypePreset.videos,
                      child: Text(l10n.fileTypeVideos),
                    ),
                    PopupMenuItem(
                      value: SearchFileTypePreset.audio,
                      child: Text(l10n.fileTypeAudio),
                    ),
                    PopupMenuItem(
                      value: SearchFileTypePreset.archives,
                      child: Text(l10n.fileTypeArchives),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: SearchFileTypePreset.custom,
                      child: Text(l10n.fileTypeCustom),
                    ),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.category_outlined, size: 16),
                    label: Text(_fileTypeLabel(searchState, l10n)),
                    backgroundColor:
                        searchState.fileTypePreset != SearchFileTypePreset.all
                            ? colorScheme.primaryContainer
                            : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Size filter selector
                PopupMenuButton<SearchSizePreset>(
                  key: const ValueKey('global_search_size_filter'),
                  tooltip: l10n.sizeFilter,
                  onSelected: (preset) {
                    ref.read(searchProvider.notifier).setSizePreset(preset);
                    _maybeRerunSearch(ref);
                  },
                  itemBuilder: (ctx) => SearchSizePreset.values
                      .map(
                        (preset) => PopupMenuItem(
                          value: preset,
                          child: Text(_sizeLabel(preset, l10n)),
                        ),
                      )
                      .toList(),
                  child: Chip(
                    avatar: const Icon(Icons.straighten_outlined, size: 16),
                    label: Text(_sizeLabel(searchState.sizePreset, l10n)),
                    backgroundColor: searchState.sizePreset != SearchSizePreset.any
                        ? colorScheme.primaryContainer
                        : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Max depth selector
                PopupMenuButton<int>(
                  key: const ValueKey('global_search_depth_filter'),
                  tooltip: l10n.depthFilter,
                  onSelected: (depth) {
                    ref.read(searchProvider.notifier).setMaxDepth(depth);
                    _maybeRerunSearch(ref);
                  },
                  itemBuilder: (ctx) => [0, 1, 2, 3, 5]
                      .map(
                        (d) => PopupMenuItem(
                          value: d,
                          child: Text(_depthLabel(d, l10n)),
                        ),
                      )
                      .toList(),
                  child: Chip(
                    avatar: const Icon(Icons.account_tree_outlined, size: 16),
                    label: Text(_depthLabel(searchState.maxDepth, l10n)),
                    backgroundColor: searchState.maxDepth > 0
                        ? colorScheme.primaryContainer
                        : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Include folders toggle chip
                FilterChip(
                  key: const ValueKey('global_search_include_dirs_chip'),
                  label: Text(l10n.includeFoldersChip),
                  selected: searchState.includeDirs,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).setIncludeDirs(selected);
                    _maybeRerunSearch(ref);
                  },
                ),
              ],
            ),
          ),
        ),

        // Live scanning progress bar + Stop button
        if (searchState.isSearching) ...[
          const LinearProgressIndicator(minHeight: 3),
          Container(
            color: colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    searchState.currentRemote.isNotEmpty
                        ? l10n.scanningProgress(
                            searchState.currentRemote,
                            searchState.scannedFiles,
                            searchState.scannedDirs,
                          )
                        : l10n.scanningAllProgress(
                            searchState.scannedFiles,
                            searchState.scannedDirs,
                          ),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  key: const ValueKey('global_search_stop_button'),
                  onPressed: () =>
                      ref.read(searchProvider.notifier).stopSearch(),
                  icon: const Icon(Icons.stop_circle_outlined, size: 16),
                  label: Text(l10n.stopSearch),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ] else if (searchState.activeJobId != null &&
            searchState.status != SearchStatus.failed) ...[
          Container(
            color: colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.searchResultsSummary(
                      results.length,
                      searchState.scannedFiles,
                      searchState.scannedDirs,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (searchState.status == SearchStatus.cancelled) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      l10n.searchCancelledLabel,
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),
        ],

        if (searchState.truncated)
          MaterialBanner(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            backgroundColor: colorScheme.secondaryContainer.withValues(alpha: 0.45),
            leading: Icon(
              Icons.info_outline,
              size: 18,
              color: colorScheme.onSecondaryContainer,
            ),
            content: Text(
              l10n.searchTruncatedNotice(searchState.results.length),
              style: const TextStyle(fontSize: 12),
            ),
            actions: const [SizedBox.shrink()],
          ),

        if (searchState.warnings.isNotEmpty)
          ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            dense: true,
            leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
            title: Text(
              l10n.searchWarningsTitle(searchState.warnings.length),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            children: searchState.warnings
                .map(
                  (w) => ListTile(
                    dense: true,
                    title: Text(w, style: const TextStyle(fontSize: 12)),
                  ),
                )
                .toList(),
          ),

        // Main Results Area
        Expanded(
          child: _buildResultsBody(context, ref, searchState, results, remotes),
        ),
      ],
    );
  }

  Widget _buildResultsBody(
    BuildContext context,
    WidgetRef ref,
    GlobalSearchState searchState,
    List<CloudItem> results,
    List<CloudRemote> remotes,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    if (searchState.status == SearchStatus.failed &&
        searchState.error != null &&
        results.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpandableErrorBox(error: searchState.error!),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(searchProvider.notifier).startSearch(),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (searchState.activeJobId == null && !searchState.isSearching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.manage_search_rounded,
                size: 56,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.globalSearchEmptyPrompt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (results.isEmpty && !searchState.isSearching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 52,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.globalSearchNoResults,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = results[index];
        final remoteName = item.remote ?? '';
        final remoteObj = remotes.where((r) => r.name == remoteName).firstOrNull;
        final badgeColor = remoteObj != null
            ? AppTheme.getProviderColor(remoteObj.type)
            : colorScheme.primary;
        final isCrypt = remoteObj?.isCrypt ?? false;

        return ListTile(
          leading: FileTypeIcon(
            fileName: item.name,
            isDir: item.isDir,
            size: 28,
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: item.isDir ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Row(
                children: [
                  if (remoteName.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCrypt) ...[
                            const Icon(
                              Icons.lock_rounded,
                              size: 10,
                              color: Color(0xFF00BFA5),
                            ),
                            const SizedBox(width: 3),
                          ],
                          Text(
                            remoteName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      item.path,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${item.isDir ? l10n.folder : _formatBytes(item.size)} • ${_formatDate(item.modTime)}',
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_openingItemKey == '$remoteName:${item.path}')
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.folder_open_outlined, size: 20),
                  tooltip: l10n.openContainingFolder,
                  onPressed: remoteName.isEmpty
                      ? null
                      : () => _openContainingFolder(context, ref, item),
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                tooltip: l10n.optionsForItem(item.name),
                onSelected: (action) {
                  switch (action) {
                    case 'open_folder':
                      unawaited(_openContainingFolder(context, ref, item));
                    case 'open':
                      unawaited(_openItem(context, ref, item));
                    case 'copy':
                      if (remoteName.isNotEmpty) {
                        ref.read(clipboardProvider.notifier).copy(item, remoteName);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.itemCopiedToClipboard(item.name)),
                          ),
                        );
                      }
                    case 'cut':
                      if (remoteName.isNotEmpty) {
                        ref.read(clipboardProvider.notifier).cut(item, remoteName);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.itemCutToClipboard(item.name)),
                          ),
                        );
                      }
                    case 'delete':
                      unawaited(_deleteItem(context, ref, item));
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'open_folder',
                    enabled: remoteName.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.folder_open_outlined),
                      title: Text(l10n.openContainingFolder),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open',
                    child: ListTile(
                      leading: const Icon(Icons.open_in_new_rounded),
                      title: Text(l10n.openAction),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'copy',
                    enabled: remoteName.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.copy_rounded),
                      title: Text(l10n.copy),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'cut',
                    enabled: remoteName.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.cut_rounded),
                      title: Text(l10n.cut),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    enabled: remoteName.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.delete_outline, color: Colors.red),
                      title: Text(
                        l10n.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => _openItem(context, ref, item),
        );
      },
    );
  }
}
