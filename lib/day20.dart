import 'dart:math';

import 'package:aoc2020/structures.dart';

const SEA_MONSTER =
    '                  # \n#    ##    ##    ###\n #  #  #  #  #  #   \n';

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

  // edgeInteger: {tile number: orientation, ...}
  var edgeInts = DefaultMap<int, Map<int, Orientation>>(() => {});
  // tile number: {edgeInteger: orientation, ...}
  var reverseEdgeInts = DefaultMap<int, Map<int, Orientation>>(() => {});
  for (var tile in tiles.entries) {
    final top = tile.value.first;
    final left = tile.value.reversed.fold<List<int>>(<int>[], (prev, e) {
      prev.add(e.first);
      return prev;
    });
    final right = tile.value.fold<List<int>>(<int>[], (prev, e) {
      prev.add(e.last);
      return prev;
    });
    final bottom = tile.value.last.reversed.toList();

    // Map out edges
    final edges = [top, right, bottom, left];
    for (var i = 0; i < edges.length; i++) {
      final edgeInt = listToInteger(edges[i]);
      edgeInts[edgeInt][tile.key] = Orientation(i, 0);
      reverseEdgeInts[tile.key][edgeInt] = Orientation(i, 0);
      final edgeIntRev = listToInteger(edges[i].reversed);
      edgeInts[edgeIntRev][tile.key] = Orientation(i, 1);
      reverseEdgeInts[tile.key][edgeIntRev] = Orientation(i, 1);
    }
  }

  // print(edgeInts);
  // print(reverseEdgeInts);

  // Find connections between edges
  // tile number: {
  //   first tile's side: second tile's TileOrientation,
  //   ...
  // }
  var adjacents = DefaultMap<int, Map<Orientation, TileOrientation>>(() => {});
  for (var tile in reverseEdgeInts.entries) {
    var tileAdjacents = adjacents[tile.key];
    for (var edge in tile.value.entries) {
      final firstOri = edge.value;
      for (var otherTile in edgeInts[edge.key].entries) {
        if (otherTile.key != tile.key) {
          tileAdjacents[firstOri] =
              TileOrientation(otherTile.key, otherTile.value);
          break;
        }
      }
    }
  }

  // print(adjacents);
  // return sols;

  // Find all corners for part 1, take one corner for starting part 2
  final corners = adjacents.entries.where((e) => e.value.length == 4).toList();
  sols.part1 = corners.fold(1, (prev, e) => prev * e.key).toString();

  final topLeftCorner = corners.first;

  // Rotate corner so right and bottom have connections
  var cornerRotation = 0;
  var activeSides = [
    Orientation.from(topLeftCorner.value.keys.where((e) => e.flip == 0).first),
    Orientation.from(topLeftCorner.value.keys.where((e) => e.flip == 0).last)
  ];
  activeSides.sort((a, b) => a.rotation - b.rotation);
  while (!(activeSides[0].rotation == 1 && activeSides[1].rotation == 2)) {
    // print('rotating');
    cornerRotation++;
    activeSides[0].rotateCounter();
    activeSides[1].rotateCounter();
  }

  // print(topLeftCorner);
  // print(cornerRotation);

  // Map of placed tiles
  var tileMap = <List<TileOrientation>>[];
  var next = TileOrientation(topLeftCorner.key, Orientation(cornerRotation, 0));
  do {
    // Find right side connections until no more
    // print('adding row');
    tileMap.add([next]);
    while ((next = next.right(adjacents)) != null) {
      tileMap.last.add(next);
    }
    // Go down one row and repeat
    // print('row ${tileMap.length} done');
  } while ((next = tileMap.last[0].down(adjacents)) != null);

  // Add all tiles to map according to position and orientation
  final size = tiles.values.first.length;
  var pixelMap = <List<int>>[];
  for (var tileY = 0; tileY < tileMap.length; tileY++) {
    var tileRow = tileMap[tileY];
    for (var i = 0; i < size - 2; i++) {
      pixelMap.add([]);
    }
    for (var tile in tileRow) {
      final pixels = tile.pixels(tiles);
      for (var pixRow = 0; pixRow < size - 2; pixRow++) {
        pixelMap[pixRow + (size - 2) * tileY]
            .addAll(pixels[pixRow + 1].skip(1).take(size - 2));
      }
    }
  }
  // pixelMap = rotatePix(pixelMap);
  // pixelMap = flipPix(pixelMap);
  // for (var row in pixelMap) {
  //   print(row.map((e) => e == 1 ? '#' : ' ').join());
  // }

  // Compute sea monster set
  final seaMonsterList = SEA_MONSTER
      .split('\n')
      .map((e) => e.split('').map((e) => e == '#' ? 1 : 0).toList())
      .toList();
  var seaMonsterSet = <Point>[];
  for (var y = 0; y < seaMonsterList.length; y++) {
    for (var x = 0; x < seaMonsterList[y].length; x++) {
      if (seaMonsterList[y][x] == 1) {
        seaMonsterSet.add(Point(y, x));
      }
    }
  }
  var monsterLength = seaMonsterSet.fold<int>(0, (prev, e) => max(prev, e.x));
  var monsterHeight = seaMonsterSet.fold<int>(0, (prev, e) => max(prev, e.y));

  // Rotate/flip map until sea monsters are spotted
  var monsters = 0;
  for (var i = 0; i < 2; i++) {
    for (var i = 0; i < 4; i++) {
      // Count sea monsters
      monsters = findSeaMonsters(
          pixelMap, seaMonsterSet, monsterLength, monsterHeight);
      if (monsters > 0) {
        break;
      }
      pixelMap = rotatePix(pixelMap);
    }
    if (monsters > 0) {
      break;
    }
    pixelMap = flipPix(pixelMap);
  }

  var notMonsters = pixelMap.fold<int>(
      0, (prev, e) => prev + e.fold<int>(0, (prev, e) => prev + e));
  sols.part2 = (notMonsters - (monsters * seaMonsterSet.length)).toString();

  return sols;
}

