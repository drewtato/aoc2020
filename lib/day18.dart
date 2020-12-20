import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var tokens = <List<String>>[];
  for (var line in input.trim().split('\n')) {
    var tokenLine = <String>[];
    for (var char in line.split('')) {
      if (char != ' ') {
        tokenLine.add(char);
      }
    }
    tokens.add(tokenLine);
  }

  var sum = 0;
  var sum2 = 0;
  for (var expression in tokens) {
    sum += eval(expression);
    sum2 += eval2(expression);
  }
  sols.part1 = '$sum';
  sols.part2 = '$sum2';

  return sols;
}

const ADD = -1;
const MUL = -2;

int eval(List<String> expression) {
  var stack = <int>[];
  var total = 0;
  var mode = ADD;
  for (var item in expression) {
    final n = int.tryParse(item);
    if (n != null) {
      if (mode == ADD) {
        total += n;
      } else {
        total *= n;
      }
    } else if (item == '+') {
      mode = ADD;
    } else if (item == '*') {
      mode = MUL;
    } else if (item == '(') {
      stack.add(total);
      stack.add(mode);
      total = 0;
      mode = ADD;
    } else if (item == ')') {
      mode = stack.removeLast();
      if (mode == ADD) {
        total += stack.removeLast();
      } else {
        total *= stack.removeLast();
      }
    } else {
      throw Exception('Not a valid token: $item');
    }
  }
  return total;
}

const OPEN = -3;

int eval2(List<String> expression) {
  var stack = <int>[];
  // expression.insert(0, '(');
  // expression.add(')');
  for (var item in expression) {
  }
}
