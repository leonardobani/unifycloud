import 'package:flutter/material.dart';

/// Representation of user-configurable application preferences.
class AppSettings {
  final ThemeMode themeMode;
  final bool showHiddenFiles;
  final bool confirmDelete;
  final String? customDownloadPath;
  final int maxConcurrentTransfers;
  final bool dualPaneEnabled;
  final bool appLockEnabled;
  final bool useBiometrics;
  final int autoLockTimeoutMinutes;

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
  });

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
    };
  }

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
    );
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
        other.autoLockTimeoutMinutes == autoLockTimeoutMinutes;
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
      );
}

