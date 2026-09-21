import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../services/app_lock_service.dart';
import 'settings_provider.dart';

/// State of the App Lock system.
class AppLockState {
  final bool isLocked;
  final bool canCheckBiometrics;
  final List<BiometricType> availableBiometrics;
  final bool hasPin;
  final bool isAuthenticating;
  final String? errorMessage;
  final DateTime? lastPausedAt;

  const AppLockState({
    this.isLocked = false,
    this.canCheckBiometrics = false,
    this.availableBiometrics = const [],
    this.hasPin = false,
    this.isAuthenticating = false,
    this.errorMessage,
    this.lastPausedAt,
  });

  AppLockState copyWith({
    bool? isLocked,
    bool? canCheckBiometrics,
    List<BiometricType>? availableBiometrics,
    bool? hasPin,
    bool? isAuthenticating,
    String? Function()? errorMessage,
    DateTime? Function()? lastPausedAt,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      hasPin: hasPin ?? this.hasPin,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      lastPausedAt: lastPausedAt != null ? lastPausedAt() : this.lastPausedAt,
    );
  }
}

/// Provider exposing [AppLockState] and [AppLockNotifier].
final appLockProvider =
    NotifierProvider<AppLockNotifier, AppLockState>(AppLockNotifier.new);

/// Riverpod 3 Notifier managing App Lock state, biometrics, and lifecycle-based auto-lock.
class AppLockNotifier extends Notifier<AppLockState>
    with WidgetsBindingObserver {
  bool _disposed = false;

  @override
  AppLockState build() {
    final settings = ref.watch(settingsProvider);
    _disposed = false;

    // Initial state: locked if appLockEnabled is true
    final initialState = AppLockState(
      isLocked: settings.appLockEnabled,
    );

    // Register lifecycle observer
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    ref.onDispose(() {
      _disposed = true;
      binding.removeObserver(this);
    });

    // Check biometrics and PIN in background
    scheduleMicrotask(() {
      if (!_disposed) {
        refreshCapabilities();
      }
    });

    return initialState;
  }

  /// Refreshes biometric capabilities and PIN presence from secure storage.
  Future<void> refreshCapabilities() async {
    if (_disposed) return;
    final service = ref.read(appLockServiceProvider);
    final canBio = await service.canCheckBiometrics();
    if (_disposed) return;
    final biometrics = await service.getAvailableBiometrics();
    if (_disposed) return;
    final hasPin = await service.hasPin();
    if (_disposed) return;

    state = state.copyWith(
      canCheckBiometrics: canBio,
      availableBiometrics: biometrics,
      hasPin: hasPin,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    final settings = ref.read(settingsProvider);
    if (!settings.appLockEnabled) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      this.state = this.state.copyWith(lastPausedAt: () => DateTime.now());
    } else if (state == AppLifecycleState.resumed) {
      final lastPaused = this.state.lastPausedAt;
      if (lastPaused != null) {
        final elapsed = DateTime.now().difference(lastPaused);
        final timeout = Duration(minutes: settings.autoLockTimeoutMinutes);

        if (elapsed >= timeout) {
          this.state = this.state.copyWith(
            isLocked: true,
            lastPausedAt: () => null,
          );
        } else {
          this.state = this.state.copyWith(lastPausedAt: () => null);
        }
      }
    }
  }

  /// Manually locks the app immediately.
  void lock() {
    if (_disposed) return;
    state = state.copyWith(isLocked: true, errorMessage: () => null);
  }

  /// Unlocks the app and clears any error message.
  void unlock() {
    if (_disposed) return;
    state = state.copyWith(
      isLocked: false,
      isAuthenticating: false,
      errorMessage: () => null,
    );
  }

  /// Verifies the entered PIN. Unlocks if correct, otherwise sets an error message.
  Future<bool> verifyPin(String pin) async {
    if (_disposed) return false;
    final service = ref.read(appLockServiceProvider);
    state = state.copyWith(isAuthenticating: true, errorMessage: () => null);
    try {
      final isValid = await service.verifyPin(pin);
      if (_disposed) return isValid;
      if (isValid) {
        unlock();
        return true;
      } else {
        state = state.copyWith(
          isAuthenticating: false,
          errorMessage: () => 'Codice PIN errato. Riprova.',
        );
        return false;
      }
    } catch (e) {
      if (_disposed) return false;
      state = state.copyWith(
        isAuthenticating: false,
        errorMessage: () => 'Errore durante la verifica: $e',
      );
      return false;
    }
  }

  /// Prompts for biometric authentication (fingerprint / face unlock).
  Future<bool> authenticateWithBiometrics() async {
    if (_disposed) return false;
    final settings = ref.read(settingsProvider);
    if (!settings.useBiometrics || !state.canCheckBiometrics) return false;

    final service = ref.read(appLockServiceProvider);
    state = state.copyWith(isAuthenticating: true, errorMessage: () => null);
    try {
      final success = await service.authenticateWithBiometrics(
        reason: 'Autenticati per accedere a UnifyCloud',
      );
      if (_disposed) return success;
      if (success) {
        unlock();
        return true;
      } else {
        state = state.copyWith(isAuthenticating: false);
        return false;
      }
    } catch (_) {
      if (_disposed) return false;
      state = state.copyWith(isAuthenticating: false);
      return false;
    }
  }
}
