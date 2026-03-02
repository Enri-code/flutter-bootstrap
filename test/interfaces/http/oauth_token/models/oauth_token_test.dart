import 'package:bootstrap/interfaces/http/oauth_token/models/oauth_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OAuthToken', () {
    test('creates instance with required accessToken only', () {
      const token = OAuthToken(accessToken: 'test-access-token');

      expect(token.accessToken, equals('test-access-token'));
      expect(token.refreshToken, isNull);
      expect(token.tokenType, equals('Bearer'));
      expect(token.expiresAt, isNull);
      expect(token.scopes, isNull);
    });

    test('creates instance with all fields', () {
      final expiresAt = DateTime(2025, 12, 31);
      final token = OAuthToken(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        expiresAt: expiresAt,
        scopes: ['read', 'write'],
      );

      expect(token.accessToken, equals('test-access-token'));
      expect(token.refreshToken, equals('test-refresh-token'));
      expect(token.tokenType, equals('Bearer'));
      expect(token.expiresAt, equals(expiresAt));
      expect(token.scopes, equals(['read', 'write']));
    });

    test('creates instance with custom tokenType', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        tokenType: 'CustomType',
      );

      expect(token.tokenType, equals('CustomType'));
    });

    test('hasRefresh returns true when refreshToken is present', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
      );

      expect(token.hasRefresh, isTrue);
    });

    test('hasRefresh returns false when refreshToken is null', () {
      const token = OAuthToken(accessToken: 'test-access-token');

      expect(token.hasRefresh, isFalse);
    });

    test('hasRefresh returns false when refreshToken is empty string', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        refreshToken: '',
      );

      expect(token.hasRefresh, isFalse);
    });

    test('isExpired returns false when expiresAt is null', () {
      const token = OAuthToken(accessToken: 'test-access-token');

      expect(token.isExpired, isFalse);
    });

    test('isExpired returns true when expiresAt is in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 1));
      final token = OAuthToken(
        accessToken: 'test-access-token',
        expiresAt: pastDate,
      );

      expect(token.isExpired, isTrue);
    });

    test('isExpired returns false when expiresAt is in the future', () {
      final futureDate = DateTime.now().add(const Duration(hours: 1));
      final token = OAuthToken(
        accessToken: 'test-access-token',
        expiresAt: futureDate,
      );

      expect(token.isExpired, isFalse);
    });

    test('isExpired returns true for current time edge case', () {
      // Set expiry to current time (already past)
      final now = DateTime.now();
      final token = OAuthToken(
        accessToken: 'test-access-token',
        expiresAt: now,
      );

      // Should be expired since DateTime.now() will be after the stored time
      expect(token.isExpired, isTrue);
    });

    test('copyWith creates new instance with updated accessToken', () {
      const original = OAuthToken(accessToken: 'original-access-token');

      final updated = original.copyWith(accessToken: 'new-access-token');

      expect(updated.accessToken, equals('new-access-token'));
      expect(updated.refreshToken, isNull);
      expect(updated.tokenType, equals('Bearer'));
    });

    test('copyWith creates new instance with updated refreshToken', () {
      const original = OAuthToken(
        accessToken: 'test-access-token',
        refreshToken: 'original-refresh-token',
      );

      final updated = original.copyWith(refreshToken: 'new-refresh-token');

      expect(updated.accessToken, equals('test-access-token'));
      expect(updated.refreshToken, equals('new-refresh-token'));
    });

    test('copyWith preserves all fields when no updates provided', () {
      final expiresAt = DateTime(2025, 12, 31);
      final original = OAuthToken(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        expiresAt: expiresAt,
        scopes: ['read', 'write'],
      );

      final copy = original.copyWith();

      expect(copy.accessToken, equals(original.accessToken));
      expect(copy.refreshToken, equals(original.refreshToken));
      expect(copy.tokenType, equals(original.tokenType));
      expect(copy.expiresAt, equals(original.expiresAt));
      expect(copy.scopes, equals(original.scopes));
    });

    test('copyWith can update all fields', () {
      final oldExpiry = DateTime(2025, 6);
      final newExpiry = DateTime(2026, 6);

      final original = OAuthToken(
        accessToken: 'old-access-token',
        refreshToken: 'old-refresh-token',
        expiresAt: oldExpiry,
        scopes: ['read'],
      );

      final updated = original.copyWith(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        tokenType: 'CustomBearer',
        expiresAt: newExpiry,
        scopes: ['read', 'write', 'admin'],
      );

      expect(updated.accessToken, equals('new-access-token'));
      expect(updated.refreshToken, equals('new-refresh-token'));
      expect(updated.tokenType, equals('CustomBearer'));
      expect(updated.expiresAt, equals(newExpiry));
      expect(updated.scopes, equals(['read', 'write', 'admin']));
    });

    test('supports empty scopes list', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        scopes: [],
      );

      expect(token.scopes, equals([]));
      expect(token.scopes, isEmpty);
    });

    test('supports single scope', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        scopes: ['read'],
      );

      expect(token.scopes, equals(['read']));
      expect(token.scopes?.length, equals(1));
    });

    test('supports multiple scopes', () {
      const token = OAuthToken(
        accessToken: 'test-access-token',
        scopes: ['read', 'write', 'admin', 'delete'],
      );

      expect(token.scopes, equals(['read', 'write', 'admin', 'delete']));
      expect(token.scopes?.length, equals(4));
    });

    test('handles long-lived token without expiry', () {
      const token = OAuthToken(
        accessToken: 'long-lived-token',
        refreshToken: 'long-lived-refresh',
      );

      expect(token.expiresAt, isNull);
      expect(token.isExpired, isFalse);
      expect(token.hasRefresh, isTrue);
    });

    test('handles short-lived token with expiry', () {
      final expiresAt = DateTime.now().add(const Duration(minutes: 15));
      final token = OAuthToken(
        accessToken: 'short-lived-token',
        expiresAt: expiresAt,
      );

      expect(token.expiresAt, isNotNull);
      expect(token.isExpired, isFalse);
      expect(token.hasRefresh, isFalse);
    });

    test('copyWith can add refreshToken to token without one', () {
      const original = OAuthToken(accessToken: 'test-access-token');

      final updated = original.copyWith(refreshToken: 'new-refresh-token');

      expect(original.hasRefresh, isFalse);
      expect(updated.hasRefresh, isTrue);
      expect(updated.refreshToken, equals('new-refresh-token'));
    });

    test('copyWith can update expiry to extend token lifetime', () {
      final oldExpiry = DateTime.now().add(const Duration(minutes: 5));
      final newExpiry = DateTime.now().add(const Duration(hours: 1));

      final original = OAuthToken(
        accessToken: 'test-access-token',
        expiresAt: oldExpiry,
      );

      final updated = original.copyWith(expiresAt: newExpiry);

      expect(updated.expiresAt, equals(newExpiry));
      expect(updated.isExpired, isFalse);
    });
  });
}
