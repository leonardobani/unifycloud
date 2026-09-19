import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/sync_rule_model.dart';
import '../models/transfer_models.dart';
import '../services/rclone_service.dart';
import 'settings_provider.dart';

/// Provider exposing the list of configured [SyncRule]s and sync operations.
final syncProvider =
    NotifierProvider<SyncNotifier, List<SyncRule>>(SyncNotifier.new);

/// Riverpod Notifier managing sync rules persistence, scheduling and execution.
class SyncNotifier extends Notifier<List<SyncRule>> {
  static const String syncRulesStorageKey = 'unifycloud_sync_rules_v1';
  final List<SyncRule>? _initialRules;
  Timer? _scheduleTimer;

  SyncNotifier([this._initialRules]);

  FlutterSecureStorage get _storage => ref.read(settingsStorageProvider);
  RcloneService get _rclone => ref.read(rcloneServiceProvider);

  @override
  List<SyncRule> build() {
    ref.onDispose(() {
      _scheduleTimer?.cancel();
    });

    final initial = _initialRules ?? const [];
    scheduleMicrotask(() async {
      await _loadFromStorage();
      _startScheduler();
    });
    return initial;
  }

  void _startScheduler() {
    _scheduleTimer?.cancel();
    // Checks every 30 seconds for scheduled rules that are due
    _scheduleTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkScheduledRules();
    });
  }

  Future<void> _checkScheduledRules() async {
    final now = DateTime.now();
    for (final rule in state) {
      if (rule.isDue(now)) {
        // Fire and forget so multiple independent rules can execute or queue
        unawaited(executeSync(rule.id));
      }
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final rawJson = await _storage.read(key: syncRulesStorageKey);
      if (rawJson != null && rawJson.trim().isNotEmpty) {
        final decoded = jsonDecode(rawJson) as List<dynamic>;
        state = decoded
            .map((item) => SyncRule.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Keep initial or empty state on error
    }
  }

  Future<void> _persist(List<SyncRule> newRules) async {
    state = newRules;
    try {
      final jsonString =
          jsonEncode(newRules.map((rule) => rule.toJson()).toList());
      await _storage.write(key: syncRulesStorageKey, value: jsonString);
    } catch (_) {}
  }

  /// Adds a new sync rule and persists it.
  Future<void> addRule(SyncRule rule) async {
    final updated = [...state, rule];
    await _persist(updated);
  }

  /// Updates an existing sync rule.
  Future<void> updateRule(SyncRule updatedRule) async {
    final updated = state.map((r) {
      return r.id == updatedRule.id ? updatedRule : r;
    }).toList();
    await _persist(updated);
  }

  /// Removes a sync rule by [id].
  Future<void> deleteRule(String id) async {
    final rule = state.where((r) => r.id == id).firstOrNull;
    if (rule?.activeJobId != null) {
      await _rclone.cancelTransfer(rule!.activeJobId!);
    }
    final updated = state.where((r) => r.id != id).toList();
    await _persist(updated);
  }

  /// Toggles whether a rule is enabled or disabled.
  Future<void> toggleRuleEnabled(String id) async {
    final updated = state.map((r) {
      if (r.id == id) {
        return r.copyWith(isEnabled: !r.isEnabled);
      }
      return r;
    }).toList();
    await _persist(updated);
  }

  /// Executes synchronization for the given [ruleId].
  ///
  /// Can be triggered either manually via "Sincronizza ora" or automatically by the scheduler.
  Future<bool> executeSync(String ruleId) async {
    final ruleIndex = state.indexWhere((r) => r.id == ruleId);
    if (ruleIndex == -1) return false;

    final rule = state[ruleIndex];
    if (rule.lastStatus == SyncStatus.inProgress) {
      return false; // Already running
    }

    // 1. Validate local directory
    final localDir = Directory(rule.localPath);
    if (!localDir.existsSync()) {
      _updateRuleInState(
        ruleId,
        (r) => r.copyWith(
          lastStatus: SyncStatus.failed,
          lastError: () => 'Cartella locale non trovata: ${rule.localPath}',
          activeJobId: () => null,
        ),
      );
      return false;
    }

    // 2. Start sync job in native engine
    try {
      _updateRuleInState(
        ruleId,
        (r) => r.copyWith(
          lastStatus: SyncStatus.inProgress,
          lastError: () => null,
        ),
      );

      final job = await _rclone.startSync(
        srcRemote: '',
        srcPath: rule.localPath,
        dstRemote: rule.remote,
        dstPath: rule.remotePath,
        mode: rule.mode.name,
      );

      _updateRuleInState(
        ruleId,
        (r) => r.copyWith(
          activeJobId: () => job.id,
        ),
      );

      // 3. Monitor sync job progress until finish
      final completed = await _monitorJob(ruleId, job.id);
      return completed;
    } catch (e) {
      _updateRuleInState(
        ruleId,
        (r) => r.copyWith(
          lastStatus: SyncStatus.failed,
          lastError: () => e.toString().replaceFirst('Exception: ', ''),
          activeJobId: () => null,
        ),
      );
      return false;
    }
  }

  Future<bool> _monitorJob(String ruleId, String jobId) async {
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      try {
        final job = await _rclone.getTransferProgress(jobId);
        if (job == null) break;

        if (job.status == TransferStatus.completed) {
          _updateRuleInState(
            ruleId,
            (r) => r.copyWith(
              lastStatus: SyncStatus.completed,
              lastSyncTime: () => DateTime.now(),
              activeJobId: () => null,
              lastError: () => null,
            ),
          );
          return true;
        } else if (job.status == TransferStatus.failed) {
          _updateRuleInState(
            ruleId,
            (r) => r.copyWith(
              lastStatus: SyncStatus.failed,
              lastError: () => job.error ?? 'Sincronizzazione fallita',
              activeJobId: () => null,
            ),
          );
          return false;
        } else if (job.status == TransferStatus.cancelled) {
          _updateRuleInState(
            ruleId,
            (r) => r.copyWith(
              lastStatus: SyncStatus.idle,
              activeJobId: () => null,
            ),
          );
          return false;
        }
      } catch (_) {
        break;
      }
    }
    return false;
  }

  /// Cancels an in-progress sync for [ruleId].
  Future<void> cancelSync(String ruleId) async {
    final rule = state.where((r) => r.id == ruleId).firstOrNull;
    if (rule?.activeJobId != null) {
      await _rclone.cancelTransfer(rule!.activeJobId!);
      _updateRuleInState(
        ruleId,
        (r) => r.copyWith(
          lastStatus: SyncStatus.idle,
          activeJobId: () => null,
        ),
      );
    }
  }

  /// Triggers synchronization for all enabled rules.
  Future<void> syncAllRules() async {
    final enabledRules = state.where((r) => r.isEnabled).toList();
    for (final rule in enabledRules) {
      unawaited(executeSync(rule.id));
    }
  }

  void _updateRuleInState(String ruleId, SyncRule Function(SyncRule) transform) {
    final updated = state.map((r) {
      if (r.id == ruleId) {
        return transform(r);
      }
      return r;
    }).toList();
    _persist(updated);
  }
}
