import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'src/providers/settings_provider.dart';
import 'src/router/app_router.dart';
import 'src/services/background_service.dart';
import 'src/services/desktop_autostart_service.dart';
import 'src/services/rclone_service.dart';
import 'src/services/secure_config_service.dart';
import 'src/services/tray_service.dart';
import 'src/ui/theme/app_theme.dart';
import 'src/ui/widgets/app_lock_gate.dart';
import 'src/utils/token_utils.dart';

void main([List<String> args = const []]) async {
  WidgetsFlutterBinding.ensureInitialized();

  final startHidden =
      args.contains('--background') || args.contains('--minimized');

  // Initialize background services (Android foreground & iOS background tasks)
  final backgroundService = AppBackgroundService();
  await backgroundService.initialize();

  // Load persisted settings synchronously before building UI so App Lock engages immediately
  const storage = SecureConfigService.defaultStorage;
  final autostartService = DesktopAutostartService();
  final initialSettings = await SettingsNotifier.loadPersistedSettings(
    storage,
    autostartService: autostartService,
  );

  // Initialize native Rclone engine and secure configuration bootstrapping
  final rclone = RcloneService();
  final secureConfig = SecureConfigService(storage);

  // Always initialize native Rclone engine first (enables copy_links and memory mode)
  try {
    await rclone.init();
  } catch (e) {
    debugPrint('[Main] Rclone initialization failed: $e');
  }

  try {
    final savedConfig = await secureConfig.loadEncryptedConfig();
    if (savedConfig != null && savedConfig.trim().isNotEmpty) {
      // Auto-heal any malformed token lines from previous versions
      final sanitized = TokenUtils.sanitizeIniConfig(savedConfig);
      if (sanitized != savedConfig) {
        await secureConfig.saveEncryptedConfig(sanitized);
      }
      // Decrypted configuration injected exclusively into RAM memory
      await rclone.loadConfigInMemory(sanitized);
    }
  } catch (e) {
    debugPrint('[Main] Failed to load secure config: $e');
  }

  final container = ProviderContainer(
    overrides: [
      settingsStorageProvider.overrideWithValue(storage),
      settingsProvider.overrideWith(() => SettingsNotifier(initialSettings)),
      desktopAutostartServiceProvider.overrideWithValue(autostartService),
      rcloneServiceProvider.overrideWithValue(rclone),
      secureConfigServiceProvider.overrideWithValue(secureConfig),
      appBackgroundServiceProvider.overrideWithValue(backgroundService),
    ],
  );

  // Initialize desktop system tray and window lifecycle
  final trayService = container.read(trayServiceProvider);
  if (trayService.isSupported) {
    await trayService.initialize(startHidden: startHidden);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const UnifyCloudApp(),
    ),
  );
}

/// Root widget for the UnifyCloud application.
class UnifyCloudApp extends ConsumerWidget {
  const UnifyCloudApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isCosmic = AppTheme.isCosmicActive(settings.themeStyle);

    return MaterialApp.router(
      title: 'UnifyCloud',
      debugShowCheckedModeBanner: false,
      theme: isCosmic ? AppTheme.cosmicLightTheme : AppTheme.standardLightTheme,
      darkTheme: isCosmic ? AppTheme.cosmicDarkTheme : AppTheme.standardDarkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
      builder: (context, child) =>
          AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
