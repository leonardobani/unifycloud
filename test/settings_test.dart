import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/ui/screens/settings_screen.dart';
import 'package:unifycloud/src/utils/url_utils.dart';

void main() {
  group('AppSettings Model Tests', () {
    test('Default values are correct', () {
      const settings = AppSettings();
      expect(settings.themeMode, equals(ThemeMode.system));
      expect(settings.showHiddenFiles, isFalse);
      expect(settings.confirmDelete, isTrue);
      expect(settings.customDownloadPath, isNull);
      expect(settings.maxConcurrentTransfers, equals(4));
    });

    test('copyWith updates specified fields correctly', () {
      const settings = AppSettings();
      final updated = settings.copyWith(
        themeMode: ThemeMode.dark,
        showHiddenFiles: true,
        confirmDelete: false,
        customDownloadPath: () => '/home/user/Downloads',
        maxConcurrentTransfers: 8,
      );

      expect(updated.themeMode, equals(ThemeMode.dark));
      expect(updated.showHiddenFiles, isTrue);
      expect(updated.confirmDelete, isFalse);
      expect(updated.customDownloadPath, equals('/home/user/Downloads'));
      expect(updated.maxConcurrentTransfers, equals(8));
    });

    test('toJson and fromJson serialize and deserialize accurately', () {
      const settings = AppSettings(
        themeMode: ThemeMode.light,
        showHiddenFiles: true,
        confirmDelete: false,
        customDownloadPath: '/custom/path',
        maxConcurrentTransfers: 2,
      );

      final json = settings.toJson();
      expect(json['theme_mode'], equals('light'));
      expect(json['show_hidden_files'], isTrue);
      expect(json['confirm_delete'], isFalse);
      expect(json['custom_download_path'], equals('/custom/path'));
      expect(json['max_concurrent_transfers'], equals(2));

      final restored = AppSettings.fromJson(json);
      expect(restored, equals(settings));
    });
  });

  group('SettingsNotifier Tests', () {
    test('Initializes with provided settings and mutates state', () async {
      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              const AppSettings(themeMode: ThemeMode.dark),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(settingsProvider).themeMode, equals(ThemeMode.dark));

      final notifier = container.read(settingsProvider.notifier);

      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(settingsProvider).themeMode, equals(ThemeMode.light));

      await notifier.setShowHiddenFiles(true);
      expect(container.read(settingsProvider).showHiddenFiles, isTrue);

      await notifier.setConfirmDelete(false);
      expect(container.read(settingsProvider).confirmDelete, isFalse);

      await notifier.setCustomDownloadPath('/storage/downloads');
      expect(
        container.read(settingsProvider).customDownloadPath,
        equals('/storage/downloads'),
      );

      await notifier.resetToDefaults();
      expect(container.read(settingsProvider).themeMode, equals(ThemeMode.system));
      expect(container.read(settingsProvider).showHiddenFiles, isFalse);
      expect(container.read(settingsProvider).customDownloadPath, isNull);
    });
  });

  group('SettingsScreen Widget Tests', () {
    Widget createSettingsApp({AppSettings initialSettings = const AppSettings()}) {
      return ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(initialSettings),
          ),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      );
    }

    testWidgets('Renders all standard settings sections', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createSettingsApp());
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Impostazioni'), findsOneWidget);

      // Verify Section 1: Aspetto & Tema
      expect(find.text('Aspetto & Tema'), findsOneWidget);
      expect(find.text('Sistema'), findsOneWidget);
      expect(find.text('Chiaro'), findsOneWidget);
      expect(find.text('Scuro'), findsOneWidget);

      // Verify Section 2: File & Esplorazione
      expect(find.text('File & Esplorazione'), findsOneWidget);
      expect(find.text('Mostra elementi nascosti'), findsOneWidget);
      expect(find.text('Conferma prima di eliminare'), findsOneWidget);
      expect(find.text('Cartella Download Predefinita'), findsOneWidget);

      // Verify Section 3: Community & Sviluppo
      expect(find.text('Community & Sviluppo'), findsOneWidget);
      expect(find.text('Sostieni lo Sviluppatore'), findsOneWidget);
      expect(find.text('Vedi Codice su GitLab'), findsOneWidget);

      // Verify Section 4 & 5: Sicurezza e Info
      expect(find.text('Sicurezza & Cifratura'), findsOneWidget);
      expect(find.text('Informazioni su UnifyCloud'), findsOneWidget);
      expect(find.text('Sviluppatore: LeoRise (@leorise25)'), findsOneWidget);
      expect(
        find.text('Licenza: GNU General Public License v3.0 (GPL-3.0)'),
        findsOneWidget,
      );
      expect(find.text('Copyright: © 2026 Leonardo Bani'), findsOneWidget);
    });

    testWidgets('Switching theme mode in SegmentedButton updates selection',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createSettingsApp(
          initialSettings: const AppSettings(themeMode: ThemeMode.system),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on 'Scuro' button
      await tester.tap(find.text('Scuro'));
      await tester.pumpAndSettle();

      final segmented = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(segmented.selected, contains(ThemeMode.dark));
    });

    testWidgets(
        'Tapping "Sostieni lo Sviluppatore" opens donation dialog with platforms',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createSettingsApp());
      await tester.pumpAndSettle();

      // Tap on Sostieni lo Sviluppatore button
      await tester.tap(find.text('Sostieni lo Sviluppatore'));
      await tester.pumpAndSettle();

      // Verify modal dialog appeared
      expect(find.text('Sostieni UnifyCloud'), findsOneWidget);
      expect(find.text('Offri un caffè su Ko-fi'), findsOneWidget);
      expect(find.text('Dona su Liberapay'), findsOneWidget);
      expect(find.text('Donazione via PayPal'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Chiudi'));
      await tester.pumpAndSettle();

      expect(find.text('Sostieni UnifyCloud'), findsNothing);
    });

    testWidgets(
        'Tapping "Cambia" opens download folder dialog and saving updates customDownloadPath',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(const AppSettings()),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on 'Cambia' button
      await tester.tap(find.text('Cambia'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Cartella Download'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter new path
      await tester.enterText(find.byType(TextField), '/home/user/CustomDownloads');
      await tester.pumpAndSettle();

      // Tap Salva
      await tester.tap(find.text('Salva'));
      await tester.pumpAndSettle();

      // Verify dialog closed and customDownloadPath updated
      expect(find.text('Cartella Download'), findsNothing);
      expect(
        container.read(settingsProvider).customDownloadPath,
        equals('/home/user/CustomDownloads'),
      );
    });

    testWidgets(
        'Download folder dialog provides "Ripristina predefinito" to reset path',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(
              const AppSettings(customDownloadPath: '/custom/existing'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Cambia
      await tester.tap(find.text('Cambia'));
      await tester.pumpAndSettle();

      // Tap Ripristina predefinito
      expect(find.text('Ripristina predefinito'), findsOneWidget);
      await tester.tap(find.text('Ripristina predefinito'));
      await tester.pumpAndSettle();

      // Verify dialog closed and customDownloadPath reset to null
      expect(find.text('Cartella Download'), findsNothing);
      expect(container.read(settingsProvider).customDownloadPath, isNull);
    });
  });

  group('UrlUtils Tests', () {
    test('openWebUrl executes safely and returns boolean', () async {
      final res = await UrlUtils.openWebUrl(
        Uri.parse('https://gitlab.com/leorise25/unifycloud'),
      );
      expect(res, isA<bool>());
    });
  });
}

