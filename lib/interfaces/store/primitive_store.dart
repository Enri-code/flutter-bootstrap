// ignore_for_file: switch_on_type

import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class KVPrimitiveStore {
  Future<V?> get<V>(String key);
  Future<void> set<V>(String key, V value);
  Future<void> delete(String key);

  @protected
  void assertIsPrimitive(Type type) => _assertIsPrimitive(type);
}

abstract class KVObjectStore<ObjectType> {
  Future<ObjectType?> get(String key);
  Future<void> set(String key, ObjectType value);
  Future<void> delete(String key);
}

abstract class PrimitiveStore<ObjectType> {
  PrimitiveStore() {
    _assertIsPrimitive(ObjectType);
  }

  Future<ObjectType?> get();
  Future<void> set(ObjectType value);
  Future<void> delete();
}

abstract class ObjectStore<ObjectType> {
  Future<ObjectType?> get();
  Future<void> set(ObjectType value);
  Future<void> delete();
}

void _assertIsPrimitive(Type type) {
  if (switch (type) {
    const (bool) => true,
    const (int) => true,
    const (double) => true,
    const (String) => true,
    const (List<String>) => true,
    _ => false,
  }) {
    return;
  }
  throw ArgumentError(
    '<ObjectType> must be a primitive [bool, int, double, String], '
    'or a List<String>',
  );
}
