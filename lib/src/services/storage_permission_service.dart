import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider for [StoragePermissionService].
final storagePermissionServiceProvider = Provider<StoragePermissionService>((ref) {
  return StoragePermissionService();
});

/// Reactive provider tracking whether the app currently has full local file
/// access on Android (`MANAGE_EXTERNAL_STORAGE` on Android 11+, legacy storage
/// permissions on Android 6-10). Always `true` on non-Android platforms.
final storageAccessProvider = NotifierProvider<StorageAccessNotifier, bool>(
  StorageAccessNotifier.new,
);

/// Checks and requests Android All Files Access (`MANAGE_EXTERNAL_STORAGE`) so
/// local storage remotes and sync rules can see files in `/storage/emulated/0`
/// instead of only the directory tree.
class StoragePermissionService {
  StoragePermissionService({
    MethodChannel? channel,
    @visibleForTesting this.isAndroidOverride,
  }) : _channel = channel ??
            const MethodChannel('dev.leonardobani.unifycloud/storage_permission');

  final MethodChannel _channel;
  @visibleForTesting
  final bool Function()? isAndroidOverride;

  bool get _isAndroid => isAndroidOverride?.call() ?? Platform.isAndroid;

  /// Returns `true` if full local storage access is available.
  Future<bool> hasAllFilesAccess() async {
    if (!_isAndroid) return true;
    try {
      final granted = await _channel.invokeMethod<bool>('hasAllFilesAccess');
      return granted ?? false;
    } on MissingPluginException {
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Prompts the user to grant full local storage access (Android Settings
  /// "All files access" on Android 11+, or runtime storage dialog on Android <= 10).
  Future<bool> requestAllFilesAccess() async {
    if (!_isAndroid) return true;
    try {
      final granted = await _channel.invokeMethod<bool>('requestAllFilesAccess');
      return granted ?? false;
    } on MissingPluginException {
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Notifier that keeps [storageAccessProvider] synchronized with Android
/// settings across app lifecycle resumes.
class StorageAccessNotifier extends Notifier<bool> with WidgetsBindingObserver {
  bool _disposed = false;

  @override
  bool build() {
    _disposed = false;
    final service = ref.read(storagePermissionServiceProvider);

    if (service._isAndroid) {
      try {
        final binding = WidgetsBinding.instance;
        binding.addObserver(this);
        ref.onDispose(() {
          _disposed = true;
          binding.removeObserver(this);
        });
      } catch (_) {}

      scheduleMicrotask(refresh);
    } else {
      ref.onDispose(() {
        _disposed = true;
      });
    }

    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  /// Re-checks whether Android full storage access is granted.
  Future<bool> refresh() async {
    if (_disposed) return state;
    final granted =
        await ref.read(storagePermissionServiceProvider).hasAllFilesAccess();
    if (!_disposed && state != granted) {
      state = granted;
    }
    return granted;
  }

  /// Launches the Android storage permission prompt / settings page and updates state.
  Future<bool> requestAccess() async {
    if (_disposed) return state;
    final granted =
        await ref.read(storagePermissionServiceProvider).requestAllFilesAccess();
    if (!_disposed) {
      state = granted;
    }
    return granted;
  }
}
