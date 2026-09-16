import 'dart:convert';

/// Utilities for normalizing and sanitizing OAuth token JSON and Rclone INI configs.
class TokenUtils {
  /// Normalizes a token string into valid JSON for Rclone / golang.org/x/oauth2.
  ///
  /// Handles:
  /// - Standard valid JSON strings.
  /// - Dart's `Map.toString()` output (e.g. `{access_token: ya29..., expires_in: 3599}`).
  /// - Computes ISO8601 `expiry` timestamp from `expires_in` if `expiry` is missing.
  static String normalizeTokenJson(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    // 1. Try standard JSON decode
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        _ensureExpiry(map);
        return jsonEncode(map);
      }
      return trimmed;
    } catch (_) {}

    // 2. If not valid JSON, check if it is formatted like Dart's Map.toString():
    // e.g. {access_token: ya29.xxx, refresh_token: 1//xxx, scope: https://..., token_type: Bearer, expires_in: 3599}
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final inner = trimmed.substring(1, trimmed.length - 1).trim();
        final map = <String, dynamic>{};

        // Match key: value pairs where key is word characters and value goes until next key: or end
        final entryRegex = RegExp(
          r'(?:^|,\s*)([a-zA-Z0-9_-]+)\s*:\s*([^,]+(?:\s+[^,:]+)*(?=,\s*[a-zA-Z0-9_-]+\s*:|$))',
        );
        final matches = entryRegex.allMatches(inner);
        for (final m in matches) {
          final key = m.group(1)!.trim();
          var valStr = m.group(2)!.trim();
          if (num.tryParse(valStr) != null) {
            map[key] = num.parse(valStr);
          } else if (valStr.toLowerCase() == 'true') {
            map[key] = true;
          } else if (valStr.toLowerCase() == 'false') {
            map[key] = false;
          } else {
            if ((valStr.startsWith('"') && valStr.endsWith('"')) ||
                (valStr.startsWith("'") && valStr.endsWith("'"))) {
              valStr = valStr.substring(1, valStr.length - 1);
            }
            map[key] = valStr;
          }
        }

        if (map.isNotEmpty) {
          _ensureExpiry(map);
          return jsonEncode(map);
        }
      } catch (_) {}
    }

    return trimmed;
  }

  /// Calculates RFC3339 / ISO8601 expiry if expires_in is present and expiry is absent.
  static void _ensureExpiry(Map<String, dynamic> map) {
    if (!map.containsKey('expiry') && map.containsKey('expires_in')) {
      final exp = map['expires_in'];
      if (exp is num) {
        map['expiry'] = DateTime.now()
            .toUtc()
            .add(Duration(seconds: exp.toInt()))
            .toIso8601String();
      }
    }
  }

  /// Scans an INI configuration string and heals any malformed `token = ...` lines.
  static String sanitizeIniConfig(String iniContent) {
    if (iniContent.isEmpty) return iniContent;

    final lines = iniContent.split('\n');
    var modified = false;
    final sanitizedLines = <String>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('token') && trimmed.contains('=')) {
        final eqIdx = line.indexOf('=');
        final keyPart = line.substring(0, eqIdx + 1);
        final valPart = line.substring(eqIdx + 1).trim();

        if (valPart.isNotEmpty) {
          final normalized = normalizeTokenJson(valPart);
          if (normalized != valPart) {
            sanitizedLines.add('$keyPart $normalized');
            modified = true;
            continue;
          }
        }
      }
      sanitizedLines.add(line);
    }

    return modified ? sanitizedLines.join('\n') : iniContent;
  }
}

