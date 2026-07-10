import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
sealed class AuthFailure with _$AuthFailure {
  const factory AuthFailure.network() = AuthNetworkFailure;
  const factory AuthFailure.sessionExpired() = AuthSessionExpiredFailure;
  const factory AuthFailure.server({int? statusCode}) = AuthServerFailure;
  const factory AuthFailure.client({int? statusCode}) = AuthClientFailure;
  const factory AuthFailure.unknown({Object? error}) = AuthUnknownFailure;
}
