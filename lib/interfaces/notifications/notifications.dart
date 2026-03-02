import 'dart:async';

import 'package:bootstrap/interfaces/notifications/models/notification.dart';
import 'package:flutter/foundation.dart';

enum NotificationEvent {
  onFCMSilent,
  onAction,
  onDisplay,
  onDismiss,
  onFCMToken,
}

typedef NotificationCallback =
    Future<void> Function(NotificationEvent event, Object data);

abstract class Notifications {
  @protected
  final listeners = <NotificationCallback>{};

  @protected
  final stream = StreamController<(NotificationEvent, Object)>.broadcast();

  Stream<(NotificationEvent, Object)> get events => stream.stream;

  // ---------- callbacks ----------
  void emit(NotificationEvent event, Object data) {
    for (final listener in listeners) {
      unawaited(listener(event, data));
    }
    stream.add((event, data));
  }

  Future<bool> requestPermission();
  void addListener(NotificationCallback callback);
  void removeListener(NotificationCallback callback);
  Future<int> upsert(NotificationData t);
  Future<void> cancelByKey(String key);
  Future<void> cancelAll();
}
