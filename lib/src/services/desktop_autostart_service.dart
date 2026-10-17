import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider for [DesktopAutostartService].
final desktopAutostartServiceProvider =
    Provider<DesktopAutostartService>((ref) {
  return DesktopAutostartService();
});

/// Service managing FreeDesktop (XDG Autostart) on Linux desktop systems.
class DesktopAutostartService {
  final String? customAutostartDirPath;
  final String? customExecutablePath;

  DesktopAutostartService({
    this.customAutostartDirPath,
    this.customExecutablePath,
  });

  /// Whether autostart configuration is supported on current platform.
  bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  /// Path to XDG autostart directory (~/.config/autostart).
  String get autostartDirectoryPath {
    final custom = customAutostartDirPath;
    if (custom != null) return custom;
    final home = Platform.environment['HOME'] ?? '';
    return '$home/.config/autostart';
  }

  /// Path to the .desktop entry file in autostart directory.
  File get desktopEntryFile {
    return File('$autostartDirectoryPath/io.gitlab.leorise25.unifycloud.desktop');
  }

  String get executablePath {
    final custom = customExecutablePath;
    if (custom != null) return custom;
    return Platform.resolvedExecutable;
  }

  /// Checks if the autostart .desktop file is present.
  Future<bool> isAutostartEnabled() async {
    if (!isSupported) return false;
    try {
      return await desktopEntryFile.exists();
    } catch (e) {
      debugPrint('[DesktopAutostartService] Error checking autostart: $e');
      return false;
    }
  }

  /// Enables or disables autostart on system boot/login.
  Future<bool> setAutostartEnabled(bool enabled) async {
    if (!isSupported) return false;

    try {
      final file = desktopEntryFile;
      if (enabled) {
        final dir = file.parent;
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final content = '''[Desktop Entry]
Type=Application
Version=1.0
Name=UnifyCloud
GenericName=Cloud Storage Client
Comment=Unified multi-cloud storage and synchronization client
Exec="$executablePath" --background
Icon=io.gitlab.leorise25.unifycloud
Terminal=false
Categories=Utility;Network;FileManager;
StartupNotify=false
X-GNOME-Autostart-enabled=true
''';
        await file.writeAsString(content);
        return true;
      } else {
        if (await file.exists()) {
          await file.delete();
        }
        return true;
      }
    } catch (e) {
      debugPrint('[DesktopAutostartService] Error setting autostart: $e');
      return false;
    }
  }
}
