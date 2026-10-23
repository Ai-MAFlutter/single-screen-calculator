import 'package:flutter/material.dart';

import '../features/calculator/presentation/pages/calculator_page.dart';
import 'app_theme.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CalculatorPage(),
    );
  }
}
