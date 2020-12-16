import 'dart:collection';

import 'package:aoc2020/structures.dart';

const FIELDS = 1;
const YOUR_TICKET = 2;
const NEARBY = 3;

Solutions run(String input) {
  var sols = Solutions();
  var state = FIELDS;
  var fields = <String, List<int>>{};
  var yourTicket = <int>[];
  var nearbyTickets = <List<int>>[];
  final fieldPat = RegExp(r'^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$');

  for (var line in input.trim().split('\n')) {
    if (line == '') {
      continue;
    }
    if (line.startsWith('your ticket:')) {
      state = YOUR_TICKET;
      continue;
    }
    if (line.startsWith('nearby tickets:')) {
      state = NEARBY;
      continue;
    }
    switch (state) {
      case FIELDS:
        final m = fieldPat.firstMatch(line);
        fields[m.group(1)] =
            m.groups([2, 3, 4, 5]).map((e) => int.parse(e)).toList();
        break;
      case YOUR_TICKET:
        yourTicket = line.split(',').map((e) => int.parse(e)).toList();
        break;
      case NEARBY:
        nearbyTickets.add(line.split(',').map((e) => int.parse(e)).toList());
        break;
      default:
        throw Exception('Invalid state $state');
    }
  }
  // print(fields);
  // print(yourTicket);
  // print(nearbyTickets);

  var allowed = <int>{};

  for (var field in fields.values) {
    for (var i = field[0]; i <= field[1]; i++) {
      allowed.add(i);
    }
    for (var i = field[2]; i <= field[3]; i++) {
      allowed.add(i);
    }
  }
  // print(allowed);
  var errorRate = 0;
  var invalidTickets = <int>[];
  for (var i = 0; i < nearbyTickets.length; i++) {
    for (var number in nearbyTickets[i]) {
      if (!allowed.contains(number)) {
        errorRate += number;
        if (invalidTickets.isEmpty || invalidTickets.last != i) {
          invalidTickets.add(i);
        }
      }
    }
  }
  sols.part1 = errorRate.toString();
  // print(nearbyTickets.length);
  // print(invalidTickets.length);
  for (var index in invalidTickets.reversed) {
    nearbyTickets.removeAt(index);
  }
  // print(nearbyTickets.length);

  var unknownFields = ListQueue.from(fields.keys);
  var knownFields = <String, int>{};
  var possibleLocations = <int>{};
  for (var i = 0; i < unknownFields.length; i++) {
    possibleLocations.add(i);
  }
  nearbyTickets.add(yourTicket);

  while (!unknownFields.isEmpty) {
    final currentField = unknownFields.removeLast();
    final ranges = fields[currentField];
    var currentPossible = possibleLocations.toSet();
    for (var ticket in nearbyTickets) {
      for (var i = 0; i < ticket.length; i++) {
        if (!currentPossible.contains(i)) {
          continue;
        }
        if ((ticket[i] >= ranges[0] && ticket[i] <= ranges[1]) ||
            (ticket[i] >= ranges[2] && ticket[i] <= ranges[3])) {
          continue;
        }
        currentPossible.remove(i);
      }
    }
    if (currentPossible.length == 1) {
      knownFields[currentField] = currentPossible.first;
      possibleLocations.remove(currentPossible.first);
    } else {
      unknownFields.addFirst(currentField);
    }
  }

  // print(knownFields);

  var product = 1;
  for (var field in knownFields.entries) {
    if (field.key.startsWith('departure')) {
      product *= yourTicket[field.value];
    }
    // print(field.key);
    // print(yourTicket[field.value]);
  }

  sols.part2 = '$product';

  return sols;
}
