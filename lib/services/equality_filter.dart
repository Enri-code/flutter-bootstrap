class EqualityFilter<S> {
  EqualityFilter(this.filter);
  final dynamic Function(S state) filter;

  bool call(S one, S two) => filter(one) != filter(two);
}
