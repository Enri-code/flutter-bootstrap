import 'dart:convert';
import 'package:bootstrap/interfaces/http/oauth_token/models/oauth_token.dart';

/// Stable JSON codec for OAuthToken.
/// {
///   "access_token": "...",
///   "refresh_token": "...",
///   "token_type": "Bearer",
///   "expires_in": 86400,  // seconds
///   "scopes": ["profile","email"]
/// }
final class OAuthTokenCodec {
  const OAuthTokenCodec();

  Map<String, dynamic> encode(OAuthToken? t) => t == null
      ? {}
      : {
          'access_token': t.accessToken,
          if (t.refreshToken != null) 'refresh_token': t.refreshToken,
          'token_type': t.tokenType,
          if (t.expiresAt != null)
            'expires_at': t.expiresAt!.toUtc().toIso8601String(),
          if (t.scopes != null && t.scopes!.isNotEmpty) 'scopes': t.scopes,
        };

  OAuthToken? decode(dynamic source) {
    if (source == null) return null;

    final map = source is String
        ? json.decode(source) as Map<String, dynamic>
        : source as Map<String, dynamic>;

    // Calculate expiresAt from expires_in (seconds)
    DateTime? expiresAt;
    if (map['expires_in'] != null) {
      final expiresInSeconds = map['expires_in'] as int;
      expiresAt = DateTime.now().add(Duration(seconds: expiresInSeconds));
    }

    return OAuthToken(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String?,
      tokenType: (map['token_type'] as String?) ?? 'Bearer',
      expiresAt: expiresAt,
      scopes: (map['scopes'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  String? toJson(OAuthToken? t) => t == null ? null : json.encode(encode(t));
  OAuthToken? fromJson(String? s) => s == null ? null : decode(s);
}
