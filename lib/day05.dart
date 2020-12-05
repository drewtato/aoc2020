import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var boarding = <List<int>>[];
  for (var line in input.trim().split('\n')) {
    var b = [0, 0, 0];
    for (var c in line.split('')) {
      switch (c) {
        case 'F':
          b[0] <<= 1;
          break;
        case 'B':
          b[0] <<= 1;
          b[0] += 1;
          break;
        case 'L':
          b[1] <<= 1;
          break;
        case 'R':
          b[1] <<= 1;
          b[1] += 1;
          break;
        default:
          throw Exception('Not a valid c: $c');
      }
    }
    b[2] = b[0] * 8 + b[1];
    boarding.add(b);
  }
  // print(boarding);
  final max =
      boarding.map((e) => e[2]).fold(0, (prev, e) => e > prev ? e : prev);
  var sols = Solutions();
  sols.part1 = '$max';
  var sorted = boarding.map((e) => e[2]).toList();
  sorted.sort();
  var last = 0;
  print(sorted);
  for (var item in sorted) {
    if (last == item - 2) {
      print(item - 1);
      break;
    }
    last = item;
  }

  return sols;
}
