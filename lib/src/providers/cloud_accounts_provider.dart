import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cloud_models.dart';
import '../services/rclone_service.dart';
import '../services/secure_config_service.dart';
import '../utils/token_utils.dart';

/// State for configured cloud accounts.
class CloudAccountsState {
  final bool isLoading;
  final String? error;
  final List<CloudRemote> remotes;

  const CloudAccountsState({
    this.isLoading = false,
    this.error,
    this.remotes = const [],
  });

  CloudAccountsState copyWith({
    bool? isLoading,
    String? error,
    List<CloudRemote>? remotes,
  }) {
    return CloudAccountsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remotes: remotes ?? this.remotes,
    );
  }
}

/// Notifier managing connected cloud storage accounts in Riverpod 3.
class CloudAccountsNotifier extends Notifier<CloudAccountsState> {
  RcloneService get _rcloneService => ref.read(rcloneServiceProvider);
  SecureConfigService get _secureConfigService =>
      ref.read(secureConfigServiceProvider);

  @override
  CloudAccountsState build() {
    scheduleMicrotask(() => loadRemotes());
    return const CloudAccountsState(isLoading: true);
  }

  /// Refreshes the list of remotes from the Go core.
  Future<void> loadRemotes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Auto-heal any malformed token lines in memory and persistent storage
      try {
        final currentIni = await _rcloneService.exportConfigInMemory();
        final sanitized = TokenUtils.sanitizeIniConfig(currentIni);
        if (sanitized != currentIni) {
          await _rcloneService.loadConfigInMemory(sanitized);
          await _secureConfigService.saveEncryptedConfig(sanitized);
        }
      } catch (_) {}

      final list = await _rcloneService.listRemotes();
      state = state.copyWith(isLoading: false, remotes: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Adds a new remote directly in RAM and persists the encrypted configuration.
  Future<void> addRemote({
    required String name,
    required String type,
    Map<String, String> options = const {},
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sanitizedOptions = Map<String, String>.from(options);
      if (sanitizedOptions.containsKey('token')) {
        sanitizedOptions['token'] =
            TokenUtils.normalizeTokenJson(sanitizedOptions['token']!);
      }

      await _rcloneService.setRemoteConfig(
        remoteName: name,
        remoteType: type,
        options: sanitizedOptions,
      );

      // Export updated configuration from RAM and save to secure storage
      final exportedIni = await _rcloneService.exportConfigInMemory();
      await _secureConfigService.saveEncryptedConfig(exportedIni);

      final list = await _rcloneService.listRemotes();
      state = state.copyWith(isLoading: false, remotes: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Removes a remote from RAM and updates encrypted secure storage.
  Future<void> deleteRemote(String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _rcloneService.deleteRemote(name);
      final exportedIni = await _rcloneService.exportConfigInMemory();
      await _secureConfigService.saveEncryptedConfig(exportedIni);

      final list = await _rcloneService.listRemotes();
      state = state.copyWith(isLoading: false, remotes: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

/// Provider for [CloudAccountsNotifier].
final cloudAccountsProvider =
    NotifierProvider<CloudAccountsNotifier, CloudAccountsState>(
  CloudAccountsNotifier.new,
);
