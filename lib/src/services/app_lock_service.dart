import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
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

/// Service managing biometric authentication via [LocalAuthentication] and hashed PIN storage.
class AppLockService {

  AppLockService({
    required this.storage,
    LocalAuthentication? localAuth,
  }) : _localAuth = localAuth ?? LocalAuthentication();
  static const String pinStorageKey = 'unifycloud_app_pin_v1';
  static const String _hashPrefix = 'pbkdf2_sha256';
  static const int _pbkdf2Iterations = 100000;
  static const int _saltBytes = 16;
  static const int _keyLength = 32;

  final FlutterSecureStorage storage;
  final LocalAuthentication _localAuth;

  FlutterSecureStorage get _storage => storage;

  static Uint8List _pbkdf2HmacSha256(
    String pin,
    List<int> salt,
    int iterations,
    int keyLength,
  ) {
    final hmac = Hmac(sha256, utf8.encode(pin));
    final blockCount = (keyLength + 31) ~/ 32;
    final output = BytesBuilder();

    for (var block = 1; block <= blockCount; block++) {
      final blockBytes = Uint8List(salt.length + 4)
        ..setAll(0, salt)
        ..buffer.asByteData().setUint32(salt.length, block);

      var u = Uint8List.fromList(hmac.convert(blockBytes).bytes);
      final t = Uint8List.fromList(u);

      for (var i = 1; i < iterations; i++) {
        u = Uint8List.fromList(hmac.convert(u).bytes);
        for (var j = 0; j < t.length; j++) {
          t[j] ^= u[j];
        }
      }
      output.add(t);
    }

    return Uint8List.sublistView(output.toBytes(), 0, keyLength);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static String _hashPin(String pin) {
    final rng = Random.secure();
    final salt = List<int>.generate(_saltBytes, (_) => rng.nextInt(256));
    final derived = _pbkdf2HmacSha256(pin, salt, _pbkdf2Iterations, _keyLength);
    return '$_hashPrefix\$$_pbkdf2Iterations\$${base64Encode(salt)}\$${base64Encode(derived)}';
  }

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
    String reason = 'Authenticate to access UnifyCloud',
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

  /// Saves a salted PBKDF2-HMAC-SHA256 hash of a 6-digit PIN in secure storage.
  Future<void> savePin(String pin) async {
    final cleanPin = pin.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(cleanPin)) {
      throw ArgumentError('PIN must be exactly 6 digits');
    }
    await _storage.write(key: pinStorageKey, value: _hashPin(cleanPin));
  }

  /// Verifies if the provided PIN matches the saved hash in secure storage.
  Future<bool> verifyPin(String pin) async {
    try {
      final cleanInput = pin.trim();
      if (!RegExp(r'^\d{6}$').hasMatch(cleanInput)) return false;

      final saved = await _storage.read(key: pinStorageKey);
      if (saved == null || saved.isEmpty) return false;

      final parts = saved.split(r'$');
      if (parts.length == 4 && parts[0] == _hashPrefix) {
        final iterations = int.tryParse(parts[1]);
        if (iterations == null || iterations <= 0) return false;
        final salt = base64Decode(parts[2]);
        final expectedHash = base64Decode(parts[3]);
        final actualHash = _pbkdf2HmacSha256(
          cleanInput,
          salt,
          iterations,
          expectedHash.length,
        );
        return _constantTimeEquals(actualHash, expectedHash);
      }

      // Legacy plaintext PIN fallback: verify in constant time and migrate to hashed format.
      final matched = _constantTimeEquals(
        utf8.encode(saved.trim()),
        utf8.encode(cleanInput),
      );
      if (matched) {
        await savePin(cleanInput);
      }
      return matched;
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
