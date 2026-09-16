import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Riverpod provider for [OAuthService].
final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});

/// Definition of OAuth configuration for a supported cloud provider.
class OAuthProviderConfig {
  final String providerType;
  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String defaultClientId;
  final String? defaultClientSecret;
  final List<String> scopes;

  const OAuthProviderConfig({
    required this.providerType,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.defaultClientId,
    this.defaultClientSecret,
    required this.scopes,
  });
}

/// Service that handles OAuth2 authorization flows for Cloud Storage providers.
class OAuthService {
  final http.Client _httpClient;

  OAuthService([http.Client? httpClient]) : _httpClient = httpClient ?? http.Client();

  /// Official built-in Rclone OAuth2 credentials for Google Drive.
  static const String rcloneDriveClientId =
      '202264815644.apps.googleusercontent.com';
  static const String rcloneDriveClientSecret =
      'X4Z3ca8xfWDb1Voo-F9a7ZxJ';

  /// Official built-in Rclone OAuth2 credentials for Dropbox.
  static const String rcloneDropboxClientId = '5jcck7diasz0rqy';

  /// Official built-in Rclone OAuth2 credentials for Microsoft OneDrive.
  static const String rcloneOneDriveClientId =
      'b15665d9-eda6-4092-8539-0eec376afd59';

  static const Map<String, OAuthProviderConfig> supportedProviders = {
    'drive': OAuthProviderConfig(
      providerType: 'drive',
      authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
      tokenEndpoint: 'https://oauth2.googleapis.com/token',
      defaultClientId: rcloneDriveClientId,
      defaultClientSecret: rcloneDriveClientSecret,
      scopes: [
        'https://www.googleapis.com/auth/drive',
      ],
    ),
    'dropbox': OAuthProviderConfig(
      providerType: 'dropbox',
      authorizationEndpoint: 'https://www.dropbox.com/oauth2/authorize',
      tokenEndpoint: 'https://api.dropboxapi.com/oauth2/token',
      defaultClientId: rcloneDropboxClientId,
      scopes: [],
    ),
    'onedrive': OAuthProviderConfig(
      providerType: 'onedrive',
      authorizationEndpoint:
          'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
      tokenEndpoint:
          'https://login.microsoftonline.com/common/oauth2/v2.0/token',
      defaultClientId: rcloneOneDriveClientId,
      scopes: ['Files.ReadWrite.All', 'offline_access'],
    ),
  };

  /// Returns the default Rclone client ID for [providerType], if available.
  static String? getRcloneClientId(String providerType) {
    final cfg = supportedProviders[providerType];
    return (cfg != null && cfg.defaultClientId.isNotEmpty)
        ? cfg.defaultClientId
        : null;
  }

  /// Returns the default Rclone client secret for [providerType], if available.
  static String? getRcloneClientSecret(String providerType) {
    final cfg = supportedProviders[providerType];
    return cfg?.defaultClientSecret;
  }

  /// Constructs the authorization URL for the chosen cloud provider.
  Uri buildAuthUrl({
    required OAuthProviderConfig config,
    required String clientId,
    required String redirectUri,
    String state = '',
  }) {
    final queryParams = {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      if (config.scopes.isNotEmpty) 'scope': config.scopes.join(' '),
      if (state.isNotEmpty) 'state': state,
      'access_type': 'offline',
      'prompt': 'consent',
    };

    return Uri.parse(config.authorizationEndpoint).replace(
      queryParameters: queryParams,
    );
  }

