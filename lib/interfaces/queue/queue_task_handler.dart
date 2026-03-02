import 'package:bootstrap/interfaces/queue/queue_task.dart';

enum TaskResult { success, retry, fail }

abstract class QueueTaskHandler<T extends QueueTask> {
  Future<TaskResult> execute(T task);
}
