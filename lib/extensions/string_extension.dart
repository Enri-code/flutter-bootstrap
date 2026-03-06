import 'package:flutter/material.dart';

/// Extension methods for [String] manipulation.
extension StringExtensions on String {
  /// Capitalizes the first character of the string.
  ///
  /// Example: 'hello' -> 'Hello'
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Adds an 's' to the end of the string for pluralization.
  ///
  /// - If [count] is 1, returns the original string (unless [force] is true).
  /// - Skips adding 's' if the string already ends with 's'.
  ///
  /// Example:
  /// ```dart
  /// 'item'.pluralize(count: 1); // 'item'
  /// 'item'.pluralize(count: 5); // 'items'
  /// 'class'.pluralize(count: 5); // 'class' (already ends with 's')
  /// ```
  String pluralize({int? count, bool force = false}) {
    if ((count == null || count == 1) && !force) return this;
    return characters.last.toLowerCase() == 's' ? this : '${this}s';
  }

  /// Trims the middle of a long string and replaces it with an ellipsis.
  ///
  /// Keeps characters from the start and end, useful for displaying
  /// long file paths or IDs in limited space.
  ///
  /// Example:
  /// ```dart
  /// 'very_long_filename_that_needs_trimming.txt'.trimMiddle(20)
  /// // 'very_lon...ming.txt'
  /// ```
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

  /// Converts a full name to "FirstName L." format.
  ///
  /// Example: 'John Doe' -> 'John D.'
  String firstAndL() {
    final parts = split(' ');
    if (parts.length < 2) return this;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }
}
