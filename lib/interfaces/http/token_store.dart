import 'package:bootstrap/interfaces/http/oauth_token/models/oauth_token.dart';

abstract class TokenStore {
  Future<OAuthToken?> read();
  Future<void> write(OAuthToken token);
  Future<void> delete();
}
