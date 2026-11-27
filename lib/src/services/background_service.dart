import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n_extension.dart';

/// Riverpod provider for [AppBackgroundService].
final appBackgroundServiceProvider = Provider<AppBackgroundService>((ref) {
  return AppBackgroundService();
});

/// Top-level background entrypoint for Android and iOS foreground service.
@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  // Listen to transfer progress updates dispatched from the main app isolate
  service.on('updateTransferProgress').listen((event) async {
    if (event == null) return;
    final activeCount = event['activeCount'] as int? ?? 0;
    final formattedSpeed = event['formattedSpeed'] as String? ?? '0 B/s';
    final percentage = event['averagePercentage'] as int? ?? 0;
    final langCode = event['locale'] as String?;
    final l10n = resolveAppLocalizations(
      langCode != null && langCode.isNotEmpty ? Locale(langCode) : null,
    );

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService() == false) {
        await service.setAsForegroundService();
      }

      await service.setForegroundNotificationInfo(
        title: '${l10n.appTitle}: ${l10n.activeTransfersCount(activeCount)}',
        content: l10n.bgNotificationProgressContent(formattedSpeed, percentage),
      );
    }
  });

  // When transfers complete or queue is idle, release foreground notification
  service.on('setIdle').listen((event) async {
    final langCode = event?['locale'] as String?;
    final l10n = resolveAppLocalizations(
      langCode != null && langCode.isNotEmpty ? Locale(langCode) : null,
    );
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: l10n.appTitle,
        content: l10n.bgNotificationIdleContent,
      );
      await service.setAsBackgroundService();
    }
  });

  // Explicit stop signal
  service.on('stop').listen((event) async {
    await service.stopSelf();
  });
}

/// iOS Background fetch handler called periodically by iOS BGTaskScheduler.
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

/// Service that coordinates background file transfer tasks across mobile platforms
/// and gracefully no-ops on desktop environments.
class AppBackgroundService {

  AppBackgroundService([FlutterBackgroundService? service])
      : _service = service ?? FlutterBackgroundService();
  final FlutterBackgroundService _service;
  bool _isInitialized = false;

  /// Whether the service has been initialized.
  bool get isInitialized => _isInitialized;

  /// Whether background service plugins are supported on current platform.
  bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Initializes the background service with notification channel and foreground parameters.
  Future<bool> initialize({Locale? locale}) async {
    if (!isSupported) {
      _isInitialized = true;
      return true;
    }

    try {
      final l10n = resolveAppLocalizations(locale);
      final configured = await _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          autoStartOnBoot: false,
          notificationChannelId: 'unifycloud_transfers',
          initialNotificationTitle: l10n.bgNotificationInitialTitle,
          initialNotificationContent: l10n.bgNotificationInitialContent,
          foregroundServiceNotificationId: 9876,
          foregroundServiceTypes: [AndroidForegroundType.dataSync],
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );

      _isInitialized = configured;
      return configured;
    } catch (e) {
      debugPrint('[AppBackgroundService] Initialization failed: $e');
      return false;
    }
  }

  /// Sends live transfer metrics to the background service notification.
  Future<void> notifyTransferProgress({
    required int activeCount,
    required double totalSpeed,
    required int averagePercentage,
    required String formattedSpeed,
    Locale? locale,
  }) async {
    if (!isSupported) return;

    try {
      final running = await _service.isRunning();
      if (!running && activeCount > 0) {
        await _service.startService();
      }

      _service.invoke('updateTransferProgress', {
        'activeCount': activeCount,
        'totalSpeed': totalSpeed,
        'averagePercentage': averagePercentage,
        'formattedSpeed': formattedSpeed,
        if (locale != null) 'locale': locale.languageCode,
      });
    } catch (e) {
      debugPrint('[AppBackgroundService] Error notifying progress: $e');
    }
  }

  /// Notifies the background service that all active transfers have finished.
  Future<void> notifyTransfersIdle({Locale? locale}) async {
    if (!isSupported) return;

    try {
      final running = await _service.isRunning();
      if (running) {
        _service.invoke('setIdle', {
          if (locale != null) 'locale': locale.languageCode,
        });
      }
    } catch (e) {
      debugPrint('[AppBackgroundService] Error notifying idle: $e');
    }
  }

  /// Stops the background service completely.
  Future<void> stop() async {
    if (!isSupported) return;

    try {
      final running = await _service.isRunning();
      if (running) {
        _service.invoke('stop');
      }
    } catch (e) {
      debugPrint('[AppBackgroundService] Error stopping service: $e');
    }
  }
}
