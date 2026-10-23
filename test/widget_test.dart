import 'package:flutter_test/flutter_test.dart';

import 'package:single_screen_calculator/app/app.dart';

void main() {
  test('CalculatorApp can be created', () {
    const app = CalculatorApp();

    expect(app, isNotNull);
  });
}
