import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/settings_models.dart';
import '../services/desktop_autostart_service.dart';

/// Provider exposing the persistent [AppSettings] state.
final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// Provider exposing [FlutterSecureStorage] for settings persistence.
final settingsStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
    lOptions: LinuxOptions(),
  );
});

/// Riverpod 3 Notifier managing application settings and persistence.
class SettingsNotifier extends Notifier<AppSettings> {
  static const String settingsStorageKey = 'unifycloud_settings_v1';
  final AppSettings? _initialSettings;

  SettingsNotifier([this._initialSettings]);

  FlutterSecureStorage get _storage => ref.read(settingsStorageProvider);

  @override
  AppSettings build() {
    final initial = _initialSettings ?? const AppSettings();
    scheduleMicrotask(() => _loadFromStorage());
    return initial;
  }

  /// Loads saved settings from persistent storage.
  Future<void> _loadFromStorage() async {
    try {
      final rawJson = await _storage.read(key: settingsStorageKey);
      if (rawJson != null && rawJson.trim().isNotEmpty) {
        final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
        state = AppSettings.fromJson(decoded);
      }
    } catch (_) {
      // Fallback to default state on parse error
    }

    try {
      final autostartService = ref.read(desktopAutostartServiceProvider);
      if (autostartService.isSupported) {
        final isActuallyEnabled = await autostartService.isAutostartEnabled();
        if (state.autostartOnBoot != isActuallyEnabled) {
          state = state.copyWith(autostartOnBoot: isActuallyEnabled);
        }
      }
    } catch (_) {}
  }

  /// Persists current settings to secure storage.
  Future<void> _persist(AppSettings newSettings) async {
    state = newSettings;
    try {
      final jsonString = jsonEncode(newSettings.toJson());
      await _storage.write(key: settingsStorageKey, value: jsonString);
    } catch (_) {}
  }

  /// Changes the application theme mode (system, light, dark).
  Future<void> setThemeMode(ThemeMode mode) async {
    await _persist(state.copyWith(themeMode: mode));
  }

  /// Changes the application visual theme style (auto, standard, cosmic).
  Future<void> setThemeStyle(AppThemeStyle style) async {
    await _persist(state.copyWith(themeStyle: style));
  }

  /// Toggles visibility of hidden files and directories.
  Future<void> setShowHiddenFiles(bool show) async {
    await _persist(state.copyWith(showHiddenFiles: show));
  }

  /// Toggles confirmation prompt before deleting files.
  Future<void> setConfirmDelete(bool confirm) async {
    await _persist(state.copyWith(confirmDelete: confirm));
  }

  /// Updates or clears the custom download path.
  Future<void> setCustomDownloadPath(String? path) async {
    await _persist(
      state.copyWith(
        customDownloadPath: () => (path != null && path.trim().isNotEmpty)
            ? path.trim()
            : null,
      ),
    );
  }

  /// Updates maximum concurrent background transfers.
  Future<void> setMaxConcurrentTransfers(int max) async {
    await _persist(state.copyWith(maxConcurrentTransfers: max));
  }

  /// Updates preference for dual-pane view on wide screens.
  Future<void> setDualPaneEnabled(bool enabled) async {
    await _persist(state.copyWith(dualPaneEnabled: enabled));
  }

  /// Enables or disables App Lock (Biometrics/PIN).
  Future<void> setAppLockEnabled(bool enabled) async {
    await _persist(state.copyWith(appLockEnabled: enabled));
  }

  /// Enables or disables Biometric authentication fallback for App Lock.
  Future<void> setUseBiometrics(bool use) async {
    await _persist(state.copyWith(useBiometrics: use));
  }

  /// Updates inactivity auto-lock timeout in minutes (0 = immediately).
  Future<void> setAutoLockTimeoutMinutes(int minutes) async {
    await _persist(state.copyWith(autoLockTimeoutMinutes: minutes));
  }

  /// Enables or disables automatic startup on system boot (Linux XDG autostart).
  Future<void> setAutostartOnBoot(bool enabled) async {
    await _persist(state.copyWith(autostartOnBoot: enabled));
    try {
      await ref.read(desktopAutostartServiceProvider).setAutostartEnabled(enabled);
    } catch (_) {}
  }

  /// Enables or disables running in the background / minimizing to tray.
  Future<void> setMinimizeToTray(bool enabled) async {
    await _persist(state.copyWith(minimizeToTray: enabled));
  }

  /// Changes the application language ('en', 'it', 'system').
  Future<void> setLanguage(String lang) async {
    await _persist(state.copyWith(language: lang));
  }

  /// Resets all settings to their default values.
  Future<void> resetToDefaults() async {
    await _persist(const AppSettings());
  }
}

