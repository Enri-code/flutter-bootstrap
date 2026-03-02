// schedule.dart

sealed class NotificationSchedule {
  const NotificationSchedule();
  const factory NotificationSchedule.now() = Now;

  const factory NotificationSchedule.at(
    DateTime when, {
    bool precise,
    bool allowWhileIdle,
  }) = At;

  const factory NotificationSchedule.daily({
    required int hour,
    required int minute,
  }) = Daily;

  const factory NotificationSchedule.weekly({
    required Set<DayOfWeek> days,
    required int hour,
    required int minute,
  }) = Weekly;

  const factory NotificationSchedule.interval(Duration interval) = Interval;
}

final class Now extends NotificationSchedule {
  const Now();
}

final class At extends NotificationSchedule {
  const At(this.date, {this.precise = true, this.allowWhileIdle = true});
  final DateTime date;
  final bool precise;
  final bool allowWhileIdle;
}

final class Daily extends NotificationSchedule {
  const Daily({required this.hour, required this.minute});
  final int hour;
  final int minute;
}

final class Weekly extends NotificationSchedule {
  const Weekly({required this.days, required this.hour, required this.minute});
  final Set<DayOfWeek> days;
  final int hour;
  final int minute;
}

final class Interval extends NotificationSchedule {
  const Interval(this.interval);
  final Duration interval;
}

enum DayOfWeek { mon, tue, wed, thu, fri, sat, sun }

extension Day on DayOfWeek {
  int get value => index + 1;
} // Mon=1 .. Sun=7
