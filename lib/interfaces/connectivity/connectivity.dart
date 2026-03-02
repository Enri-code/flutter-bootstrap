import 'dart:async';

/// Abstract contract for Connectivity.
abstract class IConnectivityService {
  bool get isConnected;
  Stream<bool> get onConnectivityChanged;
}
