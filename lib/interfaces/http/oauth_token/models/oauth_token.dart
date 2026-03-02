/// Minimal, dependency-free OAuth token model for the app.
class OAuthToken {
  const OAuthToken({
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresAt,
    this.scopes,
  });
  final String accessToken;
  final String? refreshToken;
  final String tokenType; // e.g. "Bearer"
  final DateTime? expiresAt; // optional absolute expiry
  final List<String>? scopes;

  bool get hasRefresh => (refreshToken ?? '').isNotEmpty;
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  String get authorization => '$tokenType $accessToken';

  OAuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    DateTime? expiresAt,
    List<String>? scopes,
  }) {
    return OAuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      scopes: scopes ?? this.scopes,
    );
  }
}
