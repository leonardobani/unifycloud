import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_error.dart';
import 'package:unifycloud/src/utils/token_utils.dart';

void main() {
  group('TokenUtils Normalization Tests', () {
    test('Converts Dart Map.toString() format into valid JSON', () {
      const dartMapString =
          '{access_token: ya29.a0AfH6SM..., token_type: Bearer, refresh_token: 1//0g..., expires_in: 3599, scope: https://www.googleapis.com/auth/drive}';

      final normalized = TokenUtils.normalizeTokenJson(dartMapString);

      // Must be valid JSON
      final decoded = jsonDecode(normalized) as Map<String, dynamic>;
      expect(decoded['access_token'], equals('ya29.a0AfH6SM...'));
      expect(decoded['token_type'], equals('Bearer'));
      expect(decoded['refresh_token'], equals('1//0g...'));
      expect(decoded['expires_in'], equals(3599));
      expect(decoded['scope'], equals('https://www.googleapis.com/auth/drive'));

      // Must automatically compute ISO8601 expiry
      expect(decoded.containsKey('expiry'), isTrue);
      expect(DateTime.tryParse(decoded['expiry'] as String), isNotNull);

      // Ensure JSON keys start with double-quotes, avoiding invalid character 'a'
      expect(normalized.startsWith('{"'), isTrue);
    });

    test('Preserves already valid JSON and ensures expiry', () {
      final validJson = jsonEncode({
        'access_token': 'ya29.valid',
        'token_type': 'Bearer',
        'expires_in': 3600,
      });

      final normalized = TokenUtils.normalizeTokenJson(validJson);
      final decoded = jsonDecode(normalized) as Map<String, dynamic>;

      expect(decoded['access_token'], equals('ya29.valid'));
      expect(decoded.containsKey('expiry'), isTrue);
    });

    test('Sanitizes INI config containing malformed token line', () {
      const corruptedIni = '''
[GoogleDrive]
type = drive
token = {access_token: ya29.corrupted, token_type: Bearer, expires_in: 3599}

[LocalDisk]
type = local
''';

      final sanitized = TokenUtils.sanitizeIniConfig(corruptedIni);

      expect(sanitized, contains('[GoogleDrive]'));
      expect(sanitized, contains('type = drive'));
      expect(sanitized, contains('token = {"access_token":"ya29.corrupted"'));
      expect(sanitized, contains('[LocalDisk]'));

      // Check that the token line in sanitized INI is decodable as JSON
      final tokenLine = sanitized
          .split('\n')
          .firstWhere((line) => line.trim().startsWith('token = '));
      final tokenJson = tokenLine.substring(tokenLine.indexOf('=') + 1).trim();
      final decoded = jsonDecode(tokenJson) as Map<String, dynamic>;
      expect(decoded['access_token'], equals('ya29.corrupted'));
    });
  });

  group('CloudErrorType OAuth Client Error Classification', () {
    test('Classifies rclone oauth client creation failure as authExpired', () {
      const errorMsg =
          'Exception: ListDirectory failed: failed to access remote "GoogleDrive:": drive: failed when making oauth client: failed to create oauth client: invalid character \'a\' looking for beginning of object key string';

      final errorType = CloudErrorType.fromError(errorMsg);
      expect(errorType, equals(CloudErrorType.authExpired));
      expect(errorType.userFriendlyMessage, contains('Riconnetti'));
    });
  });
}

