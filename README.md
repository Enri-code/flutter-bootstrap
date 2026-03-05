# Bootstrap Package

Foundation package providing core domain logic, type-safe error handling, async utilities, and shared interfaces for Flutter applications.

## What This Package Does

Bootstrap provides the building blocks for clean architecture Flutter apps:
- **Result Type**: Type-safe error handling without exceptions
- **AsyncRunner**: Manage async operations with loading states
- **Fetcher**: Local-first data fetching with automatic caching
- **Event System**: Decoupled communication between modules
- **Core Interfaces**: DI, logging, storage, time services
- **Use Cases**: Structured business logic patterns

## Installation

```yaml
dependencies:
  bootstrap:
    path: ../packages/bootstrap
```

```dart
import 'package:bootstrap/core.dart';
import 'package:bootstrap/definitions/result.dart';
import 'package:bootstrap/services/async_runner/async_runner.dart';
import 'package:bootstrap/services/fetcher.dart';
```

---

## 1. Result Type - Type-Safe Error Handling

The `Result<Error, Data>` type replaces try-catch with explicit error handling.

### Basic Usage

```dart
// Creating results
Result<String, int> success = Result.data(42);
Result<String, int> failure = Result.error('Something went wrong');

// Checking result type
if (result.isData) {
  print(result.data); // 42
}
if (result.isError) {
  print(result.error); // 'Something went wrong'
}
```

### Pattern Matching with map()

```dart
// Transform both success and error cases
final message = result.map(
  (error) => 'Error: $error',      // Called if Result.error
  (data) => 'Success: $data',      // Called if Result.data
);
```

### Optional Handling with when()

```dart
// Handle only the cases you care about
result.when(
  error: (e) => showErrorDialog(e),
  data: (d) => updateUI(d),
);

// Handle only errors (returns null for data)
result.when(
  error: (e) => logError(e),
);
```

### Wrapping Throwing Code

```dart
// Automatically catch exceptions and convert to Result
Future<Result<Exception, String>> fetchData() async {
  return Result.tryCatch<Exception, String>(() async {
    final response = await http.get(url); // May throw
    return response.body;
  });
}

// Usage
final result = await fetchData();
result.map(
  (error) => print('Failed: $error'),
  (data) => print('Got: $data'),
);
```

### Real-World Example: Login Function

```dart
Future<Result<AppError, User>> login(String email, String password) async {
  return Result.tryCatch<AppError, User>(() async {
    final response = await authApi.login(email, password);
    return User.fromJson(response);
  });
}

// Usage in UI
final result = await login('user@example.com', 'password123');
result.map(
  (error) => showSnackbar('Login failed: ${error.error}'),
  (user) => navigateToHome(user),
);
```

### Extension: throwOrReturn()

```dart
// Convert Result back to throwing code when needed
final data = result.throwOrReturn(); // Throws error or returns data
```

---

## 2. AsyncRunner - Async State Management

`AsyncRunner` tracks the status of async operations (idle, running, success, failure) and stores results.

### Basic AsyncRunner

```dart
// Define an async operation
late final loadUsers = AsyncRunner<AppError, List<User>>(() async {
  final users = await userRepository.fetchAll();
  return users;
});

// Execute
await loadUsers();

// Check status
if (loadUsers.status.isSuccess) {
  final users = loadUsers.result!.data;
  print('Loaded ${users.length} users');
}

if (loadUsers.status.isRunning) {
  showLoadingSpinner();
}

if (loadUsers.status.isFailure) {
  final error = loadUsers.result!.error;
  showError(error);
}
```

### AsyncRunner with Arguments

```dart
// Define operation that takes parameters
late final deleteUser = AsyncRunner.withArg<String, AppError, void>(
  (userId) async {
    await userRepository.delete(userId);
  },
);

// Execute with argument
await deleteUser('user-123');

// Check result
if (deleteUser.status.isSuccess) {
  showSnackbar('User deleted');
}
```

### Status Enum

```dart
enum RunAsyncStatus {
  idle,      // Not started
  running,   // In progress
  success,   // Completed successfully
  failure;   // Failed with error
}

// Check status
loadUsers.status.isIdle
loadUsers.status.isRunning
loadUsers.status.isSuccess
loadUsers.status.isFailure
```

