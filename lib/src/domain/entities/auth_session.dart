import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

/// An authenticated session: token pair plus the optional fields backends
/// commonly return alongside them.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    String? tokenType,
    String? redirectUrl,
  }) = _AuthSession;
}
