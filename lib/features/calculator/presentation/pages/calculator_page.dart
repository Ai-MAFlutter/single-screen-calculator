import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../domain/usecases/calculate_result.dart';
import '../widgets/calculator_button.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculateResult _calculator = const CalculateResult();

  String _display = '0';
  String _expression = '';
  String? _error;
  double? _firstNumber;
  CalculatorOperation? _operation;
  bool _resetDisplay = false;

  void _inputDigit(String digit) {
    setState(() {
      _error = null;

      if (_resetDisplay || _display == '0' || _display == 'Error') {
        _display = digit;
        _resetDisplay = false;
      } else if (_display.length < 15) {
        _display += digit;
      }
    });
  }

  void _inputDecimal() {
    setState(() {
      _error = null;

      if (_resetDisplay || _display == 'Error') {
        _display = '0.';
        _resetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  String _symbol(CalculatorOperation operation) {
    switch (operation) {
      case CalculatorOperation.add:
        return '+';
      case CalculatorOperation.subtract:
        return '−';
      case CalculatorOperation.multiply:
        return '×';
      case CalculatorOperation.divide:
        return '÷';
    }
  }

  String _format(double number) {
    if (!number.isFinite) return 'Error';
    if (number == 0) return '0';

    if (number.abs() >= 1e12 || number.abs() < 1e-8) {
      return number.toStringAsExponential(5);
    }

    return number.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _selectOperation(CalculatorOperation operation) {
    final current = double.tryParse(_display);
    if (current == null) return;

    if (_operation != null && _firstNumber != null && !_resetDisplay) {
      _calculate();
      if (_error != null) return;
    }

    final value = double.tryParse(_display);
    if (value == null) return;

    setState(() {
      _firstNumber = value;
      _operation = operation;
      _expression = '${_format(value)} ${_symbol(operation)}';
      _resetDisplay = true;
      _error = null;
    });
  }

  void _calculate() {
    if (_firstNumber == null || _operation == null) return;

    final first = _firstNumber!;
    final second = double.tryParse(_display);
    if (second == null) return;

    final operation = _operation!;

    try {
      final result = _calculator.execute(
        firstNumber: first,
        secondNumber: second,
        operation: operation,
      );

      setState(() {
        _expression =
            '${_format(first)} ${_symbol(operation)} ${_format(second)} =';
        _display = _format(result);
        _firstNumber = null;
        _operation = null;
        _resetDisplay = true;
        _error = null;
      });
    } on ArgumentError {
      setState(() {
        _display = '0';
        _expression = '';
        _firstNumber = null;
        _operation = null;
        _resetDisplay = true;
        _error = 'Cannot divide by zero';
      });
    }
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstNumber = null;
      _operation = null;
      _resetDisplay = false;
      _error = null;
    });
  }

  void _delete() {
    setState(() {
      _error = null;

      if (_resetDisplay || _display == 'Error') {
        _display = '0';
        _resetDisplay = false;
      } else if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        if (_display == '-') _display = '0';
      } else {
        _display = '0';
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display == '0' || _display == 'Error') return;

      _display = _display.startsWith('-')
          ? _display.substring(1)
          : '-$_display';

      _error = null;
      _resetDisplay = false;
    });
  }

  Widget _button(
    String label,
    VoidCallback onPressed, {
    CalculatorButtonType type = CalculatorButtonType.number,
  }) {
    return Expanded(
      child: CalculatorButton(label: label, onPressed: onPressed, type: type),
    );
  }

  Widget _buttonRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        children: [
          for (int i = 0; i < buttons.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            buttons[i],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'CALCULATOR',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simple. Clear. Accurate.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _error ?? _expression,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              _display,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 62,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buttonRow([
                          _button(
                            'AC',
                            _clear,
                            type: CalculatorButtonType.utility,
                          ),
                          _button(
                            '±',
                            _toggleSign,
                            type: CalculatorButtonType.utility,
                          ),
                          _button(
                            '⌫',
                            _delete,
                            type: CalculatorButtonType.utility,
                          ),
                          _button(
                            '÷',
                            () => _selectOperation(CalculatorOperation.divide),
                            type: CalculatorButtonType.operator,
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buttonRow([
                          for (final digit in ['7', '8', '9'])
                            _button(digit, () => _inputDigit(digit)),
                          _button(
                            '×',
                            () =>
                                _selectOperation(CalculatorOperation.multiply),
                            type: CalculatorButtonType.operator,
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buttonRow([
                          for (final digit in ['4', '5', '6'])
                            _button(digit, () => _inputDigit(digit)),
                          _button(
                            '−',
                            () =>
                                _selectOperation(CalculatorOperation.subtract),
                            type: CalculatorButtonType.operator,
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buttonRow([
                          for (final digit in ['1', '2', '3'])
                            _button(digit, () => _inputDigit(digit)),
                          _button(
                            '+',
                            () => _selectOperation(CalculatorOperation.add),
                            type: CalculatorButtonType.operator,
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buttonRow([
                          _button('0', () => _inputDigit('0')),
                          _button('.', _inputDecimal),
                          _button(
                            '=',
                            _calculate,
                            type: CalculatorButtonType.equals,
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Designed with care',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
