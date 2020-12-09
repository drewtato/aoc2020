class Code {
  var program = <Instruction>[];

  Code(String raw) {
    program = [];
    for (var line in raw.trim().split('\n')) {
      program.add(Instruction(line));
    }
  }
}

class Instruction {
  String name;
  int value;

  static final _pattern = RegExp(r'^(\w+) ((?:\+|-)\d+)$');

  Instruction(String raw) {
    final m = _pattern.firstMatch(raw.trim());
    name = m.group(1);
    value = int.parse(m.group(2));
  }
}
