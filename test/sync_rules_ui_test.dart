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

      expect(find.text('Sincronizzazione & Backup'), findsOneWidget);
      expect(find.text('Nessuna Regola Configurata'), findsOneWidget);
      expect(find.text('Crea Nuova Regola'), findsOneWidget);
      expect(find.text('Nuova Regola'), findsOneWidget); // FAB
    });

    testWidgets('Renders configured sync rules list with cards and details', (tester) async {
      const rule = SyncRule(
        id: 'rule_1',
        name: 'Backup Foto DCIM',
        localPath: '/storage/emulated/0/DCIM',
        remote: 'gdrive',
        remotePath: 'Backup/Foto',
        mode: SyncMode.copy,
        frequency: SyncFrequency.hourly,
        isEnabled: true,
        lastStatus: SyncStatus.completed,
      );

      await tester.pumpWidget(createTestApp(initialRules: [rule]));
      await tester.pumpAndSettle();

      expect(find.text('Backup Foto DCIM'), findsOneWidget);
      expect(find.text('/storage/emulated/0/DCIM'), findsOneWidget);
      expect(find.text('gdrive:Backup/Foto'), findsOneWidget);
      expect(find.text('Ogni ora'), findsOneWidget);
      expect(find.text('Backup Incrementale'), findsOneWidget);
      expect(find.text('Completato'), findsOneWidget);
      expect(find.text('Sincronizza ora'), findsOneWidget);
      expect(find.text('Sincronizza Tutte'), findsOneWidget);
    });

    testWidgets('Tapping "Nuova Regola" opens SyncRuleDialog with form fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final fakeRemote = CloudRemote(
        name: 'gdrive',
        type: 'drive',
      );

      await tester.pumpWidget(createTestApp(
        initialRules: [],
        initialRemotes: [fakeRemote],
      ));
      await tester.pumpAndSettle();

      // Tap FAB to open dialog
      await tester.tap(find.text('Nuova Regola'));
      await tester.pumpAndSettle();

      expect(find.byType(SyncRuleDialog), findsOneWidget);
      expect(find.text('Nuova Regola di Sincronizzazione'), findsOneWidget);
      expect(find.text('Cartella Locale Sorgente'), findsOneWidget);
      expect(find.text('Cloud di Destinazione'), findsOneWidget);
      expect(find.text('Cartella di Destinazione sul Cloud'), findsOneWidget);
      expect(find.text('Modalità Operativa'), findsOneWidget);
      expect(find.text('Frequenza Pianificata'), findsOneWidget);
      expect(find.text('Salva Regola'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Annulla'));
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
        isEnabled: true,
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
  final List<CloudRemote> _remotes;

  _FakeCloudAccountsNotifier(this._remotes);

  @override
  CloudAccountsState build() {
    return CloudAccountsState(remotes: _remotes);
  }
}
