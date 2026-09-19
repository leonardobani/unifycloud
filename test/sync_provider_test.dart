import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/sync_rule_model.dart';
import 'package:unifycloud/src/providers/sync_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';

void main() {
  group('SyncNotifier Tests', () {
    late Directory tempDir;
    late RcloneService rclone;

    setUpAll(() async {
      tempDir = Directory.systemTemp.createTempSync('unifycloud_sync_test_');
      rclone = RcloneService();
      await rclone.init();
    });

    tearDownAll(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('Initializes with provided rules and performs CRUD operations', () async {
      const initialRule = SyncRule(
        id: 'rule_1',
        name: 'Test Backup',
        localPath: '/non/existent/path',
        remote: 'gdrive',
        remotePath: 'Backup/Test',
      );

      final container = ProviderContainer(
        overrides: [
          syncProvider.overrideWith(
            () => SyncNotifier([initialRule]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(syncProvider.notifier);

      expect(container.read(syncProvider).length, equals(1));
      expect(container.read(syncProvider).first.id, equals('rule_1'));

      // Add rule
      const rule2 = SyncRule(
        id: 'rule_2',
        name: 'Second Rule',
        localPath: '/tmp',
        remote: 'onedrive',
        remotePath: 'Docs',
      );
      await notifier.addRule(rule2);
      expect(container.read(syncProvider).length, equals(2));

      // Toggle rule enabled
      await notifier.toggleRuleEnabled('rule_2');
      expect(container.read(syncProvider).firstWhere((r) => r.id == 'rule_2').isEnabled, isFalse);

      // Update rule
      final updatedRule = rule2.copyWith(name: 'Updated Second Rule', isEnabled: true);
      await notifier.updateRule(updatedRule);
      expect(
        container.read(syncProvider).firstWhere((r) => r.id == 'rule_2').name,
        equals('Updated Second Rule'),
      );

      // Delete rule
      await notifier.deleteRule('rule_1');
      expect(container.read(syncProvider).length, equals(1));
      expect(container.read(syncProvider).first.id, equals('rule_2'));
    });

    test('executeSync fails gracefully when local directory does not exist', () async {
      const rule = SyncRule(
        id: 'rule_missing',
        name: 'Missing Folder Rule',
        localPath: '/path/that/definitely/does/not/exist/9999',
        remote: 'gdrive',
        remotePath: 'Backup',
      );

      final container = ProviderContainer(
        overrides: [
          syncProvider.overrideWith(
            () => SyncNotifier([rule]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(syncProvider.notifier);
      final success = await notifier.executeSync('rule_missing');

      expect(success, isFalse);
      final resultRule = container.read(syncProvider).first;
      expect(resultRule.lastStatus, equals(SyncStatus.failed));
      expect(resultRule.lastError, contains('Cartella locale non trovata'));
    });

    test('executeSync successfully syncs local directory to local destination', () async {
      final srcDir = Directory('${tempDir.path}/src')..createSync();
      final dstDir = Directory('${tempDir.path}/dst')..createSync();

      // Create a test file
      File('${srcDir.path}/file1.txt').writeAsStringSync('Hello Sync!');

      final rule = SyncRule(
        id: 'rule_real_sync',
        name: 'Local Test Sync',
        localPath: srcDir.path,
        remote: '', // local
        remotePath: dstDir.path,
        mode: SyncMode.copy,
      );

      final container = ProviderContainer(
        overrides: [
          syncProvider.overrideWith(
            () => SyncNotifier([rule]),
          ),
          rcloneServiceProvider.overrideWithValue(rclone),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(syncProvider.notifier);
      final success = await notifier.executeSync('rule_real_sync');

      expect(success, isTrue);
      final resultRule = container.read(syncProvider).first;
      expect(resultRule.lastStatus, equals(SyncStatus.completed));
      expect(resultRule.lastSyncTime, isNotNull);
      expect(resultRule.lastError, isNull);

      // Verify file was copied to destination
      final copiedFile = File('${dstDir.path}/file1.txt');
      expect(copiedFile.existsSync(), isTrue);
      expect(copiedFile.readAsStringSync(), equals('Hello Sync!'));
    });
  });
}

