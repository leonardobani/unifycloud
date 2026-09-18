import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../utils/url_utils.dart';

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
  final String defaultRedirectUri;

  const OAuthProviderConfig({
    required this.providerType,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.defaultClientId,
    this.defaultClientSecret,
    required this.scopes,
    this.defaultRedirectUri = 'http://localhost:53682/',
  });
}

/// Service that handles OAuth2 authorization flows for Cloud Storage providers.
class OAuthService {
  final http.Client _httpClient;

  OAuthService([http.Client? httpClient]) : _httpClient = httpClient ?? http.Client();

  /// Official port registered with OAuth providers (OneDrive, Dropbox, Google Drive) by Rclone.
  static const int rcloneOAuthPort = 53682;
  static const String rcloneRedirectLocalhost = 'http://localhost:53682/';
  static const String rcloneRedirect127 = 'http://127.0.0.1:53682/';

  /// Official built-in Rclone OAuth2 credentials for Google Drive.
  static const String rcloneDriveClientId =
      '202264815644.apps.googleusercontent.com';
  static const String rcloneDriveClientSecret =
      'X4Z3ca8xfWDb1Voo-F9a7ZxJ';

  /// Official built-in Rclone OAuth2 credentials for Dropbox.
  static const String rcloneDropboxClientId = '5jcck7diasz0rqy';
  static const String rcloneDropboxClientSecret = '1n9m04y2zx7bf26';

  /// Official built-in Rclone OAuth2 credentials for Microsoft OneDrive.
  static const String rcloneOneDriveClientId =
      'b15665d9-eda6-4092-8539-0eec376afd59';
  static const String rcloneOneDriveClientSecret =
      'qtyfaBBYA403=unZUP40~_#';

