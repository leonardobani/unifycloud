import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../models/settings_models.dart';
import 'cosmic_icons.dart';

class AppTheme {
  // Standard Theme Colors
  static const primaryColor = Color(0xFF1E88E5); // Modern Cloud Blue
  static const secondaryColor = Color(0xFF26A69A); // Teal accent
  static const surfaceDark = Color(0xFF121820);
  static const surfaceColor = surfaceDark;
  static const backgroundDark = Color(0xFF0D1117);
  static const cardDark = Color(0xFF1A222D);

  static const surfaceLight = Color(0xFFFFFFFF);
  static const backgroundLight = Color(0xFFF8F9FA);
  static const cardLight = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFE2E8F0);
  static const borderDark = Color(0xFF2D3748);

  // COSMIC (System76) Theme Colors
  // Light mode accent: Cosmic Teal
  static const cosmicTeal = Color(0xFF2E9EA8);
  static const cosmicTealAccent = Color(0xFF48B9C7);
  static const cosmicBackgroundLight = Color(0xFFF4F6F8);
  static const cosmicSurfaceLight = Color(0xFFFFFFFF);
  static const cosmicCardLight = Color(0xFFFFFFFF);
  static const cosmicBorderLight = Color(0xFFDCE2E6);

  // Dark mode accent: Pop Orange
  static const popOrange = Color(0xFFF07127);
  static const popOrangeAccent = Color(0xFFFFA726);
  static const cosmicBackgroundDark = Color(0xFF181B1C);
  static const cosmicSurfaceDark = Color(0xFF24282B);
  static const cosmicCardDark = Color(0xFF292E31);
  static const cosmicBorderDark = Color(0xFF3C4348);

  /// Checks if the operating system is Linux and running under the COSMIC desktop environment.
  static bool isCosmicDesktopEnvironment() {
    if (kIsWeb) return false;
    if (!Platform.isLinux) return false;
    final desktop = (Platform.environment['XDG_CURRENT_DESKTOP'] ?? '').toUpperCase();
    final session = (Platform.environment['XDG_SESSION_DESKTOP'] ?? '').toUpperCase();
    final qpa = (Platform.environment['QT_QPA_PLATFORMTHEME'] ?? '').toUpperCase();
    return desktop.contains('COSMIC') || session.contains('COSMIC') || qpa.contains('COSMIC');
  }

  /// Determines whether the COSMIC style should be applied according to [style] preference.
  static bool isCosmicActive(AppThemeStyle style) {
    switch (style) {
      case AppThemeStyle.cosmic:
        return true;
      case AppThemeStyle.standard:
        return false;
      case AppThemeStyle.auto:
        return isCosmicDesktopEnvironment();
    }
  }

  /// Main dark theme for UnifyCloud across all devices (COSMIC style with Pop Orange accent).
  static ThemeData get darkTheme => cosmicDarkTheme;

  /// Main light theme for UnifyCloud across all devices (COSMIC style with Cosmic Teal accent).
  static ThemeData get lightTheme => cosmicLightTheme;

  /// Classic Material 3 dark theme.
  static ThemeData get standardDarkTheme {
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
          side: BorderSide(color: borderDark, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  /// Classic Material 3 light theme.
  static ThemeData get standardLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: surfaceLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardTheme: const CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: borderLight, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: Color(0xFF1A1C1E),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: backgroundLight,
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        selectedIconTheme: const IconThemeData(color: primaryColor),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF43474E)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        elevation: 2,
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  /// System76 COSMIC desktop light theme with Cosmic Teal accent.
  static ThemeData get cosmicLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cosmicTeal,
        brightness: Brightness.light,
        primary: cosmicTeal,
        surface: cosmicSurfaceLight,
      ),
      scaffoldBackgroundColor: cosmicBackgroundLight,
      cardTheme: const CardThemeData(
        color: cosmicCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: cosmicBorderLight, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cosmicBackgroundLight,
        foregroundColor: Color(0xFF181B1C),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cosmicBackgroundLight,
        indicatorColor: cosmicTeal.withValues(alpha: 0.18),
        selectedIconTheme: const IconThemeData(color: cosmicTeal),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF43474E)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cosmicSurfaceLight,
        indicatorColor: cosmicTeal.withValues(alpha: 0.18),
        elevation: 1,
      ),
      dividerTheme: const DividerThemeData(
        color: cosmicBorderLight,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: cosmicSurfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: cosmicBorderLight, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cosmicSurfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: cosmicBorderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: cosmicBorderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: cosmicTeal, width: 1.5),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }

  /// System76 COSMIC desktop dark theme with Pop Orange accent.
  static ThemeData get cosmicDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: popOrange,
        brightness: Brightness.dark,
        primary: popOrange,
        surface: cosmicSurfaceDark,
      ),
      scaffoldBackgroundColor: cosmicBackgroundDark,
      cardTheme: const CardThemeData(
        color: cosmicCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: cosmicBorderDark, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cosmicBackgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: cosmicBackgroundDark,
        indicatorColor: popOrange,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cosmicSurfaceDark,
        indicatorColor: popOrange.withValues(alpha: 0.25),
      ),
      dividerTheme: const DividerThemeData(
        color: cosmicBorderDark,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: cosmicSurfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: cosmicBorderDark, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cosmicSurfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: cosmicBorderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: cosmicBorderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: popOrange, width: 1.5),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
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
      case 'crypt':
        return const Color(0xFF00BFA5); // Emerald / Teal security accent
      default:
        return primaryColor;
    }
  }

  /// Icon associated with each cloud provider.
  static IconData getProviderIcon(String type) {
    switch (type.toLowerCase()) {
      case 'drive':
        return CosmicIcons.cloudDrive;
      case 'dropbox':
        return CosmicIcons.cloudDropbox;
      case 'onedrive':
        return CosmicIcons.cloudOneDrive;
      case 's3':
        return CosmicIcons.storage;
      case 'sftp':
        return CosmicIcons.terminal;
      case 'webdav':
        return CosmicIcons.networkServer;
      case 'local':
        return CosmicIcons.deviceLaptop;
      case 'crypt':
        return CosmicIcons.lock;
      default:
        return CosmicIcons.cloud;
    }
  }
}
