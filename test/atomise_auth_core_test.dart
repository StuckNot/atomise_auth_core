import 'package:atomise_auth_core/atomise_auth_core.dart';
import 'package:railway_chopper/railway_chopper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockSessionRepository extends Mock implements SessionRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLogout extends Mock implements Logout {}

const _session = AuthSession(accessToken: 'access', refreshToken: 'refresh');

void main() {
  setUpAll(() {
    registerFallbackValue(const AuthSession(accessToken: '', refreshToken: ''));
  });

  group('mapNetworkFailureToAuthFailure', () {
    test('network -> network', () {
      expect(
        mapNetworkFailureToAuthFailure(const NetworkFailure.network()),
        const AuthFailure.network(),
      );
    });

    test('timeout -> network', () {
      expect(
        mapNetworkFailureToAuthFailure(const NetworkFailure.timeout()),
        const AuthFailure.network(),
      );
    });

    test('unauthorized (401) -> sessionExpired', () {
      expect(
        mapNetworkFailureToAuthFailure(const NetworkFailure.unauthorized()),
        const AuthFailure.sessionExpired(),
      );
    });

    test('server -> server preserving the status code', () {
      expect(
        mapNetworkFailureToAuthFailure(
          const NetworkFailure.server(statusCode: 500),
        ),
        const AuthFailure.server(statusCode: 500),
      );
    });

    test('clientError (4xx) -> client preserving the status code', () {
      expect(
        mapNetworkFailureToAuthFailure(
          const NetworkFailure.clientError(statusCode: 400),
        ),
        const AuthFailure.client(statusCode: 400),
      );
    });

    test('unknown -> unknown preserving the error', () {
      final error = Exception('boom');
      expect(
        mapNetworkFailureToAuthFailure(NetworkFailure.unknown(error: error)),
        AuthFailure.unknown(error: error),
      );
    });
  });

  group('RefreshSession', () {
    late _MockSessionRepository repository;
    late _MockTokenStorage tokenStorage;

    setUp(() {
      repository = _MockSessionRepository();
      tokenStorage = _MockTokenStorage();
      when(() => tokenStorage.save(any())).thenAnswer((_) async {});
    });

    test('persists the refreshed session on success', () async {
      when(() => repository.refresh()).thenAnswer((_) async => right(_session));

      final result = await RefreshSession(repository, tokenStorage)();

      expect(result.isRight(), isTrue);
      verify(() => tokenStorage.save(_session)).called(1);
    });

    test('does not persist when refresh fails', () async {
      when(
        () => repository.refresh(),
      ).thenAnswer((_) async => left(const AuthFailure.sessionExpired()));

      final result = await RefreshSession(repository, tokenStorage)();

      expect(result.isLeft(), isTrue);
      verifyNever(() => tokenStorage.save(any()));
    });
  });

  group('Logout', () {
    late _MockSessionRepository repository;
    late _MockTokenStorage tokenStorage;

    setUp(() {
      repository = _MockSessionRepository();
      tokenStorage = _MockTokenStorage();
      when(() => tokenStorage.clear()).thenAnswer((_) async {});
    });

    test('clears storage and returns success when logout succeeds', () async {
      when(() => repository.logout()).thenAnswer((_) async => right(unit));

      final result = await Logout(repository, tokenStorage)();

      expect(result.isRight(), isTrue);
      verify(() => tokenStorage.clear()).called(1);
    });

    test('clears storage even when the backend logout fails', () async {
      when(
        () => repository.logout(),
      ).thenAnswer((_) async => left(const AuthFailure.network()));

      final result = await Logout(repository, tokenStorage)();

      expect(result.isLeft(), isTrue);
      verify(() => tokenStorage.clear()).called(1);
    });
  });

  group('AuthCubit', () {
    late _MockTokenStorage tokenStorage;
    late _MockLogout logout;

    setUp(() {
      tokenStorage = _MockTokenStorage();
      logout = _MockLogout();
    });

    blocTest<AuthCubit, AuthState>(
      'checkInitialSession emits authenticated when a session exists',
      setUp: () =>
          when(() => tokenStorage.read()).thenAnswer((_) async => _session),
      build: () => AuthCubit(tokenStorage: tokenStorage, logout: logout),
      act: (cubit) => cubit.checkInitialSession(),
      expect: () => [const AuthState.authenticated(_session)],
    );

    blocTest<AuthCubit, AuthState>(
      'checkInitialSession emits unauthenticated when no session exists',
      setUp: () =>
          when(() => tokenStorage.read()).thenAnswer((_) async => null),
      build: () => AuthCubit(tokenStorage: tokenStorage, logout: logout),
      act: (cubit) => cubit.checkInitialSession(),
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'signOut invokes Logout and emits unauthenticated',
      setUp: () => when(() => logout()).thenAnswer((_) async => right(unit)),
      build: () => AuthCubit(tokenStorage: tokenStorage, logout: logout),
      act: (cubit) => cubit.signOut(),
      expect: () => [const AuthState.unauthenticated()],
      verify: (_) => verify(() => logout()).called(1),
    );
  });
}
