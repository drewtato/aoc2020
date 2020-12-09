import 'dart:collection';

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var last = ListQueue(26);
  var sorted = <int>[];

  var list = input.trim().split('\n').map((e) => int.parse(e)).toList();
  var answer;

  for (var number in list) {
    if (last.length == 25) {
      if (!searchPair(sorted, number)) {
        answer = number;
        break;
      }
    }

    last.add(number);
    sorted.add(number);
    sorted.sort();

    if (last.length > 25) {
      final remove = last.removeFirst();
      sorted.remove(remove);
    }
  }

  sols.part1 = '$answer';

  var sum = 0;
  var sequence = ListQueue();
  for (var number in list) {
    sum += number;
    sequence.add(number);
    while (sum > answer) {
      sum -= sequence.removeFirst();
    }
    if (sum == answer && sequence.length >= 2) {
      var sorted = sequence.toList();
      sorted.sort();
      sols.part2 = (sorted.first + sorted.last).toString();
      break;
    }
  }

  return sols;
}

bool searchPair(List<int> sorted, int number) {
  var head = 0;
  var tail = sorted.length - 1;
  while (true) {
    final difference = sorted[head] + sorted[tail];
    if (difference > number) {
      tail--;
    } else if (difference < number) {
      head++;
    } else {
      return true;
    }
    if (head == tail) {
      return false;
    }
  }
}
