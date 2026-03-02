import 'package:flutter/material.dart';

extension StringExtensions on String {
  String capitalizeFirst() => '${this[0].toUpperCase()}${substring(1)}';
  String pluralize({int? count, bool force = false}) {
    if ((count == null || count == 1) && !force) return this;
    return characters.last.toLowerCase() == 's' ? this : '${this}s';
  }

  String trimMiddle(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;

    // Calculate characters to show on each side
    final charsToShow = (maxLength - ellipsis.length) ~/ 2;
    final startLength = charsToShow;
    final endLength = maxLength - startLength - ellipsis.length;

    final start = substring(0, startLength);
    final end = substring(length - endLength, length);

    return '$start$ellipsis$end';
  }

  String firstAndL() {
    final parts = split(' ');
    if (parts.length < 2) return this;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }
}
