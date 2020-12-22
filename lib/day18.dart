import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var exps = <List<Token>>[];
  for (var line in input.trim().split('\n')) {
    exps.add([]);
    for (var char in line.split('')) {
      if (char == ' ') {
        continue;
      }
      exps.last.add(Token(char));
    }
  }

  var sum = 0;
  var sum2 = 0;
  for (var exp in exps) {
    var nested = <List<Token>>[[]];
    var nested2 = <List<Token>>[[]];
    for (var token in exp) {
      switch (token.type) {
        case TokenType.left:
          nested.add([]);
          nested2.add([]);
          break;
        case TokenType.right:
          final eval = evaluate(nested.removeLast());
          nested.last.add(eval);
          final eval2 = evaluate2(nested2.removeLast());
          nested2.last.add(eval2);
          break;
        default:
          nested.last.add(token);
          nested2.last.add(token);
      }
      // print(nested2);
    }
    var result = evaluate(nested.removeLast()).number;
    var result2 = evaluate2(nested2.removeLast()).number;
    // print(result2);
    sum += result;
    sum2 += result2;
  }

  sols.part1 = sum.toString();
  sols.part2 = sum2.toString();
  return sols;
}

int add(int a, int b) {
  return a + b;
}

int mul(int a, int b) {
  return a * b;
}

Token evaluate2(List<Token> exp) {
  var numbers = exp.where((e) => e.type == TokenType.number).toList();
  var operators = exp.where((e) => e.type != TokenType.number).toList();
  for (var i = operators.length - 1; i >= 0; i--) {
    if (operators[i].type == TokenType.add) {
      numbers[i] = Token(numbers[i].number + numbers[i + 1].number);
      numbers.removeAt(i + 1);
    }
  }
  return Token(numbers.fold(1, (prev, e) => prev * e.number));
}

Token evaluate(List<Token> exp) {
  var result = 0;
  var mode = add;
  for (var token in exp) {
    switch (token.type) {
      case TokenType.add:
        mode = add;
        break;
      case TokenType.mul:
        mode = mul;
        break;
      case TokenType.number:
        result = mode(result, token.number);
        break;
      default:
        throw Exception('Not a valid token type for evaluation: $token');
    }
  }
  return Token(result);
}

enum TokenType { number, add, mul, left, right }

class Token {
  TokenType type;
  int number;
  Token(dynamic inp) {
    if (inp is int) {
      type = TokenType.number;
      number = inp;
      return;
    }
    if (inp is String) {
      var tryInt = int.tryParse(inp);
      if (tryInt != null) {
        type = TokenType.number;
        number = tryInt;
        return;
      }
      switch (inp) {
        case '+':
          type = TokenType.add;
          break;
        case '*':
          type = TokenType.mul;
          break;
        case '(':
          type = TokenType.left;
          break;
        case ')':
          type = TokenType.right;
          break;
        default:
          throw Exception('Invalid token: $inp');
      }
    } else {
      throw Exception('Invalid type: $inp');
    }
  }
  @override
  String toString() {
    switch (type) {
      case TokenType.number:
        return number.toString();
        break;
      case TokenType.add:
        return '+';
        break;
      case TokenType.mul:
        return '*';
        break;
      case TokenType.left:
        return '(';
        break;
      case TokenType.right:
        return ')';
        break;
    }
  }
}
