import 'dart:async';

class Debouncer {
  Timer? _debounceTimer;
  Completer<dynamic>? _completer;

  void debounce({
    required Duration duration,
    required void Function() onDebounce,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      onDebounce();
      cancel();
    });
  }

  FutureOr<dynamic> debounceAsync({
    required Duration duration,
    required FutureOr<dynamic> Function() onDebounce,
  }) async {
    _completer ??= Completer();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () async {
      _completer!.complete(await onDebounce());
      cancel();
    });
    return _completer!.future;
  }

  /// Cancels any pending debounced callbacks.
  ///
  /// If there is an active debounce timer, it will be canceled, and the
  /// debounced callback associated with that timer will not be invoked.
  void cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _completer?.complete();
    _completer = null;
  }
}
