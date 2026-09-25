import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:unifycloud/l10n/app_localizations.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/providers/app_lock_provider.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/services/app_lock_service.dart';
import 'package:unifycloud/src/ui/screens/settings_screen.dart';
import 'package:unifycloud/src/ui/widgets/app_lock_gate.dart';
import 'package:unifycloud/src/ui/widgets/app_lock_screen.dart';
import 'package:unifycloud/src/ui/widgets/pin_setup_dialog.dart';

/// In-memory fake implementation of [FlutterSecureStorage].
class FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _data = {};

  FakeSecureStorage([Map<String, String>? initialData]) {
    if (initialData != null) {
      _data.addAll(initialData);
    }
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _data[key];
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.clear();
  }
}

/// Fake implementation of [LocalAuthentication].
class FakeLocalAuthentication extends LocalAuthentication {
  final bool isSupported;
  final bool canCheck;
  final List<BiometricType> biometrics;
  final bool authResult;

  FakeLocalAuthentication({
    this.isSupported = true,
    this.canCheck = true,
    this.biometrics = const [BiometricType.fingerprint],
    this.authResult = true,
  });

  @override
  Future<bool> isDeviceSupported() async => isSupported;

  @override
  Future<bool> get canCheckBiometrics async => canCheck;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => biometrics;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<Object?> authMessages = const [],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async => authResult;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettings App Lock Model Tests', () {
    test('Default values for App Lock are correct', () {
      const settings = AppSettings();
      expect(settings.appLockEnabled, isFalse);
      expect(settings.useBiometrics, isTrue);
      expect(settings.autoLockTimeoutMinutes, equals(0));
    });

    test('copyWith updates App Lock fields correctly', () {
      const settings = AppSettings();
      final updated = settings.copyWith(
        appLockEnabled: true,
        useBiometrics: false,
        autoLockTimeoutMinutes: 15,
      );

      expect(updated.appLockEnabled, isTrue);
      expect(updated.useBiometrics, isFalse);
      expect(updated.autoLockTimeoutMinutes, equals(15));
    });

