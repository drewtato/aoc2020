import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var groups = <List<String>>[];
  for (var group in input.trim().split('\n\n')) {
    var g = <String>[];
    for (var line in group.split('\n')) {
      g.add(line);
    }
    groups.add(g);
  }
  var answers = <Set<String>>[];
  for (var group in groups) {
    var letters = <String>{};
    for (var person in group) {
      letters.addAll(person.split(''));
    }
    answers.add(letters);
  }

  var sols = Solutions();
  sols.part1 = answers
      .map((e) => e.length)
      .fold(0, (previousValue, element) => previousValue + element)
      .toString();

  var everyone = <Set<String>>[];
  for (var group in groups) {
    var allAnswered = group[0].split('').toSet();
    for (var person in group.skip(1)) {
      allAnswered = allAnswered.intersection(person.split('').toSet());
    }
    everyone.add(allAnswered);
  }
  sols.part2 = everyone
      .map((e) => e.length)
      .fold(0, (previousValue, element) => previousValue + element)
      .toString();

  return sols;
}
