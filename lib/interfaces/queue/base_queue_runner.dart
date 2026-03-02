import 'package:bootstrap/interfaces/queue/queue_task.dart';
import 'package:bootstrap/interfaces/queue/queue_task_handler.dart';
import 'package:bootstrap/interfaces/queue/queue_task_registry.dart';
import 'package:flutter/foundation.dart';

abstract class BaseQueueRunner<T extends QueueTask> {
  const BaseQueueRunner(this.registry);

  @protected
  final QueueTaskRegistry registry;

  @protected
  Future<List<T>> getTasks();
  @protected
  Future<void> onSuccess(T task);
  @protected
  Future<void> onRetry(T task);
  @protected
  Future<void> onFail(T task);

  Future<void> run() async {
    final tasks = await getTasks();

    for (final task in tasks) {
      final handler = registry.get(task.runtimeType);

      try {
        final result = await handler.execute(task);

        switch (result) {
          case TaskResult.success:
            await onSuccess(task);
          case TaskResult.retry:
            await onRetry(task);
          case TaskResult.fail:
            await onFail(task);
        }
      } on Object catch (_) {
        await onRetry(task);
      }
    }
  }
}
