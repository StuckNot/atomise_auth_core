import 'package:fpdart/fpdart.dart';

import '../entities/auth_session.dart';
import '../failures/auth_failure.dart';
import '../repositories/session_repository.dart';
import '../storage/token_storage.dart';

class RefreshSession {
  RefreshSession(this._repository, this._tokenStorage);

  final SessionRepository _repository;
  final TokenStorage _tokenStorage;

  Future<Either<AuthFailure, AuthSession>> call() async {
    final result = await _repository.refresh();
    await result.match(
      (_) => Future<void>.value(),
      (session) => _tokenStorage.save(session),
    );
    return result;
  }
}
