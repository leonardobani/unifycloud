import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void _confirmDelete(BuildContext context, WidgetRef ref, SyncRule rule) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Regola'),
        content: Text(
          'Vuoi davvero eliminare la regola di sincronizzazione "${rule.name}"? '
          'I file presenti sia sul dispositivo che sul cloud non verranno cancellati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              ref.read(syncProvider.notifier).deleteRule(rule.id);
              Navigator.of(context).pop();
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'Sincronizzazione & Backup',
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
              label: const Text('Sincronizza Tutte'),
              onPressed: anyInProgress
                  ? null
                  : () {
                      ref.read(syncProvider.notifier).syncAllRules();
                    },
            ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuova regola',
            onPressed: () => _openAddRuleDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuova Regola'),
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
                          'Backup Continuo & Sincronizzazione Cloud',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Crea regole per sincronizzare automaticamente le tue cartelle (es. Foto/DCIM, Documenti) con Google Drive, OneDrive o altri provider supportati.',
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
                    'Nessuna Regola Configurata',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Text(
                      'Configura una regola per eseguire il backup automatico a intervalli regolari o su richiesta con il pulsante "Sincronizza ora".',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Crea Nuova Regola'),
                    onPressed: () => _openAddRuleDialog(context),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Regole di Sincronizzazione (${rules.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...rules.map((rule) => _buildRuleCard(context, ref, rule)),
          ],
        ],
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, WidgetRef ref, SyncRule rule) {
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
                  tooltip: 'Opzioni regola',
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Modifica'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Elimina', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (action) {
                    if (action == 'edit') {
                      _openEditRuleDialog(context, rule);
                    } else if (action == 'delete') {
                      _confirmDelete(context, ref, rule);
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
                  label: Text(rule.frequency.label, style: const TextStyle(fontSize: 11)),
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
                  label: Text(rule.mode.label, style: const TextStyle(fontSize: 11)),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                ),
                // Status Badge
                _buildStatusChip(rule, colorScheme),
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

            // Action row: Last execution timestamp + "Sincronizza ora" button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatLastSyncTime(rule.lastSyncTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                if (isInProgress)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                    label: const Text('Annulla', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      ref.read(syncProvider.notifier).cancelSync(rule.id);
                    },
                  )
                else
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Sincronizza ora'),
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

  Widget _buildStatusChip(SyncRule rule, ColorScheme colorScheme) {
    switch (rule.lastStatus) {
      case SyncStatus.inProgress:
        return Chip(
          avatar: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: const Text('In corso...', style: TextStyle(fontSize: 11)),
          backgroundColor: colorScheme.primaryContainer,
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.completed:
        return const Chip(
          avatar: Icon(Icons.check_circle, size: 14, color: Colors.green),
          label: Text('Completato', style: TextStyle(fontSize: 11, color: Colors.green)),
          backgroundColor: Color(0x1A4CAF50),
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.failed:
        return Chip(
          avatar: Icon(Icons.error, size: 14, color: colorScheme.error),
          label: Text('Errore', style: TextStyle(fontSize: 11, color: colorScheme.error)),
          backgroundColor: colorScheme.errorContainer,
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
      case SyncStatus.idle:
        return const Chip(
          avatar: Icon(Icons.pause, size: 14, color: Colors.grey),
          label: Text('In attesa', style: TextStyle(fontSize: 11, color: Colors.grey)),
          backgroundColor: Color(0x1A9E9E9E),
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
        );
    }
  }

  String _formatLastSyncTime(DateTime? time) {
    if (time == null) {
      return 'Mai sincronizzato';
    }
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Ultima sinc: adesso';
    } else if (diff.inMinutes < 60) {
      return 'Ultima sinc: ${diff.inMinutes} minuti fa';
    } else if (diff.inHours < 24) {
      return 'Ultima sinc: ${diff.inHours} ore fa';
    } else {
      return 'Ultima sinc: ${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
