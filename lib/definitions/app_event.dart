import 'package:bootstrap/core.dart';
import 'package:event_bus/event_bus.dart';

/// Base class for all application events.
///
/// Events extending this class can be fired to the application's event bus
/// and listened to by other parts of the application.
///
/// Example:
/// ```dart
/// class UserLoggedInEvent extends AppEvents<UserLoggedInEvent> {
///   const UserLoggedInEvent(this.userId);
///   final String userId;
/// }
///
/// // Fire the event
/// UserLoggedInEvent('user123').fire();
///
/// // Listen to the event
/// DI().get<EventBus>().on<UserLoggedInEvent>().listen((event) {
///   print('User logged in: ${event.userId}');
/// });
/// ```
abstract class AppEvents<E extends AppEvents<E>> {
  const AppEvents();

  /// Fires this event to the application's event bus.
  /// Requires an [EventBus] instance to be registered in the DI container.
  void fire() => DI().get<EventBus>()..fire(this);
}
