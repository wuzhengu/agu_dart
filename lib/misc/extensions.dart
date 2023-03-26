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
