enum CalculatorOperation { add, subtract, multiply, divide }

class CalculateResult {
  const CalculateResult();

  double execute({
    required double firstNumber,
    required double secondNumber,
    required CalculatorOperation operation,
  }) {
    switch (operation) {
      case CalculatorOperation.add:
        return firstNumber + secondNumber;

      case CalculatorOperation.subtract:
        return firstNumber - secondNumber;

      case CalculatorOperation.multiply:
        return firstNumber * secondNumber;

      case CalculatorOperation.divide:
        if (secondNumber == 0) {
          throw ArgumentError('Cannot divide by zero.');
        }
        return firstNumber / secondNumber;
    }
  }
}
