/// Dependency Injection (DI) container interface.
///
/// This is an abstract interface that must be implemented by a concrete DI
/// adapter (e.g., get_it, riverpod, provider).
///
/// Before using DI, you must set an adapter:
/// ```dart
/// void main() {
///   DI.adapter = () => GetItAdapter(); // Your implementation
///   runApp(MyApp());
/// }
/// ```
///
/// Usage:
/// ```dart
/// // Register dependencies
/// DI().registerSingleton<ApiService>(ApiService());
///
/// // Retrieve dependencies
/// final api = DI().get<ApiService>();
/// ```
abstract class DI {
  /// Returns the singleton instance of the DI container.
  ///
  /// Throws [StateError] if [adapter] has not been set.
  factory DI() {
    if (adapter == null) {
      throw StateError(
        'DI adapter not initialized. Call DI.adapter = () => YourAdapter() '
        'before using DI.',
      );
    }
    return _instance ??= adapter!();
  }

  /// Creates a new instance of the DI container.
  ///
  /// Useful for testing or isolating dependencies.
  /// Throws [StateError] if [adapter] has not been set.
  factory DI.newInstance() {
    if (adapter == null) {
      throw StateError(
        'DI adapter not initialized. Call DI.adapter = () => YourAdapter() '
        'before using DI.',
      );
    }
    return adapter!();
  }

  static DI? _instance;

  /// The adapter factory that creates DI container instances.
  /// Must be set before using DI.
  static DI Function()? adapter;

  // ---------- Registration ----------

  /// Registers an existing instance as a singleton.
  void registerSingleton<T extends Object>(T instance);

  /// Registers a factory that will create a singleton on first access.
  void registerLazySingleton<T extends Object>(T Function() factory);

  /// Registers an async factory that will create a singleton on first access.
  void registerSingletonAsync<T extends Object>(Future<T> Function() factory);

  // ---------- Resolve ----------

  /// Retrieves a registered dependency.
  ///
  /// Throws if the dependency is not registered.
  T get<T extends Object>();

  /// Retrieves an async registered dependency.
  ///
  /// Waits for the dependency to be ready if it was registered async.
  Future<T> getAsync<T extends Object>();

  /// Retrieves a dependency if registered, otherwise returns null.
  T? maybeGet<T extends Object>();

  /// Checks if a dependency is registered.
  bool isRegistered<T extends Object>();

  // ---------- Lifecycle ----------

  /// Resets the DI container, clearing all registrations.
  Future<void> reset();
}
