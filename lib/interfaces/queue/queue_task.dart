import 'package:flutter/foundation.dart';

@immutable
abstract class QueueTask {
  const QueueTask();

  String get id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is QueueTask && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
