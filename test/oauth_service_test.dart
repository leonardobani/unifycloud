import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:unifycloud/src/services/oauth_service.dart';

void main() {
  group('OAuthService Network & Background Recovery Tests', () {
    test('isTransientNetworkError classifies SocketException and ClientException properly', () {
      expect(
        OAuthService.isTransientNetworkError(
          const SocketException(
            "Failed host lookup: 'login.microsoftonline.com'",
            osError: OSError('No address associated with hostname', 7),
          ),
        ),
        isTrue,
      );
      expect(
        OAuthService.isTransientNetworkError(
          http.ClientException(
            "SocketException: Failed host lookup: 'oauth2.googleapis.com'",
            Uri.parse('https://oauth2.googleapis.com/token'),
          ),
        ),
        isTrue,
      );
      expect(
        OAuthService.isTransientNetworkError(
          Exception('Token exchange failed (invalid_grant: Code expired)'),
        ),
        isFalse,
      );
    });

    test('authenticate waits for foreground and retries OneDrive token exchange after background DNS failure', () async {
      var isInForeground = false;
      var waitCalls = 0;
      var tokenAttempts = 0;
      var driveInfoAttempts = 0;

      final mockClient = MockClient((request) async {
        if (request.url.toString() ==
            'https://login.microsoftonline.com/common/oauth2/v2.0/token') {
          tokenAttempts++;
          if (tokenAttempts == 1) {
            throw http.ClientException(
              "SocketException: Failed host lookup: 'login.microsoftonline.com' (OS Error: No address associated with hostname, errno= 7)",
              request.url,
            );
          }
          return http.Response(
            jsonEncode({
              'access_token': 'onedrive_access_123',
              'refresh_token': 'onedrive_refresh_456',
              'token_type': 'Bearer',
            }),
            200,
          );
        }

        if (request.url.toString() == 'https://graph.microsoft.com/v1.0/me/drive') {
          driveInfoAttempts++;
          return http.Response(
            jsonEncode({
              'id': 'drive_id_abc',
              'driveType': 'personal',
            }),
            200,
          );
        }

        return http.Response('Not found', 404);
      });

      late Future<void> callbackFuture;
      final service = OAuthService.forTesting(
        httpClient: mockClient,
        isMobilePlatform: () => true,
        isAppInForeground: () => isInForeground,
        waitForForeground: (timeout) async {
          waitCalls++;
          isInForeground = true;
        },
        retryDelays: const [Duration(milliseconds: 1), Duration(milliseconds: 1)],
        browserLauncher: (authUrl) async {
          // Simulate external browser completing OAuth while app is still in background
          final redirectUri = Uri.parse(authUrl.queryParameters['redirect_uri']!);
          final state = authUrl.queryParameters['state']!;
          callbackFuture = http.get(
            redirectUri.replace(
              queryParameters: {'code': 'auth_code_xyz', 'state': state},
            ),
          );
          return true;
        },
      );

      final result = await service.authenticate(
        providerType: 'onedrive',
        clientId: OAuthService.rcloneOneDriveClientId,
        timeout: const Duration(seconds: 10),
      );
      await callbackFuture;

      expect(waitCalls, equals(1));
      expect(tokenAttempts, equals(2));
      expect(driveInfoAttempts, equals(1));
      expect(result['access_token'], equals('onedrive_access_123'));
      expect(result['drive_id'], equals('drive_id_abc'));
      expect(result['drive_type'], equals('personal'));
    });

    test('authenticate retries Google Drive token exchange on transient foreground DNS glitch', () async {
      var tokenAttempts = 0;

      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://oauth2.googleapis.com/token') {
          tokenAttempts++;
          if (tokenAttempts <= 2) {
            throw const SocketException(
              "Failed host lookup: 'oauth2.googleapis.com'",
              osError: OSError('No address associated with hostname', 7),
            );
          }
          return http.Response(
            jsonEncode({
              'access_token': 'gdrive_access_789',
              'refresh_token': 'gdrive_refresh_012',
              'token_type': 'Bearer',
            }),
            200,
          );
        }
        return http.Response('Not found', 404);
      });

      late Future<void> callbackFuture;
      final service = OAuthService.forTesting(
        httpClient: mockClient,
        isMobilePlatform: () => true,
        isAppInForeground: () => true,
        retryDelays: const [
          Duration(milliseconds: 1),
          Duration(milliseconds: 1),
          Duration(milliseconds: 1),
        ],
        browserLauncher: (authUrl) async {
          final redirectUri = Uri.parse(authUrl.queryParameters['redirect_uri']!);
          final state = authUrl.queryParameters['state']!;
          callbackFuture = http.get(
            redirectUri.replace(
              queryParameters: {'code': 'gdrive_code_111', 'state': state},
            ),
          );
          return true;
        },
      );

      final result = await service.authenticate(
        providerType: 'drive',
        clientId: OAuthService.rcloneDriveClientId,
        timeout: const Duration(seconds: 10),
      );
      await callbackFuture;

      expect(tokenAttempts, equals(3));
      expect(result['access_token'], equals('gdrive_access_789'));
    });

    test('authenticate does not retry non-network HTTP 400 token errors', () async {
      var tokenAttempts = 0;
      var waitCalls = 0;

      final mockClient = MockClient((request) async {
        tokenAttempts++;
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Authorization code expired',
          }),
          400,
        );
      });

      late Future<void> callbackFuture;
      final service = OAuthService.forTesting(
        httpClient: mockClient,
        isMobilePlatform: () => true,
        isAppInForeground: () => false,
        waitForForeground: (_) async {
          waitCalls++;
        },
        retryDelays: const [Duration(milliseconds: 1)],
        browserLauncher: (authUrl) async {
          final redirectUri = Uri.parse(authUrl.queryParameters['redirect_uri']!);
          final state = authUrl.queryParameters['state']!;
          callbackFuture = http.get(
            redirectUri.replace(
              queryParameters: {'code': 'bad_code', 'state': state},
            ),
          );
          return true;
        },
      );

      await expectLater(
        () => service.authenticate(
          providerType: 'drive',
          clientId: OAuthService.rcloneDriveClientId,
          timeout: const Duration(seconds: 10),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('invalid_grant: Authorization code expired'),
          ),
        ),
      );
      await callbackFuture;

      expect(tokenAttempts, equals(1));
      expect(waitCalls, equals(0));
    });
  });
}
