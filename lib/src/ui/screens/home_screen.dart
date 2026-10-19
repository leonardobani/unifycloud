import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/cloud_models.dart';
import '../../models/sync_rule_model.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/sync_provider.dart';
import '../../../l10n/l10n_extension.dart';
import '../theme/app_theme.dart';
import '../theme/cosmic_icons.dart';
import '../widgets/add_cloud_dialog.dart';
import '../widgets/expandable_error_box.dart';

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
            const CosmicSvgIcon(CosmicIcons.cloudSyncSvg, color: AppTheme.primaryColor, size: 28),
            const SizedBox(width: 8),
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
            icon: const CosmicSvgIcon(CosmicIcons.refreshSvg, size: 20),
            tooltip: l10n.refreshCloudsTooltip,
            onPressed: () {
              ref.read(cloudAccountsProvider.notifier).loadRemotes();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(cloudAccountsProvider.notifier).loadRemotes(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Storage Overview Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CosmicSvgIcon(CosmicIcons.diskUsageSvg, color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.storageOverviewAggregated,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Chip(
                          avatar: const CosmicSvgIcon(CosmicIcons.shieldSvg, size: 16, color: Colors.green),
                          label: Text(l10n.ramEncryptionActive, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.green.withValues(alpha: 0.1),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
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
                          value: null,
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

            // Sync & Backup Overview Card
            Builder(
              builder: (context) {
                final syncRules = ref.watch(syncProvider);
                final enabledCount = syncRules.where((r) => r.isEnabled).length;
                final isSyncing = syncRules.any((r) => r.lastStatus == SyncStatus.inProgress);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: CosmicSvgIcon(
                            CosmicIcons.syncSvg,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.syncAndBackup,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                syncRules.isEmpty
                                    ? l10n.noRulesConfigured
                                    : '${l10n.activeRulesCount(enabledCount, syncRules.length)}${isSyncing ? ' • ${l10n.syncInProgress}' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          icon: const CosmicSvgIcon(CosmicIcons.chevronRightSvg, size: 16),
                          label: Text(l10n.manage),
                          onPressed: () => context.go('/sync'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
                    showDialog(
                      context: context,
                      builder: (ctx) => const AddCloudDialog(),
                    );
                  },
                  icon: const CosmicSvgIcon(CosmicIcons.addSvg, size: 18),
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
                      CosmicSvgIcon(
                        CosmicIcons.cloudSvg,
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
                          showDialog(
                            context: context,
                            builder: (ctx) => const AddCloudDialog(),
                          );
                        },
                        icon: const CosmicSvgIcon(CosmicIcons.addSvg, size: 18),
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
                                  CircleAvatar(
                                    backgroundColor: color.withValues(alpha: 0.15),
                                    child: CosmicSvgIcon(
                                      AppTheme.getProviderSvg(remote.type),
                                      color: color,
                                      size: 22,
                                    ),
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
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    CosmicSvgIcon(
                                                      CosmicIcons.lockSvg,
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
                                    icon: const CosmicSvgIcon(CosmicIcons.moreVertSvg, size: 20),
                                    onSelected: (action) async {
                                      if (action == 'create_vault') {
                                        showDialog(
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
                                          ref
                                              .read(cloudAccountsProvider.notifier)
                                              .deleteRemote(remote.name);
                                        }
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      if (!remote.isCrypt)
                                        PopupMenuItem(
                                          value: 'create_vault',
                                          child: ListTile(
                                            leading: const CosmicSvgIcon(CosmicIcons.lockSvg, color: Color(0xFF00BFA5), size: 18),
                                            title: Text(l10n.createVaultHere),
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: ListTile(
                                          leading: const CosmicSvgIcon(CosmicIcons.deleteSvg, color: Colors.red, size: 18),
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
                                  icon: const CosmicSvgIcon(CosmicIcons.folderOpenSvg, size: 18),
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
      ),
    );
  }
}
