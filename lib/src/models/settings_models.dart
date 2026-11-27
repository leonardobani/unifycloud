import 'package:material_ui/material_ui.dart';

/// Representation of user-configurable application preferences.
class AppSettings {

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.showHiddenFiles = false,
    this.confirmDelete = true,
    this.customDownloadPath,
    this.maxConcurrentTransfers = 4,
    this.dualPaneEnabled = true,
    this.appLockEnabled = false,
    this.useBiometrics = true,
    this.autoLockTimeoutMinutes = 0,
    this.autostartOnBoot = false,
    this.minimizeToTray = true,
    this.language = 'en',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    ThemeMode mode = ThemeMode.system;
    final themeStr = json['theme_mode'] as String?;
    if (themeStr == 'dark') {
      mode = ThemeMode.dark;
    } else if (themeStr == 'light') {
      mode = ThemeMode.light;
    }

    return AppSettings(
      themeMode: mode,
      showHiddenFiles: json['show_hidden_files'] as bool? ?? false,
      confirmDelete: json['confirm_delete'] as bool? ?? true,
      customDownloadPath: json['custom_download_path'] as String?,
      maxConcurrentTransfers:
          json['max_concurrent_transfers'] as int? ?? 4,
      dualPaneEnabled: json['dual_pane_enabled'] as bool? ?? true,
      appLockEnabled: json['app_lock_enabled'] as bool? ?? false,
      useBiometrics: json['use_biometrics'] as bool? ?? true,
      autoLockTimeoutMinutes:
          json['auto_lock_timeout_minutes'] as int? ?? 0,
      autostartOnBoot: json['autostart_on_boot'] as bool? ?? false,
      minimizeToTray: json['minimize_to_tray'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
    );
  }
  final ThemeMode themeMode;
  final bool showHiddenFiles;
  final bool confirmDelete;
  final String? customDownloadPath;
  final int maxConcurrentTransfers;
  final bool dualPaneEnabled;
  final bool appLockEnabled;
  final bool useBiometrics;
  final int autoLockTimeoutMinutes;
  final bool autostartOnBoot;
  final bool minimizeToTray;
  final String language; // 'en', 'it', 'fr', 'pl', 'es', 'ar', or 'system'

  static const Set<String> supportedLanguageCodes = {
    'en',
    'it',
    'fr',
    'pl',
    'es',
    'ar',
  };

  /// Resolves the configured language to a [Locale], or `null` for system default.
  /// Scalable to any standard language or region tag (e.g. 'en', 'it', 'es', 'zh_CN').
  Locale? get locale {
    if (language == 'system' || language.trim().isEmpty) {
      return null; // Follows system locale
    }
    if (language.contains('_')) {
      final parts = language.split('_');
      return Locale(parts[0], parts[1]);
    }
    if (language.contains('-')) {
      final parts = language.split('-');
      return Locale(parts[0], parts[1]);
    }
    return Locale(language);
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? showHiddenFiles,
    bool? confirmDelete,
    String? Function()? customDownloadPath,
    int? maxConcurrentTransfers,
    bool? dualPaneEnabled,
    bool? appLockEnabled,
    bool? useBiometrics,
    int? autoLockTimeoutMinutes,
    bool? autostartOnBoot,
    bool? minimizeToTray,
    String? language,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
      confirmDelete: confirmDelete ?? this.confirmDelete,
      customDownloadPath: customDownloadPath != null
          ? customDownloadPath()
          : this.customDownloadPath,
      maxConcurrentTransfers:
          maxConcurrentTransfers ?? this.maxConcurrentTransfers,
      dualPaneEnabled: dualPaneEnabled ?? this.dualPaneEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      autoLockTimeoutMinutes:
          autoLockTimeoutMinutes ?? this.autoLockTimeoutMinutes,
      autostartOnBoot: autostartOnBoot ?? this.autostartOnBoot,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode.name,
      'show_hidden_files': showHiddenFiles,
      'confirm_delete': confirmDelete,
      'custom_download_path': customDownloadPath,
      'max_concurrent_transfers': maxConcurrentTransfers,
      'dual_pane_enabled': dualPaneEnabled,
      'app_lock_enabled': appLockEnabled,
      'use_biometrics': useBiometrics,
      'auto_lock_timeout_minutes': autoLockTimeoutMinutes,
      'autostart_on_boot': autostartOnBoot,
      'minimize_to_tray': minimizeToTray,
      'language': language,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.showHiddenFiles == showHiddenFiles &&
        other.confirmDelete == confirmDelete &&
        other.customDownloadPath == customDownloadPath &&
        other.maxConcurrentTransfers == maxConcurrentTransfers &&
        other.dualPaneEnabled == dualPaneEnabled &&
        other.appLockEnabled == appLockEnabled &&
        other.useBiometrics == useBiometrics &&
        other.autoLockTimeoutMinutes == autoLockTimeoutMinutes &&
        other.autostartOnBoot == autostartOnBoot &&
        other.minimizeToTray == minimizeToTray &&
        other.language == language;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        showHiddenFiles,
        confirmDelete,
        customDownloadPath,
        maxConcurrentTransfers,
        dualPaneEnabled,
        appLockEnabled,
        useBiometrics,
        autoLockTimeoutMinutes,
        autostartOnBoot,
        minimizeToTray,
        language,
      );
}
