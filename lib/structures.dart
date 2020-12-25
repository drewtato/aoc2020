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

class DefaultMap<K, V> implements Map<K, V> {
  Map<K, V> rawMap = {};
  V Function() def;

  DefaultMap(V Function() f, [Map<K, V> initializer]) {
    if (initializer != null) {
      rawMap = initializer;
    } else {
      rawMap = {};
    }
    def = f;
  }

  @override
  String toString() => rawMap.toString();

  @override
  V operator [](Object key) {
    if (!rawMap.containsKey(key)) {
      final d = def();
      rawMap[key] = d;
      return d;
    } else {
      return rawMap[key];
    }
  }

  @override
  void operator []=(key, value) {
    rawMap[key] = value;
  }

  @override
  void addAll(Map other) => rawMap.addAll(other);

  @override
  void addEntries(Iterable<MapEntry> newEntries) =>
      rawMap.addEntries(newEntries);

  @override
  Map<RK, RV> cast<RK, RV>() => rawMap.cast();

  @override
  void clear() => rawMap.clear();

  @override
  bool containsKey(Object key) => rawMap.containsKey(key);

  @override
  bool containsValue(Object value) => rawMap.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => rawMap.entries;

  @override
  void forEach(void Function(K key, V value) f) {
    rawMap.forEach(f);
  }

  @override
  bool get isEmpty => rawMap.isEmpty;

  @override
  bool get isNotEmpty => rawMap.isNotEmpty;

  @override
  Iterable<K> get keys => rawMap.keys;

  @override
  int get length => rawMap.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) f) =>
      rawMap.map(f);

  @override
  V putIfAbsent(key, Function() ifAbsent) => rawMap.putIfAbsent(key, ifAbsent);

  @override
  V remove(Object key) => rawMap.remove(key);

  @override
  void removeWhere(bool Function(K key, V value) predicate) =>
      rawMap.removeWhere(predicate);

  @override
  V update(key, Function(V value) update, {Function() ifAbsent}) =>
      rawMap.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(Function(K key, V value) update) => rawMap.updateAll(update);

  @override
  Iterable<V> get values => rawMap.values;
}
