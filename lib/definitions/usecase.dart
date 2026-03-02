import 'dart:async';

import 'package:bootstrap/definitions/result.dart';

/// Base interface for all use cases in the application.
/// Use cases represent business logic operations and should be
/// independent of presentation and data layers.
abstract class UseCase<Response> {
  const UseCase();
  FutureOr<Response> call();
}

/// Use case that accepts parameters.
abstract class UseCaseWithParams<Response, Params> {
  const UseCaseWithParams();

  FutureOr<Response> call(Params params);
}

abstract class ResultUseCase<Failure extends Object, Success> {
  const ResultUseCase();

  /// Executes the use case and returns a [Result] with either
  /// a [Failure] or [Success].
  FutureOr<Result<Failure, Success>> call();
}

/// Use case that accepts parameters.
abstract class ResultUseCaseWithParams<
  Failure extends Object,
  Success,
  Params
> {
  const ResultUseCaseWithParams();

  /// Executes the use case with the given [params] and returns
  /// a [Result] with either a [Failure] or [Success].
  FutureOr<Result<Failure, Success>> call(Params params);
}

/// Use case that performs a stream operation.
abstract class StreamUseCase<Failure extends Object, Success> {
  const StreamUseCase();

  /// Executes the use case and returns a [Stream] of [Result]s.
  Stream<Result<Failure, Success>> call();
}

/// Use case that performs a stream operation with parameters.
abstract class StreamUseCaseWithParams<
  Failure extends Object,
  Success,
  Params
> {
  const StreamUseCaseWithParams();

  /// Executes the use case with the given [params] and
  /// returns a [Stream] of [Result]s.
  Stream<Result<Failure, Success>> call(Params params);
}
