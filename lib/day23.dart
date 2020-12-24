import 'dart:math';

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var cups = Chain.from(input.trim().split('').map((e) => int.parse(e)));

  final moves = 100;
  // print(cups);
  for (var i = 0; i < moves; i++) {
    iterate(cups);
    // print(cups);
  }

  var one = cups.first;
  while (one.val != 1) {
    one = one.next;
  }

  sols.part1 = '';
  one = one.next;
  while (one.val != 1) {
    sols.part1 += one.toString();
    one = one.next;
  }

  cups = Chain.from(input
      .trim()
      .split('')
      .map((e) => int.parse(e))
      .followedBy(Iterable<int>.generate(1000001).skip(10)));

  final moves2 = 10000000;
  for (var i = 0; i < moves2; i++) {
    iterate(cups);
  }

  one = cups.first;
  while (one.val != 1) {
    one = one.next;
  }

  one = one.next;
  sols.part2 = (one.val * one.next.val).toString();
  return sols;
}

class Link {
  int val;
  Link prev;
  Link next;

  Link(int v) {
    val = v;
  }

  @override
  String toString() {
    return val.toString();
  }
}

// Runs a cycle and returns the new current cup.
void iterate(Chain cups) {
  final removed = cups.first.next;
  cups.first.next = cups.first.next.next.next.next;
  cups.first.next.prev = cups.first;
  final removedVals = [removed.val, removed.next.val, removed.next.next.val];

  var nextVal = ((cups.first.val - 2) % cups.maxVal) + 1;
  while (nextVal == removedVals[0] ||
      nextVal == removedVals[1] ||
      nextVal == removedVals[2]) {
    nextVal = ((nextVal - 2) % cups.maxVal) + 1;
  }

  final insertCup = cups.linkOf(nextVal);
  final endInsertCup = insertCup.next;

  insertCup.next = removed;
  removed.prev = insertCup;

  endInsertCup.prev = removed.next.next;
  endInsertCup.prev.next = endInsertCup;

  cups.first = cups.first.next;
}

class Chain {
  Link first;
  int maxVal;
  Map<int, Link> locations;

  Chain() {
    locations = {};
  }

  static Chain from(Iterable<int> source) {
    var chain = Chain();
    chain.first = Link(source.first);
    chain.maxVal = chain.first.val;
    chain.locations[source.first] = chain.first;
    var prev = chain.first;
    for (var item in source.skip(1)) {
      var l = Link(item);
      chain.maxVal = max(chain.maxVal, item);
      prev.next = l;
      l.prev = prev;
      chain.locations[item] = l;
      prev = l;
    }
    prev.next = chain.first;
    chain.first.prev = prev;
    return chain;
  }

  Link linkOf(int v) {
    return locations[v];
  }

  @override
  String toString() {
    var cur = first;
    var s = '[$cur';
    cur = cur.next;
    while (cur != first) {
      s += ', ';
      s += cur.val.toString();
      cur = cur.next;
    }
    return s + ']';
  }
}
