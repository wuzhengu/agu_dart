//extensions

extension ObjectExtension<T> on T {
  R call<R>(R Function(T it) cb) => cb(this);
}

extension NumExtension on num {
  Duration get ms => Duration(milliseconds: toInt());
}
