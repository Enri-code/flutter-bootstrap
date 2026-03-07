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
  Stream<void> trackTime(int hour, int minute, int second);

  Future<void> dispose();
}

/// Exception thrown when system time is not set to automatic
/// and NTP sync has failed.
class SystemTimeNotAutomaticException implements Exception {
  const SystemTimeNotAutomaticException();
}
