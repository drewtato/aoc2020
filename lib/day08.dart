import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var program = <MapEntry<String, int>>[];

  for (var item in input.trim().split('\n')) {
    final splitItem = item.trim().split(' ');
    program.add(MapEntry(splitItem[0], int.parse(splitItem[1])));
  }

  var ins = 0;
  var acc = 0;
  var visited = <int>{};
  while (true) {
    switch (program[ins].key) {
      case 'acc':
        acc += program[ins].value;
        break;
      case 'jmp':
        ins += program[ins].value - 1;
        break;
      case 'nop':
        break;
      default:
        throw Exception('not a valid instruction: ' + program[ins].toString());
    }
    if (!visited.add(ins)) {
      break;
    }
    ins += 1;
  }
  var sols = Solutions();
  sols.part1 = acc.toString();

  for (var changed = 0; changed < program.length; changed++) {
    var newProgram = List<MapEntry<String, int>>.from(program);
    if (program[changed].key == 'acc') {
      continue;
    } else if (program[changed].key == 'jmp') {
      newProgram[changed] = MapEntry('nop', program[changed].value);
    } else if (program[changed].key == 'nop') {
      newProgram[changed] = MapEntry('jmp', program[changed].value);
    }
    ins = 0;
    acc = 0;
    visited = <int>{0};
    var outcome = 0;
    while (true) {
      switch (newProgram[ins].key) {
        case 'acc':
          acc += newProgram[ins].value;
          break;
        case 'jmp':
          ins += newProgram[ins].value - 1;
          break;
        case 'nop':
          break;
        default:
          throw Exception(
              'not a valid instruction: ' + newProgram[ins].toString());
      }
      ins += 1;
      if (!visited.add(ins)) {
        break;
      } else if (ins == program.length) {
        outcome = 1;
        break;
      } else if (ins > program.length || ins < 0) {
        outcome = 2;
        break;
      }
    }
    if (outcome == 1) {
      // print(changed.toString() + ' ' + program[changed].toString());
      sols.part2 = '$acc';
      break;
    }
    // print('$changed $outcome');
  }

  return sols;
}
