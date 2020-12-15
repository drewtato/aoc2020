import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var nums = input.trim().split(',').map((e) => int.parse(e)).toList();

  sols.part1 = '${play(nums, 2020)}';
  sols.part2 = '${play(nums, 30000000)}';
  return sols;
}

int play(List<int> starter, int maxTurns) {
  var lastSpoken = <int, int>{};
  var last = 0;
  var turns = 0;
  for (var item in starter) {
    lastSpoken[last] = turns;
    last = item;
    turns++;
  }
  while (turns < maxTurns) {
    if (!lastSpoken.containsKey(last)) {
      lastSpoken[last] = turns;
      last = 0;
    } else {
      final next = turns - lastSpoken[last];
      lastSpoken[last] = turns;
      last = next;
    }
    turns++;
  }
  // print(lastSpoken.length);
  return last;
}
