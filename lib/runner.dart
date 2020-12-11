import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:aoc2020/structures.dart';
import 'package:aoc2020/day01.dart' as day01;
import 'package:aoc2020/day02.dart' as day02;
import 'package:aoc2020/day03.dart' as day03;
import 'package:aoc2020/day04.dart' as day04;
import 'package:aoc2020/day05.dart' as day05;
import 'package:aoc2020/day06.dart' as day06;
import 'package:aoc2020/day07.dart' as day07;
import 'package:aoc2020/day08.dart' as day08;
import 'package:aoc2020/day09.dart' as day09;
import 'package:aoc2020/day10.dart' as day10;
import 'package:aoc2020/day11.dart' as day11;

Future<Solutions> run(int day) async {
  try {
    final input = await fetch_input(day);
    switch (day) {
      case 1:
        return day01.run(input);
      case 2:
        return day02.run(input);
      case 3:
        return day03.run(input);
      case 4:
        return day04.run(input);
      case 5:
        return day05.run(input);
      case 6:
        return day06.run(input);
      case 7:
        return day07.run(input);
      case 8:
        return day08.run(input);
      case 9:
        return day09.run(input);
      case 10:
        return day10.run(input);
      case 11:
        return day11.run(input);
      default:
        throw AOCException.withReason('No case for this in the runner.');
    }
  } on AOCException catch (e) {
    print(e.toString());
    return null;
  }
}

Future<String> fetch_input(int day) async {
  final inputPath = 'inputs/$day.txt';
  String input;
  try {
    input = await File(inputPath).readAsString();
  } on FileSystemException {
    final url = 'https://adventofcode.com/2020/day/$day/input';
    final dir = path.current;
    final api = await File('$dir/API.txt').readAsString();
    final response = await http.get(url, headers: {'Cookie': 'session=$api'});
    final code = response.statusCode;
    if (response.statusCode >= 300 || response.statusCode < 200) {
      throw AOCException.withReason(
          'Status code $code, Try again when the puzzle unlocks.');
    }
    input = response.body;
    await File(inputPath).writeAsString(input);
    print(input);
  }
  return input;
}
