import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_lock_provider.dart';
import '../../providers/settings_provider.dart';

/// Full-screen lock widget displayed when UnifyCloud is locked.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final List<String> _enteredDigits = [];
  final FocusNode _focusNode = FocusNode();
  bool _hasAttemptedAutoBiometrics = false;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() => _triggerAutoBiometrics());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _triggerAutoBiometrics() {
    if (_hasAttemptedAutoBiometrics || !mounted) return;
    _hasAttemptedAutoBiometrics = true;

    final settings = ref.read(settingsProvider);
    final lockState = ref.read(appLockProvider);

    if (settings.useBiometrics && lockState.canCheckBiometrics) {
      ref.read(appLockProvider.notifier).authenticateWithBiometrics();
    }
  }

  void _onDigitPressed(String digit) {
    if (_enteredDigits.length < 6) {
      setState(() {
        _enteredDigits.add(digit);
      });

      // Auto-submit when 6 digits are entered
      if (_enteredDigits.length == 6) {
        _submitPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredDigits.isNotEmpty) {
      setState(() {
        _enteredDigits.removeLast();
      });
    }
  }

  Future<void> _submitPin() async {
    final pin = _enteredDigits.join();
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.verifyPin(pin);

    if (!success && mounted) {
      setState(() {
        _enteredDigits.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lockState = ref.watch(appLockProvider);
    final settings = ref.watch(settingsProvider);

    return PopScope(
      canPop: false, // Prevent dismissing lock screen via back button
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                final key = event.logicalKey;
                if (key == LogicalKeyboardKey.backspace) {
                  _onBackspacePressed();
                } else {
                  final char = event.character;
                  if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
                    _onDigitPressed(char);
                  }
                }
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lock Icon & Header
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 38,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'UnifyCloud',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Applicazione bloccata',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // PIN Indicators (up to 6 dots)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final isFilled = index < _enteredDigits.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest,
                              border: Border.all(
                                color: isFilled
                                    ? colorScheme.primary
                                    : colorScheme.outline.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Error message (if any)
                      AnimatedOpacity(
                        opacity: lockState.errorMessage != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          lockState.errorMessage ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Numeric Keypad
                      _buildKeypad(
                        colorScheme,
                        showBiometricsButton:
                            settings.useBiometrics && lockState.canCheckBiometrics,
                      ),
                      const SizedBox(height: 24),

                      // Biometrics alternative button
                      if (settings.useBiometrics && lockState.canCheckBiometrics)
                        TextButton.icon(
                          onPressed: () {
                            ref
                                .read(appLockProvider.notifier)
                                .authenticateWithBiometrics();
                          },
                          icon: const Icon(Icons.fingerprint_rounded, size: 24),
                          label: const Text(
                            'Sblocca con Biometria',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(
    ColorScheme colorScheme, {
    required bool showBiometricsButton,
  }) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((d) => _buildKeypadButton(d, colorScheme)).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left button: Biometrics shortcut (or empty)
              if (showBiometricsButton)
                InkWell(
                  onTap: () {
                    ref
                        .read(appLockProvider.notifier)
                        .authenticateWithBiometrics();
                  },
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.fingerprint_rounded,
                      size: 28,
                      color: colorScheme.primary,
                    ),
                  ),
                )
              else
                const SizedBox(width: 70, height: 70),

              // Middle: 0
              _buildKeypadButton('0', colorScheme),

              // Right: Backspace
              InkWell(
                onTap: _onBackspacePressed,
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 24,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _onDigitPressed(digit),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

