import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  final parts = input.trim().split('\n\n');
  final rulePat = RegExp(r'^(\d+): (.+)$');
  final ruleEndPat = RegExp(r'^(?:"(\w)"|([\d| ]+))$');

  var rules = <int, Rule>{};
  for (var line in parts[0].split('\n')) {
    final ruleMatch = rulePat.firstMatch(line);
    final ruleNumber = int.parse(ruleMatch.group(1));
    final ruleEnd = ruleEndPat.firstMatch(ruleMatch.group(2));
    if (ruleEnd == null) {
      print(line);
    }
    var rule = Rule();
    rule.type = CHAR;
    if (ruleEnd.group(1) != null) {
      rule.character = ruleEnd.group(1);
    } else {
      rule.type++;
      final allNumbers = ruleEnd.group(2).split(' | ');
      rule.groups = [];
      for (var group in allNumbers) {
        rule.groups.add([]);
        for (var n in group.split(' ')) {
          rule.groups.last.add(int.parse(n));
        }
      }
    }
    rules[ruleNumber] = rule;
  }
  // print(rules[0]);

  final messages = parts[1].split('\n');
  // print(messages);

  final humungo = RegExp('^' + humungoRegex(rules, 0) + '\$');
  rules[11].groups = [
    [42, 31],
    [42, 42, 31, 31],
    [42, 42, 42, 31, 31, 31],
    [42, 42, 42, 42, 31, 31, 31, 31],
    [42, 42, 42, 42, 42, 31, 31, 31, 31, 31],
    // [42, 42, 42, 42, 42, 42, 31, 31, 31, 31, 31, 31],
  ];
  final humungo2 = RegExp('^' + humungoRegex2(rules, 0).pattern + '\$');

  // print(humungo2);
  // print(eleven);
  var count1 = 0;
  var count2 = 0;
  for (var message in messages) {
    // print('Matching $message');
    if (humungo.hasMatch(message)) {
      count1++;
    }
    if (humungo2.hasMatch(message)) {
      count2++;
    }
  }

  // for (var i = 0; i < 5; i++) {
  //   print('$i: ${humungoRegex2(rules, 0, i).pattern}');
  // }

  sols.part1 = '$count1';
  sols.part2 = '$count2';

  return sols;
}

var memoHumungo2 = <int, RegExp>{};
RegExp humungoRegex2(Map<int, Rule> rules, int start) {
  if (memoHumungo2.containsKey(start)) {
    return memoHumungo2[start];
  }

  var reg = '';
  if (rules[start].type == CHAR) {
    reg += rules[start].character;
  } else if (start == 8) {
    reg += '(?:${humungoRegex2(rules, 42).pattern})+';
  } else {
    for (var group in rules[start].groups) {
      for (var n in group) {
        reg += humungoRegex2(rules, n).pattern;
      }
      reg += '|';
    }
    if (rules[start].groups.length > 1) {
      reg = '(?:' + reg.substring(0, reg.length - 1) + ')';
    } else {
      reg = reg.substring(0, reg.length - 1);
    }
  }

  memoHumungo2[start] = RegExp(reg);
  return memoHumungo2[start];
}

var memoHumungo = <int, String>{};
String humungoRegex(Map<int, Rule> rules, int start) {
  if (memoHumungo.containsKey(start)) {
    return memoHumungo[start];
  }

  var reg = '';
  if (rules[start].type == CHAR) {
    reg += rules[start].character;
  } else {
    reg += '(?:';
    for (var group in rules[start].groups) {
      for (var n in group) {
        reg += humungoRegex(rules, n);
      }
      reg += '|';
    }
    reg = reg.substring(0, reg.length - 1) + ')';
  }

  memoHumungo[start] = reg;
  return memoHumungo[start];
}

const CHAR = 1;
const GROUPS = 2;

class Rule {
  int type;
  List<List<int>> groups;
  String character;

  @override
  String toString() {
    switch (type) {
      case CHAR:
        return '"$character"';
        break;
      case GROUPS:
        return groups.toString();
        break;
      default:
        return 'none';
    }
  }
}
