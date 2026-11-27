import 'package:flutter/foundation.dart';

import '../../l10n/app_localizations.dart';

/// Supported synchronization operating modes.
enum SyncMode {
  /// Incremental backup: copies new/modified files from local to cloud without deleting anything on cloud.
  copy,

  /// Mirror synchronization: makes destination cloud folder identical to local source, removing deleted files.
  sync;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case SyncMode.copy:
        return l10n.syncModeCopy;
      case SyncMode.sync:
        return l10n.syncModeSync;
    }
  }

  String localizedDescription(AppLocalizations l10n) {
    switch (this) {
      case SyncMode.copy:
        return l10n.syncModeCopyDesc;
      case SyncMode.sync:
        return l10n.syncModeSyncDesc;
    }
  }

  String get label {
    switch (this) {
      case SyncMode.copy:
        return 'Incremental Backup';
      case SyncMode.sync:
        return 'Mirror Synchronization';
    }
  }

  String get description {
    switch (this) {
      case SyncMode.copy:
        return 'Uploads new and modified files, preserving existing cloud files.';
      case SyncMode.sync:
        return 'Makes the remote destination identical to the local folder (deletions locally are deleted on cloud).';
    }
  }
}

/// Interval frequencies for scheduled sync executions.
enum SyncFrequency {
  manual,
  minutes15,
  minutes30,
  hourly,
  hours6,
  hours12,
  daily;

  Duration? get duration {
    switch (this) {
      case SyncFrequency.manual:
        return null;
      case SyncFrequency.minutes15:
        return const Duration(minutes: 15);
      case SyncFrequency.minutes30:
        return const Duration(minutes: 30);
      case SyncFrequency.hourly:
        return const Duration(hours: 1);
      case SyncFrequency.hours6:
        return const Duration(hours: 6);
      case SyncFrequency.hours12:
        return const Duration(hours: 12);
      case SyncFrequency.daily:
        return const Duration(hours: 24);
    }
  }

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case SyncFrequency.manual:
        return l10n.freqManual;
      case SyncFrequency.minutes15:
        return l10n.freq15Min;
      case SyncFrequency.minutes30:
        return l10n.freq30Min;
      case SyncFrequency.hourly:
        return l10n.freqHourly;
      case SyncFrequency.hours6:
        return l10n.freq6Hours;
      case SyncFrequency.hours12:
        return l10n.freq12Hours;
      case SyncFrequency.daily:
        return l10n.freqDaily;
    }
  }

  String get label {
    switch (this) {
      case SyncFrequency.manual:
        return 'Manual (on demand only)';
      case SyncFrequency.minutes15:
        return 'Every 15 minutes';
      case SyncFrequency.minutes30:
        return 'Every 30 minutes';
      case SyncFrequency.hourly:
        return 'Every hour';
      case SyncFrequency.hours6:
        return 'Every 6 hours';
      case SyncFrequency.hours12:
        return 'Every 12 hours';
      case SyncFrequency.daily:
        return 'Every day (24 hours)';
    }
  }
}

/// Execution status of a sync rule.
enum SyncStatus {
  idle,
  inProgress,
  completed,
  failed;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case SyncStatus.idle:
        return l10n.statusWaiting;
      case SyncStatus.inProgress:
        return l10n.statusInProgress;
      case SyncStatus.completed:
        return l10n.statusCompleted;
      case SyncStatus.failed:
        return l10n.statusFailed;
    }
  }

  String get label {
    switch (this) {
      case SyncStatus.idle:
        return 'Pending';
      case SyncStatus.inProgress:
        return 'In progress...';
      case SyncStatus.completed:
        return 'Completed';
      case SyncStatus.failed:
        return 'Failed';
    }
  }
}

/// Model describing an automated or on-demand folder sync rule.
@immutable
class SyncRule {

  const SyncRule({
    required this.id,
    required this.name,
    required this.localPath,
    required this.remote,
    required this.remotePath,
    this.mode = SyncMode.copy,
    this.frequency = SyncFrequency.hourly,
    this.isEnabled = true,
    this.lastSyncTime,
    this.lastStatus = SyncStatus.idle,
    this.lastError,
    this.activeJobId,
  });

