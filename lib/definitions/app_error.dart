/// Base error class for all application errors.
/// All domain errors should extend this class.
class AppError implements Exception {
  const AppError({this.error, this.stackTrace});

  /// Creates an [UserVisibleError] from any object.
  /// Handles common error types and provides fallback behavior.
  factory AppError.fromObject(Object e, [StackTrace? stackTrace]) {
    if (e is AppError) return e;
    return AppError(error: e, stackTrace: stackTrace ?? StackTrace.current);
  }

  /// Original error object (for debugging).
  final Object? error;

  /// Stack trace (for debugging).
  final StackTrace? stackTrace;

  /// Creates a copy of this error with updated fields.
  AppError copyWith({Object? error, StackTrace? stackTrace}) {
    return AppError(
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  String toString() => 'AppError(error: $error, \n$stackTrace)';
}

class InfrastructureError extends AppError {
  const InfrastructureError({super.error});
}

class DomainError extends AppError {
  const DomainError({super.error});
}

class PresentationError extends AppError {
  const PresentationError({super.error, super.stackTrace});
}

class UserVisibleError extends PresentationError {
  const UserVisibleError({
    this.message = defaultMessage,
    super.error,
    super.stackTrace,
  });

  final String message;

  @override
  String toString() =>
      'UserVisibleError($message, error: $error, \n$stackTrace)';

  static const defaultMessage = 'An error occurred. Please try again later.';
}

class ValidationError extends PresentationError {
  const ValidationError({super.error, this.fields});
  final Map<String, String>? fields;
}

class DevicePermissionError extends InfrastructureError {
  const DevicePermissionError(this.permission)
    : super(error: '$permission permission is denied.');
  final String permission;
}
