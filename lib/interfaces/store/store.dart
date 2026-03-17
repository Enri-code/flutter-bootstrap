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

abstract class StreamableKVPrimitiveStore extends KVPrimitiveStore {
  Stream<V?> watch<V>(String key);
  void dispose();
}

abstract class StreamableKVObjectStore<ObjectType>
    extends KVObjectStore<ObjectType> {
  Stream<ObjectType?> watch(String key);
  void dispose();
}

abstract class StreamablePrimitiveStore<ObjectType>
    extends PrimitiveStore<ObjectType> {
  Stream<ObjectType?> watch();
  void dispose();
}

abstract class StreamableObjectStore<ObjectType>
    extends ObjectStore<ObjectType> {
  Stream<ObjectType?> watch();
  void dispose();
}

void _assertIsPrimitive(Type type) {
  switch (type) {
    case (const (bool)):
    case (const (int)):
    case (const (double)):
    case (const (String)):
    case (const (List<String>)):
      return;
    default:
      throw ArgumentError(
        '<ObjectType> must be a primitive [bool, int, double, String], '
        'or a List<String>',
      );
  }
}
