extension IterablesExt<T> on Iterable<Iterable<T>> {
  Iterable<T> flatten() => expand((e) => e);
}
