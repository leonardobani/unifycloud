import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/cloud_models.dart';
import '../../models/sync_rule_model.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/file_explorer_provider.dart';
import '../../providers/sync_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_cloud_dialog.dart';
import '../widgets/expandable_error_box.dart';

/// Home screen showing the aggregated storage overview and list of connected cloud providers.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cloudAccountsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.cloud_sync, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              'UnifyCloud',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aggiorna cloud configurati',
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
                            const Icon(Icons.pie_chart_outline, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Panoramica Storage Aggregato',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Chip(
                          avatar: const Icon(Icons.shield_outlined, size: 16, color: Colors.green),
                          label: const Text('Cifratura RAM Attiva', style: TextStyle(fontSize: 12)),
                          backgroundColor: Colors.green.withValues(alpha: 0.1),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (state.remotes.isEmpty) ...[
                      const Text(
                        'Account Cloud Collegati: 0',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                        'Nessun account cloud configurato. Tocca "+ Collega Nuovo Cloud" in basso.',
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                      ),
                    ] else if (state.hasStorageData) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Account Cloud Collegati: ${state.remotes.length}',
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
                              '${(state.usedStoragePercentage * 100).toStringAsFixed(1)}% occupato',
                              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${StorageQuota.formatBytes(state.freeStorageBytes)} disponibili',
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
                        'Account Cloud Collegati: ${state.remotes.length}',
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
                        'Calcolo quote storage in corso o spazio illimitato...',
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
                          child: Icon(
                            Icons.sync,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sincronizzazione & Backup',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                syncRules.isEmpty
                                    ? 'Nessuna regola configurata'
                                    : '$enabledCount/${syncRules.length} regole attive${isSyncing ? ' • Sincronizzazione in corso...' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Gestisci'),
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
                  'Cloud Collegati (${state.remotes.length})',
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
                  icon: const Icon(Icons.add),
                  label: const Text('Collega Nuovo Cloud'),
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
                      const Text(
                        'Nessun Provider Cloud Collegato',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Collega Google Drive, Dropbox, OneDrive, SFTP o WebDAV per iniziare a sincronizzare ed esplorare i tuoi file.',
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
                        icon: const Icon(Icons.add),
                        label: const Text('Aggiungi Primo Cloud'),
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
                      mainAxisExtent: 215,
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
                                  CircleAvatar(
                                    backgroundColor: color.withValues(alpha: 0.15),
                                    child: Icon(icon, color: color),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          remote.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          remote.type.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    onSelected: (action) async {
                                      if (action == 'delete') {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Disconnetti Cloud'),
                                            content: Text(
                                              'Vuoi rimuovere "${remote.name}"? Le credenziali verranno eliminate dallo storage cifrato.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: const Text('Annulla'),
                                              ),
                                              FilledButton(
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                child: const Text('Disconnetti'),
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
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: ListTile(
                                          leading: Icon(Icons.delete_outline, color: Colors.red),
                                          title: Text('Disconnetti', style: TextStyle(color: Colors.red)),
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
                                          '${StorageQuota.formatBytes(quota.effectiveFree)} liberi',
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
                                            'Storage',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Disponibile',
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
                                  label: const Text('Esplora File'),
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
