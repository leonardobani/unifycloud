import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Riverpod provider for [SecureConfigService].
final secureConfigServiceProvider = Provider<SecureConfigService>((ref) {
  return SecureConfigService();
});

/// Service responsible for managing encrypted credentials and configurations
/// in native Keychains/Keystores without writing plaintext files to disk.
class SecureConfigService {
  final FlutterSecureStorage _storage;
  static const String _configKey = 'unifycloud_rclone_config_encrypted';

  SecureConfigService([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
              mOptions: MacOsOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
              lOptions: LinuxOptions(),
            );

  /// Saves the complete Rclone INI configuration into encrypted secure storage.
  Future<void> saveEncryptedConfig(String configContent) async {
    await _storage.write(key: _configKey, value: configContent);
  }

  /// Loads the decrypted Rclone INI configuration from secure storage.
  ///
  /// Returns `null` if no configuration has been stored yet.
  Future<String?> loadEncryptedConfig() async {
    return await _storage.read(key: _configKey);
  }

  /// Checks if an encrypted configuration already exists.
  Future<bool> hasSavedConfig() async {
    return await _storage.containsKey(key: _configKey);
  }

  /// Deletes the encrypted configuration from secure storage (e.g. on logout/reset).
  Future<void> clearConfig() async {
    await _storage.delete(key: _configKey);
  }
}
