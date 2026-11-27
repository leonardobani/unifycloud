import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/l10n/app_localizations.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/settings_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/screens/home_screen.dart';
import 'package:unifycloud/src/ui/screens/settings_screen.dart';
import 'package:unifycloud/src/ui/theme/app_theme.dart';
import 'package:unifycloud/src/ui/widgets/breadcrumbs_bar.dart';
import 'package:unifycloud/src/ui/widgets/expandable_error_box.dart';
import 'package:unifycloud/src/ui/widgets/file_type_icon.dart';
import 'package:unifycloud/src/ui/widgets/transfer_panel.dart';

class CloudAccountsMock extends CloudAccountsNotifier {
  CloudAccountsMock(this._initial);
  final CloudAccountsState _initial;

  @override
  CloudAccountsState build() => _initial;
}

class FileExplorerMock extends FileExplorerNotifier {
  FileExplorerMock(this._initial);
  final FileExplorerState _initial;

  @override
  FileExplorerState build() => _initial;
}

class SettingsMock extends SettingsNotifier {
  SettingsMock(this._initial);
  final AppSettings _initial;

  @override
  AppSettings build() => _initial;
}

void main() {
  group('Material 3 Theme Definition Tests', () {
    test('AppTheme.lightTheme follows M3 specifications', () {
      final light = AppTheme.lightTheme;
      expect(light.useMaterial3, isTrue);
      expect(light.brightness, equals(Brightness.light));
      expect(light.scaffoldBackgroundColor, equals(AppTheme.backgroundLight));
      expect(light.cardTheme.color, equals(AppTheme.cardLight));
      expect(light.colorScheme.surface, equals(AppTheme.surfaceLight));
      expect(light.appBarTheme.backgroundColor, equals(AppTheme.backgroundLight));
      expect(light.appBarTheme.foregroundColor, equals(const Color(0xFF1A1C1E)));
      expect(light.dividerTheme.color, equals(AppTheme.borderLight));
    });

    test('AppTheme.darkTheme follows M3 specifications', () {
      final dark = AppTheme.darkTheme;
      expect(dark.useMaterial3, isTrue);
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.scaffoldBackgroundColor, equals(AppTheme.backgroundDark));
      expect(dark.cardTheme.color, equals(AppTheme.cardDark));
      expect(dark.colorScheme.surface, equals(AppTheme.surfaceDark));
      expect(dark.appBarTheme.backgroundColor, equals(AppTheme.backgroundDark));
      expect(dark.dividerTheme.color, equals(AppTheme.borderDark));
    });
  });

  group('Light Theme Widget & Contrast Tests', () {
    testWidgets('HomeScreen renders properly in Light Mode with high contrast text', (tester) async {
      const mockState = CloudAccountsState(
        remotes: [
          CloudRemote(
            name: 'MyDrive',
            type: 'drive',
            quota: StorageQuota(
              total: 15 * 1024 * 1024 * 1024,
              used: 5 * 1024 * 1024 * 1024,
              free: 10 * 1024 * 1024 * 1024,
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(() => CloudAccountsMock(mockState)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Panoramica Storage Aggregato'), findsOneWidget);
      expect(find.text('Account Cloud Collegati: 1'), findsOneWidget);
      expect(find.text('33.3% occupato'), findsOneWidget);
      expect(find.text('MyDrive'), findsOneWidget);

      // Verify available space text is rendered with dark green in light mode
      final freeSpaceText = tester.widget<Text>(find.text('10.0 GB disponibili'));
      expect(freeSpaceText.style?.color, equals(const Color(0xFF1B5E20)));
    });

    testWidgets('FileExplorerScreen empty state is clearly readable in Light Mode', (tester) async {
      const mockState = FileExplorerState(
        currentRemote: 'MyDrive',
        currentPath: 'Documents',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(() => FileExplorerMock(mockState)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const FileExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('This folder is empty'), findsOneWidget);
      final emptyText = tester.widget<Text>(find.text('This folder is empty'));
      expect(emptyText.style?.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });

    testWidgets('SettingsScreen appearance and download texts use onSurfaceVariant in Light Mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              () => SettingsMock(
                const AppSettings(themeMode: ThemeMode.light, language: 'it'),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Aspetto & Tema'), findsOneWidget);
      final subtitle = tester.widget<Text>(
        find.text('Scegli il tema visivo per l\'interfaccia di UnifyCloud:'),
      );
      expect(subtitle.style?.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });

    testWidgets('ExpandableErrorBox text is high contrast in Light Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ExpandableErrorBox(error: 'Detailed error trace 403 Forbidden'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);
      final expandText = tester.widget<Text>(find.text('Expand'));
      expect(expandText.style?.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));

      // Expand the box
      await tester.tap(find.byType(ExpandableErrorBox));
      await tester.pumpAndSettle();

      expect(find.text('Collapse'), findsOneWidget);
      final compressedText = tester.widget<Text>(find.text('Collapse'));
      expect(compressedText.style?.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });

    testWidgets('FileTypeIcon generic fallback uses onSurfaceVariant in Light Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: FileTypeIcon(fileName: 'unknown.xyz', isDir: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.insert_drive_file_outlined));
      expect(icon.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });

    testWidgets('BreadcrumbsBar in Light Mode uses M3 theme tokens', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(
              () => FileExplorerMock(
                const FileExplorerState(
                  currentRemote: 'MyDrive',
                  currentPath: 'FolderA/FolderB',
                ),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: BreadcrumbsBar()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      expect(homeIcon.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });

    testWidgets('TransferSheet in Light Mode renders with M3 surfaceContainer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: TransferSheet()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transfer Queue (0)'), findsOneWidget);
      expect(find.text('No recent transfers'), findsOneWidget);
      final subtitle = tester.widget<Text>(find.text('Downloads, uploads, and cloud copies will appear here.'));
      expect(subtitle.style?.color, equals(AppTheme.lightTheme.colorScheme.onSurfaceVariant));
    });
  });
}
