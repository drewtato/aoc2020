import 'dart:math';

import 'package:aoc2020/structures.dart';

const BLACK = 1;
const WHITE = 0;

Solutions run(String input) {
  var sols = Solutions();

  final pat = RegExp('se|sw|ne|nw|e|w');

  var instructions = <List<List<int>>>[];

  for (var line in input.trim().split('\n')) {
    final matches = pat.allMatches(line);
    instructions.add([]);
    for (var match in matches) {
      var dir = <int>[];
      switch (match.group(0)) {
        case 'e':
          dir = [0, 2];
          break;
        case 'se':
          dir = [1, 1];
          break;
        case 'sw':
          dir = [1, -1];
          break;
        case 'w':
          dir = [0, -2];
          break;
        case 'nw':
          dir = [-1, -1];
          break;
        case 'ne':
          dir = [-1, 1];
          break;
        default:
      }
      instructions.last.add(dir);
    }
  }
  // print(instructions);

  var tiles = Tiles({});
  for (var ins in instructions) {
    final tile =
        ins.fold([0, 0], (prev, e) => [prev[0] + e[0], prev[1] + e[1]]);
    tiles.flip(tile[0], tile[1]);
  }

  // print(tiles);

  sols.part1 = tiles.count().toString();

  final generations = 100;
  for (var i = 0; i < generations - 1; i++) {
    // var count = tiles.iterate();
    tiles.iterate();
    // if (i % 10 == 9) {
    //   print('Day ${i + 1}: $count');
    // }
  }

  sols.part2 = tiles.iterate().toString();

  return sols;
}

class Tiles {
  Map<int, Map<int, int>> map;
  List<int> yBounds;
  List<int> xBounds;

  Tiles(Map<int, Map<int, int>> m) {
    for (var row in m.entries) {
      var y = row.key;
      yBounds = [min(yBounds[0], y), max(yBounds[1], y)];
      for (var cell in row.value.entries) {
        var x = cell.key;
        xBounds = [min(xBounds[0], x), max(xBounds[1], x)];
      }
    }
    if (yBounds == null) {
      yBounds = [0, 0];
      xBounds = [0, 0];
    }
    map = m;
  }

  int check(int y, int x) {
    try {
      if (map[y][x] == BLACK) {
        return BLACK;
      } else {
        return WHITE;
      }
    } catch (e) {
      return WHITE;
    }
  }

  void flip(int y, int x) {
    if (!map.containsKey(y)) {
      map[y] = {};
    }
    if (!map[y].containsKey(x)) {
      map[y][x] = 1;
      yBounds = [min(yBounds[0], y), max(yBounds[1], y)];
      xBounds = [min(xBounds[0], x), max(xBounds[1], x)];
    } else {
      map[y].remove(x);
      if (map[y].isEmpty) {
        map.remove(y);
      }
    }
  }

  int iterate() {
    var newTiles = Tiles({});
    var alive = 0;
    for (var y = yBounds[0] - 1; y <= yBounds[1] + 1; y++) {
      for (var x = xBounds[0] - 2; x < xBounds[1] + 2; x++) {
        var count = 0;
        for (var nei in [
          [0, 2],
          [1, 1],
          [1, -1],
          [0, -2],
          [-1, -1],
          [-1, 1],
        ]) {
          count += check(nei[0] + y, nei[1] + x);
        }
        if (count == 2 || (check(y, x) == BLACK && count == 1)) {
          newTiles.flip(y, x);
          alive++;
        }
      }
    }
    map = newTiles.map;
    yBounds = newTiles.yBounds;
    xBounds = newTiles.xBounds;
    return alive;
  }

  int count() {
    return map.values
        .fold(0, (prev, e) => e.values.fold(0, (prev, e) => prev + e) + prev);
  }
}
