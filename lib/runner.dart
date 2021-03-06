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
import 'package:aoc2020/day12.dart' as day12;
import 'package:aoc2020/day13.dart' as day13;
import 'package:aoc2020/day14.dart' as day14;
import 'package:aoc2020/day15.dart' as day15;
import 'package:aoc2020/day16.dart' as day16;
import 'package:aoc2020/day17.dart' as day17;
import 'package:aoc2020/day18.dart' as day18;
import 'package:aoc2020/day19.dart' as day19;
import 'package:aoc2020/day20.dart' as day20;
import 'package:aoc2020/day21.dart' as day21;
import 'package:aoc2020/day22.dart' as day22;
import 'package:aoc2020/day23.dart' as day23;
import 'package:aoc2020/day24.dart' as day24;
import 'package:aoc2020/day25.dart' as day25;

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
      case 12:
        return day12.run(input);
      case 13:
        return day13.run(input);
      case 14:
        return day14.run(input);
      case 15:
        return day15.run(input);
      case 16:
        return day16.run(input);
      case 17:
        return day17.run(input);
      case 18:
        return day18.run(input);
      case 19:
        return day19.run(input);
      case 20:
        return day20.run(input);
      case 21:
        return day21.run(input);
      case 22:
        return day22.run(input);
      case 23:
        return day23.run(input);
      case 24:
        return day24.run(input);
      case 25:
        return day25.run(input);
      default:
        return null;
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