### UI Integration with AsyncRunnerBuilder

```dart
AsyncRunnerBuilder<AppError, List<User>>(
  runner: loadUsers,
  builder: (context, state, child) {
    if (state.status.isRunning) {
      return CircularProgressIndicator();
    }
    
    if (state.status.isFailure) {
      return Text('Error: ${state.result!.error}');
    }
    
    if (state.status.isSuccess) {
      final users = state.result!.data;
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserTile(users[index]),
      );
    }
    
    return SizedBox.shrink();
  },
)
```

### UI Integration with AsyncRunnerListener

```dart
AsyncRunnerListener<AppError, void>(
  runner: deleteUser,
  listener: (context, state) {
    if (state.status.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted')),
      );
    }
    if (state.status.isFailure) {
      showErrorDialog(context, state.result!.error);
    }
  },
  child: YourWidget(),
)
```

### Reset State

```dart
// Reset to idle state
loadUsers.reset();
```

---

## 3. Fetcher - Local-First Data Fetching

`Fetcher` implements local-first architecture: show cached data immediately, then fetch fresh data.

### Setup

```dart
final usersFetcher = Fetcher<List<User>>(
  fetchRemote: () async {
    // Fetch from API (throws on error)
    final dto = await api.getUsers();
    return dto.map((e) => User.fromJson(e)).toList();
  },
  readLocal: () async {
    // Read from cache
    return await cache.getUsers();
  },
  writeLocal: (users) async {
    // Write to cache
    await cache.saveUsers(users);
  },
  log: logger, // Optional
);
```

### Strategy 1: localThenRemote (Recommended)

Shows cached data immediately, then updates with fresh data.

```dart
// Returns a stream with up to 2 emissions:
// 1. Local data (if available)
// 2. Remote data (always)
await for (final response in usersFetcher.localThenRemote()) {
  if (response.source == DataSource.local) {
    print('Showing cached data');
    displayUsers(response.data);
  } else {
    print('Showing fresh data');
    displayUsers(response.data);
  }
}
```

### Strategy 2: remoteOrLocal

Tries remote first, falls back to cache if remote fails.

```dart
final response = await usersFetcher.remoteOrLocal();
if (response.source == DataSource.local) {
  showWarning('Showing cached data (offline)');
}
displayUsers(response.data);
```

### Strategy 3: localOrRemote

Tries cache first, fetches remote only if cache is empty.

```dart
final response = await usersFetcher.localOrRemote();
displayUsers(response.data);
```

### Strategy 4: remote

Fetch only from remote (still caches result).

```dart
final users = await usersFetcher.remote();
displayUsers(users);
```

### Strategy 5: local

Read only from cache.

```dart
final users = await usersFetcher.local();
if (users != null) {
  displayUsers(users);
}
```

### Real-World Example: Repository Pattern

```dart
class UserRepository {
  final _fetcher = Fetcher<List<User>>(
    fetchRemote: () => api.getUsers(),
    readLocal: () => cache.getUsers(),
    writeLocal: (users) => cache.saveUsers(users),
  );

  // Wrap in Result.tryCatch at repository layer
  Stream<Result<AppError, FetcherResponse<List<User>>>> getUsers() {
    return _fetcher.localThenRemote().asyncMap((response) {
      return Result.tryCatch<AppError, FetcherResponse<List<User>>>(
        () => response,
      );
    });
  }
}

// Usage in ViewModel
await for (final result in userRepository.getUsers()) {
  result.map(
    (error) => handleError(error),
    (response) {
      if (response.source == DataSource.local) {
        showCachedIndicator();
      }
      updateUI(response.data);
    },
  );
}
```

### FetcherResponse

```dart
class FetcherResponse<R> {
  final R data;
  final DataSource source; // DataSource.local or DataSource.remote
}
```

---

## 4. Event System

Decoupled communication between modules using event bus.

### Define Events

```dart
class UserLoggedInEvent extends AppEvents<UserLoggedInEvent> {
  const UserLoggedInEvent(this.user);
  final User user;
}

class DataSyncedEvent extends AppEvents<DataSyncedEvent> {
  const DataSyncedEvent();
}
```

### Fire Events

```dart
// Fire event to all listeners
UserLoggedInEvent(currentUser).fire();

// Or using DI
DI().get<EventBus>().fire(UserLoggedInEvent(currentUser));
```

