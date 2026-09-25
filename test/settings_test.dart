import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/l10n/app_localizations.dart';
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
      expect(settings.language, equals('en'));
    });

    test('copyWith updates specified fields correctly', () {
      const settings = AppSettings();
      final updated = settings.copyWith(
        themeMode: ThemeMode.dark,
        showHiddenFiles: true,
        confirmDelete: false,
        customDownloadPath: () => '/home/user/Downloads',
        maxConcurrentTransfers: 8,
        language: 'it',
      );

      expect(updated.themeMode, equals(ThemeMode.dark));
      expect(updated.showHiddenFiles, isTrue);
      expect(updated.confirmDelete, isFalse);
      expect(updated.customDownloadPath, equals('/home/user/Downloads'));
      expect(updated.maxConcurrentTransfers, equals(8));
      expect(updated.language, equals('it'));
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

    test('locale getter dynamically resolves arbitrary language tags (scalable to 10-20 languages)', () {
      expect(const AppSettings(language: 'en').locale, equals(const Locale('en')));
      expect(const AppSettings(language: 'it').locale, equals(const Locale('it')));
      expect(const AppSettings(language: 'es').locale, equals(const Locale('es')));
      expect(const AppSettings(language: 'de').locale, equals(const Locale('de')));
      expect(const AppSettings(language: 'fr').locale, equals(const Locale('fr')));
      expect(const AppSettings(language: 'ja').locale, equals(const Locale('ja')));
      expect(const AppSettings(language: 'pt_BR').locale, equals(const Locale('pt', 'BR')));
      expect(const AppSettings(language: 'zh-CN').locale, equals(const Locale('zh', 'CN')));
      expect(const AppSettings(language: 'system').locale, isNull);
      expect(const AppSettings(language: '').locale, isNull);
    });
  });

  group('SettingsNotifier Tests', () {
    test('setLanguage updates language in state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      await notifier.setLanguage('it');
      expect(container.read(settingsProvider).language, equals('it'));

      await notifier.setLanguage('es');
      expect(container.read(settingsProvider).language, equals('es'));
    });
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
    Widget createSettingsApp({
      AppSettings initialSettings = const AppSettings(language: 'it'),
    }) {
      return ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            () => SettingsNotifier(initialSettings),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final currentSettings = ref.watch(settingsProvider);
            return MaterialApp(
              locale: currentSettings.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const SettingsScreen(),
            );
          },
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
          initialSettings: const AppSettings(
            themeMode: ThemeMode.system,
            language: 'it',
          ),
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
            () => SettingsNotifier(const AppSettings(language: 'it')),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on 'Cambia' button
      await tester.tap(find.text('Cambia'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Cartella Download Predefinita'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);

      // Enter new path
      await tester.enterText(find.byType(TextField), '/home/user/CustomDownloads');
      await tester.pumpAndSettle();

      // Tap Salva
      await tester.tap(find.text('Salva'));
      await tester.pumpAndSettle();

      // Verify dialog closed and customDownloadPath updated
      expect(find.byType(TextField), findsNothing);
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
              const AppSettings(
                language: 'it',
                customDownloadPath: '/custom/existing',
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SettingsScreen(),
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
      expect(find.text('Cartella Download Predefinita'), findsOneWidget);
      expect(container.read(settingsProvider).customDownloadPath, isNull);
    });

    testWidgets('Renders in English by default and switches to Italian',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Default settings (language: 'en')
      await tester.pumpWidget(
        createSettingsApp(initialSettings: const AppSettings()),
      );
      await tester.pumpAndSettle();

      // Verify English Headers & Labels
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance & Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Italiano'), findsOneWidget);
      expect(find.text('Files & Exploration'), findsOneWidget);
      expect(find.text('Community & Support'), findsOneWidget);
      expect(find.text('Security & Encryption'), findsOneWidget);

      // Tap on Italiano segment to switch language
      await tester.tap(find.text('Italiano'));
      await tester.pumpAndSettle();

      // Verify UI immediately re-renders in Italian
      expect(find.text('Impostazioni'), findsOneWidget);
      expect(find.text('Aspetto & Tema'), findsOneWidget);
      expect(find.text('Lingua'), findsOneWidget);
      expect(find.text('File & Esplorazione'), findsOneWidget);
      expect(find.text('Community & Sviluppo'), findsOneWidget);
      expect(find.text('Sicurezza & Cifratura'), findsOneWidget);
    });

    testWidgets('SettingsScreen.getLanguageDisplayName returns proper names across 10-20 languages',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              expect(SettingsScreen.getLanguageDisplayName('en', l10n), equals('English'));
              expect(SettingsScreen.getLanguageDisplayName('it', l10n), equals('Italiano'));
              expect(SettingsScreen.getLanguageDisplayName('system', l10n), equals('System Default'));
              expect(SettingsScreen.getLanguageDisplayName('de', l10n), equals('Deutsch'));
              expect(SettingsScreen.getLanguageDisplayName('es', l10n), equals('Español'));
              expect(SettingsScreen.getLanguageDisplayName('fr', l10n), equals('Français'));
              expect(SettingsScreen.getLanguageDisplayName('ja', l10n), equals('日本語'));
              expect(SettingsScreen.getLanguageDisplayName('zh', l10n), equals('中文'));
              expect(SettingsScreen.getLanguageDisplayName('xyz', l10n), equals('XYZ'));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
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

