import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'src/providers/settings_provider.dart';
import 'src/router/app_router.dart';
import 'src/services/background_service.dart';
import 'src/services/rclone_service.dart';
import 'src/services/secure_config_service.dart';
import 'src/ui/theme/app_theme.dart';
import 'src/ui/widgets/app_lock_gate.dart';
import 'src/utils/token_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize background services (Android foreground & iOS background tasks)
  final backgroundService = AppBackgroundService();
  await backgroundService.initialize();

  // Initialize native Rclone engine and secure configuration bootstrapping
  final rclone = RcloneService();
  final secureConfig = SecureConfigService();

  // Always initialize native Rclone engine first (enables copy_links and memory mode)
  try {
    await rclone.init();
  } catch (_) {}

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
  } catch (_) {}

  runApp(
    ProviderScope(
      overrides: [
        rcloneServiceProvider.overrideWithValue(rclone),
        secureConfigServiceProvider.overrideWithValue(secureConfig),
        appBackgroundServiceProvider.overrideWithValue(backgroundService),
      ],
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

    return MaterialApp.router(
      title: 'UnifyCloud',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
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
