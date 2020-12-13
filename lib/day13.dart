import 'package:aoc2020/structures.dart';

const UNAVAILABLE = -1;

Solutions run(String input) {
  var sols = Solutions();
  final lines = input.trim().split('\n').toList();
  final timestamp = int.parse(lines[0]);
  final buses = lines[1]
      .split(',')
      .map((e) => e == 'x' ? UNAVAILABLE : int.parse(e))
      .toList();
  // print(timestamp);
  // print(buses);
  var min = timestamp;
  var minBus = -1;
  for (var bus in buses) {
    if (bus == UNAVAILABLE) {
      continue;
    }
    final wait = bus - (timestamp % bus);
    if (wait < min) {
      min = wait;
      minBus = bus;
    }
  }
  // print(minBus);
  // print(min);
  sols.part1 = '${minBus * min}';

  var minute = 1;
  // Should be all the past buses multiplied together.
  var multiplier = 1;
  // var lastMinute = 1;
  // var counter = 0;
  for (var currentBus = 0; currentBus < buses.length; currentBus++) {
    if (buses[currentBus] == UNAVAILABLE) {
      continue;
    }
    while ((minute + currentBus) % buses[currentBus] != 0) {
      minute += multiplier;
      // counter++;
    }
    multiplier *= buses[currentBus];
    // print('Bus ${buses[currentBus]} works at $minute');
  }
  // print(counter);
  sols.part2 = '$minute';
  return sols;
}
