import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Utility methods for safely launching web URLs across desktop and mobile platforms.
class UrlUtils {
  /// Safely attempts to open a URL in the default system browser.
  /// On Linux, prioritizes Freedesktop D-Bus portal calls (`gdbus` / `busctl`) to bypass
  /// `gtk_show_uri_on_window`, preventing "Gdk-WARNING: Server is missing xdg_foreign support"
  /// and ensuring URLs open seamlessly on Wayland, Flatpak, Distrobox, and COSMIC desktop environments.
  static Future<bool> openWebUrl(Uri url) async {
    final urlStr = url.toString();

    // 1. On Linux, prioritize native D-Bus Portal and command-line launchers
    if (Platform.isLinux) {
      // Direct Freedesktop D-Bus Portal via gdbus
      try {
        final res = await Process.run('gdbus', [
          'call',
          '--session',
          '--dest',
          'org.freedesktop.portal.Desktop',
          '--object-path',
          '/org/freedesktop/portal/desktop',
          '--method',
          'org.freedesktop.portal.OpenURI.OpenURI',
          '',
          urlStr,
          '{}',
        ]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // Direct Freedesktop D-Bus Portal via busctl
      try {
        final res = await Process.run('busctl', [
          '--user',
          'call',
          'org.freedesktop.portal.Desktop',
          '/org/freedesktop/portal/desktop',
          'org.freedesktop.portal.OpenURI',
          'OpenURI',
          'ssa{sv}',
          '',
          urlStr,
          '0',
        ]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // Try gio open
      try {
        final res = await Process.run('gio', ['open', urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // Try /usr/bin/gio directly
      try {
        final res = await Process.run('/usr/bin/gio', ['open', urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // Try /usr/bin/xdg-open (bypassing any wrapper scripts in /usr/local/bin)
      try {
        final res = await Process.run('/usr/bin/xdg-open', [urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // Try xdg-open in PATH
      try {
        final res = await Process.run('xdg-open', [urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}

      // flatpak-spawn (for sandboxed desktop environments)
      try {
        final res = await Process.run('flatpak-spawn', [
          '--host',
          'xdg-open',
          urlStr,
        ]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    } else if (Platform.isMacOS) {
      try {
        final res = await Process.run('open', [urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    } else if (Platform.isWindows) {
      try {
        final res = await Process.run('explorer.exe', [urlStr]);
        if (res.exitCode == 0) return true;
      } catch (_) {}
    }

    // 2. Standard url_launcher across mobile (Android, iOS) and desktop fallback
    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        return true;
      }
    } catch (_) {}

    try {
      if (await launchUrl(url, mode: LaunchMode.platformDefault)) {
        return true;
      }
    } catch (_) {}

    return false;
  }
}
