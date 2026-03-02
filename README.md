# Core Package

Foundation package for the BGYCC mobile app, providing core domain entities, interfaces, utilities, and shared business logic.

## Purpose

The core package contains:
- Domain entities (pure Dart, no Flutter dependencies)
- Core interfaces and abstractions
- Result types and error handling
- Domain events system
- Shared utilities and helpers

## Features

### Domain Entities
- `User` - User data model
- `BadgeData` - Badge/achievement data
- `Cycle` - Learning cycle information
- `Club` - Club/community data

### Result Type
Type-safe error handling:

```dart
typedef Result<E, T> = Either<E, T>;

// Usage
Result<AppError, User> getUser() {
  try {
    final user = fetchUser();
    return Result.data(user);
  } catch (e) {
    return Result.error(AppError.fromException(e));
  }
}

// Pattern matching
result.map(
  (error) => handleError(error),
  (user) => displayUser(user),
);
```

### Domain Events

Event-driven communication between modules:

```dart
// Define event
class UserUpdatedEvent extends AppEvents<UserUpdatedEvent> {
  const UserUpdatedEvent(this.user);
  final MyUserData user;
}

// Fire event
eventBus.fire(UserUpdatedEvent(user));

// Listen to event
eventBus.on<UserUpdatedEvent>().listen((event) {
  handleUserUpdate(event.user);
});
```

### AsyncRunner

Manage async operations with loading states:

```dart
late final loadData = AsyncRunner<AppError, List<Item>>(() async {
  final items = await repository.fetchItems();
  return items;
});

// Execute
await loadData();

// Check status
if (loadData.status.isSuccess) {
  final items = loadData.result;
}

// With argument
late final saveItem = AsyncRunner.withArg<Item, AppError, void>((item) async {
  await repository.save(item);
});

await saveItem(myItem);
```

### Fetcher

Local-first data fetching with caching. Fetcher methods throw errors that should be caught at the repository layer using `Result.tryCatch`:

```dart
// Repository layer - wrap with Result.tryCatch
final fetcher = Fetcher<List<Item>>(
  fetchRemote: () async {
    // Just return data or throw errors
    final dto = await api.getItems();
    return dto.toDomain();
  },
  readLocal: () => cache.get(),
  writeLocal: (data) => cache.set(data),
);

// Local then remote - wrap in Result.tryCatch at repository layer
Stream<Result<MyError, FetcherResponse<List<Item>>>> localThenRemote() {
  return fetcher.localThenRemote().asyncMap((response) {
    return Result.tryCatch<MyError, FetcherResponse<List<Item>>>(
      () => response,
    );
  });
}

// Presentation layer - use result.map()
await for (final result in repository.localThenRemote()) {
  result.map(
    (error) => handleError(error),
    (response) {
      if (response.source == DataSource.local) {
        showCachedData(response.data);
      } else {
        showFreshData(response.data);
      }
    },
  );
}
```

### Interfaces

Core abstractions:

```dart
// Dependency Injection
abstract class DI {
  T get<T extends Object>();
  void register<T extends Object>(T instance);
}

// Logging
abstract class Logger {
  void info(String message);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  void warn(String message);
}

// Storage
abstract class ObjectStore<T> {
  Future<T?> get();
  Future<void> set(T value);
  Future<void> delete();
}

// Time Service
abstract class TimeService {
  DateTime get now;
  Stream<void> get onMidnight;
  Future<void> trackMidnight();
}
```

## Architecture

```
lib/
├── definitions/
│   ├── app_error.dart       # Base error types
│   ├── app_event.dart       # Event system
│   └── result.dart          # Result type
├── entities/
│   ├── user.dart            # User entity
│   ├── badge_data.dart      # Badge entity
│   └── cycle.dart           # Cycle entity
├── interfaces/
│   ├── di/                  # Dependency injection
│   ├── logger/              # Logging interface
│   ├── store/               # Storage interfaces
│   └── time/                # Time service
├── utils/
│   ├── async_runner.dart    # Async operation manager
│   ├── fetcher.dart         # Data fetching utility
│   └── extensions/          # Dart extensions
└── usecases/
    └── log_out_uc.dart      # Shared use cases
```

## Usage

### Add Dependency

```yaml
dependencies:
  bootstrap:
    path: ../packages/bootstrap
```

### Import

```dart
import 'package:bootstrap/core.dart';
import 'package:bootstrap/entities/user.dart';
import 'package:bootstrap/definitions/result.dart';
import 'package:bootstrap/utils/async_runner.dart';
```

## Testing

```bash
# Run tests
flutter test

# With coverage
flutter test --coverage
```

### Test Coverage

- \u2705 Entity tests
- \u2705 Result type tests
- \u2705 AsyncRunner tests
- \u2705 Fetcher tests
- \u2705 Extension tests

## Best Practices

### DO
- \u2705 Keep entities pure (no Flutter dependencies)
- \u2705 Use Result type for error handling
- \u2705 Define interfaces for external dependencies
- \u2705 Use domain events for cross-module communication
- \u2705 Keep business logic in use cases

### DON'T
- \u274c Import Flutter in core package
- \u274c Put UI logic in entities
- \u274c Use concrete implementations (use interfaces)
- \u274c Throw exceptions without wrapping in Result
- \u274c Mix presentation logic with domain logic

## Dependencies

- `freezed` - Immutable data classes
- `json_annotation` - JSON serialization
- `event_bus` - Event system
- `either_dart` - Result type

## Examples

### Creating an Entity

```dart
@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required bool isCompleted,
    DateTime? completedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
```

### Using Result Type

```dart
Future<Result<AppError, User>> login(String email, String password) async {
  try {
    final user = await authService.login(email, password);
    return Result.data(user);
  } on NetworkException catch (e) {
    return Result.error(AppError.network(e.message));
  } on AuthException catch (e) {
    return Result.error(AppError.auth(e.message));
  }
}
```

### Domain Event

```dart
// Define
class TaskCompletedEvent extends AppEvents<TaskCompletedEvent> {
  const TaskCompletedEvent(this.taskId);
  final String taskId;
}

// Fire
eventBus.fire(TaskCompletedEvent('task-123'));

// Listen
eventBus.on<TaskCompletedEvent>().listen((event) {
  print('Task ${event.taskId} completed');
});
```

## Contributing

When adding new features to bootstrap:

1. Ensure no Flutter dependencies
2. Add comprehensive tests
3. Update this README
4. Follow Clean Architecture principles
5. Use JsonSerealizable for data classes
