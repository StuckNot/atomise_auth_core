import 'package:get_it/get_it.dart';

import '../data/interceptors/auth_interceptor.dart';
import '../domain/storage/token_storage.dart';
import '../domain/usecases/logout.dart';
import '../domain/usecases/refresh_session.dart';
import '../presentation/cubits/auth_cubit.dart';

/// Wires the session lifecycle (refresh, logout, app-wide AuthCubit) on top
/// of a SessionRepository and TokenStorage that the consuming app must
/// already have registered — those are backend/storage-specific and stay
/// the app's responsibility.
///
/// Auth-method slices (e.g. atomise_auth_otp) register their own use cases
/// and blocs via their own module, called after this one.
void registerAuthModule(GetIt getIt) {
  getIt
    ..registerFactory(() => RefreshSession(getIt(), getIt()))
    ..registerLazySingleton(
      () => AuthInterceptor(
        tokenStorage: getIt<TokenStorage>(),
        onUnauthorized: () =>
            getIt<RefreshSession>().call().then((r) => r.isRight()),
      ),
    )
    ..registerFactory(() => Logout(getIt(), getIt()))
    ..registerLazySingleton(
      () => AuthCubit(tokenStorage: getIt(), logout: getIt()),
    );
}
