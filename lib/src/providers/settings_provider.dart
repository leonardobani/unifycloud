import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/settings_models.dart';

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

  /// Resets all settings to their default values.
  Future<void> resetToDefaults() async {
    await _persist(const AppSettings());
  }
}

