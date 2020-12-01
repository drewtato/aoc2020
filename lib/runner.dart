import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:aoc2020/day01.dart' as day01;
import 'package:aoc2020/day02.dart' as day02;
import 'package:aoc2020/day03.dart' as day03;
import 'package:aoc2020/day04.dart' as day04;

Future<String> run(int day) async {
  final input = await fetch_input(day);
  switch (day) {
    case 1:
      return day01.run(input);
    default:
      return 'create that one in the runner';
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
    if (response.statusCode == 404) {
      throw Exception('API returned 404, try again when the puzzle releases');
    }
    input = response.body;
    await File(inputPath).writeAsString(input);
    print(input);
  }
  return input;
}