import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../l10n/l10n_extension.dart';
import '../utils/url_utils.dart';

/// Riverpod provider for [OAuthService].
final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});

/// Definition of OAuth configuration for a supported cloud provider.
class OAuthProviderConfig {

  const OAuthProviderConfig({
    required this.providerType,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.defaultClientId,
    this.defaultClientSecret,
    required this.scopes,
    this.defaultRedirectUri = 'http://localhost:53682/',
  });
  final String providerType;
  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String defaultClientId;
  final String? defaultClientSecret;
  final List<String> scopes;
  final String defaultRedirectUri;
}

/// Service that handles OAuth2 authorization flows for Cloud Storage providers.
class OAuthService {

  OAuthService([http.Client? httpClient])
      : _injectedHttpClient = httpClient,
        _waitForForegroundOverride = null,
        _isAppInForegroundOverride = null,
        _isMobilePlatformOverride = null,
        _browserLauncherOverride = null,
        _retryDelays = _defaultRetryDelays;

  @visibleForTesting
  OAuthService.forTesting({
    http.Client? httpClient,
    Future<void> Function(Duration timeout)? waitForForeground,
    bool Function()? isAppInForeground,
    bool Function()? isMobilePlatform,
    Future<bool> Function(Uri url)? browserLauncher,
    List<Duration>? retryDelays,
  })  : _injectedHttpClient = httpClient,
        _waitForForegroundOverride = waitForForeground,
        _isAppInForegroundOverride = isAppInForeground,
        _isMobilePlatformOverride = isMobilePlatform,
        _browserLauncherOverride = browserLauncher,
        _retryDelays = retryDelays ?? _defaultRetryDelays;

  final http.Client? _injectedHttpClient;
  final Future<void> Function(Duration timeout)? _waitForForegroundOverride;
  final bool Function()? _isAppInForegroundOverride;
  final bool Function()? _isMobilePlatformOverride;
  final Future<bool> Function(Uri url)? _browserLauncherOverride;
  final List<Duration> _retryDelays;

  static const List<Duration> _defaultRetryDelays = [
    Duration(milliseconds: 400),
    Duration(milliseconds: 900),
    Duration(milliseconds: 1800),
    Duration(milliseconds: 3000),
  ];

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

