import 'package:fpdart/fpdart.dart';

import '../failures/auth_failure.dart';
import '../repositories/session_repository.dart';
import '../storage/token_storage.dart';

class Logout {
  Logout(this._repository, this._tokenStorage);

  final SessionRepository _repository;
  final TokenStorage _tokenStorage;

  /// Clears local storage regardless of whether the backend call succeeds —
  /// the user's intent to log out should hold even if offline.
  Future<Either<AuthFailure, Unit>> call() async {
    final result = await _repository.logout();
    await _tokenStorage.clear();
    return result;
  }
}
