import 'package:bootstrap/core.dart';
import 'package:event_bus/event_bus.dart';

abstract class AppEvents<E extends AppEvents<E>> {
  const AppEvents();

  void fire() => DI().get<EventBus>().fire(this);
}
