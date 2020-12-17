import 'dart:math';

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();
  var volume = Volume();
  var hyper = HyperVolume();
  var row = 0;
  for (var line in input.trim().split('\n')) {
    var col = 0;
    for (var c in line.split('')) {
      volume.place(0, row, col, c == '#');
      hyper.place(0, 0, row, col, c == '#');
      col++;
    }
    row++;
  }

  // print(volume.check(0, 0, 100));

  for (var i = 0; i < 6; i++) {
    volume.update();
    hyper.update();
  }

  sols.part1 = volume.count.toString();
  sols.part2 = hyper.count.toString();

  return sols;
}

class HyperVolume {
  Map<int, Map<int, Map<int, Map<int, bool>>>> vol;
  int maxZ, minZ, maxY, minY, maxX, minX, maxW, minW, count;
  HyperVolume() {
    vol = {};
    maxZ = 0;
    minZ = 0;
    maxY = 0;
    minY = 0;
    maxX = 0;
    minX = 0;
    maxW = 0;
    minW = 0;
    count = 0;
  }

  bool check(int z, int y, int x, int w) {
    try {
      return vol[z][y][x][w] == true;
    } on NoSuchMethodError {
      return false;
    }
  }

  void place(int z, int y, int x, int w, bool value) {
    if (value && (!check(z, y, x, w))) {
      count++;
      if (!vol.containsKey(z)) {
        vol[z] = {};
        maxZ = max(maxZ, z);
        minZ = min(minZ, z);
      }
      if (!vol[z].containsKey(y)) {
        vol[z][y] = {};
        maxY = max(maxY, y);
        minY = min(minY, y);
      }
      if (!vol[z][y].containsKey(x)) {
        vol[z][y][x] = {};
        maxX = max(maxX, x);
        minX = min(minX, x);
      }
      vol[z][y][x][w] = value;
      maxW = max(maxW, w);
      minW = min(minW, w);
    } else if ((!value) && check(z, y, x, w)) {
      vol[z][y][x][w] = false;
      count--;
    }
  }

  int checkNeighbors(int z, int y, int x, int w) {
    var sum = check(z, y, x, w) ? -1 : 0;
    for (var dz in [-1, 0, 1]) {
      for (var dy in [-1, 0, 1]) {
        for (var dx in [-1, 0, 1]) {
          for (var dw in [-1, 0, 1]) {
            sum += check(z + dz, y + dy, x + dx, w + dw) ? 1 : 0;
          }
        }
      }
    }
    return sum;
  }

  void update() {
    var tempVol = HyperVolume();
    for (var z = minZ - 1; z <= maxZ + 1; z++) {
      for (var y = minY - 1; y <= maxY + 1; y++) {
        for (var x = minX - 1; x <= maxX + 1; x++) {
          for (var w = minW - 1; w <= maxW + 1; w++) {
            final neighbors = checkNeighbors(z, y, x, w);
            if (neighbors == 3 || (neighbors == 2 && check(z, y, x, w))) {
              tempVol.place(z, y, x, w, true);
            }
          }
        }
      }
    }

    vol = tempVol.vol;
    maxZ = tempVol.maxZ;
    minZ = tempVol.minZ;
    maxY = tempVol.maxY;
    minY = tempVol.minY;
    maxX = tempVol.maxX;
    minX = tempVol.minX;
    maxW = tempVol.maxW;
    minW = tempVol.minW;
    count = tempVol.count;
  }
}

class Volume {
  Map<int, Map<int, Map<int, bool>>> vol;
  int maxZ, minZ, maxY, minY, maxX, minX, count;
  Volume() {
    vol = {};
    maxZ = 0;
    minZ = 0;
    maxY = 0;
    minY = 0;
    maxX = 0;
    minX = 0;
    count = 0;
  }
  bool check(int z, int y, int x) {
    try {
      return vol[z][y][x] == true;
    } on NoSuchMethodError {
      return false;
    }
  }

  void place(int z, int y, int x, bool value) {
    if (value) {
      count++;
      if (!vol.containsKey(z)) {
        vol[z] = {};
        maxZ = max(maxZ, z);
        minZ = min(minZ, z);
      }
      if (!vol[z].containsKey(y)) {
        vol[z][y] = {};
        maxY = max(maxY, y);
        minY = min(minY, y);
      }
      vol[z][y][x] = value;
      maxX = max(maxX, x);
      minX = min(minX, x);
    } else if (check(z, y, x)) {
      vol[z][y][x] = false;
      count--;
    }
  }

  int checkNeighbors(int z, int y, int x) {
    var sum = check(z, y, x) ? -1 : 0;
    for (var dz in [-1, 0, 1]) {
      for (var dy in [-1, 0, 1]) {
        for (var dx in [-1, 0, 1]) {
          sum += check(z + dz, y + dy, x + dx) ? 1 : 0;
        }
      }
    }
    return sum;
  }

  void update() {
    var tempVol = Volume();
    for (var z = minZ - 1; z <= maxZ + 1; z++) {
      for (var y = minY - 1; y <= maxY + 1; y++) {
        for (var x = minX - 1; x <= maxX + 1; x++) {
          final neighbors = checkNeighbors(z, y, x);
          if (neighbors == 3 || (neighbors == 2 && check(z, y, x))) {
            tempVol.place(z, y, x, true);
          }
        }
      }
    }

    vol = tempVol.vol;
    maxZ = tempVol.maxZ;
    minZ = tempVol.minZ;
    maxY = tempVol.maxY;
    minY = tempVol.minY;
    maxX = tempVol.maxX;
    minX = tempVol.minX;
    count = tempVol.count;
  }
}