    test('toJson and fromJson serialize and deserialize App Lock fields', () {
      const settings = AppSettings(
        appLockEnabled: true,
        useBiometrics: false,
        autoLockTimeoutMinutes: 5,
      );

      final json = settings.toJson();
      expect(json['app_lock_enabled'], isTrue);
      expect(json['use_biometrics'], isFalse);
      expect(json['auto_lock_timeout_minutes'], equals(5));

      final restored = AppSettings.fromJson(json);
      expect(restored.appLockEnabled, isTrue);
      expect(restored.useBiometrics, isFalse);
      expect(restored.autoLockTimeoutMinutes, equals(5));
      expect(restored, equals(settings));
    });
  });

  group('AppLockService Tests', () {
    late FakeSecureStorage fakeStorage;
    late FakeLocalAuthentication fakeAuth;
    late AppLockService service;

    setUp(() {
      fakeStorage = FakeSecureStorage();
      fakeAuth = FakeLocalAuthentication();
      service = AppLockService(
        storage: fakeStorage,
        localAuth: fakeAuth,
      );
    });

    test('hasPin returns false when no PIN is saved', () async {
      expect(await service.hasPin(), isFalse);
    });

    test('savePin saves 6-digit PIN and hasPin returns true', () async {
      await service.savePin('123456');
      expect(await service.hasPin(), isTrue);
      expect(await service.verifyPin('123456'), isTrue);
      expect(await service.verifyPin('999999'), isFalse);
    });

    test('savePin rejects invalid PIN lengths (!= 6)', () async {
      expect(() => service.savePin('12'), throwsArgumentError);
      expect(() => service.savePin('1234'), throwsArgumentError);
      expect(() => service.savePin('1234567'), throwsArgumentError);
    });

    test('clearPin deletes the saved PIN', () async {
      await service.savePin('654321');
      expect(await service.hasPin(), isTrue);

      await service.clearPin();
      expect(await service.hasPin(), isFalse);
    });

    test('canCheckBiometrics delegates to LocalAuthentication', () async {
      expect(await service.canCheckBiometrics(), isTrue);
      expect(await service.getAvailableBiometrics(), equals([BiometricType.fingerprint]));
      expect(await service.authenticateWithBiometrics(), isTrue);
    });
  });

  group('AppLockNotifier Tests', () {
    test('Initializes unlocked when appLockEnabled is false', () async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings(appLockEnabled: false)),
          ),
          appLockServiceProvider.overrideWithValue(
            AppLockService(storage: fakeStorage, localAuth: fakeAuth),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(appLockProvider);
      expect(state.isLocked, isFalse);
    });

    test('Initializes locked when appLockEnabled is true', () async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings(appLockEnabled: true)),
          ),
          appLockServiceProvider.overrideWithValue(
            AppLockService(storage: fakeStorage, localAuth: fakeAuth),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(appLockProvider);
      expect(state.isLocked, isTrue);
    });

    test('lock and unlock mutate state', () async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings(appLockEnabled: false)),
          ),
          appLockServiceProvider.overrideWithValue(
            AppLockService(storage: fakeStorage, localAuth: fakeAuth),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      expect(container.read(appLockProvider).isLocked, isFalse);

      notifier.lock();
      expect(container.read(appLockProvider).isLocked, isTrue);

      notifier.unlock();
      expect(container.read(appLockProvider).isLocked, isFalse);
    });

    test('verifyPin unlocks on valid PIN and reports error on invalid PIN', () async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();
      final service = AppLockService(storage: fakeStorage, localAuth: fakeAuth);
      await service.savePin('654321');

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings(appLockEnabled: true)),
          ),
          appLockServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      expect(container.read(appLockProvider).isLocked, isTrue);

      // Wrong PIN
      final wrongResult = await notifier.verifyPin('000000');
      expect(wrongResult, isFalse);
      expect(container.read(appLockProvider).isLocked, isTrue);
      expect(container.read(appLockProvider).errorMessage, contains('PIN errato'));

      // Correct PIN
      final rightResult = await notifier.verifyPin('654321');
      expect(rightResult, isTrue);
      expect(container.read(appLockProvider).isLocked, isFalse);
      expect(container.read(appLockProvider).errorMessage, isNull);
    });

    test('auto-lock triggers on resume when elapsed time exceeds timeout', () async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              const AppSettings(
                appLockEnabled: true,
                autoLockTimeoutMinutes: 0, // Immediately
              ),
            ),
          ),
          appLockServiceProvider.overrideWithValue(
            AppLockService(storage: fakeStorage, localAuth: fakeAuth),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();
      expect(container.read(appLockProvider).isLocked, isFalse);

      // App goes to background
      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(container.read(appLockProvider).lastPausedAt, isNotNull);

      // App returns to foreground
      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(container.read(appLockProvider).isLocked, isTrue);
    });
  });

  group('AppLockGate & AppLockScreen Widget Tests', () {
    testWidgets('AppLockGate renders child when unlocked', (tester) async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(const AppSettings(appLockEnabled: false)),
            ),
            appLockServiceProvider.overrideWithValue(
              AppLockService(storage: fakeStorage, localAuth: fakeAuth),
            ),
          ],
          child: const MaterialApp(
            home: AppLockGate(
              child: Scaffold(
                body: Text('Protected App Content'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Protected App Content'), findsOneWidget);
      expect(find.byType(AppLockScreen), findsNothing);
    });

    testWidgets('AppLockGate renders AppLockScreen when locked', (tester) async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(const AppSettings(appLockEnabled: true)),
            ),
            appLockServiceProvider.overrideWithValue(
              AppLockService(storage: fakeStorage, localAuth: fakeAuth),
            ),
          ],
          child: const MaterialApp(
            home: AppLockGate(
              child: Scaffold(
                body: Text('Protected App Content'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Protected App Content'), findsNothing);
      expect(find.byType(AppLockScreen), findsOneWidget);
      expect(find.text('UnifyCloud'), findsOneWidget);
      expect(find.text('Applicazione bloccata'), findsOneWidget);
    });

    testWidgets('AppLockScreen entering digits and backspace updates PIN dots',
        (tester) async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication(authResult: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(const AppSettings(appLockEnabled: true)),
            ),
            appLockServiceProvider.overrideWithValue(
              AppLockService(storage: fakeStorage, localAuth: fakeAuth),
            ),
          ],
          child: const MaterialApp(
            home: AppLockScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap digits '1', '2', '3'
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();

      // Tap backspace
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();
    });

    testWidgets('AppLockScreen unlocks when entering correct PIN', (tester) async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication(authResult: false);
      final service = AppLockService(storage: fakeStorage, localAuth: fakeAuth);
      await service.savePin('123456');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(const AppSettings(appLockEnabled: true)),
            ),
            appLockServiceProvider.overrideWithValue(service),
          ],
          child: const MaterialApp(
            home: AppLockGate(
              child: Scaffold(
                body: Text('Unlocked Dashboard'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(AppLockScreen), findsOneWidget);

      // Enter '1', '2', '3', '4', '5', '6'
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('6'));
      await tester.pumpAndSettle();

      // Should now be unlocked
      expect(find.text('Unlocked Dashboard'), findsOneWidget);
      expect(find.byType(AppLockScreen), findsNothing);
    });
  });

  group('PinSetupDialog Widget Tests', () {
    testWidgets('PinSetupDialog setup mode requires confirmation and matching PIN',
        (tester) async {
      String? savedPin;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => PinSetupDialog(
                      mode: PinDialogMode.setup,
                      onSaveNewPin: (pin) async {
                        savedPin = pin;
                      },
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Imposta Codice PIN'), findsOneWidget);

      // Enter '123456' on step 1
      for (var d in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }

      await tester.tap(find.text('Continua'));
      await tester.pumpAndSettle();

      // Step 2: Confirm
      expect(find.text('Conferma Codice PIN'), findsOneWidget);

      // Enter mismatched PIN '111111'
      for (var d in ['1', '1', '1', '1', '1', '1']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }

      await tester.tap(find.text('Conferma'));
      await tester.pumpAndSettle();

      expect(find.text('I codici PIN non corrispondono. Riprova.'), findsOneWidget);

      // Now enter matching PIN '123456'
      for (var d in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }

      await tester.tap(find.text('Conferma'));
      await tester.pumpAndSettle();

      expect(savedPin, equals('123456'));
      expect(find.byType(PinSetupDialog), findsNothing);
    });
  });

  group('SettingsScreen App Lock UI Tests', () {
    testWidgets('SettingsScreen displays App Lock toggle and controls',
        (tester) async {
      final fakeStorage = FakeSecureStorage();
      final fakeAuth = FakeLocalAuthentication();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsNotifier(
                const AppSettings(
                  appLockEnabled: true,
                  useBiometrics: true,
                  autoLockTimeoutMinutes: 5,
                  language: 'it',
                ),
              ),
            ),
            appLockServiceProvider.overrideWithValue(
              AppLockService(storage: fakeStorage, localAuth: fakeAuth),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to security card
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Blocco Applicazione (PIN / Biometria)'), findsOneWidget);
      expect(find.text('Cambia Codice PIN'), findsOneWidget);
      expect(find.text('Autenticazione Biometrica'), findsOneWidget);
      expect(find.text('Blocco Automatico'), findsOneWidget);
      expect(find.text('Dopo 5 minuti'), findsOneWidget);
    });
  });
}
