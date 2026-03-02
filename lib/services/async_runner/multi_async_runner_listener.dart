import 'package:bootstrap/services/async_runner/async_runner.dart';
import 'package:flutter/material.dart';

/// Listens to multiple AsyncRunners and triggers a listener callback.
///
/// This is useful for handling errors from multiple async operations.
///
/// Example:
/// ```dart
/// MultiAsyncRunnerListener<MyError, void>(
///   runners: [
///     cubit.loadData1,
///     cubit.loadData2,
///     cubit.loadData3,
///   ],
///   listener: (context, state) {
///     state.result?.when(error: (e) => e.displayAsToast(context));
///   },
///   child: MyWidget(),
/// )
/// ```
class MultiAsyncRunnersListener<E extends Object, R> extends StatefulWidget {
  const MultiAsyncRunnersListener({
    required this.runners,
    required this.child,
    required this.listener,
    super.key,
  });

  final void Function(BuildContext context, AsyncState<E, R> state) listener;
  final List<AsyncRunnerBase<E, R>> runners;
  final Widget child;

  @override
  State<MultiAsyncRunnersListener<E, R>> createState() =>
      _MultiAsyncRunnersListenerState<E, R>();
}

class _MultiAsyncRunnersListenerState<E extends Object, R>
    extends State<MultiAsyncRunnersListener<E, R>> {
  final List<VoidCallback> _listeners = [];

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    for (final runner in widget.runners) {
      final listener = () {
        if (mounted) widget.listener(context, runner);
      };
      _listeners.add(listener);
      runner.addListener(listener);
    }
  }

  void _removeListeners() {
    for (var i = 0; i < widget.runners.length; i++) {
      widget.runners[i].removeListener(_listeners[i]);
    }
    _listeners.clear();
  }

  @override
  void didUpdateWidget(covariant MultiAsyncRunnersListener<E, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listener != widget.listener ||
        oldWidget.runners != widget.runners) {
      _removeListeners();
      _addListeners();
    }
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