  static String _generateRandomToken([int byteLength = 32]) {
    final rng = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => rng.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String _computeCodeChallenge(String verifier) {
    final digest = sha256.convert(ascii.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  /// Constructs the authorization URL for the chosen cloud provider.
  Uri buildAuthUrl({
    required OAuthProviderConfig config,
    required String clientId,
    required String redirectUri,
    String state = '',
    String? codeChallenge,
  }) {
    final queryParams = {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      if (config.scopes.isNotEmpty) 'scope': config.scopes.join(' '),
      if (state.isNotEmpty) 'state': state,
      if (codeChallenge != null && codeChallenge.isNotEmpty) ...{
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
      if (config.providerType == 'drive') 'access_type': 'offline',
      'prompt': 'consent',
    };

    return Uri.parse(config.authorizationEndpoint).replace(
      queryParameters: queryParams,
    );
  }

  /// Safely attempts to open a URL in the browser across desktop and mobile.
  Future<bool> openBrowser(Uri url) async {
    if (_browserLauncherOverride != null) {
      return _browserLauncherOverride(url);
    }
    return await UrlUtils.openWebUrl(url);
  }

  /// Returns true when [error] is a transient OS/network failure (such as a DNS
  /// lookup failure while backgrounded on Android) that may succeed on retry.
  static bool isTransientNetworkError(Object error) {
    if (error is SocketException ||
        error is HandshakeException ||
        error is TlsException ||
        error is HttpException) {
      return true;
    }
    if (error is http.ClientException) {
      final msg = error.message.toLowerCase();
      return msg.contains('socketexception') ||
          msg.contains('failed host lookup') ||
          msg.contains('connection') ||
          msg.contains('network') ||
          msg.contains('handshake') ||
          msg.contains('timed out') ||
          msg.contains('reset');
    }
    return false;
  }

  bool _isMobile() {
    if (_isMobilePlatformOverride != null) {
      return _isMobilePlatformOverride();
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  bool _isAppInForeground() {
    if (_isAppInForegroundOverride != null) {
      return _isAppInForegroundOverride();
    }
    try {
      final state = WidgetsBinding.instance.lifecycleState;
      return state == null || state == AppLifecycleState.resumed;
    } catch (_) {
      return true;
    }
  }

  Future<void> _waitForForeground(Duration timeout) async {
    if (_waitForForegroundOverride != null) {
      await _waitForForegroundOverride(timeout);
      return;
    }
    if (_isAppInForeground()) return;

    final WidgetsBinding binding;
    try {
      binding = WidgetsBinding.instance;
    } catch (_) {
      return;
    }

    final completer = Completer<void>();
    final observer = _ForegroundLifecycleObserver(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    binding.addObserver(observer);
    try {
      if (_isAppInForeground() && !completer.isCompleted) {
        completer.complete();
      }
      await completer.future.timeout(timeout);
    } finally {
      binding.removeObserver(observer);
    }
  }

  Future<T> _executeWithNetworkRecovery<T>(
    Future<T> Function(http.Client client) operation, {
    required Duration timeout,
  }) async {
    final deadline = DateTime.now().add(timeout);
    var retryIndex = 0;
    var foregroundWaits = 0;

    while (true) {
      final client = _injectedHttpClient ?? http.Client();
      try {
        return await operation(client);
      } catch (e) {
        if (!isTransientNetworkError(e)) {
          rethrow;
        }

        final remaining = deadline.difference(DateTime.now());
        if (remaining <= Duration.zero) {
          rethrow;
        }

        // On mobile (Android 15/16+, iOS), the OS can block DNS/sockets while
        // the app is backgrounded during external browser login. Wait until
        // the app returns to the foreground before retrying.
        if (_isMobile() && !_isAppInForeground() && foregroundWaits < 2) {
          foregroundWaits++;
          try {
            await _waitForForeground(remaining);
          } on TimeoutException {
            rethrow;
          }
          continue;
        }

        if (retryIndex >= _retryDelays.length) {
          rethrow;
        }

        final delay = _retryDelays[retryIndex++];
        final waitDuration = delay < remaining ? delay : remaining;
        if (waitDuration > Duration.zero) {
          await Future<void>.delayed(waitDuration);
        }
      } finally {
        if (_injectedHttpClient == null) {
          client.close();
        }
      }
    }
  }

  static Future<void> _sendHtmlResponse(
    HttpRequest request,
    int statusCode,
    String html,
  ) async {
    try {
      request.response.statusCode = statusCode;
      request.response.headers.contentType = ContentType.html;
      request.response.write(html);
      await request.response.close();
    } catch (_) {
      // Ignore client disconnect errors after serving the local callback page.
    }
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
    AppLocalizations? l10n,
  }) async {
    final strings = l10n ?? resolveAppLocalizations(const Locale('en'));
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
        throw Exception(strings.oauthPortOccupied(rcloneOAuthPort));
      }
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    }

    final redirectUri = server.port == rcloneOAuthPort
        ? config.defaultRedirectUri
        : 'http://localhost:${server.port}/';
    final state = _generateRandomToken();
    final codeVerifier = _generateRandomToken();
    final codeChallenge = _computeCodeChallenge(codeVerifier);

    final authUrl = buildAuthUrl(
      config: config,
      clientId: clientId,
      redirectUri: redirectUri,
      state: state,
      codeChallenge: codeChallenge,
    );

    // 2. Attempt to launch authorization page in browser using resilient fallback chain
    final launched = await openBrowser(authUrl);

    // Notify caller with generated URL and browser launch status
    onAuthUrlReady?.call(authUrl, launched);

    // 3. Wait for HTTP redirect callback
    final completer = Completer<String>();

    final sub = server.listen(
      (HttpRequest request) async {
        final uri = request.uri;

        // Ignore browser favicon requests
        if (uri.path == '/favicon.ico') {
          try {
            request.response.statusCode = HttpStatus.notFound;
            await request.response.close();
          } catch (_) {}
          return;
        }

        final code = uri.queryParameters['code'];
        final returnedState = uri.queryParameters['state'];
        final error = uri.queryParameters['error'];
        final errorDesc = uri.queryParameters['error_description'];

        // Only handle OAuth callback responses that contain code or error
        if (code == null && error == null) {
          try {
            request.response.statusCode = HttpStatus.notFound;
            request.response.write('Not an OAuth callback.');
            await request.response.close();
          } catch (_) {}
          return;
        }

        if (code != null && state.isNotEmpty && returnedState == state) {
          final safeTitle = const HtmlEscape().convert(strings.oauthHtmlSuccessTitle);
          final safeHeading = const HtmlEscape().convert(strings.oauthHtmlSuccessHeading);
          final safeBody = const HtmlEscape().convert(strings.oauthHtmlSuccessBody);
          await _sendHtmlResponse(request, HttpStatus.ok, '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>$safeTitle</title></head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>$safeHeading &#x2705;</h2>
  <p>$safeBody</p>
</body>
</html>
''');
          if (!completer.isCompleted) {
            completer.complete(code);
          }
        } else {
          final rawErrMsg = errorDesc ??
              error ??
              (returnedState != state
                  ? strings.oauthInvalidState
                  : strings.oauthInvalidCode);
          final safeErrMsg = const HtmlEscape().convert(rawErrMsg);
          final safeErrTitle = const HtmlEscape().convert(strings.oauthHtmlErrorTitle);
          final safeErrHeading = const HtmlEscape().convert(strings.oauthHtmlErrorHeading);
          await _sendHtmlResponse(request, HttpStatus.badRequest, '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>$safeErrTitle</title></head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>$safeErrHeading &#x274C;</h2>
  <p>$safeErrMsg</p>
</body>
</html>
''');
          if (!completer.isCompleted) {
            completer.completeError(
              Exception('OAuth authorization failed: $rawErrMsg'),
            );
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        // Ignore transient OS socket resets while the local server waits in background.
      },
    );

    try {
      final code = await completer.future.timeout(timeout);
      await sub.cancel();
      await server.close(force: true);

      final effectiveSecret = (clientSecret != null && clientSecret.isNotEmpty)
          ? clientSecret
          : (clientId == config.defaultClientId ? config.defaultClientSecret : null);

      // 4. Exchange authorization code for token (recovering if OS blocked
      // background network/DNS while the browser was still on screen).
      final tokens = await _executeWithNetworkRecovery(
        (client) => exchangeCodeForTokens(
          config: config,
          clientId: clientId,
          clientSecret: effectiveSecret,
          code: code,
          redirectUri: redirectUri,
          codeVerifier: codeVerifier,
          client: client,
        ),
        timeout: timeout,
      );

      // 5. Automatic discovery of drive_id and drive_type for OneDrive
      if (providerType == 'onedrive') {
        final accessToken = tokens['access_token'] as String?;
        if (accessToken != null && accessToken.isNotEmpty) {
          Map<String, String>? driveInfo;
          try {
            driveInfo = await _executeWithNetworkRecovery(
              (client) => _fetchOneDriveDriveInfo(
                accessToken: accessToken,
                client: client,
              ),
              timeout: const Duration(seconds: 30),
            );
          } catch (_) {}
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
    http.Client? client,
  }) async {
    final activeClient = client ?? _injectedHttpClient ?? http.Client();
    try {
      return await _fetchOneDriveDriveInfo(
        accessToken: accessToken,
        client: activeClient,
      );
    } catch (_) {
      return null;
    } finally {
      if (client == null && _injectedHttpClient == null) {
        activeClient.close();
      }
    }
  }

  Future<Map<String, String>?> _fetchOneDriveDriveInfo({
    required String accessToken,
    required http.Client client,
  }) async {
    // 1. Primary personal / business endpoint: /me/drive
    final res = await client.get(
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
    final listRes = await client.get(
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
    return null;
  }

  /// Exchanges an authorization code for access and refresh tokens.
  Future<Map<String, dynamic>> exchangeCodeForTokens({
    required OAuthProviderConfig config,
    required String clientId,
    String? clientSecret,
    required String code,
    required String redirectUri,
    String? codeVerifier,
    http.Client? client,
  }) async {
    final activeClient = client ?? _injectedHttpClient ?? http.Client();
    try {
      final response = await activeClient.post(
        Uri.parse(config.tokenEndpoint),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': clientId,
          if (clientSecret != null && clientSecret.isNotEmpty)
            'client_secret': clientSecret,
          'code': code,
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri,
          if (codeVerifier != null && codeVerifier.isNotEmpty)
            'code_verifier': codeVerifier,
        },
      );

      if (response.statusCode != 200) {
        String summary = 'HTTP ${response.statusCode}';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map) {
            final err = decoded['error']?.toString();
            final desc = decoded['error_description']?.toString();
            if (err != null && err.isNotEmpty) {
              summary = desc != null && desc.isNotEmpty ? '$err: $desc' : err;
            }
          }
        } catch (_) {}
        throw Exception('Token exchange failed ($summary)');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } finally {
      if (client == null && _injectedHttpClient == null) {
        activeClient.close();
      }
    }
  }
}

class _ForegroundLifecycleObserver with WidgetsBindingObserver {
  _ForegroundLifecycleObserver(this.onResumed);

  final VoidCallback onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
