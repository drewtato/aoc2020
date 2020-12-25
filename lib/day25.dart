import 'package:aoc2020/structures.dart';

const SPECIAL = 20201227;

Solutions run(String input) {
  var sols = Solutions();

  final pubKeys = input.trim().split('\n').map((e) => int.parse(e));
  final cardPubKey = pubKeys.first;
  final doorPubKey = pubKeys.last;
  var subjectNumber = 7;

  var cardLoopSize = 0;
  var transform = 1;
  while (transform != cardPubKey) {
    transform *= subjectNumber;
    transform %= SPECIAL;
    cardLoopSize++;
  }

  // print(transform);

  var doorLoopSize = 0;
  transform = 1;
  while (transform != doorPubKey) {
    transform *= subjectNumber;
    transform %= SPECIAL;
    doorLoopSize++;
  }

  // print(transform);

  // print(cardLoopSize);
  // print(doorLoopSize);

  subjectNumber = doorPubKey;
  transform = 1;
  for (var i = 0; i < cardLoopSize; i++) {
    transform *= subjectNumber;
    transform %= SPECIAL;
  }

  // print(transform);

  subjectNumber = cardPubKey;
  transform = 1;
  for (var i = 0; i < doorLoopSize; i++) {
    transform *= subjectNumber;
    transform %= SPECIAL;
  }

  // print(transform);

  sols.part1 = '$transform';
  sols.part2 = 'merry christmas';

  return sols;
}
