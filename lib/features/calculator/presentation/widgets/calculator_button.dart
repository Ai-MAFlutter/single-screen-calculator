import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

enum CalculatorButtonType { number, operator, utility, equals }

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    required this.label,
    required this.onPressed,
    this.type = CalculatorButtonType.number,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final CalculatorButtonType type;

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (type) {
      case CalculatorButtonType.number:
        backgroundColor = AppTheme.numberButton;
        foregroundColor = AppTheme.textPrimary;
      case CalculatorButtonType.operator:
        backgroundColor = AppTheme.operatorButton;
        foregroundColor = AppTheme.accent;
      case CalculatorButtonType.utility:
        backgroundColor = AppTheme.surface;
        foregroundColor = AppTheme.textSecondary;
      case CalculatorButtonType.equals:
        backgroundColor = AppTheme.accent;
        foregroundColor = AppTheme.background;
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: label.length > 2 ? 19 : 27,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
