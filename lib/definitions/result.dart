// ignore_for_file: avoid_types_as_parameter_names

import 'dart:async';

import 'package:flutter/foundation.dart';

/// A sealed class representing either a successful result ([Data]) or
/// an error result ([Error]).
///
/// This type provides a type-safe way to handle operations that can fail
/// without using exceptions.
sealed class Result<Error, Data> {
  const Result();

  const factory Result.error(Error value) = _Error<Error, Data>;
  const factory Result.data(Data value) = _Data<Error, Data>;

  /// Executes [callback] and wraps the result in a [Result].
  ///
  /// If [callback] succeeds, returns [Result.data] with the value.
  /// If [callback] throws an error of type [TError], returns [Result.error].
  /// If [callback] throws any other exception, it will be rethrown.
  ///
  /// Note: This method only catches errors that match the [TError] type.
  /// Use with caution and ensure proper error type matching.
  static FutureOr<Result<TError, TData>> tryCatch<
      TError extends Object,
      TData>(
    FutureOr<TData> Function() callback,
  ) async {
    try {
      return _Data<TError, TData>(await callback());
    } on TError catch (e) {
      return _Error<TError, TData>(e);
    }
  }

  bool get isData => this is _Data<Error, Data>;
  bool get isError => this is _Error<Error, Data>;

  Error get error => (this as _Error<Error, Data>).value;
  Data get data => (this as _Data<Error, Data>).value;

  T map<T>(T Function(Error error) error, T Function(Data data) data) {
    return isData ? data(this.data) : error(this.error);
  }

  T? when<T>({T Function(Error error)? error, T Function(Data data)? data}) {
    return isData ? data?.call(this.data) : error?.call(this.error);
  }
}

@immutable
class _Error<Error, Data> extends Result<Error, Data> {
  const _Error(this.value);
  final Error value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _Error<Error, Data> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

@immutable
class _Data<Error, Data> extends Result<Error, Data> {
  const _Data(this.value);
  final Data value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _Data<Error, Data> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
