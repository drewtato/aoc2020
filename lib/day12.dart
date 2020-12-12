import 'package:aoc2020/structures.dart';

const EAST = 0;
const SOUTH = 90;
const WEST = 180;
const NORTH = 270;

Solutions run(String input) {
  var sols = Solutions();
  var location = [0, 0];
  var location2 = [0, 0];
  var waypoint = [1, 10];
  var direction = EAST;
  final r = RegExp(r'^(.)(\d+)$');
  for (var line in input.trim().split('\n')) {
    var m = r.firstMatch(line.trim());
    final number = int.parse(m.group(2));
    switch (m.group(1)) {
      case 'N':
        location[0] += number;
        break;
      case 'S':
        location[0] -= number;
        break;
      case 'E':
        location[1] += number;
        break;
      case 'W':
        location[1] -= number;
        break;
      case 'L':
        direction = (direction - number) % 360;
        break;
      case 'R':
        direction = (direction + number) % 360;
        break;
      case 'F':
        switch (direction) {
          case EAST:
            location[1] += number;
            break;
          case SOUTH:
            location[0] -= number;
            break;
          case WEST:
            location[1] -= number;
            break;
          case NORTH:
            location[0] += number;
            break;
          default:
            throw Exception('Invalid direction $direction');
        }
        break;
      default:
        throw Exception('Invalid char ${m.group(1)}');
    }

    switch (m.group(1)) {
      case 'N':
        waypoint[0] += number;
        break;
      case 'S':
        waypoint[0] -= number;
        break;
      case 'E':
        waypoint[1] += number;
        break;
      case 'W':
        waypoint[1] -= number;
        break;
      case 'L':
        for (var i = 0; i < number; i += 90) {
          var temp = waypoint.toList();
          waypoint[0] = temp[1];
          waypoint[1] = -temp[0];
        }
        break;
      case 'R':
        for (var i = 0; i < number; i += 90) {
          var temp = waypoint.toList();
          waypoint[0] = -temp[1];
          waypoint[1] = temp[0];
        }
        break;
      case 'F':
        for (var i = 0; i < number; i++) {
          location2[0] += waypoint[0];
          location2[1] += waypoint[1];
        }
        break;
    }
  }
  sols.part1 = (location[0].abs() + location[1].abs()).toString();
  sols.part2 = (location2[0].abs() + location2[1].abs()).toString();
  return sols;
}
