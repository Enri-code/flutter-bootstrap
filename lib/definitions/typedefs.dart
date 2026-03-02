import 'package:bootstrap/definitions/app_error.dart';
import 'package:bootstrap/definitions/result.dart';

typedef AppErrorOrResult<T> = Result<AppError, T>;

typedef ErrorOrVoidResult = Result<AppError, void>;

typedef ValueUpdater<T> = T Function(T? value);
