import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();
  var adapters = input.trim().split('\n').map((e) => int.parse(e)).toList();
  adapters.sort();
  adapters.add(adapters.last + 3);
  adapters.insert(0, 0);
  var three = 0;
  var one = 0;
  for (var i = 0; i < adapters.length - 1; i++) {
    // print(adapters[i + 1] - adapters[i]);
    switch (adapters[i + 1] - adapters[i]) {
      case 1:
        one++;
        break;
      case 3:
        three++;
        break;
    }
  }
  // print(one);
  // print(three);

  sols.part1 = '${one * three}';

  var ways = <int, int>{0: 1};
  var ans = 0;

  for (var i = 1; i < adapters.length; i++) {
    var sum = 0;
    for (var j = 1; j < 4; j++) {
      var add = ways[adapters[i] - j];
      if (add != null) {
        sum += add;
      }
    }
    ways[adapters[i]] = sum;
    ans = sum;
    // print(ways);
  }

  sols.part2 = '$ans';

  return sols;
}
