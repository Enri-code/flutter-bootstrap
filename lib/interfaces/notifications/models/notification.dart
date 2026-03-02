// template.dart

import 'package:bootstrap/interfaces/notifications/models/schedule.dart';

class NotificationData {
  const NotificationData({
    required this.key,
    required this.channelKey,
    required this.title,
    required this.schedule,
    this.body,
    this.payload,
  });
  final String key; // stable logical key, used to derive ID
  final String channelKey;
  final String title;
  final String? body;
  final Map<String, String>? payload;
  final NotificationSchedule schedule;
}