### Listen to Events

```dart
// Subscribe to specific event type
DI().get<EventBus>().on<UserLoggedInEvent>().listen((event) {
  print('User logged in: ${event.user.name}');
  loadUserData(event.user);
});

// Multiple listeners can subscribe to the same event
DI().get<EventBus>().on<DataSyncedEvent>().listen((event) {
  refreshUI();
});
```

### Real-World Example

```dart
// Module A: Authentication
class AuthService {
  Future<void> login(String email, String password) async {
    final user = await api.login(email, password);
    UserLoggedInEvent(user).fire(); // Notify other modules
  }
}

// Module B: Analytics (listens to auth events)
class AnalyticsService {
  void init() {
    DI().get<EventBus>().on<UserLoggedInEvent>().listen((event) {
      trackLoginEvent(event.user.id);
    });
  }
}

// Module C: Data Sync (also listens to auth events)
class SyncService {
  void init() {
    DI().get<EventBus>().on<UserLoggedInEvent>().listen((event) {
      syncUserData(event.user);
    });
  }
}
```

---

## 5. Core Interfaces

### Dependency Injection (DI)

```dart
// Setup (in main.dart)
DI.useAdapter = () => GetItAdapter(); // Your DI implementation

// Register services
DI().registerSingleton<Logger>(ConsoleLogger());
DI().registerLazySingleton<ApiClient>(() => ApiClient());
DI().registerSingletonAsync<Database>(() async => await Database.init());

// Resolve dependencies
final logger = DI().get<Logger>();
final api = DI().get<ApiClient>();
final db = await DI().getAsync<Database>();

// Check registration
if (DI().isRegistered<Logger>()) {
  print('Logger is registered');
}

// Reset (for testing)
await DI().reset();
```

### Logger

```dart
abstract class Logger {
  void debug(String msg, {Map<String, Object?>? extra});
  void info(String msg, {Map<String, Object?>? extra});
  void warn(String msg, {Map<String, Object?>? extra});
  void error(String msg, {Object? error, StackTrace? stack, Map<String, Object?>? extra});
  void exception(Object throwable, {StackTrace? stack, Map<String, Object?>? extra});
}

// Usage
final logger = DI().get<Logger>();
logger.info('User logged in', extra: {'userId': user.id});
logger.error('API call failed', error: exception, stack: stackTrace);
```

### Storage Interfaces

```dart
// Primitive types (bool, int, double, String, List<String>)
abstract class PrimitiveStore<T> {
  Future<T?> get();
  Future<void> set(T value);
  Future<void> delete();
}

// Complex objects
abstract class ObjectStore<T> {
  Future<T?> get();
  Future<void> set(T value);
  Future<void> delete();
}

// Key-value store
abstract class KVPrimitiveStore {
  Future<V?> get<V>(String key);
  Future<void> set<V>(String key, V value);
  Future<void> delete(String key);
}

// Usage example
class TokenStore extends PrimitiveStore<String> {
  @override
  Future<String?> get() => secureStorage.read(key: 'auth_token');
  
  @override
  Future<void> set(String value) => secureStorage.write(key: 'auth_token', value: value);
  
  @override
  Future<void> delete() => secureStorage.delete(key: 'auth_token');
}
```

### Time Service

```dart
abstract class TimeService {
  Future<DateTime> getTime();           // NTP-synced time
  Future<void> trackMidnight();         // Start tracking midnight
  Stream<void> get onMidnight;          // Emits at midnight
  Future<void> dispose();
}

// Usage
final timeService = DI().get<TimeService>();

// Get accurate time
final now = await timeService.getTime();

// Listen for midnight (for daily resets, streaks, etc.)
timeService.onMidnight.listen((_) {
  resetDailyData();
  checkStreaks();
});
```

---

## 6. Use Cases

Structured business logic that's independent of UI and data layers.

### Basic Use Case

```dart
class GetUserProfileUseCase extends UseCase<User> {
  const GetUserProfileUseCase(this.repository);
  final UserRepository repository;

  @override
  Future<User> call() async {
    return await repository.getCurrentUser();
  }
}

// Usage
final useCase = GetUserProfileUseCase(userRepository);
final user = await useCase();
```

