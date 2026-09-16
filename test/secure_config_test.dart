import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/services/oauth_service.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/services/secure_config_service.dart';

void main() {
  group('Fase 4: In-Memory Rclone Configuration & Security Tests', () {
    late RcloneService rcloneService;

    setUp(() async {
      rcloneService = RcloneService();
      await rcloneService.init();
    });

    test('Loads INI configuration string directly into memory (zero disk files)', () async {
      const sampleIni = '''
[test_drive]
type = drive
client_id = fake-client-id
token = {"access_token":"fake_token","token_type":"Bearer"}

[test_sftp]
type = sftp
host = test.example.com
user = testuser
''';

      final remotes = await rcloneService.loadConfigInMemory(sampleIni);
      // ignore: avoid_print
      print('>>> [Security] Loaded in-memory remotes: $remotes');

      expect(remotes, contains('test_drive'));
      expect(remotes, contains('test_sftp'));

      final list = await rcloneService.listRemotes();
      final names = list.map((r) => r.name).toList();
      expect(names, contains('test_drive'));
      expect(names, contains('test_sftp'));
    });

    test('SetRemoteConfig adds or updates a remote in memory dynamically', () async {
      await rcloneService.setRemoteConfig(
        remoteName: 'dynamic_dropbox',
        remoteType: 'dropbox',
        options: {
          'token': '{"access_token":"sl.xyz123","token_type":"bearer"}',
        },
      );

      final remotes = await rcloneService.listRemotes();
      final names = remotes.map((r) => r.name).toList();
      expect(names, contains('dynamic_dropbox'));
    });

    test('ExportConfigInMemory serializes current configuration for encryption', () async {
      final exportedIni = await rcloneService.exportConfigInMemory();
      // ignore: avoid_print
      print('>>> [Security] Exported INI snippet:\n$exportedIni');

      expect(exportedIni, contains('[dynamic_dropbox]'));
      expect(exportedIni, contains('type = dropbox'));
    });

    test('DeleteRemote removes a remote from in-memory config', () async {
      await rcloneService.deleteRemote('dynamic_dropbox');
      final remotes = await rcloneService.listRemotes();
      final names = remotes.map((r) => r.name).toList();
      expect(names, isNot(contains('dynamic_dropbox')));
    });
  });

  group('Fase 4: OAuthService Tests', () {
    final oauthService = OAuthService();

    test('buildAuthUrl generates valid authorization URLs for Google Drive', () {
      final config = OAuthService.supportedProviders['drive']!;
      final url = oauthService.buildAuthUrl(
        config: config,
        clientId: 'my-client-id.apps.googleusercontent.com',
        redirectUri: 'http://localhost:8080/oauth2callback',
        state: 'xyz_state_123',
      );

      expect(url.scheme, equals('https'));
      expect(url.host, equals('accounts.google.com'));
      expect(url.queryParameters['client_id'], equals('my-client-id.apps.googleusercontent.com'));
      expect(url.queryParameters['redirect_uri'], equals('http://localhost:8080/oauth2callback'));
      expect(url.queryParameters['state'], equals('xyz_state_123'));
      expect(url.queryParameters['response_type'], equals('code'));
    });

    test('buildAuthUrl generates valid authorization URLs for OneDrive', () {
      final config = OAuthService.supportedProviders['onedrive']!;
      final url = oauthService.buildAuthUrl(
        config: config,
        clientId: 'onedrive-client-id',
        redirectUri: 'http://localhost:9090/oauth2callback',
      );

      expect(url.host, equals('login.microsoftonline.com'));
      expect(url.queryParameters['client_id'], equals('onedrive-client-id'));
      expect(url.queryParameters['scope'], contains('Files.ReadWrite.All'));
    });
  });

  group('Fase 4: SecureConfigService Unit Tests', () {
    test('SecureConfigService initializes with default secure options', () {
      final service = SecureConfigService();
      expect(service, isNotNull);
    });
  });
}

