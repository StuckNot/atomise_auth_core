// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:chopper/chopper.dart';

import '../../domain/storage/token_storage.dart';


/// Attaches the current access token to every request and, on a 401,
/// single-flights [onUnauthorized] before retrying the request once.
///
/// This package owns the refresh *mechanism*; what [onUnauthorized] actually
/// does (e.g. call a refresh-token endpoint) is the consuming feature's
/// concern, injected here as a callback.
class AuthInterceptor implements Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.onUnauthorized,
  });

  final TokenStorage tokenStorage;
  final Future<bool> Function() onUnauthorized;

  // Mutable by design: single-flight gate guarding concurrent refreshes.
  Completer<bool>? _refreshing;

  @override
  Future<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final token = await tokenStorage.readAccessToken();
    final request = token == null
        ? chain.request
        : chain.request.copyWith(
            headers: {
              ...chain.request.headers,
              'Authorization': 'Bearer $token',
            },
          );

    final response = await chain.proceed(request);
    if (response.statusCode != 401) return response;

    //ToDo: need to check if 401 is because of unauthorized or some other reason before refresh
    final refreshed = await _refreshOnce();
    if (!refreshed) return response;

    final newToken = await tokenStorage.readAccessToken();
    final retryRequest = newToken == null
        ? chain.request
        : chain.request.copyWith(
            headers: {
              ...chain.request.headers,
              'Authorization': 'Bearer $newToken',
            },
          );
    return chain.proceed(retryRequest);
  }

  Future<bool> _refreshOnce() {
    if (_refreshing != null) return _refreshing!.future;

    final completer = Completer<bool>();
    _refreshing = completer;
    onUnauthorized().then((result) {
      _refreshing = null;
      completer.complete(result);
    }, onError: (Object error, StackTrace stackTrace) {
      _refreshing = null;
      completer.complete(false);
    });
    return completer.future;
  }
}
