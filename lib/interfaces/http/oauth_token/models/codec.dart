import 'dart:convert';
import 'package:bootstrap/interfaces/http/oauth_token/models/oauth_token.dart';

/// Stable JSON codec for OAuthToken.
/// {
///   "access_token": "...",
///   "refresh_token": "...",
///   "token_type": "Bearer",
///   "expires_at": "2025-11-10T12:00:00Z",
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

    return OAuthToken(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String?,
      tokenType: (map['token_type'] as String?) ?? 'Bearer',
      expiresAt: map['expires_at'] != null
          ? DateTime.tryParse(map['expires_at'] as String)?.toUtc()
          : null,
      scopes: (map['scopes'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  String? toJson(OAuthToken? t) => t == null ? null : json.encode(encode(t));
  OAuthToken? fromJson(String? s) => s == null ? null : decode(s);
}
