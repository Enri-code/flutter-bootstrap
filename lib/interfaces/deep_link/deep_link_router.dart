import 'package:bootstrap/interfaces/deep_link/deep_link_handler.dart';
import 'package:flutter/material.dart';

/// Router that manages multiple deep link handlers by priority
class DeepLinkRouter {
  DeepLinkRouter({List<DeepLinkHandler<dynamic>>? handlers})
    : _handlers = handlers ?? [];

  final List<DeepLinkHandler<dynamic>> _handlers;

  /// Register a new deep link handler
  void register(DeepLinkHandler<dynamic> handler) {
    _handlers
      ..add(handler)
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Handle a deep link by finding the appropriate handler
  Future<bool> handle(BuildContext context, Uri uri) async {
    for (final handler in _handlers) {
      if (handler.canHandle(uri)) {
        final result = await handler.handle(context, uri);
        return result.maybeWhen(
          orElse: () => false,
          success: (_) => true,
          redirect: (_) => true,
        );
      }
    }
    return false;
  }

  /// Get all registered handlers
  List<DeepLinkHandler<dynamic>> get handlers => List.unmodifiable(_handlers);
}
