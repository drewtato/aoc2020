import 'dart:collection';

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();
  var myCards = ListQueue<int>();
  var crabCards = ListQueue<int>();

  for (var line in input.trim().split('\n\n')[0].split('\n').skip(1)) {
    myCards.add(int.parse(line));
  }
  for (var line in input.trim().split('\n\n')[1].split('\n').skip(1)) {
    crabCards.add(int.parse(line));
  }

  play(myCards, crabCards);

  sols.part1 = score(myCards.isNotEmpty ? myCards : crabCards).toString();

  myCards = ListQueue<int>();
  crabCards = ListQueue<int>();

  for (var line in input.trim().split('\n\n')[0].split('\n').skip(1)) {
    myCards.add(int.parse(line));
  }
  for (var line in input.trim().split('\n\n')[1].split('\n').skip(1)) {
    crabCards.add(int.parse(line));
  }

  play2(myCards, crabCards);

  sols.part2 = score(myCards.isNotEmpty ? myCards : crabCards).toString();

  return sols;
}

// 1 for win by p1, 2 for win by p2
int play2(ListQueue<int> p1, ListQueue<int> p2) {
  var previousRounds = <String>{};
  while (p1.isNotEmpty && p2.isNotEmpty) {
    if (!previousRounds.add('$p1$p2')) {
      return 1;
    }
    var played = [p1.removeFirst(), p2.removeFirst()];
    var receiver = p1;
    var winner = played[0] > played[1] ? 1 : 2;

    if (p1.length >= played[0] && p2.length >= played[1]) {
      winner = play2(ListQueue.from(p1.take(played[0])),
          ListQueue.from(p2.take(played[1])));
    }

    if (winner == 2) {
      receiver = p2;
      played = [played[1], played[0]];
    }
    receiver.addAll(played);
  }
  return p1.isNotEmpty ? 1 : 2;
}

// 1 for win by p1, 2 for win by p2
int play(ListQueue<int> p1, ListQueue<int> p2) {
  while (p1.isNotEmpty && p2.isNotEmpty) {
    final played = [p1.removeFirst(), p2.removeFirst()];
    var receiver = p1;
    if (played[0] < played[1]) {
      receiver = p2;
    }
    played.sort((a, b) => b - a);
    receiver.addAll(played);
  }
  return p1.isNotEmpty ? 1 : 2;
}

int score(ListQueue<int> player) {
  var score = 0;
  var mult = player.length;
  for (var card in player) {
    score += card * mult;
    mult--;
  }
  return score;
}
