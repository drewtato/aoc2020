import 'package:aoc2020/structures.dart';

const CHAR_TO_SPACE = {'.': FLOOR, 'L': SEAT, '#': OCCUPIED};

const FLOOR = 0;
const SEAT = 1;
const OCCUPIED = 2;

Solutions run(String input) {
  var sols = Solutions();
  var area = input
      .trim()
      .split('\n')
      .map((line) => line.split('').map((c) => CHAR_TO_SPACE[c]).toList())
      .toList();

  var newArea = area.map((e) => e.map((e) => 0).toList()).toList();
  // print(area);
  do {
    iterate(area, newArea);
    // print(countOccupied(area));
    iterate(newArea, area);
    // print(countOccupied(area));
  } while (!check(newArea, area));
  sols.part1 = '${countOccupied(area)}';

  area = input
      .trim()
      .split('\n')
      .map((line) => line.split('').map((c) => CHAR_TO_SPACE[c]).toList())
      .toList();
  do {
    iterateSight(area, newArea);
    // print(countOccupied(area));
    iterateSight(newArea, area);
    // print(countOccupied(area));
  } while (!check(newArea, area));
  sols.part2 = '${countOccupied(area)}';
  return sols;
}

void iterate(List<List<int>> area, List<List<int>> newArea) {
  for (var y = 0; y < area.length; y++) {
    for (var x = 0; x < area[0].length; x++) {
      final space = area[y][x];
      if (space != FLOOR) {
        final occupied = testNeighbors(area, y, x);
        if (((space == OCCUPIED) && (occupied < 4)) ||
            ((space == SEAT) && (occupied == 0))) {
          newArea[y][x] = OCCUPIED;
        } else {
          newArea[y][x] = SEAT;
        }
      } else {
        newArea[y][x] = FLOOR;
      }
    }
  }
}

void iterateSight(List<List<int>> area, List<List<int>> newArea) {
  for (var y = 0; y < area.length; y++) {
    for (var x = 0; x < area[0].length; x++) {
      final space = area[y][x];
      if (space != FLOOR) {
        final occupied = testSightlines(area, y, x);
        if (((space == OCCUPIED) && (occupied < 5)) ||
            ((space == SEAT) && (occupied == 0))) {
          newArea[y][x] = OCCUPIED;
        } else {
          newArea[y][x] = SEAT;
        }
      } else {
        newArea[y][x] = FLOOR;
      }
    }
  }
}

const TESTABLES = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
];

int testNeighbors(List<List<int>> area, int y, int x) {
  var count = 0;
  for (var testable in TESTABLES) {
    try {
      if (area[testable[0] + y][testable[1] + x] == OCCUPIED) {
        count++;
      }
    } on IndexError catch (_) {} on RangeError catch (_) {}
  }
  return count;
}

int testSightlines(List<List<int>> area, int y, int x) {
  var count = 0;
  for (var testable in TESTABLES) {
    try {
      for (var i = 1; true; i++) {
        var nextSeat = area[testable[0] * i + y][testable[1] * i + x];
        if (nextSeat == FLOOR) {
          continue;
        }
        if (nextSeat == OCCUPIED) {
          count++;
        }
        break;
      }
    } on IndexError catch (_) {} on RangeError catch (_) {}
  }
  return count;
}

int countOccupied(List<List<int>> area) {
  var count = 0;
  for (var row in area) {
    for (var space in row) {
      if (space == OCCUPIED) {
        count++;
      }
    }
  }
  return count;
}

bool check(List<List<int>> area, List<List<int>> newArea) {
  for (var y = 0; y < area.length; y++) {
    for (var x = 0; x < area[0].length; x++) {
      if (area[y][x] != newArea[y][x]) {
        return false;
      }
    }
  }
  return true;
}
