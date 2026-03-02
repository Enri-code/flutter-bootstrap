import 'dart:async';

abstract class RunOnce {
  factory RunOnce(FutureOr<void> Function() callback) = _RunOnce;

  static RunOnceAsync async(Future<void> Function() callback) =>
      RunOnceAsync(callback);

  bool get hasRun;

  void call();

  void reset();
}

abstract class RunOnceWithArg<T> {
  factory RunOnceWithArg(FutureOr<void> Function(T) callback) = _RunOnceWithArg;

  bool get hasRun;

  void call(T arg);

  void reset();
}

class _RunOnceWithArg<T> implements RunOnceWithArg<T> {
  _RunOnceWithArg(this.callback);

  final FutureOr<void> Function(T) callback;

  bool _hasRun = false;

  @override
  bool get hasRun => _hasRun;

  @override
  void call(T arg) {
    if (_hasRun) return;

    callback(arg);
    _hasRun = true;
  }

  @override
  void reset() => _hasRun = false;
}

class _RunOnce implements RunOnce {
  _RunOnce(this.callback);

  final void Function() callback;

  bool _hasRun = false;

  @override
  bool get hasRun => _hasRun;

  @override
  void call() {
    if (_hasRun) return;

    callback();
    _hasRun = true;
  }

  @override
  void reset() => _hasRun = false;

  // static async(Future<Null> Function() param0) {}
}

class RunOnceAsync implements RunOnce {
  RunOnceAsync(this.callback);

  final Future<void> Function() callback;

  bool _hasRun = false;

  @override
  bool get hasRun => _hasRun;

  @override
  Future<void> call() async {
    if (_hasRun) return;

    await callback();
    _hasRun = true;
  }

  @override
  void reset() => _hasRun = false;

  // static async(Future<Null> Function() param0) {}
}
