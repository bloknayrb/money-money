import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../shared/widgets/pin_number_pad.dart';

/// PIN setup screen for initial configuration or PIN change.
class PinSetupScreen extends ConsumerStatefulWidget {
  /// If true, this is a PIN change flow (requires old PIN first).
  final bool isChange;

  const PinSetupScreen({super.key, this.isChange = false});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

enum _SetupStep { enterOld, enterNew, confirmNew }

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _pin = '';
  String _firstPin = '';
  bool _isError = false;
  bool _isProcessing = false;
  String _errorMessage = '';
  late _SetupStep _step;

  static const int pinLength = 6;

  @override
  void initState() {
    super.initState();
    _step = widget.isChange ? _SetupStep.enterOld : _SetupStep.enterNew;
  }

  String get _instructionText {
    switch (_step) {
      case _SetupStep.enterOld:
        return 'Enter your current PIN';
      case _SetupStep.enterNew:
        return widget.isChange ? 'Enter your new PIN' : 'Create a 6-digit PIN';
      case _SetupStep.confirmNew:
        return 'Confirm your PIN';
    }
  }

  String get _title {
    if (widget.isChange) return 'Change PIN';
    return 'Set Up PIN';
  }

  String get _subtitle {
    if (!widget.isChange) {
      return 'This PIN will be used to protect your financial data.';
    }
    return '';
  }

  void _addDigit(String digit) {
    if (_pin.length >= pinLength || _isProcessing) return;

    setState(() {
      _pin += digit;
      _isError = false;
      _errorMessage = '';
    });

    if (_pin.length == pinLength) {
      _handlePinComplete();
    }
  }

  void _removeDigit() {
    if (_pin.isEmpty || _isProcessing) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _isError = false;
      _errorMessage = '';
    });
  }

  Future<void> _handlePinComplete() async {
    switch (_step) {
      case _SetupStep.enterOld:
        await _verifyOldPin();
      case _SetupStep.enterNew:
        _saveFirstPin();
      case _SetupStep.confirmNew:
        await _confirmAndSave();
    }
  }

  Future<void> _verifyOldPin() async {
    setState(() => _isProcessing = true);

    final pinService = ref.read(pinServiceProvider);
    final isValid = await pinService.verifyPin(_pin);

    if (!mounted) return;

    if (isValid) {
      setState(() {
        _pin = '';
        _step = _SetupStep.enterNew;
        _isProcessing = false;
      });
    } else {
      setState(() {
        _isError = true;
        _errorMessage = 'Incorrect PIN';
        _pin = '';
        _isProcessing = false;
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _saveFirstPin() {
    _firstPin = _pin;
    setState(() {
      _pin = '';
      _step = _SetupStep.confirmNew;
    });
  }

  Future<void> _confirmAndSave() async {
    if (_pin != _firstPin) {
      setState(() {
        _isError = true;
        _errorMessage = 'PINs don\'t match. Try again.';
        _pin = '';
        _step = _SetupStep.enterNew;
        _firstPin = '';
      });
      HapticFeedback.mediumImpact();
      return;
    }

    setState(() => _isProcessing = true);

    final pinService = ref.read(pinServiceProvider);
    await pinService.setupPin(_pin);

    if (!mounted) return;

    HapticFeedback.heavyImpact();

    if (widget.isChange) {
      // PIN change flow: pop back to settings
      context.pop(true);
    } else {
      // First-time setup: check if user has accounts
      ref.read(hasPinCachedProvider.notifier).state = true;
      ref.invalidate(hasPinProvider);
      ref.read(isUnlockedProvider.notifier).state = true;

      // If no accounts exist, show onboarding; otherwise go to dashboard
      final accountCount = await ref.read(accountRepositoryProvider).getAccountCount();
      if (!mounted) return;

      if (accountCount == 0) {
        context.go(AppRoutes.onboarding);
      } else {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: widget.isChange
          ? AppBar(title: Text(_title))
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Icon for first-time setup
              if (!widget.isChange) ...[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
              ],

              // Step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isChange) _buildStepDot(_step == _SetupStep.enterOld, colorScheme),
                  if (widget.isChange) const SizedBox(width: 8),
                  _buildStepDot(_step == _SetupStep.enterNew, colorScheme),
                  const SizedBox(width: 8),
                  _buildStepDot(_step == _SetupStep.confirmNew, colorScheme),
                ],
              ),
              const SizedBox(height: 24),

              // Instruction
              Text(
                _instructionText,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Error message
              SizedBox(
                height: 24,
                child: _isError
                    ? Text(
                        _errorMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 24),

              // PIN dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pinLength, (index) {
                  final isFilled = index < _pin.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isError
                            ? colorScheme.error
                            : isFilled
                                ? colorScheme.primary
                                : Colors.transparent,
                        border: Border.all(
                          color: _isError
                              ? colorScheme.error
                              : colorScheme.outline,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              if (_isProcessing) ...[
                const SizedBox(height: 16),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],

              const Spacer(),

              // Number pad
              PinNumberPad(
                onDigit: _addDigit,
                onDelete: _removeDigit,
                isDisabled: _isProcessing,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(bool isActive, ColorScheme colorScheme) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
      ),
    );
  }
}