### Use Case with Parameters

```dart
class UpdateUserNameUseCase extends UseCaseWithParams<void, String> {
  const UpdateUserNameUseCase(this.repository);
  final UserRepository repository;

  @override
  Future<void> call(String newName) async {
    await repository.updateName(newName);
  }
}

// Usage
final useCase = UpdateUserNameUseCase(userRepository);
await useCase('John Doe');
```

### Result-Based Use Case

```dart
class LoginUseCase extends ResultUseCaseWithParams<AppError, User, LoginParams> {
  const LoginUseCase(this.authRepository);
  final AuthRepository authRepository;

  @override
  Future<Result<AppError, User>> call(LoginParams params) async {
    return await authRepository.login(params.email, params.password);
  }
}

class LoginParams {
  const LoginParams(this.email, this.password);
  final String email;
  final String password;
}

// Usage
final useCase = LoginUseCase(authRepository);
final result = await useCase(LoginParams('user@example.com', 'password'));
result.map(
  (error) => showError(error),
  (user) => navigateToHome(user),
);
```

### Stream Use Case

```dart
class WatchUsersUseCase extends StreamUseCase<AppError, List<User>> {
  const WatchUsersUseCase(this.repository);
  final UserRepository repository;

  @override
  Stream<Result<AppError, List<User>>> call() {
    return repository.watchUsers();
  }
}

// Usage
final useCase = WatchUsersUseCase(userRepository);
await for (final result in useCase()) {
  result.map(
    (error) => showError(error),
    (users) => updateUI(users),
  );
}
```

---

## 7. Error Handling

### Error Hierarchy

```dart
class AppError implements Exception {
  const AppError({this.error, this.stackTrace});
  final Object? error;
  final StackTrace? stackTrace;
}

class InfrastructureError extends AppError {
  // Network, database, file system errors
}

class DomainError extends AppError {
  // Business logic errors
}

class PresentationError extends AppError {
  // UI-related errors
}

class UserVisibleError extends PresentationError {
  const UserVisibleError({this.message = 'An error occurred'});
  final String message;
}

class ValidationError extends PresentationError {
  const ValidationError({this.fields});
  final Map<String, String>? fields; // field -> error message
}

class DevicePermissionError extends InfrastructureError {
  const DevicePermissionError(this.permission);
  final String permission; // 'camera', 'location', etc.
}
```

### Usage

```dart
// Create errors
throw UserVisibleError(message: 'Invalid email address');
throw ValidationError(fields: {'email': 'Required', 'password': 'Too short'});
throw DevicePermissionError('camera');

// Convert any error to AppError
try {
  riskyOperation();
} catch (e, stack) {
  final appError = AppError.fromObject(e, stack);
  logger.error('Operation failed', error: appError);
}
```

---

## 8. Utilities

### Debouncer

```dart
final debouncer = Debouncer();

// Debounce synchronous callbacks
debouncer.debounce(
  duration: Duration(milliseconds: 500),
  onDebounce: () => searchUsers(query),
);

// Debounce async callbacks
await debouncer.debounceAsync(
  duration: Duration(milliseconds: 500),
  onDebounce: () async => await searchUsers(query),
);

// Cancel pending callbacks
debouncer.cancel();
```

### RunOnce

```dart
// Execute callback only once
final initOnce = RunOnce(() => initializeApp());
initOnce(); // Runs
initOnce(); // Ignored
initOnce(); // Ignored

// Check if already run
if (!initOnce.hasRun) {
  initOnce();
}

// Reset
initOnce.reset();
initOnce(); // Runs again

// Async version
final asyncInit = RunOnce.async(() async => await loadConfig());
await asyncInit();

// With arguments
final logOnce = RunOnceWithArg<String>((message) => print(message));
logOnce('Hello'); // Prints
logOnce('World'); // Ignored
```

### EqualityFilter

```dart
// Filter stream emissions by specific field
final filter = EqualityFilter<User>((user) => user.id);

// Returns true if IDs are different
filter(user1, user2); // true if user1.id != user2.id

// Use with streams
userStream.where((user) => filter(previousUser, user));
```

---

## 9. Configuration

