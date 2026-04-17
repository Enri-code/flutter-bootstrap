import 'dart:async';

/// Simple performance tracking interface.
///
/// Use this to measure how long critical operations take.
/// Integrates with Sentry for production monitoring.
///
/// Example usage:
/// ```dart
/// final timer = performanceLogger.start('task_completion');
/// try {
///   await repository.markTask(...);
///   timer.stop(); // Records success
/// } catch (e) {
///   timer.stop(failed: true); // Records failure
///   rethrow;
/// }
/// ```
abstract class PerformanceLogger {
  const PerformanceLogger();

  /// Initialize the performance logger
  FutureOr<void> init();

  /// Start timing an operation.
  ///
  /// Returns a timer that you must call `.stop()` on when done.
  /// The operation name should be descriptive, like 'task_completion'
  /// or 'upload_audio'.
  PerformanceTimer start(String operationName);

  /// Track a one-shot metric value (e.g. cache_hits, file_size).
  void trackMetric(String name, num value, {Map<String, dynamic>? extra});
}

/// A timer for measuring operation duration.
///
/// Always call `.stop()` when the operation finishes.
abstract class PerformanceTimer {
  /// Stop the timer and record the measurement.
  ///
  /// Set [failed] to true if the operation failed.
  /// Add [extra] metadata for additional context.
  void stop({bool failed = false, Map<String, dynamic>? extra});

  /// Attach a custom metric to this specific timer/transaction.
  /// [unit] can be 'ms', 'byte', etc. depending on the implementation.
  void setMeasurement(String name, num value, {String? unit});

  /// Get elapsed time (useful for logging)
  Duration get elapsed;
}
