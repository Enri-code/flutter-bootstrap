import 'dart:async';

/// Simple logger interface for application-wide logging.
///
/// Provides basic logging levels (debug, info, warn, error, exception).
/// Keep this interface simple - for performance tracking,
/// use PerformanceLogger.
abstract class Logger {
  const Logger();

  FutureOr<void> init();

  void debug(String msg, {Map<String, Object?>? extra});
  void info(String msg, {Map<String, Object?>? extra});
  void warn(String msg, {Map<String, Object?>? extra});
  void error(
    String msg, {
    Object? error,
    StackTrace? stack,
    Map<String, Object?>? extra,
  });
  void exception(
    Object throwable, {
    StackTrace? stack,
    Map<String, Object?>? extra,
  });
}
