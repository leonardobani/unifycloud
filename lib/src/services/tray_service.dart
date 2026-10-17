// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/legacy.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/settings_provider.dart';

/// Riverpod provider for [TrayService].
final trayServiceProvider = Provider<TrayService>((ref) {
  final service = TrayService(ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// Service managing system tray panel indicator and window behavior on desktop platforms.
class TrayService with TrayListener, WindowListener {
  final Ref _ref;
  final TrayManager? _customTrayManager;
  final WindowManager? _customWindowManager;
  bool _isInitialized = false;
  int _activeTransfers = 0;
  String _formattedSpeed = '';

  TrayService(
    this._ref, [
    TrayManager? trayManager,
    WindowManager? windowManager,
  ])  : _customTrayManager = trayManager,
        _customWindowManager = windowManager;

  TrayManager get _trayManager => _customTrayManager ?? trayManager;
  WindowManager get _windowManager =>
      _customWindowManager ?? WindowManager.instance;

  /// Whether desktop tray management is supported in the current runtime environment.
  bool get isSupported {
    if (kIsWeb) return false;
    if (Platform.environment.containsKey('FLUTTER_TEST')) return false;
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  /// Whether the tray service has completed initialization.
  bool get isInitialized => _isInitialized;

  int get activeTransfers => _activeTransfers;
  String get formattedSpeed => _formattedSpeed;

  /// Initializes the system tray icon, window listeners, and context menu.
  Future<void> initialize({bool startHidden = false}) async {
    if (!isSupported) return;

    try {
      await _windowManager.ensureInitialized();
      _windowManager.addListener(this);
      _trayManager.addListener(this);

      // Prevent default closing when minimize-to-tray is preferred
      await _windowManager.setPreventClose(true);

      // Setup Tray Icon & Tooltip
      const iconPath = 'assets/icons/tray_icon.png';
      await _trayManager.setIcon(iconPath);
      await _trayManager.setToolTip('UnifyCloud');

      _isInitialized = true;
      await updateTrayMenu();

      if (startHidden) {
        await _windowManager.hide();
      } else {
        await _windowManager.show();
        await _windowManager.focus();
      }
    } catch (e) {
      debugPrint('[TrayService] Initialization error: $e');
    }
  }

  /// Updates transfer metrics in the system tray menu and tooltip.
  Future<void> updateTransferStatus({
    required int activeTransfers,
    String? formattedSpeed,
  }) async {
    _activeTransfers = activeTransfers;
    _formattedSpeed = formattedSpeed ?? '';
    if (!_isInitialized || !isSupported) return;

    try {
      final tooltip = activeTransfers > 0
          ? 'UnifyCloud: $activeTransfers ${_activeTransfers == 1 ? 'trasferimento attivo' : 'trasferimenti attivi'} ($_formattedSpeed)'
          : 'UnifyCloud';
      await _trayManager.setToolTip(tooltip);
      await updateTrayMenu();
    } catch (e) {
      debugPrint('[TrayService] Error updating transfer status: $e');
    }
  }

  /// Refreshes the tray context menu actions.
  Future<void> updateTrayMenu() async {
    if (!_isInitialized || !isSupported) return;

    try {
      final statusLabel = _activeTransfers > 0
          ? '$_activeTransfers ${_activeTransfers == 1 ? 'trasferimento attivo' : 'trasferimenti attivi'} ($_formattedSpeed)'
          : 'Inattivo (Nessun trasferimento)';

      final menu = Menu(
        items: [
          MenuItem(
            key: 'show_window',
            label: 'Mostra UnifyCloud',
          ),
          MenuItem(
            key: 'hide_window',
            label: 'Riduci nel vassoio',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'status',
            label: 'Stato: $statusLabel',
            disabled: true,
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            label: 'Esci da UnifyCloud',
          ),
        ],
      );

      await _trayManager.setContextMenu(menu);
    } catch (e) {
      debugPrint('[TrayService] Error updating context menu: $e');
    }
  }

  @override
  void onTrayIconMouseDown() async {
    if (!isSupported) return;
    try {
      final isVisible = await _windowManager.isVisible();
      if (isVisible) {
        await _windowManager.hide();
      } else {
        await _windowManager.show();
        await _windowManager.focus();
      }
    } catch (_) {}
  }

  @override
  void onTrayIconRightMouseDown() {
    if (!isSupported) return;
    _trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show_window':
        await _windowManager.show();
        await _windowManager.focus();
        break;
      case 'hide_window':
        await _windowManager.hide();
        break;
      case 'exit_app':
        await quitApp();
        break;
    }
  }

  @override
  void onWindowClose() async {
    final settings = _ref.read(settingsProvider);
    if (settings.minimizeToTray) {
      await _windowManager.hide();
    } else {
      await quitApp();
    }
  }

  /// Closes the application completely and cleans up native resources.
  Future<void> quitApp() async {
    try {
      if (isSupported) {
        await _windowManager.destroy();
      }
    } catch (_) {}
    exit(0);
  }

  /// Cleans up listeners when service is disposed.
  void dispose() {
    if (!isSupported) return;
    _trayManager.removeListener(this);
    _windowManager.removeListener(this);
  }
}
