import 'dart:math';

import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();
  var allPrograms = <Program>[];
  final pat = RegExp(r'mem\[(\d+)\]');

  for (var line in input.trim().split('\n')) {
    final equals = line.split(' = ');
    if (equals[0] == 'mask') {
      allPrograms.add(Program());
      var power = 1;
      for (var item in equals[1].split('').reversed) {
        switch (item) {
          case '1':
            allPrograms.last.upmask += power;
            break;
          case '0':
            allPrograms.last.downmask -= power;
            break;
          case 'X':
            allPrograms.last.floating.add(power);
        }
        power *= 2;
      }
    } else {
      final mem = int.parse(pat.firstMatch(equals[0]).group(1));
      final value = int.parse(equals[1]);
      allPrograms.last.program.add([mem, value]);
    }
  }
  var mem = <int, int>{};
  for (var prog in allPrograms) {
    // print(prog);
    for (var line in prog.program) {
      var value = line[1];
      value &= prog.downmask;
      value |= prog.upmask;
      // print('overriding ${line[0]} with $value');
      mem[line[0]] = value;
    }
  }
  // print(mem);
  sols.part1 = mem.values.fold(0, (prev, e) => prev + e).toString();

  mem = {};
  for (var prog in allPrograms) {
    for (var line in prog.program) {
      var address = line[0] | prog.upmask;
      // print(prog.floating);
      changeFloating(prog.floating, mem, address, line[1]);
    }
  }

  sols.part2 = mem.values.fold(0, (prev, e) => prev + e).toString();
  return sols;
}

class Program {
  int upmask;
  int downmask;
  List<int> floating;
  List<List<int>> program;
  Program() {
    upmask = 0;
    downmask = pow(2, 32) - 1;
    floating = [];
    program = [];
  }
  @override
  String toString() {
    return '$upmask, $downmask\n$program';
  }
}

void changeFloating(
    List<int> floating, Map<int, int> mem, int address, int value) {
  if (floating.isEmpty) {
    // print('$address = $value');
    mem[address] = value;
    return;
  }
  final float = floating.removeLast();
  changeFloating(floating, mem, address ^ float, value);
  changeFloating(floating, mem, address, value);
  floating.add(float);
}
