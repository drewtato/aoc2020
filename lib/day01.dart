List<String> run(String input) {
  var list = <int>[];
  for (var item in input.split('\n')) {
    if (item.isNotEmpty) {
      list.add(int.parse(item));
    }
  }
  return [run1(list), run2(list)];
}

String run1(List<int> list) {
  for (var i1 in list) {
    for (var i2 in list) {
      if (i1 + i2 == 2020) {
        return (i1 * i2).toString();
      }
    }
  }
  throw Exception;
}

String run2(List<int> list) {
  for (var i1 in list) {
    for (var i2 in list) {
      for (var i3 in list) {
        if (i1 + i2 + i3 == 2020) {
          return (i1 * i2 * i3).toString();
        }
      }
    }
  }
  throw Exception;
}
