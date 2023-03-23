//extensions

extension ObjectExtension<T> on T {
  R call<R>(R Function(T it) cb) => cb(this);
}
