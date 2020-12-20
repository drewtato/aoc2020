import 'dart:math' as math;

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var tiles = <int, List<List<int>>>{};
  final pat = RegExp(r'^Tile (\d+):$');
  for (var chunk in input.trim().split('\n\n')) {
    var lines = chunk.trim().split('\n');
    final tileNo = int.parse(pat.firstMatch(lines[0]).group(1));
    var tile = <List<int>>[];
    for (var line in lines.skip(1)) {
      final pix = line.split('').map((e) => e == '#' ? 1 : 0).toList();
      tile.add(pix);
    }
    tiles[tileNo] = tile;
  }

  // for (var tile in tiles.entries) {
  //   print(tile.key);
  //   for (var line in tile.value) {
  //     print(line.map((e) => e == 1 ? '#' : '.').join());
  //   }
  //   print('');
  // }

  // Values are [[tile number, orientation], ...]
  // orientation is
  //    1,2: top
  //    3,4: right
  //    5,6: bottom
  //    7,8: left
  // Even numbers are reverse direction.
  // Orientations on tiles are which direction the top is pointing.
  var edges = <int, List<List<int>>>{};
  var reverseEdges = <int, List<int>>{};
  for (var tile in tiles.entries) {
    final top = tile.value.first;
    final left =
        tile.value.fold(<int>[], (prev, e) => prev + [e.first]) as List<int>;
    final right =
        tile.value.fold(<int>[], (prev, e) => prev + [e.last]) as List<int>;
    final bottom = tile.value.last;

    reverseEdges[tile.key] = [];
    for (var sequence in [
      [
        top,
        [1]
      ],
      [
        right,
        [3]
      ],
      [
        bottom,
        [5]
      ],
      [
        left,
        [7]
      ]
    ]) {
      for (var seq in [
        [
          sequence[0],
          [0]
        ],
        [
          sequence[0].reversed,
          [1]
        ]
      ]) {
        final numeric = listToNumeric(seq[0]);
        if (!edges.containsKey(numeric)) {
          edges[numeric] = [];
        }
        edges[numeric].add([tile.key, sequence[1][0] + seq[1].first]);
        reverseEdges[tile.key].add(numeric);
      }
    }
  }

  // print(edges.entries.first);
  // print(reverseEdges[edges.values.first[0][0]]);
  // print(tiles.length);

  // [
  //   [[tile, orientation], [tile, orientation], ...],
  //   [[tile, orientation], [tile, orientation], ...],
  //   ...
  // ]
  var missingEdge = <int, int>{};
  for (var edge in edges.entries) {
    if (edge.value.length == 1) {
      if (!missingEdge.containsKey(edge.value[0][0])) {
        missingEdge[edge.value[0][0]] = 0;
      }
      missingEdge[edge.value[0][0]]++;
    }
  }
  final corners = missingEdge.entries.where((e) => e.value == 4).toList();
  // print(corners);
  sols.part1 = corners
      .map((e) => e.key)
      .fold(1, (previousValue, element) => previousValue * element)
      .toString();

  // Map from tile number to [[adjacent tile, side, thisSide], ...]
  var connections = <int, List<List<int>>>{};
  for (var entry in edges.entries) {
    if (entry.value.length == 1) {
      continue;
    }
    final first = entry.value[0];
    final second = entry.value[1];
    if (!connections.containsKey(first[0])) {
      connections[first[0]] = [];
    }
    if (!connections.containsKey(second[0])) {
      connections[second[0]] = [];
    }
    connections[first[0]].add([second[0], second[1], first[1]]);
    connections[second[0]].add([first[0], first[1], second[1]]);
  }

  // print(connections);

  final firstTile = connections.keys.first;
  // Y-X map of [tile number, tile orientation]
  var map = <int, Map<int, List<int>>>{};
  // tile number
  var used = {firstTile};
  // tile number: [y, x, orientation]
  var next = {
    firstTile: [0, 0, 1]
  };
  while (next.isNotEmpty) {
    final addTile = next.keys.first;
    final meta = next.remove(addTile);
    if (!map.containsKey(meta[0])) {
      map[meta[0]] = {};
    }
    map[meta[0]][meta[1]] = [addTile, meta[2]];
    for (var conn in connections[addTile]) {
      if (!used.add(conn[0])) {
        continue;
      }
      final actualSide = tileAndSideAdjustment(meta[2], conn[2]);
      final newOrientation = startingAndMatchedAdjustment(actualSide, conn[1]);
      var y = meta[0];
      var x = meta[1];
      switch ((actualSide - 1) ~/ 2) {
        case 0:
          y--;
          break;
        case 1:
          x++;
          break;
        case 2:
          y++;
          break;
        case 3:
          x--;
          break;
        default:
          throw Exception('Invalid orientation: $actualSide');
      }
      next[conn[0]] = [y, x, newOrientation];
    }
  }

  var finalMap = <List<int>>[];
  var minY = map.keys.fold(0, math.min);
  var maxY = map.keys.fold(0, math.max);
  var minX = map.values.map((e) => e.keys.fold(0, math.min)).fold(0, math.min);
  var maxX = map.values.map((e) => e.keys.fold(0, math.max)).fold(0, math.max);

  for (var y = minY; y <= maxY; y++) {
    finalMap.add([]);
    for (var x = minX; x <= maxX; x++) {
      try {
        finalMap.last.add(map[y][x][0]);
      } on NoSuchMethodError {
        finalMap.last.add(9999);
      }
    }
  }

  for (var line in finalMap) {
    print(line);
  }

  return sols;
}

int listToNumeric(Iterable<int> list) {
  var n = 0;
  for (var i in list) {
    n <<= 1;
    n += i;
  }
  return n;
}

int tileAndSideAdjustment(int tile, int side) {
  return [
    [1, 2, 3, 4, 5, 6, 7, 8],
    [2, 1, 4, 3, 6, 5, 8, 7],
    [3, 8, 5, 2, 7, 4, 1, 6],
    [4, 7, 6, 1, 8, 3, 2, 5],
    [5, 6, 7, 8, 1, 2, 3, 4],
    [6, 5, 8, 7, 2, 1, 4, 3],
    [7, 4, 1, 6, 3, 8, 5, 2],
    [8, 3, 2, 5, 4, 7, 6, 1]
  ][side - 1][tile - 1];
}

int startingAndMatchedAdjustment(int starting, int matched) {
  return [
    [6, 5, 8, 7, 2, 1, 4, 3],
    [5, 6, 7, 8, 1, 2, 3, 4],
    [8, 3, 2, 5, 4, 7, 6, 1],
    [3, 8, 5, 2, 7, 4, 1, 6],
    [2, 1, 4, 3, 6, 5, 8, 7],
    [1, 2, 3, 4, 5, 6, 7, 8],
    [4, 7, 6, 1, 8, 3, 2, 5],
    [7, 4, 1, 6, 3, 8, 5, 2],
  ][matched - 1][starting - 1];
}
