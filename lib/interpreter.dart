int calculateExpr(String expr) {
  try {
    final tokens = tokenizer(expr);

    EvalStack evalStack = tokens.fold(EvalStack([], []),
        (EvalStack evalStack, String token) => eval(evalStack, token));

    while (evalStack.operations.isNotEmpty) {
      evalStack = calculateLast(evalStack);
    }

    print('$expr = ${evalStack.digit.first}');

    return evalStack.digit.first;
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

List<String> tokenizer(String expr) {
  final tokens = expr.split('').fold(<String>[], (List<String> p, String e) {
    if ('+-*/()'.contains(e)) {
      p.add(e);
    } else if (isDigit(e)) {
      if (p.isNotEmpty) {
        if (isDigit(p.last)) {
          p.last = p.last + e;
        } else {
          p.add(e);
        }
      } else {
        p.add(e);
      }
    }
    return p;
  });
  return tokens;
}

bool isDigit(String s) {
  return int.tryParse(s) != null;
}

EvalStack eval(EvalStack evalStack, String token) {
  final plusSubMultiDiv = '+-*/';
  final plusSub = '+-';
  final multiDiv = '*/';

  if (plusSub.contains(token)) {
    if (evalStack.operations.isNotEmpty) {
      while (evalStack.operations.isNotEmpty &&
          plusSubMultiDiv.contains(evalStack.operations.last)) {
        evalStack = calculateLast(evalStack);
      }
    }
    evalStack.operations.add(token);
  } else if (multiDiv.contains(token)) {
    if (evalStack.operations.isNotEmpty) {
      while (evalStack.operations.isNotEmpty &&
          multiDiv.contains(evalStack.operations.last)) {
        evalStack = calculateLast(evalStack);
      }
    }
    evalStack.operations.add(token);
  } else if (token == "(") {
    evalStack.operations.add(token);
  } else if (token == ")") {
    if (evalStack.operations.isNotEmpty) {
      while ("(" != evalStack.operations.last) {
        evalStack = calculateLast(evalStack);
      }
      if (evalStack.operations.isNotEmpty) {
        evalStack.operations.removeLast();
      }
    }
  } else if (isDigit(token)) {
    evalStack.digit.add(int.parse(token));
  }
  return evalStack;
}

EvalStack calculateLast(EvalStack evalStack) {
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

class EvalStack {
  List<int> digit;
  List<String> operations;

  EvalStack(this.digit, this.operations);
}
