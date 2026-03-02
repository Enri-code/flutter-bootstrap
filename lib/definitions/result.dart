// ignore_for_file: avoid_types_as_parameter_names

import 'dart:async';

sealed class Result<Error, Data> {
  const Result();

  const factory Result.error(Error value) = _Error<Error, Data>;
  const factory Result.data(Data value) = _Data<Error, Data>;

  static FutureOr<Result<Error, Data>> tryCatch<Error extends Object, Data>(
    FutureOr<Data> Function() callback,
  ) async {
    try {
      return _Data<Error, Data>(await callback());
    } on Error catch (e) {
      return _Error<Error, Data>(e);
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

class _Error<Error, Data> extends Result<Error, Data> {
  const _Error(this.value);
  final Error value;
}

class _Data<Error, Data> extends Result<Error, Data> {
  const _Data(this.value);
  final Data value;
}
