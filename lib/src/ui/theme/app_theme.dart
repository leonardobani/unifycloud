import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF1E88E5); // Modern Cloud Blue
  static const secondaryColor = Color(0xFF26A69A); // Teal accent
  static const surfaceDark = Color(0xFF121820);
  static const surfaceColor = surfaceDark;
  static const backgroundDark = Color(0xFF0D1117);
  static const cardDark = Color(0xFF1A222D);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: surfaceDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardTheme: const CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Color(0xFF2D3748), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: backgroundDark,
        indicatorColor: primaryColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: primaryColor.withValues(alpha: 0.2),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
    );
  }

  /// Color associated with each cloud provider.
  static Color getProviderColor(String type) {
    switch (type.toLowerCase()) {
      case 'drive':
        return const Color(0xFF4285F4);
      case 'dropbox':
        return const Color(0xFF0061FF);
      case 'onedrive':
        return const Color(0xFF0078D4);
      case 's3':
        return const Color(0xFFFF9900);
      case 'sftp':
        return const Color(0xFF4CAF50);
      case 'webdav':
        return const Color(0xFF9C27B0);
      case 'local':
        return const Color(0xFF607D8B);
      default:
        return primaryColor;
    }
  }

  /// Icon associated with each cloud provider.
  static IconData getProviderIcon(String type) {
    switch (type.toLowerCase()) {
      case 'drive':
        return Icons.add_to_drive;
      case 'dropbox':
        return Icons.inventory_2_outlined;
      case 'onedrive':
        return Icons.cloud_circle_outlined;
      case 's3':
        return Icons.storage_outlined;
      case 'sftp':
        return Icons.terminal_outlined;
      case 'webdav':
        return Icons.dns_outlined;
      case 'local':
        return Icons.laptop_outlined;
      default:
        return Icons.cloud_outlined;
    }
  }
}
