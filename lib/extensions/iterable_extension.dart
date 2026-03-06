/// Extension on nested [Iterable] to flatten them into a single iterable.
extension IterablesExt<T> on Iterable<Iterable<T>> {
  /// Flattens a nested iterable into a single-level iterable.
  ///
  /// Example:
  /// ```dart
  /// final nested = [[1, 2], [3, 4], [5]];
  /// final flat = nested.flatten(); // [1, 2, 3, 4, 5]
  /// ```
  Iterable<T> flatten() => expand((e) => e);
}
