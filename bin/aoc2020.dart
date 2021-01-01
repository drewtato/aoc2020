import 'package:aoc2020/runner.dart' as runner;

void main(List<String> arguments) async {
  // print('Use `dart test -n day01` to run day 1');
  for (var day in Iterable.generate(25, (e) => e + 1)) {
    final answers = await runner.run(day);
    if (answers == null) {
      continue;
    }
    print(answers.part1);
    print(answers.part2);
  }
}
