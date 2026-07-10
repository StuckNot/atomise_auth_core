import '../entities/auth_session.dart';

/// Single source of truth for the persisted session. Implemented by the
/// consuming app (e.g. backed by secure_storage) and registered in get_it.
abstract interface class TokenStorage {
  Future<void> save(AuthSession session);
  Future<AuthSession?> read();
  Future<String?> readAccessToken();
  Future<void> clear();
}
