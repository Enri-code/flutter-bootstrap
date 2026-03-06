import 'dart:async';

import 'package:bootstrap/definitions/result.dart';
import 'package:flutter/material.dart';

/// A utility class for running async operations with state management.
///
/// Provides state tracking (idle, running, success, failure) and notifies
/// listeners of state changes. Prevents concurrent execution of the same
/// operation.
class AsyncRunner<E extends Object, R>
    with ChangeNotifier, AsyncState<E, R>, AsyncRunnerBase<E, R> {
  AsyncRunner(this.event);

  /// Creates an AsyncRunner that accepts an argument.
  static AsyncRunnerWithArg<A, E, R> withArg<A, E extends Object, R>(
    Future<R> Function(A arg) event,
  ) =>
      AsyncRunnerWithArg<A, E, R>(event);
  final Future<R> Function() event;

  Future<R> call() => run(event);
}

/// An AsyncRunner that accepts an argument when called.
class AsyncRunnerWithArg<A, E extends Object, R>
    with ChangeNotifier, AsyncState<E, R>, AsyncRunnerBase<E, R> {
  AsyncRunnerWithArg(this.event);
  final Future<R> Function(A arg) event;

  Future<R> call(A arg) => run(() => event(arg));
}

/// Base mixin that handles async operation execution and state management.
///
/// Prevents concurrent execution - if an operation is already running,
/// subsequent calls will wait for the first one to complete.
mixin AsyncRunnerBase<E extends Object, R> on AsyncState<E, R> {
  Future<R>? _runner;

  @protected
  Future<R> run(Future<R> Function() event) async {
    return _runner ??= _run(event);
  }

  Future<R> _run(Future<R> Function() event) async {
    _status = RunAsyncStatus.running;
    _result = null;
    notifyListeners();

    try {
      final response = await event();

      _result = Result.data(response);
      _status = RunAsyncStatus.success;
      _runner = null;
      notifyListeners();

      return response;
    } on E catch (e) {
      _result = Result.error(e);
      _status = RunAsyncStatus.failure;
      _runner = null;
      notifyListeners();

      rethrow;
    }
  }

  /// Resets the runner to idle state and clears any stored result.
  void reset() {
    _status = RunAsyncStatus.idle;
    _result = null;
    notifyListeners();
  }
}

/// Mixin providing state management for async operations.
mixin AsyncState<E, R> on ChangeNotifier {
  Result<E, R>? _result;
  RunAsyncStatus _status = RunAsyncStatus.idle;

  /// The result of the last async operation (if any).
  Result<E, R>? get result => _result;

  /// The current status of the async operation.
  RunAsyncStatus get status => _status;
}

/// Status of an async operation.
enum RunAsyncStatus {
  /// No operation has been started.
  idle,

  /// Operation is currently running.
  running,

  /// Operation completed successfully.
  success,

  /// Operation failed with an error.
  failure;

  bool get isIdle => this == idle;
  bool get isRunning => this == running;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

class AsyncRunnerBuilder<E extends Object, R> extends StatelessWidget {
  const AsyncRunnerBuilder({
    required this.runner,
    required this.builder,
    super.key,
    this.child,
  });

  final Widget Function(BuildContext, AsyncState<E, R>, Widget?) builder;
  final AsyncRunnerBase<E, R> runner;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: runner,
      builder: (context, _) => builder(context, runner, child),
    );
  }
}

class AsyncRunnerListener<E extends Object, R> extends StatefulWidget {
  const AsyncRunnerListener({
    required this.runner,
    required this.child,
    required this.listener,
    super.key,
  });

  final void Function(BuildContext context, AsyncState<E, R> state) listener;
  final AsyncRunnerBase<E, R> runner;
  final Widget child;

  @override
  State<AsyncRunnerListener<E, R>> createState() =>
      _AsyncRunnerListenerState<E, R>();
}

class _AsyncRunnerListenerState<E extends Object, R>
    extends State<AsyncRunnerListener<E, R>> {
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _addNewListener();
  }

  void _addNewListener() {
    _listener = () {
      if (mounted) widget.listener(context, widget.runner);
    };
    widget.runner.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant AsyncRunnerListener<E, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listener != widget.listener) {
      widget.runner.removeListener(_listener);
      _addNewListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.runner.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
