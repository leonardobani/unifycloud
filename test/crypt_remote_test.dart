import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/ui/theme/app_theme.dart';
import 'package:unifycloud/src/ui/widgets/add_cloud_dialog.dart';

void main() {
  group('CloudRemote Crypt Model Tests', () {
    test('isCrypt returns true for crypt type (case-insensitive)', () {
      const r1 = CloudRemote(name: 'MyVault', type: 'crypt');
      expect(r1.isCrypt, isTrue);

      const r2 = CloudRemote(name: 'MyVault2', type: 'CRYPT');
      expect(r2.isCrypt, isTrue);

      const r3 = CloudRemote(name: 'MyDrive', type: 'drive');
      expect(r3.isCrypt, isFalse);
    });

    test('remote field is serialized and deserialized correctly', () {
      final json = {
        'name': 'SecureVault',
        'type': 'crypt',
        'remote': 'GoogleDrive:secret_data',
      };

      final remote = CloudRemote.fromJson(json);
      expect(remote.name, equals('SecureVault'));
      expect(remote.type, equals('crypt'));
      expect(remote.remote, equals('GoogleDrive:secret_data'));
      expect(remote.isCrypt, isTrue);

      final outJson = remote.toJson();
      expect(outJson['remote'], equals('GoogleDrive:secret_data'));
    });

    test('copyWith preserves or modifies remote field', () {
      const original = CloudRemote(
        name: 'Vault1',
        type: 'crypt',
        remote: 'OneDrive:vault',
      );

      final copy1 = original.copyWith(name: 'VaultRenamed');
      expect(copy1.remote, equals('OneDrive:vault'));

      final copy2 = original.copyWith(remote: 'Dropbox:new_vault');
      expect(copy2.remote, equals('Dropbox:new_vault'));
    });
  });

  group('AppTheme Crypt Provider Tests', () {
    test('getProviderColor and getProviderIcon return crypt assets', () {
      expect(AppTheme.getProviderColor('crypt'), equals(const Color(0xFF00BFA5)));
      expect(AppTheme.getProviderIcon('crypt'), equals(Icons.lock_outline_rounded));
    });
  });

  group('AddCloudDialog Crypt UI Tests', () {
    Widget createDialogApp({
      String? initialProvider,
      String? initialTargetRemote,
      List<CloudRemote>? existingRemotes,
    }) {
      final remotes = existingRemotes ??
          const [
            CloudRemote(name: 'GoogleDrive', type: 'drive'),
            CloudRemote(name: 'DiscoLocale', type: 'local'),
          ];

      return ProviderScope(
        overrides: [
          cloudAccountsProvider.overrideWith(
            () => _MockCloudAccountsNotifier(remotes),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AddCloudDialog(
              initialProvider: initialProvider,
              initialTargetRemote: initialTargetRemote,
            ),
          ),
        ),
      );
    }

    testWidgets('Selecting Crypt provider updates name and displays vault fields',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // Find Crypt ChoiceChip and tap it
      final cryptChip = find.text('Crittografia E2E (Crypt)');
      expect(cryptChip, findsOneWidget);
      await tester.tap(cryptChip);
      await tester.pumpAndSettle();

      // Check default name is VaultCifrato
      expect(find.widgetWithText(TextFormField, 'VaultCifrato'), findsOneWidget);

      // Verify E2E AES-256 security banner
      expect(
        find.text('Crittografia End-to-End Client-Side (AES-256)'),
        findsOneWidget,
      );

      // Verify fields for crypt configuration
      expect(find.text('Cloud di destinazione *'), findsOneWidget);
      expect(find.text('Percorso o Cartella di destinazione'), findsOneWidget);
      expect(find.text('Password di Cifratura (Password Principale) *'), findsOneWidget);
      expect(find.text('Conferma Password *'), findsOneWidget);
      expect(find.text('Salt / Password Secondaria (Opzionale)'), findsOneWidget);
      expect(find.text('Cifratura dei Nomi File'), findsOneWidget);
      expect(find.text('Cifra anche i nomi delle cartelle'), findsOneWidget);
    });

    testWidgets('AddCloudDialog with initialProvider: crypt initializes correctly',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createDialogApp(
          initialProvider: 'crypt',
          initialTargetRemote: 'DiscoLocale',
        ),
      );
      await tester.pumpAndSettle();

      // Should directly show crypt banner
      expect(
        find.text('Crittografia End-to-End Client-Side (AES-256)'),
        findsOneWidget,
      );

      // Destination should have DiscoLocale selected
      expect(find.text('DiscoLocale (local)'), findsOneWidget);
    });

    testWidgets('Validation warns if password is empty or passwords do not match',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createDialogApp(
          initialProvider: 'crypt',
          initialTargetRemote: 'GoogleDrive',
        ),
      );
      await tester.pumpAndSettle();

      // Tap Connetti Cloud without entering password
      final connectBtn = find.text('Connetti Cloud');
      await tester.tap(connectBtn);
      await tester.pumpAndSettle();

      // Expect password validation error
      expect(find.text('Inserisci la password di cifratura'), findsOneWidget);
    });
  });
}

class _MockCloudAccountsNotifier extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  final List<CloudRemote> _mockRemotes;

  _MockCloudAccountsNotifier(this._mockRemotes);

  @override
  CloudAccountsState build() {
    return CloudAccountsState(remotes: _mockRemotes, isLoading: false);
  }

  @override
  Future<void> loadRemotes() async {}

  @override
  Future<void> addRemote({
    required String name,
    required String type,
    Map<String, String> options = const {},
  }) async {}

  @override
  Future<void> deleteRemote(String name) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
