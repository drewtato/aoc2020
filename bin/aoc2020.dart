import 'package:aoc2020/runner.dart' as runner;

void main(List<String> arguments) async {
  // print('Use `dart test -n day01` to run day 1');
  final answers = await runner.run(25);
  if (answers == null) {
    return;
  }
  print(answers.part1);
  print(answers.part2);
}
