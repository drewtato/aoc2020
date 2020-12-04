class Solutions {
  String part1;
  String part2;

  Solutions();
  static Solutions withParts(String p1, String p2) {
    var sols = Solutions();
    sols.part1 = p1;
    sols.part2 = p2;
    return sols;
  }

  @override
  String toString() {
    return '$part1\n$part2';
  }
}

class AOCException implements Exception {
  String reason = '';
  static AOCException withReason(String reason) {
    var exc = AOCException();
    exc.reason = reason;
    return exc;
  }

  @override
  String toString() {
    return reason;
  }
}