```dart
enum Environment {
  dev,
  stg,
  prod;
}

abstract class AppConfig {
  Environment get env;
}

// Usage
class MyAppConfig implements AppConfig {
  @override
  final Environment env;
  
  MyAppConfig(this.env);
}

// Check environment
final config = DI().get<AppConfig>();
if (config.env.isDev) {
  enableDebugMode();
}
if (config.env.isProd) {
  enableAnalytics();
}

// Parse from string
final env = Environment.fromString('dev'); // Case-insensitive
```

---

## Architecture Guidelines

### DO ✅
- Use `Result` for all operations that can fail
- Wrap repository methods with `Result.tryCatch`
- Use `AsyncRunner` for UI-triggered async operations
- Use `Fetcher` for data that needs caching
- Define interfaces for external dependencies
- Keep business logic in use cases
- Use events for cross-module communication

### DON'T ❌
- Don't throw exceptions in domain/repository layer (use `Result`)
- Don't import Flutter in core entities
- Don't put UI logic in use cases
- Don't use concrete implementations (depend on interfaces)
- Don't mix presentation logic with domain logic

---

## Testing

```bash
flutter test
flutter test --coverage
```

### Example Test

```dart
test('Result.tryCatch returns data on success', () async {
  final result = await Result.tryCatch<Exception, int>(() => 42);
  
  expect(result.isData, isTrue);
  expect(result.data, equals(42));
});

test('Result.tryCatch returns error on exception', () async {
  final exception = Exception('Test error');
  final result = await Result.tryCatch<Exception, int>(() => throw exception);
  
  expect(result.isError, isTrue);
  expect(result.error, equals(exception));
});
```

---

## Dependencies

```yaml
dependencies:
  event_bus: ^2.0.1
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.0.0
  mocktail: ^1.0.4
```

---

## Complete Example: Feature Implementation

```dart
// 1. Define entity
class User {
  const User({required this.id, required this.name, required this.email});
  final String id;
  final String name;
  final String email;
}

// 2. Define repository interface
abstract class UserRepository {
  Stream<Result<AppError, FetcherResponse<List<User>>>> getUsers();
  Future<Result<AppError, void>> updateUser(User user);
}

// 3. Implement repository with Fetcher
class UserRepositoryImpl implements UserRepository {
  final _fetcher = Fetcher<List<User>>(
    fetchRemote: () => api.getUsers(),
    readLocal: () => cache.getUsers(),
    writeLocal: (users) => cache.saveUsers(users),
  );

  @override
  Stream<Result<AppError, FetcherResponse<List<User>>>> getUsers() {
    return _fetcher.localThenRemote().asyncMap((response) {
      return Result.tryCatch<AppError, FetcherResponse<List<User>>>(
        () => response,
      );
    });
  }

  @override
  Future<Result<AppError, void>> updateUser(User user) {
    return Result.tryCatch<AppError, void>(() async {
      await api.updateUser(user);
    });
  }
}

// 4. Create use case
class GetUsersUseCase extends StreamUseCase<AppError, FetcherResponse<List<User>>> {
  const GetUsersUseCase(this.repository);
  final UserRepository repository;

  @override
  Stream<Result<AppError, FetcherResponse<List<User>>>> call() {
    return repository.getUsers();
  }
}

// 5. Use in ViewModel
class UserViewModel {
  final getUsersUseCase = GetUsersUseCase(userRepository);
  late final loadUsers = AsyncRunner<AppError, void>(() async {
    await for (final result in getUsersUseCase()) {
      result.map(
        (error) => handleError(error),
        (response) => updateUsers(response.data),
      );
    }
  });

  void init() {
    loadUsers();
  }
}

// 6. Use in UI
AsyncRunnerBuilder<AppError, void>(
  runner: viewModel.loadUsers,
  builder: (context, state, child) {
    if (state.status.isRunning) return CircularProgressIndicator();
    if (state.status.isFailure) return ErrorWidget(state.result!.error);
    return UserList(users: viewModel.users);
  },
)
```

---

## Summary

This package provides:
- **Result**: Type-safe error handling
- **AsyncRunner**: Async state management
- **Fetcher**: Local-first data fetching
- **Events**: Decoupled module communication
- **Interfaces**: DI, logging, storage, time
- **Use Cases**: Structured business logic
- **Utilities**: Debouncer, RunOnce, EqualityFilter

All designed for clean architecture and testability.
