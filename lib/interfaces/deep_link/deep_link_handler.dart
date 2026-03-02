import 'package:flutter/material.dart';

/// Result of handling a deep link
abstract class DeepLinkHandlerResult<T> {
  const DeepLinkHandlerResult();

  factory DeepLinkHandlerResult.notHandled() = _NotHandled<T>;

  factory DeepLinkHandlerResult.success(T data) = _Success<T>;

  factory DeepLinkHandlerResult.redirect(String path) = _Redirect<T>;

  R when<R>({
    required R Function() notHandled,
    required R Function(T data) success,
    required R Function(String path) redirect,
  });

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? notHandled,
    R Function(T data)? success,
    R Function(String path)? redirect,
  });
}

class _NotHandled<T> implements DeepLinkHandlerResult<T> {
  const _NotHandled();

  @override
  R when<R>({
    required R Function() notHandled,
    required R Function(T data) success,
    required R Function(String path) redirect,
  }) {
    return notHandled();
  }

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? notHandled,
    R Function(T data)? success,
    R Function(String path)? redirect,
  }) {
    return notHandled?.call() ?? orElse();
  }
}

class _Success<T> implements DeepLinkHandlerResult<T> {
  const _Success(this.data);

  final T data;

  @override
  R when<R>({
    required R Function() notHandled,
    required R Function(T data) success,
    required R Function(String path) redirect,
  }) {
    return success(data);
  }

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? notHandled,
    R Function(T data)? success,
    R Function(String path)? redirect,
  }) {
    return success?.call(data) ?? orElse();
  }
}

class _Redirect<T> implements DeepLinkHandlerResult<T> {
  const _Redirect(this.path);

  final String path;

  @override
  R when<R>({
    required R Function() notHandled,
    required R Function(T data) success,
    required R Function(String path) redirect,
  }) {
    return redirect(path);
  }

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? notHandled,
    R Function(T data)? success,
    R Function(String path)? redirect,
  }) {
    return redirect?.call(path) ?? orElse();
  }
}

/// Abstract handler for deep links of a specific type
abstract class DeepLinkHandler<T> {
  const DeepLinkHandler();
  /// Priority for this handler. Higher priority handlers are checked first.
  /// Recommended values: 0-100
  int get priority;

  /// Whether this handler can handle the given URI
  bool canHandle(Uri uri);

  /// Handle the deep link and return a result
  Future<DeepLinkHandlerResult<T>> handle(BuildContext context, Uri uri);

  /// Convert parameters to a deep link URI
  Uri linkFromParams(T params);

  /// Extract parameters from a deep link URI
  T paramsFromLink(Uri uri);
}
