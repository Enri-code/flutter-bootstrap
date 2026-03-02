/// Service for accurate time management using NTP synchronization.
///
/// This service provides:
/// - Current time from NTP server
/// - Midnight detection for cycle resets (using user's local timezone)
abstract class TimeService {
  /// Get the current time from NTP server.
  ///
  /// Returns accurate time from NTP. Falls back to system time if NTP fails
  /// and automatic time is enabled.
  ///
  /// Throws [SystemTimeNotAutomaticException]
  /// if system time is manual and NTP fails.
  Future<DateTime> getTime();

  /// Throws [SystemTimeNotAutomaticException]
  /// if system time is manual and NTP fails.
  Future<void> trackMidnight();

  Future<void> dispose();

  /// Stream that emits when midnight is crossed in user's local timezone.
  ///
  /// Use this to trigger cycle resets, streak checks, etc.
  /// Emits the DateTime at midnight (00:00:00).
  Stream<void> get onMidnight;
}

/// Exception thrown when system time is not set to automatic
/// and NTP sync has failed.
class SystemTimeNotAutomaticException implements Exception {
  const SystemTimeNotAutomaticException();
}
