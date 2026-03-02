import 'package:bootstrap/interfaces/queue/queue_task.dart';
import 'package:bootstrap/interfaces/queue/queue_task_handler.dart';

abstract class NetworkQueueManager {
  Future<void> start();
  void close();
}

class NetworkQueueTask extends QueueTask {
  const NetworkQueueTask({required this.id, required this.action});

  @override
  final String id;
  final Future<void> Function() action;
}

class NetworkQueueTaskHandler extends QueueTaskHandler<NetworkQueueTask> {
  @override
  Future<TaskResult> execute(NetworkQueueTask task) async {
    try {
      await task.action();
      return TaskResult.success;
    } on Object {
      return TaskResult.retry;
    }
  }
}
