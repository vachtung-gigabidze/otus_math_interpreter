class Interpreter {
  int? calculateExpr(String expr) {
    try {
      expr = expr.replaceAll(" ", "");

      final tokens = _tokenizer(expr);
      final validator = Validator(tokens);

      if (!validator.isValid()) {
        throw validator.getErrorMessage();
      }

      EvalStack evalStack = tokens.fold(EvalStack([], []),
          (EvalStack evalStack, String token) => _eval(evalStack, token));

      while (evalStack.operations.isNotEmpty) {
        evalStack = _calculateLast(evalStack);
      }

      print('$expr = ${evalStack.digit.first}');

      return evalStack.digit.first;
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  List<String> _tokenizer(String expr) {
    final tokens =
        expr.split('').fold(<String>[], (List<String> stack, String symbol) {
      if (_isDigit(symbol)) {
        if (stack.isNotEmpty) {
          if (_isDigit(stack.last)) {
            stack.last = stack.last + symbol;
          } else {
            stack.add(symbol);
          }
        } else {
          stack.add(symbol);
        }
      } else {
        stack.add(symbol);
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

class Validator {
  final List<String> _tokens;
  late String _errorMessage;

  Validator(this._tokens) {
    _errorMessage = "";
  }

  void _addError(String error) {
    _errorMessage += '${_errorMessage.isNotEmpty ? "\n" : ""} $error';
  }

  bool _isToShortExpr([int minLenght = 3]) {
    if (_tokens.length < minLenght) {
      _addError("Validate throw error. Math expression is too short.");
      return false;
    } else {
      return true;
    }
  }

  bool _isCorrectParenth() {
    if (_tokens.fold(<String>[], (List<String> patherList, String symbol) {
      if (symbol == "(") {
        patherList.add(symbol);
      }
      if (symbol == ")") {
        if (patherList.isNotEmpty) {
          if (patherList.last == "(") {
            patherList.removeLast();
          }
        }
      }
      return patherList;
    }).isNotEmpty) {
      _addError("Validate throw error. In expr has unpaired parenthesis.");
      return false;
    } else {
      return true;
    }
  }

  bool _isNotOperationOnBeginOrEnd() {
    if ('+-*/)'.contains(_tokens.first) || '+-*/('.contains(_tokens.last)) {
      _addError(
          "Validate throw error. there is an operator at the beginning and\\or end of the expression.");
      return false;
    } else {
      return true;
    }
  }

  bool _isPairOperator() {
    for (int i = 0; i < _tokens.length - 2; i++) {
      if ("+-*/(".contains(_tokens[i])) {
        if ("+-*/)".contains(_tokens[i + 1])) {
          _addError(
              "Validate throw error. There are two operators as a wrong pair.");
          return false;
        }
      }
    }
    return true;
  }

  bool _isOnlyCorretSymbol() {
    if (_tokens
        .where((token) => !(_isDigit(token) || "+-*/()".contains(token)))
        .isNotEmpty) {
      _addError(
          "Validate throw error. The expression has incorrect characters.");
      return false;
    } else {
      return true;
    }
  }

  bool _isCorretCountDigit([int minCountDigit = 2]) {
    if (_tokens.where((token) => _isDigit(token)).length < minCountDigit) {
      _addError("Validate throw error. Not enough numbers in math expression.");
      return false;
    } else {
      return true;
    }
  }

  bool _isCorretCountOperator() {
    int minCountOperator = _tokens.where((token) => _isDigit(token)).length - 1;

    if (_tokens.where((token) => "+-*/".contains(token)).length <
        minCountOperator) {
      _addError(
          "Validate throw error. Not enough operators  in math expression.");
      return false;
    } else {
      return true;
    }
  }

  bool _isDigit(String s) {
    return int.tryParse(s) != null;
  }

  bool isValid() {
    bool correctly = true;

    correctly = _isToShortExpr() &&
        _isCorrectParenth() &&
        _isNotOperationOnBeginOrEnd() &&
        _isPairOperator() &&
        _isOnlyCorretSymbol() &&
        _isCorretCountDigit() &&
        _isCorretCountOperator();

    return correctly;
  }

  String getErrorMessage() {
    return _errorMessage;
  }
}
