import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../providers/settings_provider.dart';

/// Provider exposing [AppLockService].
final appLockServiceProvider = Provider<AppLockService>((ref) {
  final storage = ref.watch(settingsStorageProvider);
  return AppLockService(
    storage: storage,
    localAuth: LocalAuthentication(),
  );
});

/// Service managing biometric authentication via [LocalAuthentication] and secure PIN storage.
class AppLockService {
  static const String pinStorageKey = 'unifycloud_app_pin_v1';

  final FlutterSecureStorage storage;
  final LocalAuthentication _localAuth;

  FlutterSecureStorage get _storage => storage;

  AppLockService({
    required this.storage,
    LocalAuthentication? localAuth,
  })  : _localAuth = localAuth ?? LocalAuthentication();

  /// Checks if biometrics are supported and can be checked on this device.
  Future<bool> canCheckBiometrics() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) return false;
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Returns list of available biometric types (e.g. fingerprint, face, weak, strong).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return const [];
    }
  }

  /// Prompts the user with the native biometric dialog (fingerprint, face unlock).
  Future<bool> authenticateWithBiometrics({
    String reason = 'Autenticati per sbloccare UnifyCloud',
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;

      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Checks if a PIN has been set and saved in secure storage.
  Future<bool> hasPin() async {
    try {
      final pin = await _storage.read(key: pinStorageKey);
      return pin != null && pin.trim().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Saves a 6-digit PIN in secure storage.
  Future<void> savePin(String pin) async {
    final cleanPin = pin.trim();
    if (cleanPin.length != 6) {
      throw ArgumentError('Il PIN deve essere esattamente di 6 cifre');
    }
    await _storage.write(key: pinStorageKey, value: cleanPin);
  }

  /// Verifies if the provided PIN matches the saved PIN in secure storage.
  Future<bool> verifyPin(String pin) async {
    try {
      final savedPin = await _storage.read(key: pinStorageKey);
      if (savedPin == null || savedPin.isEmpty) return false;
      return savedPin.trim() == pin.trim();
    } catch (_) {
      return false;
    }
  }

  /// Clears the saved PIN from secure storage.
  Future<void> clearPin() async {
    try {
      await _storage.delete(key: pinStorageKey);
    } catch (_) {}
  }
}
