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
  final int failedAttempts;
  final DateTime? lockoutUntil;

  const AppLockState({
    this.isLocked = false,
    this.canCheckBiometrics = false,
    this.availableBiometrics = const [],
    this.hasPin = false,
    this.isAuthenticating = false,
    this.errorMessage,
    this.lastPausedAt,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  bool get isLockedOut =>
      lockoutUntil != null && DateTime.now().isBefore(lockoutUntil!);

  AppLockState copyWith({
    bool? isLocked,
    bool? canCheckBiometrics,
    List<BiometricType>? availableBiometrics,
    bool? hasPin,
    bool? isAuthenticating,
    String? Function()? errorMessage,
    DateTime? Function()? lastPausedAt,
    int? failedAttempts,
    DateTime? Function()? lockoutUntil,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      hasPin: hasPin ?? this.hasPin,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      lastPausedAt: lastPausedAt != null ? lastPausedAt() : this.lastPausedAt,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil != null ? lockoutUntil() : this.lockoutUntil,
    );
  }
}

/// Provider exposing [AppLockState] and [AppLockNotifier].
final appLockProvider =
    NotifierProvider<AppLockNotifier, AppLockState>(AppLockNotifier.new);

/// Riverpod 3 Notifier managing App Lock state, biometrics, rate-limiting, and auto-lock.
class AppLockNotifier extends Notifier<AppLockState>
    with WidgetsBindingObserver {
  static const int _maxFreeAttempts = 5;
  bool _disposed = false;
  Timer? _inactivityTimer;

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
      _inactivityTimer?.cancel();
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

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    if (_disposed || state.isLocked) return;

    final settings = ref.read(settingsProvider);
    if (!settings.appLockEnabled || settings.autoLockTimeoutMinutes <= 0) {
      return;
    }

    _inactivityTimer = Timer(
      Duration(minutes: settings.autoLockTimeoutMinutes),
      lock,
    );
  }

  /// Records user interaction to postpone foreground inactivity auto-lock.
  void recordActivity() {
    if (_disposed || state.isLocked) return;
    _resetInactivityTimer();
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
    _inactivityTimer?.cancel();
    state = state.copyWith(isLocked: true, errorMessage: () => null);
  }

  /// Unlocks the app and clears any error message and failed attempt counters.
  void unlock() {
    if (_disposed) return;
    state = state.copyWith(
      isLocked: false,
      isAuthenticating: false,
      errorMessage: () => null,
      failedAttempts: 0,
      lockoutUntil: () => null,
    );
    _resetInactivityTimer();
  }

  /// Verifies the entered PIN. Unlocks if correct, otherwise sets an error message
  /// and enforces exponential backoff after [_maxFreeAttempts] failures.
  Future<bool> verifyPin(String pin) async {
    if (_disposed) return false;

    final now = DateTime.now();
    if (state.lockoutUntil != null && now.isBefore(state.lockoutUntil!)) {
      final remaining = state.lockoutUntil!.difference(now).inSeconds + 1;
      state = state.copyWith(
        errorMessage: () =>
            'Troppi tentativi falliti. Riprova tra ${remaining}s.',
      );
      return false;
    }

    final service = ref.read(appLockServiceProvider);
    state = state.copyWith(isAuthenticating: true, errorMessage: () => null);
    try {
      final isValid = await service.verifyPin(pin);
      if (_disposed) return isValid;
      if (isValid) {
        unlock();
        return true;
      } else {
        final nextAttempts = state.failedAttempts + 1;
        DateTime? nextLockout;
        var msg = 'Codice PIN errato. Riprova.';
        if (nextAttempts >= _maxFreeAttempts) {
          final exponent = (nextAttempts - _maxFreeAttempts).clamp(0, 5);
          final cooldownSec = (30 * (1 << exponent)).clamp(30, 900);
          nextLockout = DateTime.now().add(Duration(seconds: cooldownSec));
          msg = 'Troppi tentativi falliti. Riprova tra ${cooldownSec}s.';
        }
        state = state.copyWith(
          isAuthenticating: false,
          failedAttempts: nextAttempts,
          lockoutUntil: () => nextLockout,
          errorMessage: () => msg,
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
