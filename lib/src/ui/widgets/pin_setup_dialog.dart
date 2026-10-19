import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/cosmic_icons.dart';

/// Mode for [PinSetupDialog].
enum PinDialogMode {
  /// Setting up a PIN for the first time.
  setup,

  /// Changing an existing PIN (requires entering the old PIN first).
  change,

  /// Verifying the existing PIN (e.g. before disabling App Lock).
  verify,
}

/// Dialog for setting up, changing, or verifying the App Lock PIN.
class PinSetupDialog extends StatefulWidget {
  final PinDialogMode mode;
  final Future<bool> Function(String pin)? onVerifyOldPin;
  final Future<void> Function(String newPin)? onSaveNewPin;

  const PinSetupDialog({
    super.key,
    required this.mode,
    this.onVerifyOldPin,
    this.onSaveNewPin,
  });

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  // Steps:
  // 0: Enter old PIN (only in change or verify mode)
  // 1: Enter new PIN (setup or change mode)
  // 2: Confirm new PIN (setup or change mode)
  late int _currentStep;
  String _enteredNewPin = '';
  String _enteredConfirmPin = '';

  String? _errorMessage;
  bool _isLoading = false;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentStep = (widget.mode == PinDialogMode.setup) ? 1 : 0;
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.mode) {
      case PinDialogMode.setup:
        return _currentStep == 1 ? 'Imposta Codice PIN' : 'Conferma Codice PIN';
      case PinDialogMode.change:
        if (_currentStep == 0) return 'Inserisci PIN Attuale';
        return _currentStep == 1 ? 'Nuovo Codice PIN' : 'Conferma Nuovo PIN';
      case PinDialogMode.verify:
        return 'Verifica Codice PIN';
    }
  }

  String get _subtitle {
    switch (widget.mode) {
      case PinDialogMode.setup:
        return _currentStep == 1
            ? 'Crea un codice numerico a 6 cifre per proteggere l\'app.'
            : 'Digita nuovamente il codice PIN per confermarlo.';
      case PinDialogMode.change:
        if (_currentStep == 0) {
          return 'Inserisci il tuo codice PIN attuale per continuare.';
        }
        return _currentStep == 1
            ? 'Inserisci il nuovo codice PIN a 6 cifre.'
            : 'Digita nuovamente il nuovo PIN per confermarlo.';
      case PinDialogMode.verify:
        return 'Inserisci il tuo codice PIN per confermare l\'operazione.';
    }
  }

  void _onDigitPressed(String digit) {
    if (_pinController.text.length < 6) {
      setState(() {
        _errorMessage = null;
        _pinController.text += digit;
      });
    }
  }

  void _onBackspacePressed() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _errorMessage = null;
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  Future<void> _submitCurrentStep() async {
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      setState(() {
        _errorMessage = 'Il PIN deve avere esattamente 6 cifre';
      });
      return;
    }

    if (_currentStep == 0) {
      // Verifying old PIN
      setState(() => _isLoading = true);
      final isValid = widget.onVerifyOldPin != null
          ? await widget.onVerifyOldPin!(pin)
          : true;
      setState(() => _isLoading = false);

      if (!isValid) {
        setState(() {
          _errorMessage = 'Codice PIN errato. Riprova.';
          _pinController.clear();
        });
        return;
      }

      if (widget.mode == PinDialogMode.verify) {
        if (mounted) Navigator.of(context).pop(true);
        return;
      }

      // Transition to entering new PIN
      setState(() {
        _currentStep = 1;
        _pinController.clear();
        _errorMessage = null;
      });
    } else if (_currentStep == 1) {
      // Entering new PIN -> transition to confirm
      setState(() {
        _enteredNewPin = pin;
        _currentStep = 2;
        _pinController.clear();
        _errorMessage = null;
      });
    } else if (_currentStep == 2) {
      // Confirming new PIN
      _enteredConfirmPin = pin;
      if (_enteredConfirmPin != _enteredNewPin) {
        setState(() {
          _errorMessage = 'I codici PIN non corrispondono. Riprova.';
          _pinController.clear();
        });
        return;
      }

      setState(() => _isLoading = true);
      if (widget.onSaveNewPin != null) {
        await widget.onSaveNewPin!(_enteredNewPin);
      }
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pinLength = _pinController.text.length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and Title
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: CosmicSvgIcon(
                  CosmicIcons.lockSvg,
                  size: 30,
                  color: colorScheme.onPrimaryContainer,
                  fallbackMaterialIcon: Icons.lock_rounded,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // PIN Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final isFilled = index < pinLength;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: isFilled
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Keyboard Listener for hardware keyboards
              KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    final key = event.logicalKey;
                    if (key == LogicalKeyboardKey.backspace) {
                      _onBackspacePressed();
                    } else if (key == LogicalKeyboardKey.enter) {
                      _submitCurrentStep();
                    } else {
                      final char = event.character;
                      if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
                        _onDigitPressed(char);
                      }
                    }
                  }
                },
                child: const SizedBox.shrink(),
              ),

              // Numeric Keypad (Grid of buttons)
              _buildKeypad(colorScheme),
              const SizedBox(height: 16),

              // Action buttons (Cancel / Confirm)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: const Text('Annulla'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: (_isLoading || pinLength != 6)
                        ? null
                        : _submitCurrentStep,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_currentStep == 2 ||
                                widget.mode == PinDialogMode.verify
                            ? 'Conferma'
                            : 'Continua'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildKeypad(ColorScheme colorScheme) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((d) => _buildKeypadButton(d, colorScheme)).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 60, height: 48), // Empty placeholder
              _buildKeypadButton('0', colorScheme),
              InkWell(
                onTap: _onBackspacePressed,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 60,
                  height: 48,
                  alignment: Alignment.center,
                  child: CosmicSvgIcon(
                    CosmicIcons.undoSvg,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                    fallbackMaterialIcon: Icons.backspace_outlined,
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 60,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
