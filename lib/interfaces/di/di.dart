abstract class DI {
  factory DI() {
    assert(adapter != null, 'DI.useAdapter must be called first');
    return _instance ??= adapter!();
  }
  factory DI.newInstance() {
    assert(adapter != null, 'DI.useAdapter must be called first');
    return adapter!();
  }

  static DI? _instance;
  static DI Function()? adapter;

  // ---------- Registration ----------
  void registerSingleton<T extends Object>(T instance);
  void registerLazySingleton<T extends Object>(T Function() factory);
  void registerSingletonAsync<T extends Object>(Future<T> Function() factory);

  // ---------- Resolve ----------
  T get<T extends Object>();

  Future<T> getAsync<T extends Object>();

  T? maybeGet<T extends Object>();
  bool isRegistered<T extends Object>();

  // ---------- Lifecycle ----------
  Future<void> reset();
}