  /// Safely attempts to open a URL in the browser across desktop and mobile.
  /// Falls back through multiple strategies (LaunchMode.externalApplication,
  /// LaunchMode.platformDefault, xdg-open, flatpak-spawn, gio, open, explorer.exe).
  Future<bool> openBrowser(Uri url) async {
    // 1. Try url_launcher with externalApplication
    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        return true;
      }
    } catch (_) {}

    // 2. Try url_launcher with platformDefault
    try {
      if (await launchUrl(url, mode: LaunchMode.platformDefault)) {
        return true;
      }
    } catch (_) {}

    // 3. System process fallbacks on desktop / container environments
    if (Platform.isLinux) {
      // Direct xdg-open (or Distrobox / host wrapper)
      try {
        final res = await Process.run('xdg-open', [url.toString()]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // flatpak-spawn --host xdg-open (Flatpak / OSTree environments)
      try {
        final res = await Process.run('flatpak-spawn', [
          '--host',
          'xdg-open',
          url.toString(),
        ]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // gio open
      try {
        final res = await Process.run('gio', ['open', url.toString()]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    } else if (Platform.isMacOS) {
      try {
        final res = await Process.run('open', [url.toString()]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    } else if (Platform.isWindows) {
      try {
        final res = await Process.run('explorer.exe', [url.toString()]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    }

    return false;
  }

  /// Initiates interactive OAuth2 authorization:
  /// 1. Spawns an ephemeral local loopback HTTP server.
  /// 2. Opens the provider's consent page in the user's browser (or provides manual URL fallback).
  /// 3. Intercepts the authorization code callback.
  /// 4. Exchanges the code for access/refresh tokens.
  Future<Map<String, dynamic>> authenticate({
    required String providerType,
    required String clientId,
    String? clientSecret,
    void Function(Uri authUrl, bool browserOpened)? onAuthUrlReady,
    Duration timeout = const Duration(minutes: 3),
  }) async {
    final config = supportedProviders[providerType];
    if (config == null) {
      throw UnsupportedError('Unsupported OAuth provider: $providerType');
    }

    // 1. Start ephemeral loopback server on localhost with random free port
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final redirectUri = 'http://localhost:${server.port}/oauth2callback';
    final state = DateTime.now().millisecondsSinceEpoch.toString();

    final authUrl = buildAuthUrl(
      config: config,
      clientId: clientId,
      redirectUri: redirectUri,
      state: state,
    );

    // 2. Attempt to launch authorization page in browser using resilient fallback chain
    final launched = await openBrowser(authUrl);

    // Notify caller with generated URL and browser launch status
    onAuthUrlReady?.call(authUrl, launched);

    // 3. Wait for HTTP redirect callback
    final completer = Completer<String>();

    final sub = server.listen((HttpRequest request) async {
      final uri = request.uri;
      if (uri.path == '/oauth2callback') {
        final code = uri.queryParameters['code'];
        final returnedState = uri.queryParameters['state'];
        final error = uri.queryParameters['error'];

        request.response.headers.contentType = ContentType.html;
        if (code != null && (state.isEmpty || returnedState == state)) {
          request.response.write('''
<!DOCTYPE html>
<html>
<head><title>UnifyCloud - Autenticato</title></head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>Autenticazione riuscita! &#x2705;</h2>
  <p>Puoi chiudere questa scheda e tornare all'applicazione <strong>UnifyCloud</strong>.</p>
</body>
</html>
''');
          await request.response.close();
          completer.complete(code);
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.write('''
<!DOCTYPE html>
<html>
<head><title>UnifyCloud - Errore</title></head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>Errore di autenticazione &#x274C;</h2>
  <p>${error ?? 'Codice di autorizzazione non valido.'}</p>
</body>
</html>
''');
          await request.response.close();
          completer.completeError(
            Exception('OAuth authorization failed: $error'),
          );
        }
      }
    });

    try {
      final code = await completer.future.timeout(timeout);
      await sub.cancel();
      await server.close(force: true);

      // 4. Exchange authorization code for token
      return await exchangeCodeForTokens(
        config: config,
        clientId: clientId,
        clientSecret: clientSecret,
        code: code,
        redirectUri: redirectUri,
      );
    } catch (e) {
      await sub.cancel();
      await server.close(force: true);
      rethrow;
    }
  }

  /// Exchanges an authorization code for access and refresh tokens.
  Future<Map<String, dynamic>> exchangeCodeForTokens({
    required OAuthProviderConfig config,
    required String clientId,
    String? clientSecret,
    required String code,
    required String redirectUri,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(config.tokenEndpoint),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': clientId,
        if (clientSecret != null && clientSecret.isNotEmpty)
          'client_secret': clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Token exchange failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}

