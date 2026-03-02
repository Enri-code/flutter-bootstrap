import 'package:bootstrap/definitions/result.dart';

extension ResultExtensions<E extends Object, R> on Result<E, R> {
  // ignore: only_throw_errors
  R throwOrReturn() => map((error) => throw error, (data) => data);
}
