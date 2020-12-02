List<String> run(String input) {
  final reg = RegExp(r'^(\d+)-(\d+) (.): (\w+)$');
  var passes = [];
  for (var line in input.trim().split('\n')) {
    final match = reg.firstMatch(line.trim());
    passes.add([
      int.parse(match.group(1)),
      int.parse(match.group(2)),
      match.group(3),
      match.group(4)
    ]);
  }

  var count1 = 0;
  var count2 = 0;

  for (var p in passes) {
    final int low = p[0];
    final int high = p[1];
    final String letter = p[2];
    final String password = p[3];

    // Part 1
    final count = password.split(letter).length - 1;
    if (count <= high && count >= low) {
      count1++;
    }

    // Part 2
    var matches = 0;
    try {
      if (password[low - 1] == letter) {
        matches++;
      }
      if (password[high - 1] == letter) {
        matches++;
      }
      // ignore: empty_catches
    } on RangeError {}
    if (matches == 1) {
      count2++;
    }
  }

  return ['$count1', '$count2'];
}
