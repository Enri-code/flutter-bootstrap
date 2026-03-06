/// Error severity levels for categorizing error importance
enum ErrorSeverity {
  /// Informational - no action needed
  info,

  /// Warning - user should be aware but can continue
  warning,

  /// Error - operation failed, user action may be needed
  error,
}

/// Error categories for better error handling and user messaging
enum ErrorCategory {
  /// Network connectivity issues
  network,

  /// Authentication/authorization failures
  authentication,

  /// Input validation errors
  validation,

  /// Server-side errors
  server,

  /// Data format/parsing errors
  data,

  /// Permission errors (device, API)
  permission,

  /// Resource not found
  notFound,

  /// Business logic errors
  business,

  /// Unknown/uncategorized errors
  unknown,
}

/// Base error class for all application errors.
/// All domain errors should extend this class.
class AppError implements Exception {
  const AppError({
    this.error,
    this.stackTrace,
    this.code,
    this.message,
    this.severity = ErrorSeverity.error,
    this.category = ErrorCategory.unknown,
    this.isRetryable = false,
    this.metadata,
  });

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

  /// Error code (e.g., "AUTH_001", "NETWORK_TIMEOUT")
  final String? code;

  /// Human-readable error message
  final String? message;

  /// Severity level of the error
  final ErrorSeverity severity;

  /// Category of the error for handling logic
  final ErrorCategory category;

  /// Whether this error can be retried
  final bool isRetryable;

  /// Additional metadata for context
  final Map<String, dynamic>? metadata;

  /// Creates a copy of this error with updated fields.
  AppError copyWith({
    Object? error,
    StackTrace? stackTrace,
    String? code,
    String? message,
    ErrorSeverity? severity,
    ErrorCategory? category,
    bool? isRetryable,
    Map<String, dynamic>? metadata,
  }) {
    return AppError(
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      code: code ?? this.code,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      isRetryable: isRetryable ?? this.isRetryable,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get user-friendly error message
  String get userMessage =>
      message ?? error?.toString() ?? 'An unexpected error occurred';

  @override
  String toString() =>
      'AppError(code: $code, message: $message, category: $category, error: $error)';
}

/// Infrastructure layer errors (network, storage, external services)
class InfrastructureError extends AppError {
  const InfrastructureError({
    super.error,
    super.code,
    super.message,
    super.stackTrace,
    super.severity = ErrorSeverity.error,
    super.category = ErrorCategory.network,
    super.isRetryable = true,
    super.metadata,
  });

  /// Network connectivity error
  factory InfrastructureError.network({
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return InfrastructureError(
      code: 'NETWORK_ERROR',
      message:
          message ??
          'Network connection failed. Please check your internet connection.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.network,
      isRetryable: true,
    );
  }

  /// Timeout error
  factory InfrastructureError.timeout({
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return InfrastructureError(
      code: 'TIMEOUT',
      message: message ?? 'Request timed out. Please try again.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.network,
      isRetryable: true,
    );
  }

  /// Server error (5xx)
  factory InfrastructureError.server({
    String? message,
    Object? error,
    StackTrace? stackTrace,
    int? statusCode,
  }) {
    return InfrastructureError(
      code: 'SERVER_ERROR',
      message: message ?? 'Server error occurred. Please try again later.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.server,
      isRetryable: true,
      metadata: statusCode != null ? {'statusCode': statusCode} : null,
    );
  }
}

/// Domain/business logic errors
class DomainError extends AppError {
  const DomainError({
    super.error,
    super.code,
    super.message,
    super.stackTrace,
    super.severity = ErrorSeverity.error,
    super.category = ErrorCategory.business,
    super.isRetryable = false,
    super.metadata,
  });

  /// Authentication error
  factory DomainError.authentication({
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return DomainError(
      code: 'AUTH_ERROR',
      message:
          message ?? 'Authentication failed. Please check your credentials.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.authentication,
      isRetryable: false,
    );
  }

  /// Authorization error
  factory DomainError.authorization({
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return DomainError(
      code: 'FORBIDDEN',
      message: message ?? 'You do not have permission to perform this action.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.authentication,
      isRetryable: false,
      severity: ErrorSeverity.warning,
    );
  }

  /// Resource not found
  factory DomainError.notFound({
    String? resource,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return DomainError(
      code: 'NOT_FOUND',
      message: message ?? '${resource ?? 'Resource'} not found.',
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.notFound,
      isRetryable: false,
    );
  }

  /// Business rule violation
  factory DomainError.businessRule({
    required String message,
    String? code,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return DomainError(
      code: code ?? 'BUSINESS_RULE_VIOLATION',
      message: message,
      error: error,
      stackTrace: stackTrace,
      category: ErrorCategory.business,
      isRetryable: false,
    );
  }
}

/// Presentation layer errors (UI-specific issues)
class PresentationError extends AppError {
  const PresentationError({
    super.error,
    super.code,
    super.message,
    super.stackTrace,
    super.severity = ErrorSeverity.error,
    super.category = ErrorCategory.unknown,
    super.isRetryable = false,
    super.metadata,
  });
}

/// User-visible errors with custom messages for display
class UserVisibleError extends PresentationError {
  const UserVisibleError({
    String message = defaultMessage,
    super.error,
    super.stackTrace,
    super.code,
    super.severity = ErrorSeverity.error,
    super.category = ErrorCategory.unknown,
    super.isRetryable = false,
    super.metadata,
  }) : super(message: message);

  @override
  String toString() =>
      'UserVisibleError($message, error: $error, \n$stackTrace)';

  static const defaultMessage = 'An error occurred. Please try again later.';
}

/// Validation errors with field-level details
class ValidationError extends PresentationError {
  const ValidationError({
    super.error,
    super.stackTrace,
    super.message = 'Validation failed. Please check your input.',
    this.fields,
  }) : super(
         code: 'VALIDATION_ERROR',
         category: ErrorCategory.validation,
         severity: ErrorSeverity.warning,
         isRetryable: false,
       );

  /// Field-specific error messages (field name -> error message)
  final Map<String, String>? fields;

  /// Get error message for a specific field
  String? getFieldError(String fieldName) => fields?[fieldName];

  /// Check if a specific field has an error
  bool hasFieldError(String fieldName) =>
      fields?.containsKey(fieldName) ?? false;
}

/// Device permission errors
class DevicePermissionError extends InfrastructureError {
  const DevicePermissionError(
    this.permission, {
    String? message,
  }) : super(
         code: 'PERMISSION_DENIED',
         message: message ?? '$permission permission is denied.',
         category: ErrorCategory.permission,
         severity: ErrorSeverity.warning,
         isRetryable: false,
         error: '$permission permission is denied.',
       );

  /// The permission that was denied
  final String permission;
}
