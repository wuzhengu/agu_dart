//extensions

import 'dart:math';

extension ObjectExtension<T> on T {
  R call<R>(R Function(T it) cb) => cb(this);
}

extension NumExtension on num {
  Duration get ms => Duration(milliseconds: toInt());

  num roundTo(int digits) {
    if (this is int) return this;
    var scale = pow(10, digits);
    var res = (this * scale).round() / scale;
    for (var i = res.toInt();;) return i == res ? i : res;
  }
}

extension ListExtension<E> on Iterable<E> {
  E? find(bool Function(E e) test, [bool last = false]) {
    var list = this;
    if (last) list = (list is List<E> ? list : list.toList()).reversed;
    for (var e in list) {
      if (test(e)) return e;
    }
    return null;
  }
}

extension MapExtension<K, V> on Map<K, V?> {
  V? pull(K key) {
    var contains = this.containsKey(key);
    var value = this.remove(key);
    if (contains) this[key] = value;
    return value;
  }
}

extension StringExtension on String {
  /// 分割字符串，返回结果包含分隔符
  ///
  /// JS RegExp不支持反向预搜索
  List<String> splitWith(Pattern pattern) {
    final input = this;
    List<String> res = [];
    var start = 0;
    for (var match in pattern.allMatches(input)) {
      if (start < match.start) {
        res.add(input.substring(start, match.start));
      }
      res.add(input.substring(match.start, match.end));
      start = match.end;
    }
    if (start < input.length) {
      res.add(input.substring(start));
    }
    return res;
  }
}
