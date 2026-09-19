import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/sync_rule_model.dart';

void main() {
  group('SyncRule Model Tests', () {
    test('Default values are correct', () {
      const rule = SyncRule(
        id: 'rule_1',
        name: 'Backup Foto',
        localPath: '/home/user/Pictures',
        remote: 'gdrive',
        remotePath: 'Backup/Foto',
      );

      expect(rule.id, equals('rule_1'));
      expect(rule.name, equals('Backup Foto'));
      expect(rule.localPath, equals('/home/user/Pictures'));
      expect(rule.remote, equals('gdrive'));
      expect(rule.remotePath, equals('Backup/Foto'));
      expect(rule.mode, equals(SyncMode.copy));
      expect(rule.frequency, equals(SyncFrequency.hourly));
      expect(rule.isEnabled, isTrue);
      expect(rule.lastSyncTime, isNull);
      expect(rule.lastStatus, equals(SyncStatus.idle));
      expect(rule.lastError, isNull);
      expect(rule.activeJobId, isNull);
    });

    test('copyWith updates specified fields correctly', () {
      const rule = SyncRule(
        id: 'rule_1',
        name: 'Backup Foto',
        localPath: '/home/user/Pictures',
        remote: 'gdrive',
        remotePath: 'Backup/Foto',
      );

      final now = DateTime(2026, 9, 19, 12, 0);
      final updated = rule.copyWith(
        name: 'Backup Immagini Aggiornato',
        mode: SyncMode.sync,
        frequency: SyncFrequency.daily,
        isEnabled: false,
        lastSyncTime: () => now,
        lastStatus: SyncStatus.completed,
        lastError: () => 'Nessun errore',
        activeJobId: () => 'job_123',
      );

      expect(updated.name, equals('Backup Immagini Aggiornato'));
      expect(updated.mode, equals(SyncMode.sync));
      expect(updated.frequency, equals(SyncFrequency.daily));
      expect(updated.isEnabled, isFalse);
      expect(updated.lastSyncTime, equals(now));
      expect(updated.lastStatus, equals(SyncStatus.completed));
      expect(updated.lastError, equals('Nessun errore'));
      expect(updated.activeJobId, equals('job_123'));
    });

    test('toJson and fromJson serialize and deserialize accurately', () {
      final now = DateTime(2026, 9, 19, 10, 30);
      final rule = SyncRule(
        id: 'rule_100',
        name: 'Backup Documenti',
        localPath: '/home/user/Documents',
        remote: 'onedrive',
        remotePath: 'Lavoro/Doc',
        mode: SyncMode.sync,
        frequency: SyncFrequency.hours6,
        isEnabled: true,
        lastSyncTime: now,
        lastStatus: SyncStatus.completed,
        lastError: null,
        activeJobId: null,
      );

      final json = rule.toJson();
      expect(json['id'], equals('rule_100'));
      expect(json['name'], equals('Backup Documenti'));
      expect(json['mode'], equals('sync'));
      expect(json['frequency'], equals('hours6'));
      expect(json['is_enabled'], isTrue);
      expect(json['last_status'], equals('completed'));

      final restored = SyncRule.fromJson(json);
      expect(restored.id, equals(rule.id));
      expect(restored.name, equals(rule.name));
      expect(restored.localPath, equals(rule.localPath));
      expect(restored.remote, equals(rule.remote));
      expect(restored.remotePath, equals(rule.remotePath));
      expect(restored.mode, equals(rule.mode));
      expect(restored.frequency, equals(rule.frequency));
      expect(restored.isEnabled, equals(rule.isEnabled));
      expect(restored.lastSyncTime, equals(rule.lastSyncTime));
      expect(restored.lastStatus, equals(rule.lastStatus));
    });

    test('isDue calculation logic handles intervals correctly', () {
      final baseTime = DateTime(2026, 9, 19, 12, 0);

      // Rule never synced before -> isDue is true
      const newRule = SyncRule(
        id: 'rule_new',
        name: 'New',
        localPath: '/path',
        remote: 'remote',
        remotePath: 'path',
        frequency: SyncFrequency.hourly,
      );
      expect(newRule.isDue(baseTime), isTrue);

      // Disabled rule -> never due
      final disabledRule = newRule.copyWith(isEnabled: false);
      expect(disabledRule.isDue(baseTime), isFalse);

      // Manual rule -> never due automatically
      final manualRule = newRule.copyWith(frequency: SyncFrequency.manual);
      expect(manualRule.isDue(baseTime), isFalse);

      // In-progress rule -> not due while running
      final runningRule = newRule.copyWith(lastStatus: SyncStatus.inProgress);
      expect(runningRule.isDue(baseTime), isFalse);

      // Hourly rule synced 30 minutes ago -> not due yet
      final synced30m = newRule.copyWith(
        lastSyncTime: () => baseTime.subtract(const Duration(minutes: 30)),
      );
      expect(synced30m.isDue(baseTime), isFalse);

      // Hourly rule synced 61 minutes ago -> due
      final synced61m = newRule.copyWith(
        lastSyncTime: () => baseTime.subtract(const Duration(minutes: 61)),
      );
      expect(synced61m.isDue(baseTime), isTrue);
    });

    test('Enum labels and descriptions are user friendly', () {
      expect(SyncMode.copy.label, equals('Backup Incrementale'));
      expect(SyncMode.sync.label, equals('Sincronizzazione Mirror'));
      expect(SyncFrequency.manual.duration, isNull);
      expect(SyncFrequency.minutes15.duration, equals(const Duration(minutes: 15)));
      expect(SyncFrequency.hourly.duration, equals(const Duration(hours: 1)));
      expect(SyncFrequency.daily.duration, equals(const Duration(hours: 24)));
      expect(SyncStatus.inProgress.label, equals('In corso...'));
    });
  });
}

