import 'package:interpreter/interpreter.dart';
import 'package:test/test.dart';

void main() {
  test('calculate 3+2', () {
    expect(Interpreter().calculateExpr('3 + 2'), 5);
  });
  test('calculate ( 1 + 2 ) * ( 3 + 4 / 2 - ( 1 + 2 ) ) * 2 + 1', () {
    expect(
        Interpreter()
            .calculateExpr('( 1 + 2 ) * ( 3 + 4 / 2 - ( 1 + 2 ) ) * 2 + 1'),
        13);
  });
  test('calculate 3-2', () {
    expect(Interpreter().calculateExpr('3 - 2'), 1);
  });
  test('calculate 2 - 3', () {
    expect(Interpreter().calculateExpr('2 - 3'), -1);
  });
  test('calculate 7 - 3 * 2', () {
    expect(Interpreter().calculateExpr('7 - 3 * 2'), 1);
  });
  test('calculate ( 7 - 3 ) * 2', () {
    expect(Interpreter().calculateExpr('( 7 - 3 ) * 2'), 8);
  });
  test('calculate ( ( 7 - 3 ) * 2 )', () {
    expect(Interpreter().calculateExpr('( ( 7 - 3 ) * 2 )'), 8);
  });
  test('calculate 8 / 2 * 2', () {
    expect(Interpreter().calculateExpr('8 / 2 * 2'), 8);
  });
  test('calculate 8 / ( 2 * 2 )', () {
    expect(Interpreter().calculateExpr('8 / ( 2 * 2 )'), 2);
  });
  test('calculate 0', () {
    expect(Interpreter().calculateExpr('0'), 0);
  });
  test('calculate 10', () {
    expect(Interpreter().calculateExpr('10'), 10);
  });
  test('calculate 123 - 23', () {
    expect(Interpreter().calculateExpr('123 - 23'), 100);
  });
  test('calculate 1000 * 1000', () {
    expect(Interpreter().calculateExpr('1000 * 1000'), 1000000);
  });
  test('calculate (100)', () {
    expect(Interpreter().calculateExpr('(100)'), 100);
  });
}
