import 'package:interpreter/interpreter.dart' as interpreter;

void main(List<String> arguments) {
  interpreter.calculateExpr('( 1 + 2 ) * ( 3 + 4 / 2 - ( 1 + 2 ) ) * 2 + 1');
}
