import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

import '../../../l10n/l10n_extension.dart';
import '../../models/cloud_models.dart';
import '../../models/favorite_item.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/search_provider.dart';
import '../../services/file_opener_service.dart';
import '../theme/app_theme.dart';
import '../widgets/add_cloud_dialog.dart';
import '../widgets/expandable_error_box.dart';
import '../widgets/file_type_icon.dart';
import '../widgets/unify_cloud_logo.dart';

/// Home screen showing the aggregated storage overview and list of connected cloud providers.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(cloudAccountsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const UnifyCloudLogo(size: 30),
            const SizedBox(width: 10),
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const ValueKey('home_global_search_button'),
            icon: const Icon(Icons.search),
            tooltip: l10n.globalSearch,
            onPressed: () {
              ref.read(searchProvider.notifier).requestOpenGlobalSearch();
              context.go('/explorer');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshCloudsTooltip,
            onPressed: () {
              ref.read(cloudAccountsProvider.notifier).loadRemotes();
            },
          ),
          IconButton(
            key: const ValueKey('home_settings_button'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Storage Overview Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pie_chart_outline, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.storageOverviewAggregated,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (state.remotes.isEmpty) ...[
                      Text(
                        l10n.connectedAccountsCount(0),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: 0.0,
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noCloudsConfiguredHint,
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                      ),
                    ] else if (state.hasStorageData) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.connectedAccountsCount(state.remotes.length),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${StorageQuota.formatBytes(state.usedStorageBytes)} / ${StorageQuota.formatBytes(state.totalStorageBytes)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: state.usedStoragePercentage,
                          minHeight: 10,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                            state.usedStoragePercentage > 0.9 ? Colors.orange : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.percentUsed((state.usedStoragePercentage * 100).toStringAsFixed(1)),
                              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.availableSpace(StorageQuota.formatBytes(state.freeStorageBytes)),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF69F0AE) : const Color(0xFF1B5E20),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        l10n.connectedAccountsCount(state.remotes.length),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.calculatingQuota,
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pinned Favorites Slim Card
            _PinnedFavoritesCard(remotes: state.remotes, isLoadingRemotes: state.isLoading),
            const SizedBox(height: 20),

            // Header for Connected Clouds
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  l10n.connectedCloudsCount(state.remotes.length),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => const AddCloudDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.connectNewCloud),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ExpandableErrorBox(
                    error: state.error!,
                  ),
                ),
              )
            else if (state.remotes.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 64,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noCloudProvidersConnected,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.connectCloudDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => const AddCloudDialog(),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addFirstCloud),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Grid of configured remotes
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 225,
                    ),
                    itemCount: state.remotes.length,
                    itemBuilder: (context, index) {
                      final remote = state.remotes[index];
                      final color = AppTheme.getProviderColor(remote.type);
                      final icon = AppTheme.getProviderIcon(remote.type);
                      final quota = remote.quota;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(icon, color: color, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                remote.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (remote.isCrypt) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF00BFA5)
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: const Color(0xFF00BFA5)
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.lock,
                                                      size: 10,
                                                      color: Color(0xFF00BFA5),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      'E2E',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF00BFA5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          remote.isCrypt && remote.remote != null
                                              ? l10n.vaultOnRemote(remote.remote!.toUpperCase())
                                              : remote.type.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    onSelected: (action) async {
                                      if (action == 'create_vault') {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (ctx) => AddCloudDialog(
                                            initialProvider: 'crypt',
                                            initialTargetRemote: remote.name,
                                          ),
                                        );
                                      } else if (action == 'delete') {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text(l10n.disconnectCloudTitle),
                                            content: Text(
                                              l10n.disconnectCloudPrompt(remote.name),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: Text(l10n.cancel),
                                              ),
                                              FilledButton(
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                child: Text(l10n.disconnect),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await ref
                                              .read(cloudAccountsProvider.notifier)
                                              .deleteRemote(remote.name);
                                          await ref
                                              .read(favoritesProvider.notifier)
                                              .removeByRemote(remote.name);
                                        }
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      if (!remote.isCrypt)
                                        PopupMenuItem(
                                          value: 'create_vault',
                                          child: ListTile(
                                            leading: const Icon(Icons.lock_outline, color: Color(0xFF00BFA5)),
                                            title: Text(l10n.createVaultHere),
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: ListTile(
                                          leading: const Icon(Icons.delete_outline, color: Colors.red),
                                          title: Text(l10n.disconnect, style: const TextStyle(color: Colors.red)),
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   if (quota != null && quota.hasData) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${StorageQuota.formatBytes(quota.effectiveUsed)} / ${StorageQuota.formatBytes(quota.effectiveTotal)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.freeSpace(StorageQuota.formatBytes(quota.effectiveFree)),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: quota.usedPercentage,
                                        minHeight: 6,
                                        backgroundColor: colorScheme.surfaceContainerHighest,
                                        valueColor: AlwaysStoppedAnimation(
                                          quota.usedPercentage > 0.9 ? Colors.orange : color,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.storage,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.available,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: 0.0,
                                        minHeight: 6,
                                        backgroundColor: colorScheme.surfaceContainerHighest,
                                        valueColor: AlwaysStoppedAnimation(color),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    ref
                                        .read(fileExplorerProvider.notifier)
                                        .openRemote(remote.name);
                                    context.go('/explorer');
                                  },
                                  icon: const Icon(Icons.folder_open, size: 18),
                                  label: Text(l10n.exploreFiles),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
    );
  }
}

/// Slim card displaying pinned favorite files and folders with small icons and text.
class _PinnedFavoritesCard extends ConsumerWidget {
  const _PinnedFavoritesCard({
    required this.remotes,
    required this.isLoadingRemotes,
  });

  final List<CloudRemote> remotes;
  final bool isLoadingRemotes;

  void _openInExplorer(BuildContext context, WidgetRef ref, FavoriteItem fav) {
    final targetPath = fav.isDir
        ? fav.path
        : (() {
            final dir = p.posix.dirname(fav.path);
            return (dir == '.' || dir == '/') ? '' : dir;
          })();
    ref.read(fileExplorerProvider.notifier).openRemote(fav.remote, path: targetPath);
    context.go('/explorer');
  }

  void _handleTap(BuildContext context, WidgetRef ref, FavoriteItem fav) {
    final l10n = context.l10n;
    final remoteExists = remotes.any((r) => r.name == fav.remote);
    if (!isLoadingRemotes && !remoteExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.remoteNotConnected(fav.remote))),
      );
      return;
    }

    if (fav.isDir) {
      _openInExplorer(context, ref, fav);
    } else {
      ref.read(fileOpenerServiceProvider).openCloudItem(
            context: context,
            item: fav.toCloudItem(),
            remote: fav.remote,
            currentPath: '',
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final favorites = ref.watch(favoritesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.push_pin_outlined,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.pinnedFavorites,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (favorites.isEmpty)
              Text(
                l10n.noPinnedFavoritesHint,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                children: [
                  for (var i = 0; i < favorites.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _FavoriteRow(
                      item: favorites[i],
                      onTap: () => _handleTap(context, ref, favorites[i]),
                      onLongPress: () => _openInExplorer(context, ref, favorites[i]),
                      onUnpin: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .removeFavorite(favorites[i].remote, favorites[i].path);
                      },
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow({
    required this.item,
    required this.onTap,
    required this.onLongPress,
    required this.onUnpin,
  });

  final FavoriteItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onUnpin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            FileTypeIcon(
              fileName: item.name,
              isDir: item.isDir,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.remote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 15,
                color: colorScheme.onSurfaceVariant,
              ),
              tooltip: l10n.unpinFromHome,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              onPressed: onUnpin,
            ),
          ],
        ),
      ),
    );
  }
}
