class Interpreter {
  int calculateExpr(String expr) {
    try {
      final tokens = _tokenizer(expr);

      EvalStack evalStack = tokens.fold(EvalStack([], []),
          (EvalStack evalStack, String token) => _eval(evalStack, token));

      while (evalStack.operations.isNotEmpty) {
        evalStack = _calculateLast(evalStack);
      }

      print('$expr = ${evalStack.digit.first}');

      return evalStack.digit.first;
    } catch (error) {
      print('Error: $error');
      return 0;
    }
  }

  List<String> _tokenizer(String expr) {
    final tokens =
        expr.split('').fold(<String>[], (List<String> stack, String symbol) {
      if ('+-*/()'.contains(symbol)) {
        if (stack.isNotEmpty) {
          if ('+-*/'.contains(stack.last) && '+-*/'.contains(symbol)) {
            throw 'Tokenizer throw error. Uncorrect expr \'$expr\', To many operator $symbol after ${stack.last}';
          }
        }
        stack.add(symbol);
      } else if (_isDigit(symbol)) {
        if (stack.isNotEmpty) {
          if (_isDigit(stack.last)) {
            stack.last = stack.last + symbol;
          } else {
            stack.add(symbol);
          }
        } else {
          stack.add(symbol);
        }
      } else if (" " == symbol) {
        return stack;
      } else {
        throw 'Tokenizer throw error. Uncorrect symbol \'$symbol\' in expr \'$expr\'';
      }
      return stack;
    });
    return tokens;
  }

  bool _isDigit(String s) {
    return int.tryParse(s) != null;
  }

  EvalStack _eval(EvalStack evalStack, String token) {
    final plusSubMultiDiv = '+-*/';
    final plusSub = '+-';
    final multiDiv = '*/';

    if (plusSub.contains(token)) {
      if (evalStack.operations.isNotEmpty) {
        while (evalStack.operations.isNotEmpty &&
            plusSubMultiDiv.contains(evalStack.operations.last)) {
          evalStack = _calculateLast(evalStack);
        }
      }
      evalStack.operations.add(token);
    } else if (multiDiv.contains(token)) {
      if (evalStack.operations.isNotEmpty) {
        while (evalStack.operations.isNotEmpty &&
            multiDiv.contains(evalStack.operations.last)) {
          evalStack = _calculateLast(evalStack);
        }
      }
      evalStack.operations.add(token);
    } else if (token == "(") {
      evalStack.operations.add(token);
    } else if (token == ")") {
      if (evalStack.operations.isNotEmpty) {
        while ("(" != evalStack.operations.last) {
          evalStack = _calculateLast(evalStack);
        }
        if (evalStack.operations.isNotEmpty) {
          evalStack.operations.removeLast();
        }
      }
    } else if (_isDigit(token)) {
      evalStack.digit.add(int.parse(token));
    }
    return evalStack;
  }

  EvalStack _calculateLast(EvalStack evalStack) {
    if (evalStack.digit.length < 2 || evalStack.operations.isEmpty) {
      return evalStack;
    }
    int b = evalStack.digit.last;
    evalStack.digit.removeLast();
    int a = evalStack.digit.last;
    evalStack.digit.removeLast();

    switch (evalStack.operations.last) {
      case "+":
        evalStack.digit.add(a + b);
        break;
      case "-":
        evalStack.digit.add(a - b);
        break;
      case "*":
        evalStack.digit.add(a * b);
        break;
      case "/":
        evalStack.digit.add(a ~/ b);
        break;
    }
    evalStack.operations.removeLast();
    return evalStack;
  }
}

class EvalStack {
  List<int> digit;
  List<String> operations;

  EvalStack(this.digit, this.operations);
}
