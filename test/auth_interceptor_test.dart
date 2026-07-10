import 'dart:async';

import 'package:atomise_auth_core/atomise_auth_core.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class _MockChain extends Mock implements Chain<String> {}

class _MockTokenStorage extends Mock implements TokenStorage {}

Response<String> _resp(int statusCode) =>
    Response(http.Response('', statusCode), '');

void main() {
  final baseRequest = Request(
    'GET',
    Uri.parse('/protected'),
    Uri.parse('https://api.test'),
  );

  setUpAll(() {
    registerFallbackValue(
      Request('GET', Uri.parse('/x'), Uri.parse('https://x')),
    );
  });

  late _MockChain chain;
  late _MockTokenStorage tokenStorage;

  setUp(() {
    chain = _MockChain();
    tokenStorage = _MockTokenStorage();
    when(() => chain.request).thenReturn(baseRequest);
  });

  test('attaches the bearer token and passes through when not 401', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => 'token-1');
    when(() => chain.proceed(any())).thenAnswer((_) async => _resp(200));

    var refreshCalls = 0;
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      onUnauthorized: () async {
        refreshCalls++;
        return true;
      },
    );

    final response = await interceptor.intercept<String>(chain);

    expect(response.statusCode, 200);
    expect(refreshCalls, 0);
    final sent =
        verify(() => chain.proceed(captureAny())).captured.single as Request;
    expect(sent.headers['Authorization'], 'Bearer token-1');
  });

  test('sends no Authorization header when there is no token', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => null);
    when(() => chain.proceed(any())).thenAnswer((_) async => _resp(200));

    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      onUnauthorized: () async => true,
    );

    await interceptor.intercept<String>(chain);

    final sent =
        verify(() => chain.proceed(captureAny())).captured.single as Request;
    expect(sent.headers.containsKey('Authorization'), isFalse);
  });

  test('on 401 refreshes once and retries with the new token', () async {
    var reads = 0;
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async {
      reads++;
      return reads == 1 ? 'stale' : 'fresh';
    });
    var attempts = 0;
    when(() => chain.proceed(any())).thenAnswer((_) async {
      attempts++;
      return attempts == 1 ? _resp(401) : _resp(200);
    });

    var refreshCalls = 0;
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      onUnauthorized: () async {
        refreshCalls++;
        return true;
      },
    );

    final response = await interceptor.intercept<String>(chain);

    expect(response.statusCode, 200);
    expect(refreshCalls, 1);
    final sent = verify(() => chain.proceed(captureAny())).captured;
    expect(sent.length, 2);
    expect((sent[0] as Request).headers['Authorization'], 'Bearer stale');
    expect((sent[1] as Request).headers['Authorization'], 'Bearer fresh');
  });

  test('on 401 returns the original response when refresh fails', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => 'stale');
    var attempts = 0;
    when(() => chain.proceed(any())).thenAnswer((_) async {
      attempts++;
      return _resp(401);
    });

    var refreshCalls = 0;
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      onUnauthorized: () async {
        refreshCalls++;
        return false;
      },
    );

    final response = await interceptor.intercept<String>(chain);

    expect(response.statusCode, 401);
    expect(refreshCalls, 1);
    expect(attempts, 1); // no retry attempted
  });

  test('single-flights the refresh across concurrent 401s', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => 'stale');
    when(() => chain.proceed(any())).thenAnswer((_) async => _resp(401));

    final gate = Completer<bool>();
    var refreshCalls = 0;
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      onUnauthorized: () {
        refreshCalls++;
        return gate.future;
      },
    );

    final f1 = interceptor.intercept<String>(chain);
    final f2 = interceptor.intercept<String>(chain);
    // Let both calls reach the refresh gate before releasing it.
    await Future<void>.delayed(Duration.zero);
    gate.complete(true);
    await Future.wait([f1, f2]);

    expect(refreshCalls, 1);
  });
}
