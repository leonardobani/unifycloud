import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/sync_rule_model.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/sync_provider.dart';
import 'package:unifycloud/src/ui/screens/sync_rules_screen.dart';
import 'package:unifycloud/src/ui/widgets/sync_rule_dialog.dart';

void main() {
  Widget createTestApp({
    List<SyncRule> initialRules = const [],
    List<CloudRemote> initialRemotes = const [],
  }) {
    return ProviderScope(
      overrides: [
        syncProvider.overrideWith(
          () => SyncNotifier(initialRules),
        ),
        cloudAccountsProvider.overrideWith(
          () => _FakeCloudAccountsNotifier(initialRemotes),
        ),
      ],
      child: const MaterialApp(
        home: SyncRulesScreen(),
      ),
    );
  }

  group('SyncRulesScreen Widget Tests', () {
    testWidgets('Renders empty state when no sync rules exist', (tester) async {
      await tester.pumpWidget(createTestApp(initialRules: []));
      await tester.pumpAndSettle();

      expect(find.text('Sync & Backup'), findsOneWidget);
      expect(find.text('No rules configured'), findsOneWidget);
      expect(find.text('Create New Rule'), findsOneWidget);
      expect(find.text('New Rule'), findsOneWidget); // FAB
    });

    testWidgets('Renders configured sync rules list with cards and details', (tester) async {
      const rule = SyncRule(
        id: 'rule_1',
        name: 'Backup Foto DCIM',
        localPath: '/storage/emulated/0/DCIM',
        remote: 'gdrive',
        remotePath: 'Backup/Foto',
        lastStatus: SyncStatus.completed,
      );

      await tester.pumpWidget(createTestApp(initialRules: [rule]));
      await tester.pumpAndSettle();

      expect(find.text('Backup Foto DCIM'), findsOneWidget);
      expect(find.text('/storage/emulated/0/DCIM'), findsOneWidget);
      expect(find.text('gdrive:Backup/Foto'), findsOneWidget);
      expect(find.text('Every hour'), findsOneWidget);
      expect(find.text('Incremental Backup'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Sync now'), findsOneWidget);
      expect(find.text('Sync All'), findsOneWidget);
    });

    testWidgets('Tapping "New Rule" opens SyncRuleDialog with form fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const fakeRemote = CloudRemote(
        name: 'gdrive',
        type: 'drive',
      );

      await tester.pumpWidget(createTestApp(
        initialRules: [],
        initialRemotes: [fakeRemote],
      ));
      await tester.pumpAndSettle();

      // Tap FAB to open dialog
      await tester.tap(find.text('New Rule'));
      await tester.pumpAndSettle();

      expect(find.byType(SyncRuleDialog), findsOneWidget);
      expect(find.text('New Synchronization Rule'), findsOneWidget);
      expect(find.text('Local Source Folder'), findsOneWidget);
      expect(find.text('Destination Cloud'), findsOneWidget);
      expect(find.text('Remote Destination Path'), findsOneWidget);
      expect(find.text('Sync Mode'), findsOneWidget);
      expect(find.text('Execution Frequency'), findsOneWidget);
      expect(find.text('Save Rule'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(SyncRuleDialog), findsNothing);
    });

    testWidgets('Toggling rule switch enables and disables rule', (tester) async {
      const rule = SyncRule(
        id: 'rule_toggle',
        name: 'Regola Toggle',
        localPath: '/tmp/test',
        remote: 'onedrive',
        remotePath: 'Test',
      );

      await tester.pumpWidget(createTestApp(initialRules: [rule]));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });
  });
}

class _FakeCloudAccountsNotifier extends CloudAccountsNotifier {

  _FakeCloudAccountsNotifier(this._remotes);
  final List<CloudRemote> _remotes;

  @override
  CloudAccountsState build() {
    return CloudAccountsState(remotes: _remotes);
  }
}
