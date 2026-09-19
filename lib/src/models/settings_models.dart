import 'package:flutter/material.dart';

/// Representation of user-configurable application preferences.
class AppSettings {
  final ThemeMode themeMode;
  final bool showHiddenFiles;
  final bool confirmDelete;
  final String? customDownloadPath;
  final int maxConcurrentTransfers;
  final bool dualPaneEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.showHiddenFiles = false,
    this.confirmDelete = true,
    this.customDownloadPath,
    this.maxConcurrentTransfers = 4,
    this.dualPaneEnabled = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? showHiddenFiles,
    bool? confirmDelete,
    String? Function()? customDownloadPath,
    int? maxConcurrentTransfers,
    bool? dualPaneEnabled,
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
        other.dualPaneEnabled == dualPaneEnabled;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        showHiddenFiles,
        confirmDelete,
        customDownloadPath,
        maxConcurrentTransfers,
        dualPaneEnabled,
      );
}

