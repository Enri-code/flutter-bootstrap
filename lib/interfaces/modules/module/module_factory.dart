import 'package:bootstrap/core.dart';
import 'package:bootstrap/interfaces/modules/module/module.dart';
import 'package:bootstrap/interfaces/modules/router/router_factory.dart';
import 'package:flutter/widgets.dart';

final class ModuleFactory<RouteType, RouterType extends RouterConfig<Object>> {
  ModuleFactory({
    required this.injector,
    required this.routerFactory,
    required this.modules,
  });
  final DI injector;
  final RouterFactory<RouteType, RouterType> routerFactory;
  final List<Module<RouteType>> modules;

  RouterType get routerConfig => routerFactory.buildRouter(modules);

  void registerServices() {
    for (final module in modules) {
      module.registerServices(injector);
    }
  }
}
