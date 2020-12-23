import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  var cups = Chain.from(input.trim().split('').map((e) => int.parse(e)));
  print(cups);

  final moves = 10;
  for (var i = 0; i < moves; i++) {}

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

class Chain {
  Link first;
  Link last;
  Map<int, Link> locations;

  Chain() {
    locations = {};
  }

  static Chain from(Iterable source) {
    var chain = Chain();
    chain.first = Link(source.first);
    chain.locations[source.first] = chain.first;
    var prev = chain.first;
    for (var item in source.skip(1)) {
      var l = Link(item);
      prev.next = l;
      l.prev = prev;
      chain.locations[item] = l;
      prev = l;
    }
    chain.last = prev;
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
    while (cur != null) {
      s += ', ';
      s += cur.val.toString();
      cur = cur.next;
    }
    return s + ']';
  }
}
