// packages/bootstrap/lib/modules/module.dart

import 'package:bootstrap/interfaces/di/di.dart';

/// A feature module. Implement this in each module package.
abstract class Module<RouteType> implements ModuleRoutes<RouteType> {
  const Module();

  void registerServices(DI injector) {}
}

abstract class ModuleRoutes<RouteType> {
  const ModuleRoutes();
  Set<RouteType> get routes;
}

abstract class ModuleStartup<T> {
  const ModuleStartup();

  /// Initialize the module and return a [ModuleRouteResponse] to indicate
  /// the initial route of the module.
  ///
  /// Return null if user should be navigated to Auth
  Future<T?> initialize();
}

class ModuleRouteResponse {
  const ModuleRouteResponse(this.route, [this.extra]);

  final String route;
  final dynamic extra;
}
