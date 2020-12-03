import 'package:aoc2020/structures.dart';

const TREE = 1;
const OPEN = 0;

Solutions run(String input) {
  var sols = Solutions();
  var processed = <List<int>>[];
  for (var line in input.trim().split('\n')) {
    var row = <int>[];
    for (var c in line.split('')) {
      row.add(c == '.' ? OPEN : TREE);
    }
    processed.add(row);
  }

  final count = countTrees(processed, 3, 1);

  sols.part1 = '$count';

  var prod = 1;
  for (var item in [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
  ]) {
    prod *= countTrees(processed, item[0], item[1]);
  }
  sols.part2 = '$prod';
  return sols;
}

int countTrees(List<List<int>> processed, int right, int down) {
  final rows = processed.length;
  final cols = processed[0].length;

  var count = 0;
  var x = 0;
  for (var y = 0; y < rows; y += down) {
    if (processed[y][x] == TREE) {
      count += 1;
    }
    x = (x + right) % cols;
  }

  return count;
}
