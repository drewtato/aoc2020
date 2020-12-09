import 'dart:io';

import 'package:aoc2020/code.dart';
import 'package:test/test.dart';
import 'package:aoc2020/runner.dart' as runner;

void main() async {
  for (var day in Iterable.generate(25, (i) => i + 1)) {
    String formatted;
    if (day < 10) {
      formatted = '0$day';
    } else {
      formatted = '$day';
    }
    test('day$formatted', () async => print(await runner.run(day)));
  }
  test('code',
      () async => {Code(await File('test/testcode.txt').readAsString())});
}
