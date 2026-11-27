import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/l10n_extension.dart';
import '../../models/sync_rule_model.dart';
import '../../providers/sync_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/sync_rule_dialog.dart';

/// Screen allowing users to configure and manage automated and on-demand folder sync rules.
class SyncRulesScreen extends ConsumerWidget {
  const SyncRulesScreen({super.key});

  void _openAddRuleDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => const SyncRuleDialog(),
    );
  }

  void _openEditRuleDialog(BuildContext context, SyncRule rule) {
    showDialog<bool>(
      context: context,
      builder: (context) => SyncRuleDialog(existingRule: rule),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SyncRule rule,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRuleTitle),
        content: Text(l10n.deleteRulePrompt(rule.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              ref.read(syncProvider.notifier).deleteRule(rule.id);
              Navigator.of(context).pop();
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rules = ref.watch(syncProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final anyInProgress = rules.any((r) => r.lastStatus == SyncStatus.inProgress);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sync, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.syncAndBackup,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (rules.isNotEmpty)
            TextButton.icon(
              icon: anyInProgress
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(l10n.syncAll),
              onPressed: anyInProgress
                  ? null
                  : () {
                      ref.read(syncProvider.notifier).syncAllRules();
                    },
            ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.newRuleTooltip,
            onPressed: () => _openAddRuleDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.newRule),
        onPressed: () => _openAddRuleDialog(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Informational Overview Banner
          Card(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.backup,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.backupBannerTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.backupBannerSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Rules List or Empty State
          if (rules.isEmpty) ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_sync_outlined,
                    size: 80,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noRulesConfigured,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Text(
                      l10n.noSyncRulesEmptyDesc,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createNewRule),
                    onPressed: () => _openAddRuleDialog(context),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              l10n.syncRulesCount(rules.length),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...rules.map((rule) => _buildRuleCard(context, ref, rule, l10n)),
          ],
        ],
      ),
    );
  }

  Widget _buildRuleCard(
    BuildContext context,
    WidgetRef ref,
    SyncRule rule,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isInProgress = rule.lastStatus == SyncStatus.inProgress;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isInProgress
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isInProgress ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title + Status Switch + Popup Menu
            Row(
              children: [
                Icon(
                  rule.mode == SyncMode.sync
                      ? Icons.sync
                      : Icons.backup_outlined,
                  color: rule.isEnabled
                      ? colorScheme.primary
                      : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rule.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: rule.isEnabled
                          ? null
                          : TextDecoration.lineThrough,
                      color: rule.isEnabled ? null : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch(
                  value: rule.isEnabled,
                  onChanged: isInProgress
                      ? null
                      : (v) {
                          ref.read(syncProvider.notifier).toggleRuleEnabled(rule.id);
                        },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: l10n.ruleOptionsTooltip,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (action) {
                    if (action == 'edit') {
                      _openEditRuleDialog(context, rule);
                    } else if (action == 'delete') {
                      _confirmDelete(context, ref, rule, l10n);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Path mapping: Local Folder -> Cloud Remote Folder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_outlined, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rule.localPath,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  ),
                  const Icon(Icons.cloud_outlined, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${rule.remote}:${rule.remotePath}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Badges: Frequency, Mode, Last Status
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                // Frequency Badge
                Chip(
                  avatar: const Icon(Icons.schedule, size: 14),
                  label: Text(
                    rule.frequency.localizedLabel(l10n),
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                ),
                // Mode Badge
                Chip(
                  avatar: Icon(
                    rule.mode == SyncMode.sync ? Icons.sync : Icons.backup,
                    size: 14,
                  ),
                  label: Text(
                    rule.mode.localizedLabel(l10n),
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                ),
                // Status Badge
                _buildStatusChip(rule, colorScheme, l10n),
              ],
            ),
            const SizedBox(height: 12),

            // Last Sync info & Errors
            if (rule.lastError != null && rule.lastError!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        size: 16, color: colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rule.lastError!,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Action row: Last execution timestamp + "Sync now" button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatLastSyncTime(rule.lastSyncTime, l10n),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                if (isInProgress)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                    label: Text(l10n.cancel, style: const TextStyle(color: Colors.red)),
                    onPressed: () {
                      ref.read(syncProvider.notifier).cancelSync(rule.id);
                    },
                  )
                else
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: Text(l10n.syncNow),
                    onPressed: () {
                      ref.read(syncProvider.notifier).executeSync(rule.id);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    SyncRule rule,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    switch (rule.lastStatus) {
      case SyncStatus.inProgress:
        return Chip(
          avatar: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: Text(l10n.statusInProgress, style: const TextStyle(fontSize: 11)),
          backgroundColor: colorScheme.primaryContainer,
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.completed:
        return Chip(
          avatar: const Icon(Icons.check_circle, size: 14, color: Colors.green),
          label: Text(
            l10n.statusCompleted,
            style: const TextStyle(fontSize: 11, color: Colors.green),
          ),
          backgroundColor: const Color(0x1A4CAF50),
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.failed:
        return Chip(
          avatar: Icon(Icons.error, size: 14, color: colorScheme.error),
          label: Text(
            l10n.statusFailed,
            style: TextStyle(fontSize: 11, color: colorScheme.error),
          ),
          backgroundColor: colorScheme.errorContainer,
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.idle:
        return Chip(
          avatar: const Icon(Icons.pause, size: 14, color: Colors.grey),
          label: Text(
            l10n.statusWaiting,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          backgroundColor: const Color(0x1A9E9E9E),
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
    }
  }

  String _formatLastSyncTime(DateTime? time, AppLocalizations l10n) {
    if (time == null) {
      return l10n.neverSynced;
    }
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return l10n.lastSyncNow;
    } else if (diff.inMinutes < 60) {
      return l10n.lastSyncMinutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.lastSyncHoursAgo(diff.inHours);
    } else {
      final formatted =
          '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      return l10n.lastSyncDate(formatted);
    }
  }
}
