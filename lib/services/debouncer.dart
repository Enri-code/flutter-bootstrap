import 'dart:async';

/// A utility class for debouncing function calls.
///
/// Debouncing delays the execution of a function until a certain amount of
/// time has passed without it being called again. Useful for search inputs,
/// scroll handlers, etc.
///
/// Example:
/// ```dart
/// final debouncer = Debouncer();
///
/// // In your search field
/// onChanged: (value) {
///   debouncer.debounce(
///     duration: Duration(milliseconds: 500),
///     onDebounce: () => performSearch(value),
///   );
/// }
/// ```
class Debouncer {
  Timer? _debounceTimer;
  Completer<dynamic>? _completer;

  /// Debounces a synchronous callback.
  ///
  /// If called multiple times, only the last callback will execute after
  /// [duration] has passed since the last call.
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

  /// Debounces an asynchronous callback and returns a Future.
  ///
  /// Returns the result of the last debounced callback. All calls share
  /// the same Future until the debounce completes.
  ///
  /// Note: Multiple rapid calls will return the same Future instance.
  FutureOr<dynamic> debounceAsync({
    required Duration duration,
    required FutureOr<dynamic> Function() onDebounce,
  }) async {
    _completer ??= Completer();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () async {
      final completer = _completer;
      if (completer != null && !completer.isCompleted) {
        try {
          completer.complete(await onDebounce());
        } catch (e, stackTrace) {
          completer.completeError(e, stackTrace);
        }
      }
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
