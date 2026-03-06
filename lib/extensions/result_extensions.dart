import 'package:bootstrap/definitions/result.dart';

/// Extension methods for [Result] types.
extension ResultExtensions<E extends Object, R> on Result<E, R> {
  /// Throws the error if this is an error result, otherwise returns the data.
  ///
  /// Useful for converting Result-based code to exception-based code.
  ///
  /// Example:
  /// ```dart
  /// final result = await someOperation();
  /// try {
  ///   final data = result.throwOrReturn();
  ///   print('Success: $data');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  // ignore: only_throw_errors
  R throwOrReturn() => map((error) => throw error, (data) => data);
}
