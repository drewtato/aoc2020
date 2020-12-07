import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var bags = <String, Map<String, int>>{};
  var inverseBags = <String, Map<String, int>>{};
  for (var line in input.trim().split('\n')) {
    final split = line.split(' bags contain ');
    final color = split[0];
    final matches = RegExp(r'(\d+) (\w+ \w+) bag').allMatches(split[1]);
    var contains = <String, int>{};
    for (var l in matches.map((m) => [m.group(2), int.parse(m.group(1))])) {
      contains[l[0]] = l[1];
      var inv = inverseBags[l[0]];
      if (inv == null) {
        inverseBags[l[0]] = {color: l[1]};
      } else {
        inv.addAll({color: l[1]});
      }
    }
    bags[color] = contains;
  }
  // print(bags);
  // print(inverseBags);

  var candidates = ['shiny gold'];
  var containsGold = <String>{};
  while (candidates.isNotEmpty) {
    var newCandidates = <String>[];
    for (var cand in candidates) {
      if (inverseBags[cand]?.keys != null) {
        for (var name in inverseBags[cand]?.keys) {
          if (containsGold.add(name)) {
            newCandidates.add(name);
          }
        }
      }
    }
    candidates = newCandidates;
  }

  var sols = Solutions();
  sols.part1 = containsGold.length.toString();

  var bagsInGold = 0;
  var currentBags = {'shiny gold': 1};
  while (currentBags.isNotEmpty) {
    var newCurrent = <String, int>{};
    for (var curr in currentBags.entries) {
      for (var contents in bags[curr.key].entries) {
        newCurrent.update(
            contents.key, (value) => value + contents.value * curr.value,
            ifAbsent: () => contents.value * curr.value);
        bagsInGold += contents.value * curr.value;
      }
    }
    currentBags = newCurrent;
  }
  sols.part2 = '$bagsInGold';
  return sols;
}
