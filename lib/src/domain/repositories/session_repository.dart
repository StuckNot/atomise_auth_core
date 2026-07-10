import 'package:fpdart/fpdart.dart';

import '../entities/auth_session.dart';
import '../failures/auth_failure.dart';

/// Mechanism-agnostic: refreshing and ending a session works the same way
/// regardless of how it was acquired (OTP, password, Google, ...). Shared
/// across every login mode rather than duplicated per mechanism.
abstract class SessionRepository {
  Future<Either<AuthFailure, AuthSession>> refresh();

  Future<Either<AuthFailure, Unit>> logout();
}
