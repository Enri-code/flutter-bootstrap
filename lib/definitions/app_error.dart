/// How an error should be presented to the user.
enum ErrorPresentation {
  /// Silent - log only, don't show to user (internal errors, debugging)
  silent,

  /// Toast - show brief message at bottom/top of screen
  toast,

  /// Dialog - show in a dialog/popup that requires dismissal
  dialog,

  /// Inline - show next to the input field (validation errors)
  inline,
}

/// Base error class for all application errors.
///
/// Use this for errors that should NOT be shown to users (internal errors).
/// For user-facing errors, use [UserError] or [ValidationError].
class AppError implements Exception {
  const AppError({
    this.message,
    this.code,
    this.error,
    this.stackTrace,
    this.isRetryable = false,
  });

  /// Creates an AppError from any object.
  factory AppError.fromObject(Object e, [StackTrace? stackTrace]) {
    if (e is AppError) return e;
    return AppError(
      error: e,
      message: e.toString(),
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  /// Human-readable message (for logs/debugging)
  final String? message;

  /// Error code for categorization
  final String? code;

  /// Original error object
  final Object? error;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  /// Whether the operation can be retried
  final bool isRetryable;

  @override
  String toString() => 'AppError(code: $code, message: $message)';
}

// ============================================================================
// USER-FACING ERRORS
// ============================================================================

/// Error that should be shown to the user.
///
/// This is the main error class for user-facing errors like network failures,
/// business rule violations, etc.
class UserError extends AppError {
  const UserError({
    required String message,
    super.code,
    super.error,
    super.stackTrace,
    super.isRetryable,
    this.presentation = ErrorPresentation.toast,
  }) : super(message: message);

  /// Resource not found
  factory UserError.notFound({
    String message = 'Resource not found.',
    Object? error,
    StackTrace? stackTrace,
  }) {
    return UserError(
      code: 'NOT_FOUND',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ---------------------------------------------------------------------------
  // Common Error Factories
  // ---------------------------------------------------------------------------

  /// Network error - connection failed, timeout, etc.
  factory UserError.network({
    String message = 'Connection failed. Please check your internet.',
    Object? error,
    StackTrace? stackTrace,
  }) {
    return UserError(
      code: 'NETWORK_ERROR',
      message: message,
      error: error,
      stackTrace: stackTrace,
      isRetryable: true,
    );
  }

  /// Server error (5xx responses)
  factory UserError.server({
    String message = 'Server error. Please try again later.',
    Object? error,
    StackTrace? stackTrace,
    int? statusCode,
  }) {
    return UserError(
      code: statusCode?.toString() ?? 'SERVER_ERROR',
      message: message,
      error: error,
      stackTrace: stackTrace,
      isRetryable: true,
    );
  }

  /// Authentication failed
  factory UserError.authentication({
    String message = 'Authentication failed. Please log in again.',
    Object? error,
    StackTrace? stackTrace,
  }) {
    return UserError(
      code: 'AUTH_ERROR',
      message: message,
      error: error,
      stackTrace: stackTrace,
      presentation: ErrorPresentation.dialog,
    );
  }

  /// Permission denied (authorization)
  factory UserError.forbidden({
    String message = 'You do not have permission to perform this action.',
    Object? error,
    StackTrace? stackTrace,
  }) {
    return UserError(
      code: 'FORBIDDEN',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Business logic violation
  factory UserError.business({
    required String message,
    String? code,
    Object? error,
    StackTrace? stackTrace,
    ErrorPresentation presentation = ErrorPresentation.dialog,
  }) {
    return UserError(
      code: code ?? 'BUSINESS_ERROR',
      message: message,
      error: error,
      stackTrace: stackTrace,
      presentation: presentation,
    );
  }

  /// Device permission denied (camera, location, etc.)
  factory UserError.permission({
    required String permission,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return UserError(
      code: 'PERMISSION_DENIED',
      message: message ?? '$permission permission is required.',
      error: error,
      stackTrace: stackTrace,
      presentation: ErrorPresentation.dialog,
    );
  }

  /// How to present this error to the user
  final ErrorPresentation presentation;

  @override
  String get message => super.message ?? 'An error occurred.';

  @override
  String toString() => 'UserError(code: $code, message: $message)';
}

// ============================================================================
// VALIDATION ERRORS
// ============================================================================

/// Validation error with field-level details.
///
/// Use this for form validation errors that should be shown inline next to
/// input fields.
class ValidationError extends AppError {
  const ValidationError({
    String message = 'Please fix the errors below.',
    this.fields = const {},
  }) : super(message: message, code: 'VALIDATION_ERROR');

  /// Creates a validation error for a single field
  factory ValidationError.field(String fieldName, String errorMessage) {
    return ValidationError(
      fields: {fieldName: errorMessage},
      message: errorMessage,
    );
  }

  /// Field-specific error messages (field name -> error message)
  final Map<String, String> fields;

  /// Get error message for a specific field
  String? getFieldError(String fieldName) => fields[fieldName];

  /// Check if a specific field has an error
  bool hasFieldError(String fieldName) => fields.containsKey(fieldName);

  /// Whether this validation error has any field errors
  bool get hasErrors => fields.isNotEmpty;

  @override
  String toString() => 'ValidationError(fields: $fields)';
}
