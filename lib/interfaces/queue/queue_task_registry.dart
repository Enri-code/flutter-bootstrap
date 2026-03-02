import 'package:bootstrap/interfaces/queue/queue_task.dart';
import 'package:bootstrap/interfaces/queue/queue_task_handler.dart';

class QueueTaskRegistry {
  final Map<Type, QueueTaskHandler> _handlers = {};

  void register<T extends QueueTask>(QueueTaskHandler<T> handler) {
    _handlers[T] = handler;
  }

  QueueTaskHandler get(Type type) {
    final handler = _handlers[type];
    if (handler == null) throw Exception('No handler registered for $type');

    return handler;
  }
}