int findSeaMonsters(List<List<int>> pix, List<Point> monster, int monsterLength,
    int monsterHeight) {
  var monsters = 0;
  for (var bigY = 0; bigY < pix.length - monsterHeight + 1; bigY++) {
    for (var bigX = 0; bigX < pix.first.length - monsterLength + 1; bigX++) {
      var found = true;
      for (var point in monster) {
        if (pix[point.y + bigY][point.x + bigX] != 1) {
          found = false;
          break;
        }
      }
      if (found) {
        // print(bigX);
        // print(bigY);
        monsters++;
      }
    }
  }
  return monsters;
}

int listToInteger(Iterable<int> list) {
  var n = 0;
  for (var i in list) {
    n <<= 1;
    n += i;
  }
  return n;
}

class Point {
  int y, x;

  Point(int y, int x) {
    this.y = y;
    this.x = x;
  }

  @override
  int get hashCode => y * 65536 + x;
  @override
  bool operator ==(Object other) =>
      other is Point && other.y == y && other.x == x;

  @override
  String toString() => '($y, $x)';
}

class Orientation {
  int rotation, flip;

  Orientation(int r, int f) {
    rotation = r;
    flip = f;
  }

  void rotateClock([int times = 1]) {
    rotation = (rotation + times) % 4;
  }

  void rotateCounter([int times = 1]) {
    rotation = (rotation - times) % 4;
  }

  int toggleFlip() => flip = (flip + 1) % 2;

  Orientation.from(Orientation ori) : this(ori.rotation, ori.flip);

  @override
  int get hashCode => rotation * 2 + flip;
  @override
  bool operator ==(Object other) =>
      other is Orientation && other.rotation == rotation && other.flip == flip;

  @override
  String toString() => '<$rotation, $flip>';
}

class TileOrientation {
  int tile;
  Orientation ori;

  TileOrientation(int t, Orientation o) {
    tile = t;
    ori = o;
  }

  @override
  String toString() => '$tile$ori';

  TileOrientation.from(TileOrientation tior)
      : this(tior.tile, Orientation.from(tior.ori));

  TileOrientation right(Map<int, Map<Orientation, TileOrientation>> allTiles) {
    final thisEntry = allTiles[tile];
    // print(thisEntry);
    // print(ori);
    final rightOri = Orientation(
        ori.flip == 0 ? (ori.rotation + 1) % 4 : (ori.rotation - 1) % 4,
        ori.flip);
    rightOri.toggleFlip();
    // print(rightOri);
    var otherEntry = thisEntry[rightOri];
    if (otherEntry == null) {
      return null;
    }
    var rawOther = TileOrientation.from(otherEntry);
    if (rawOther.ori.flip == 1) {
      rawOther.ori.rotateCounter(1);
    } else {
      rawOther.ori.rotateClock(1);
    }
    // rawOther.ori.toggleFlip();
    // print(rawOther.ori);
    return rawOther;
  }

  TileOrientation down(Map<int, Map<Orientation, TileOrientation>> allTiles) {
    final thisEntry = allTiles[tile];
    final downOri = Orientation.from(ori);
    downOri.rotateClock(2);
    downOri.toggleFlip();
    var otherEntry = thisEntry[downOri];
    if (otherEntry == null) {
      return null;
    }
    return TileOrientation.from(otherEntry);
  }

  List<List<int>> pixels(Map<int, List<List<int>>> tiles) {
    final tileData = tiles[tile];
    var pix = <List<int>>[];
    switch (ori.rotation) {
      case 0:
        pix = tileData.map((e) => e.toList()).toList();
        break;
      case 1:
        for (var y = tileData.first.length - 1; y >= 0; y--) {
          pix.add([]);
          for (var x = 0; x < tileData.length; x++) {
            pix.last.add(tileData[x][y]);
          }
        }
        break;
      case 2:
        for (var y = tileData.first.length - 1; y >= 0; y--) {
          pix.add([]);
          for (var x = tileData.length - 1; x >= 0; x--) {
            pix.last.add(tileData[y][x]);
          }
        }
        break;
      case 3:
        for (var y = 0; y < tileData.first.length; y++) {
          pix.add([]);
          for (var x = tileData.length - 1; x >= 0; x--) {
            pix.last.add(tileData[x][y]);
          }
        }
        break;
    }
    if (ori.flip == 1) {
      var old = pix;
      pix = [];
      for (var row in old) {
        pix.add(row.reversed.toList());
      }
    }
    return pix;
  }
}

List<List<int>> flipPix(List<List<int>> pix) =>
    pix.map((e) => e.reversed.toList()).toList();

List<List<int>> rotatePix(List<List<int>> pix) {
  var newPix = <List<int>>[];
  for (var x = 0; x < pix.first.length; x++) {
    newPix.add([]);
    for (var y = pix.length - 1; y >= 0; y--) {
      newPix.last.add(pix[y][x]);
    }
  }
  return newPix;
}
