import 'package:bootstrap/interfaces/modules/module/module.dart';
import 'package:flutter/widgets.dart';

abstract class RouterFactory<
  RouteType,
  RouterType extends RouterConfig<Object>
> {
  RouterType buildRouter(List<ModuleRoutes<RouteType>> modules);
}