  factory SyncRule.fromJson(Map<String, dynamic> json) {
    SyncMode syncMode = SyncMode.copy;
    final modeStr = json['mode'] as String?;
    if (modeStr == 'sync') {
      syncMode = SyncMode.sync;
    }

    SyncFrequency freq = SyncFrequency.hourly;
    final freqStr = json['frequency'] as String?;
    for (final f in SyncFrequency.values) {
      if (f.name == freqStr) {
        freq = f;
        break;
      }
    }

    SyncStatus status = SyncStatus.idle;
    final statusStr = json['last_status'] as String?;
    for (final s in SyncStatus.values) {
      if (s.name == statusStr) {
        status = s;
        break;
      }
    }

    DateTime? lastTime;
    final timeStr = json['last_sync_time'] as String?;
    if (timeStr != null && timeStr.isNotEmpty) {
      lastTime = DateTime.tryParse(timeStr);
    }

    return SyncRule(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      localPath: json['local_path'] as String? ?? '',
      remote: json['remote'] as String? ?? '',
      remotePath: json['remote_path'] as String? ?? '',
      mode: syncMode,
      frequency: freq,
      isEnabled: json['is_enabled'] as bool? ?? true,
      lastSyncTime: lastTime,
      lastStatus: status,
      lastError: json['last_error'] as String?,
      activeJobId: json['active_job_id'] as String?,
    );
  }
  final String id;
  final String name;
  final String localPath;
  final String remote;
  final String remotePath;
  final SyncMode mode;
  final SyncFrequency frequency;
  final bool isEnabled;
  final DateTime? lastSyncTime;
  final SyncStatus lastStatus;
  final String? lastError;
  final String? activeJobId;

  /// Whether this rule is currently due for automated periodic execution.
  bool isDue([DateTime? nowTime]) {
    if (!isEnabled || frequency == SyncFrequency.manual || lastStatus == SyncStatus.inProgress) {
      return false;
    }
    final now = nowTime ?? DateTime.now();
    if (lastSyncTime == null) {
      return true;
    }
    final interval = frequency.duration;
    if (interval == null) return false;
    return now.difference(lastSyncTime!) >= interval;
  }

  SyncRule copyWith({
    String? id,
    String? name,
    String? localPath,
    String? remote,
    String? remotePath,
    SyncMode? mode,
    SyncFrequency? frequency,
    bool? isEnabled,
    DateTime? Function()? lastSyncTime,
    SyncStatus? lastStatus,
    String? Function()? lastError,
    String? Function()? activeJobId,
  }) {
    return SyncRule(
      id: id ?? this.id,
      name: name ?? this.name,
      localPath: localPath ?? this.localPath,
      remote: remote ?? this.remote,
      remotePath: remotePath ?? this.remotePath,
      mode: mode ?? this.mode,
      frequency: frequency ?? this.frequency,
      isEnabled: isEnabled ?? this.isEnabled,
      lastSyncTime: lastSyncTime != null ? lastSyncTime() : this.lastSyncTime,
      lastStatus: lastStatus ?? this.lastStatus,
      lastError: lastError != null ? lastError() : this.lastError,
      activeJobId: activeJobId != null ? activeJobId() : this.activeJobId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'local_path': localPath,
      'remote': remote,
      'remote_path': remotePath,
      'mode': mode.name,
      'frequency': frequency.name,
      'is_enabled': isEnabled,
      'last_sync_time': lastSyncTime?.toIso8601String(),
      'last_status': lastStatus.name,
      'last_error': lastError,
      'active_job_id': activeJobId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncRule &&
        other.id == id &&
        other.name == name &&
        other.localPath == localPath &&
        other.remote == remote &&
        other.remotePath == remotePath &&
        other.mode == mode &&
        other.frequency == frequency &&
        other.isEnabled == isEnabled &&
        other.lastSyncTime == lastSyncTime &&
        other.lastStatus == lastStatus &&
        other.lastError == lastError &&
        other.activeJobId == activeJobId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        localPath,
        remote,
        remotePath,
        mode,
        frequency,
        isEnabled,
        lastSyncTime,
        lastStatus,
        lastError,
        activeJobId,
      );
}
