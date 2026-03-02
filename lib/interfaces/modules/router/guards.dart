import 'dart:async';
import 'package:flutter/widgets.dart';

/// Generic route guard interface.
abstract class RouteGuard {
  /// Returns a redirect path (absolute) if navigation should be blocked.
  /// Return `null` to allow navigation.
  FutureOr<String?> redirect(BuildContext context, String? from);
}

class RedirectGuard implements RouteGuard {
  const RedirectGuard(this.to, {this.from});
  final String to;
  final String? from;

  @override
  Future<String?> redirect(BuildContext context, String? path) async {
    return (from == null || path == from) ? to : null;
  }
}

/// Composite guard that runs a list of guards in order.
class CompositeGuard implements RouteGuard {
  const CompositeGuard(this._guards);
  final Iterable<RouteGuard> _guards;

  @override
  Future<String?> redirect(BuildContext context, String? from) async {
    for (final g in _guards) {
      final r = await g.redirect(context, from);
      if (r != null) return r;
    }
    return null;
  }
}
