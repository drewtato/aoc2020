import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  final messagePat = RegExp(r'^(?:a|b)+$');
  final rulesPat = RegExp(r'^(\d+): (.+)$');
  final letterPat = RegExp(r'^"(\w)"$');

  var ruleMap = <int, Rule>{};
  var messageList = <String>[];

  for (var line in input.trim().split('\n').where((e) => e.isNotEmpty)) {
    if (messagePat.hasMatch(line)) {
      messageList.add(line);
      continue;
    }

    var rule = Rule();
    final m = rulesPat.firstMatch(line);
    rule.name = int.parse(m.group(1));

    ruleMap[rule.name] = rule;
    rule.ruleMap = ruleMap;

    final letterMatch = letterPat.firstMatch(m.group(2));
    if (letterMatch != null) {
      rule.letter = letterMatch.group(1);
      rule.type = RuleType.letter;
      continue;
    }

    rule.type = RuleType.subrules;
    rule.subRules = [];
    for (var subRule in m.group(2).split(' | ')) {
      var subRulePart = subRule.split(' ').map((e) => int.parse(e)).toList();
      rule.subRules.add(subRulePart);
    }
  }

  // for (var rule in ruleMap.values) {
  //   print(rule);
  // }

  var matches = 0;
  final zero = ruleMap[0];
  for (var message in messageList) {
    if (zero.hasMatch(message)) {
      matches++;
    }
  }

  sols.part1 = '$matches';

  var eight = Rule();
  eight.name = 8;
  eight.type = RuleType.subrules;
  eight.subRules = [
    [42],
    [42, 8]
  ];
  eight.ruleMap = ruleMap;
  ruleMap[8] = eight;

  var eleven = Rule();
  eleven.name = 11;
  eleven.type = RuleType.subrules;
  eleven.subRules = [
    [42, 31],
    [42, 11, 31]
  ];
  eleven.ruleMap = ruleMap;
  ruleMap[11] = eleven;

  matches = 0;
  for (var message in messageList) {
    if (zero.hasMatch(message)) {
      matches++;
    }
  }

  sols.part2 = '$matches';

  return sols;
}

enum RuleType { letter, subrules }

class Rule {
  int name;
  RuleType type;
  String letter;
  List<List<int>> subRules;
  Map<int, Rule> ruleMap;

  bool hasMatch(String message) {
    return hasPartialMatch(message, 0).contains(message.length);
  }

  Iterable<int> hasPartialMatch(String message, int start) sync* {
    if (type == RuleType.letter) {
      if (message.length > start && message[start] == letter) {
        yield start + 1;
      }
      return;
    }

    for (var sub in subRules) {
      Iterable<int> possibleLengths = [start];
      for (var r in sub) {
        possibleLengths = possibleLengths
            .expand((e) => ruleMap[r].hasPartialMatch(message, e));
      }
      yield* possibleLengths;
    }
  }

  @override
  String toString() {
    return '$name: ${type == RuleType.letter ? letter : subRules}';
  }
}