  static const Map<String, OAuthProviderConfig> supportedProviders = {
    'drive': OAuthProviderConfig(
      providerType: 'drive',
      authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
      tokenEndpoint: 'https://oauth2.googleapis.com/token',
      defaultClientId: rcloneDriveClientId,
      defaultClientSecret: rcloneDriveClientSecret,
      defaultRedirectUri: rcloneRedirect127,
      scopes: [
        'https://www.googleapis.com/auth/drive',
      ],
    ),
    'dropbox': OAuthProviderConfig(
      providerType: 'dropbox',
      authorizationEndpoint: 'https://www.dropbox.com/oauth2/authorize',
      tokenEndpoint: 'https://api.dropboxapi.com/oauth2/token',
      defaultClientId: rcloneDropboxClientId,
      defaultClientSecret: rcloneDropboxClientSecret,
      defaultRedirectUri: rcloneRedirectLocalhost,
      scopes: [],
    ),
    'onedrive': OAuthProviderConfig(
      providerType: 'onedrive',
      authorizationEndpoint:
          'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
      tokenEndpoint:
          'https://login.microsoftonline.com/common/oauth2/v2.0/token',
      defaultClientId: rcloneOneDriveClientId,
      defaultClientSecret: rcloneOneDriveClientSecret,
      defaultRedirectUri: rcloneRedirectLocalhost,
      scopes: [
        'Files.Read',
        'Files.ReadWrite',
        'Files.Read.All',
        'Files.ReadWrite.All',
        'Sites.Read.All',
        'offline_access',
      ],
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

  /// Official UnifyCloud OAuth2 credentials (can be injected via --dart-define or configured for release).
  static const String unifycloudDriveClientId = String.fromEnvironment(
    'UC_DRIVE_CLIENT_ID',
    defaultValue: rcloneDriveClientId,
  );
  static const String unifycloudDriveClientSecret = String.fromEnvironment(
    'UC_DRIVE_CLIENT_SECRET',
    defaultValue: rcloneDriveClientSecret,
  );

  static const String unifycloudDropboxClientId = String.fromEnvironment(
    'UC_DROPBOX_CLIENT_ID',
    defaultValue: rcloneDropboxClientId,
  );
  static const String unifycloudDropboxClientSecret = String.fromEnvironment(
    'UC_DROPBOX_CLIENT_SECRET',
    defaultValue: rcloneDropboxClientSecret,
  );

  static const String unifycloudOneDriveClientId = String.fromEnvironment(
    'UC_ONEDRIVE_CLIENT_ID',
    defaultValue: rcloneOneDriveClientId,
  );
  static const String unifycloudOneDriveClientSecret = String.fromEnvironment(
    'UC_ONEDRIVE_CLIENT_SECRET',
    defaultValue: rcloneOneDriveClientSecret,
  );

  /// Returns official UnifyCloud Client ID for [providerType].
  static String? getUnifyCloudClientId(String providerType) {
    switch (providerType) {
      case 'drive':
        return unifycloudDriveClientId;
      case 'dropbox':
        return unifycloudDropboxClientId;
      case 'onedrive':
        return unifycloudOneDriveClientId;
      default:
        return null;
    }
  }

  /// Returns official UnifyCloud Client Secret for [providerType].
  static String? getUnifyCloudClientSecret(String providerType) {
    switch (providerType) {
      case 'drive':
        return unifycloudDriveClientSecret;
      case 'dropbox':
        return unifycloudDropboxClientSecret;
      case 'onedrive':
        return unifycloudOneDriveClientSecret;
      default:
        return null;
    }
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
      if (config.providerType == 'drive') 'access_type': 'offline',
      'prompt': 'consent',
    };

    return Uri.parse(config.authorizationEndpoint).replace(
      queryParameters: queryParams,
    );
  }

  /// Safely attempts to open a URL in the browser across desktop and mobile.
  Future<bool> openBrowser(Uri url) async {
    return await UrlUtils.openWebUrl(url);
  }

  /// Initiates interactive OAuth2 authorization:
  /// 1. Spawns an ephemeral local loopback HTTP server (binding port 53682 matching Rclone registration).
  /// 2. Opens the provider's consent page in the user's browser (or provides manual URL fallback).
  /// 3. Intercepts the authorization code callback.
  /// 4. Exchanges the code for access/refresh tokens.
  /// 5. Auto-discovers Microsoft OneDrive drive_id and drive_type if applicable.
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

    // 1. Bind local loopback server.
    // Built-in Rclone OAuth apps (especially Microsoft OneDrive) require port 53682
    // and exact registered redirect URIs (e.g. http://localhost:53682/).
    HttpServer server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, rcloneOAuthPort);
    } catch (e) {
      if (clientId == config.defaultClientId) {
        throw Exception(
          'La porta $rcloneOAuthPort è già occupata da un altro processo. '
          'Chiudi eventuali sessioni Rclone o browser aperte e riprova.',
        );
      }
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    }

    final redirectUri = server.port == rcloneOAuthPort
        ? config.defaultRedirectUri
        : 'http://localhost:${server.port}/';
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

      // Ignore browser favicon requests
      if (uri.path == '/favicon.ico') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }

      final code = uri.queryParameters['code'];
      final returnedState = uri.queryParameters['state'];
      final error = uri.queryParameters['error'];
      final errorDesc = uri.queryParameters['error_description'];

      // Only handle OAuth callback responses that contain code or error
      if (code == null && error == null) {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Not an OAuth callback.');
        await request.response.close();
        return;
      }

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
        if (!completer.isCompleted) {
          completer.complete(code);
        }
      } else {
        final errMsg = errorDesc ?? error ?? 'Codice di autorizzazione non valido.';
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('''
<!DOCTYPE html>
<html>
<head><title>UnifyCloud - Errore</title></head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>Errore di autenticazione &#x274C;</h2>
  <p>$errMsg</p>
</body>
</html>
''');
        await request.response.close();
        if (!completer.isCompleted) {
          completer.completeError(
            Exception('OAuth authorization failed: $errMsg'),
          );
        }
      }
    });

    try {
      final code = await completer.future.timeout(timeout);
      await sub.cancel();
      await server.close(force: true);

      final effectiveSecret = (clientSecret != null && clientSecret.isNotEmpty)
          ? clientSecret
          : (clientId == config.defaultClientId ? config.defaultClientSecret : null);

      // 4. Exchange authorization code for token
      final tokens = await exchangeCodeForTokens(
        config: config,
        clientId: clientId,
        clientSecret: effectiveSecret,
        code: code,
        redirectUri: redirectUri,
      );

      // 5. Automatic discovery of drive_id and drive_type for OneDrive
      if (providerType == 'onedrive') {
        final accessToken = tokens['access_token'] as String?;
        if (accessToken != null && accessToken.isNotEmpty) {
          final driveInfo = await getOneDriveDriveInfo(accessToken: accessToken);
          if (driveInfo != null) {
            tokens['drive_id'] = driveInfo['drive_id'];
            tokens['drive_type'] = driveInfo['drive_type'];
          }
        }
      }

      return tokens;
    } catch (e) {
      await sub.cancel();
      await server.close(force: true);
      rethrow;
    }
  }

  /// Queries Microsoft Graph API to find the user's primary drive ID and drive type.
  Future<Map<String, String>?> getOneDriveDriveInfo({
    required String accessToken,
  }) async {
    try {
      // 1. Primary personal / business endpoint: /me/drive
      final res = await _httpClient.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/drive'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final id = data['id'] as String?;
        final type = data['driveType'] as String? ?? 'personal';
        if (id != null && id.isNotEmpty) {
          return {'drive_id': id, 'drive_type': type};
        }
      }

      // 2. Fallback to /me/drives (for some business or multi-drive accounts)
      final listRes = await _httpClient.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/drives'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (listRes.statusCode == 200) {
        final listData = jsonDecode(listRes.body) as Map<String, dynamic>;
        final drives = listData['value'] as List<dynamic>?;
        if (drives != null && drives.isNotEmpty) {
          final first = drives.first as Map<String, dynamic>;
          final id = first['id'] as String?;
          final type = first['driveType'] as String? ?? 'business';
          if (id != null && id.isNotEmpty) {
            return {'drive_id': id, 'drive_type': type};
          }
        }
      }
    } catch (_) {}
    return null;
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

