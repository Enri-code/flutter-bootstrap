/// A utility for comparing states based on a specific property.
///
/// Useful with state management libraries (like Bloc) to determine if
/// a state change should trigger a rebuild based on a specific field.
///
/// Example:
/// ```dart
/// // Only rebuild when userId changes, not the entire state
/// BlocSelector<UserBloc, UserState, String>(
///   selector: (state) => state.userId,
///   buildWhen: EqualityFilter((state) => state.userId),
///   builder: (context, userId) => Text(userId),
/// );
/// ```
class EqualityFilter<S> {
  EqualityFilter(this.filter);

  /// The function that extracts the property to compare.
  final dynamic Function(S state) filter;

  /// Returns true if the filtered values are different (state changed).
  /// Returns false if the filtered values are equal (no change).
  bool call(S one, S two) => filter(one) != filter(two);
}
