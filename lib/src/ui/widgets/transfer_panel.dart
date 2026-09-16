import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transfer_models.dart';
import '../../providers/transfer_provider.dart';
import '../theme/app_theme.dart';
import 'file_type_icon.dart';

/// Floating banner shown when transfers are active.
class TransferFloatingBar extends ConsumerWidget {
  const TransferFloatingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferProvider);
    final activeCount = transferState.activeCount;

    if (activeCount == 0) {
      return const SizedBox.shrink();
    }

    final speedText = transferState.formattedTotalSpeed;
    final avgProgress = transferState.averageProgress;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.surfaceColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => const TransferSheet(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$activeCount ${activeCount == 1 ? 'trasferimento attivo' : 'trasferimenti attivi'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            speedText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: avgProgress > 0 ? avgProgress : null,
                          minHeight: 4,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(
                              AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.expand_less, size: 22, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-height / modal bottom sheet displaying all transfers and progress.
class TransferSheet extends ConsumerWidget {
  const TransferSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferProvider);
    final transfers = state.transfers;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.swap_vert_rounded,
                    color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Coda Trasferimenti (${transfers.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (transfers.any((t) => !t.isActive))
                  TextButton.icon(
                    onPressed: () {
                      ref.read(transferProvider.notifier).clearCompleted();
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Pulisci'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Transfer list
          Expanded(
            child: transfers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_done_outlined,
                            size: 64, color: Colors.grey.shade600),
                        const SizedBox(height: 16),
                        const Text(
                          'Nessun trasferimento recente',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'I download, gli upload e le copie cloud appariranno qui.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: transfers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final job = transfers[index];
                      return _TransferCard(job: job);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TransferCard extends ConsumerWidget {
  final TransferJob job;

  const _TransferCard({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FileTypeIcon(fileName: job.fileName, isDir: false, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.fileName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      _buildRouteBadges(),
                    ],
                  ),
                ),
                _buildStatusWidget(context, ref),
              ],
            ),

            if (job.isActive) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: job.percentage > 0 ? job.percentage / 100 : null,
                  minHeight: 6,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor:
                      const AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${job.percentage}% • ${job.formattedProgress}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    '${job.formattedSpeed} • ETA ${job.formattedEta}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ] else if (job.status == TransferStatus.completed) ...[
              const SizedBox(height: 6),
              Text(
                'Completato • ${job.formattedProgress}',
                style: const TextStyle(fontSize: 11, color: Colors.green),
              ),
            ] else if (job.status == TransferStatus.failed) ...[
              const SizedBox(height: 6),
              Text(
                'Errore: ${job.error ?? "Trasferimento fallito"}',
                style: const TextStyle(fontSize: 11, color: Colors.red),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else if (job.status == TransferStatus.cancelled) ...[
              const SizedBox(height: 6),
              const Text(
                'Annullato dall\'utente',
                style: TextStyle(fontSize: 11, color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRouteBadges() {
    final src = job.srcRemote.isEmpty ? 'Locale' : job.srcRemote;
    final dst = job.dstRemote.isEmpty ? 'Locale' : job.dstRemote;
    final action = job.isMove ? 'Sposta in' : 'Copia in';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            src,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            action,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            dst,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusWidget(BuildContext context, WidgetRef ref) {
    if (job.isActive) {
      return IconButton(
        icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 22),
        tooltip: 'Annulla trasferimento',
        onPressed: () {
          ref.read(transferProvider.notifier).cancelTransfer(job.id);
        },
      );
    }

    switch (job.status) {
      case TransferStatus.completed:
        return const Icon(Icons.check_circle_rounded,
            color: Colors.green, size: 22);
      case TransferStatus.failed:
        return const Icon(Icons.error_outline_rounded,
            color: Colors.red, size: 22);
      case TransferStatus.cancelled:
        return const Icon(Icons.cancel_rounded, color: Colors.orange, size: 22);
      default:
        return const SizedBox.shrink();
    }
  }
}
