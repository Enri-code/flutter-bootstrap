# Changelog

All notable changes to the Bootstrap package will be documented in this file.

## 0.0.2

### Added
- `RunOnce.withArg` static function to return `RunOnceWithArg`

## 0.0.1

### Core Definitions
- **Result Type**: Type-safe error handling with `Result<Error, Data>`
  - `Result.data()` and `Result.error()` constructors
  - `Result.tryCatch()` for wrapping throwing code
  - `map()` for pattern matching
  - `when()` for optional handling
  - `throwOrReturn()` extension
- **AppError Hierarchy**: Structured error types
  - `AppError` base class
  - `InfrastructureError`, `DomainError`, `PresentationError`
  - `UserVisibleError`, `ValidationError`, `DevicePermissionError`
- **Use Cases**: Business logic patterns
  - `UseCase<Response>`
  - `UseCaseWithParams<Response, Params>`
  - `ResultUseCase<Failure, Success>`
  - `ResultUseCaseWithParams<Failure, Success, Params>`
  - `StreamUseCase<Failure, Success>`
  - `StreamUseCaseWithParams<Failure, Success, Params>`
- **App Events**: Event bus integration with `AppEvents<T>` base class
- **Configuration**: Environment management with `Environment` enum and `AppConfig`
- **Type Definitions**: Common type aliases

### Services
- **AsyncRunner**: Async operation state management
  - `AsyncRunner<E, R>` for basic operations
  - `AsyncRunner.withArg<A, E, R>` for parameterized operations
  - `RunAsyncStatus` enum (idle, running, success, failure)
  - `AsyncRunnerBuilder` widget for UI integration
  - `AsyncRunnerListener` widget for side effects
  - `MultiAsyncRunnersListener` for multiple runners
- **Fetcher**: Local-first data fetching
  - `localThenRemote()` strategy
  - `remoteOrLocal()` strategy
  - `localOrRemote()` strategy
  - `remote()` and `local()` methods
  - `FetcherResponse<R>` with `DataSource` enum
- **Debouncer**: Debounce callbacks
  - `debounce()` for sync callbacks
  - `debounceAsync()` for async callbacks
  - `cancel()` method
- **RunOnce**: Execute callbacks once
  - `RunOnce` for sync callbacks
  - `RunOnce.async()` for async callbacks
  - `RunOnceWithArg<T>` for parameterized callbacks
- **EqualityFilter**: Filter stream emissions by field equality
- **Pagination**: Pagination utilities
  - `PageParams` with `nextPage()` and `firstPage()`
  - `PaginationMeta` with `hasMore`, `totalPages`, `nextPage`

### Interfaces
- **DI**: Dependency injection abstraction
  - `registerSingleton<T>()`
  - `registerLazySingleton<T>()`
  - `registerSingletonAsync<T>()`
  - `get<T>()`, `getAsync<T>()`, `maybeGet<T>()`
  - `isRegistered<T>()`, `reset()`
- **Logger**: Logging interface
  - `debug()`, `info()`, `warn()`, `error()`, `exception()`
- **PerformanceLogger**: Performance tracking
  - `start()` returns `PerformanceTimer`
  - `NoOpPerformanceLogger` implementation
- **Storage**: Storage abstractions
  - `PrimitiveStore<T>` for primitives
  - `ObjectStore<T>` for complex objects
  - `KVPrimitiveStore` for key-value primitives
  - `KVObjectStore<T>` for key-value objects
- **TimeService**: Time management
  - `getTime()` for NTP-synced time
  - `trackMidnight()` and `onMidnight` stream
- **Connectivity**: Network connectivity
  - `IConnectivityService` with `isConnected` and `onConnectivityChanged`
- **Deep Links**: Deep link handling
  - `DeepLinkHandler<T>` abstract class
  - `DeepLinkHandlerResult<T>` with pattern matching
  - `DeepLinkRouter` for managing handlers
- **HTTP**: OAuth token management
  - `OAuthToken` model
  - `OAuthTokenCodec` for JSON serialization
  - `TokenStore` interface
- **Modules**: Modular architecture
  - `Module<RouteType>` base class
  - `ModuleRoutes<RouteType>` interface
  - `ModuleStartup<T>` for initialization
  - `ModuleFactory` for module management
  - `RouterFactory` for router creation
  - `RouteGuard`, `RedirectGuard`, `CompositeGuard`
- **Notifications**: Local notifications
  - `Notifications` abstract class
  - `NotificationData` model
  - `NotificationSchedule` (Now, At, Daily, Weekly, Interval)
  - `NotificationEvent` enum
- **Queue**: Task queue system
  - `QueueTask` base class
  - `QueueTaskHandler<T>` interface
  - `QueueTaskRegistry` for handler registration
  - `BaseQueueRunner<T>` abstract runner
  - `NetworkQueueManager` for network tasks
- **Toast**: Toast notifications
  - `IToastService` interface
  - `ToastServiceProvider` widget

### Extensions
- **Result Extensions**: `throwOrReturn()` method
- **String Extensions**: 
  - `capitalizeFirst()`
  - `pluralize()`
  - `trimMiddle()`
  - `firstAndL()`
- **Iterable Extensions**: `flatten()` for nested iterables
- **Color Filter**: `SrcInColorFilter` for blend modes
- **Context Extensions**: `renderBoxRect` for positioning

### Dependencies
- `event_bus: ^2.0.1`
- `flutter: sdk`

### Dev Dependencies
- `flutter_test: sdk`
- `very_good_analysis: ^10.0.0`
- `mocktail: ^1.0.4`
