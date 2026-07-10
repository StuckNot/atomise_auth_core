import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/storage/token_storage.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

/// App-wide session status, sourced from [TokenStorage]. Call
/// [checkInitialSession] once at startup (e.g. before showing the first
/// route) to resolve [AuthState.unknown] into authenticated/unauthenticated.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required TokenStorage tokenStorage, required Logout logout})
      : _tokenStorage = tokenStorage,
        _logout = logout,
        super(const AuthState.unknown());

  final TokenStorage _tokenStorage;
  final Logout _logout;

  Future<void> checkInitialSession() async {
    final session = await _tokenStorage.read();
    emit(
      session == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(session),
    );
  }

  Future<void> signOut() async {
    await _logout();
    emit(const AuthState.unauthenticated());
  }
}
