import 'package:interpreter/interpreter.dart' as interpreter;

void main(List<String> arguments) {
  interpreter.Interpreter().calculateExpr('(6))(5 * 3) - 2');
}
