// Types-only barrel (no get_it). Imported by UI / feature code; the
// composition root imports `atomise_auth_core_di.dart` instead, which re-exports
// this file plus the DI registration.

// mapNetworkFailureToAuthFailure — the app's repository adapters call this at
// the data boundary to turn atomise_network's NetworkFailure into AuthFailure.
export 'src/data/mappers/network_failure_mapper.dart';

// AuthInterceptor — the composition root drops `sl<AuthInterceptor>()` into
// buildChopperClient's interceptors to get token attachment + 401 refresh.
export 'src/data/interceptors/auth_interceptor.dart';

// AuthSession — the session (access + refresh tokens) the app reads and that
// method packages produce on login.
export 'src/domain/entities/auth_session.dart';

// AuthFailure — the single failure type the UI maps to messages and that
// repository adapters return across the domain boundary.
export 'src/domain/failures/auth_failure.dart';

// SessionRepository — interface the app implements as its backend adapter
// (refresh / logout) and registers in get_it.
export 'src/domain/repositories/session_repository.dart';

// TokenStorage — interface the app implements (e.g. secure_storage) and
// registers; also the single surface any package reads the token from.
export 'src/domain/storage/token_storage.dart';

// Logout — session use case, wired into AuthCubit.signOut() internally.
// Exported only for apps that need to invoke it directly; otherwise a
// candidate to drop from the public surface.
export 'src/domain/usecases/logout.dart';

// RefreshSession — session use case, wired into the interceptor's
// onUnauthorized internally. Exported only for apps that want a manual
// "refresh now"; otherwise a candidate to drop from the public surface.
export 'src/domain/usecases/refresh_session.dart';

// AuthCubit — app-wide session guardian the app provides to its widget tree.
export 'src/presentation/cubits/auth_cubit.dart';

// AuthState — unknown / authenticated / unauthenticated; the states the app
// switches on to pick its first route.
export 'src/presentation/cubits/auth_state.dart';
