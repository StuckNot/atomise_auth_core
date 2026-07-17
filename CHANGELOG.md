# Changelog

## 0.1.1

- `atomise_network` dependency now resolves over HTTPS instead of SSH — no
  functional change, transport only.

## 0.1.0

Initial release.

### Core
- `AuthSession` — persisted session (access + refresh tokens)
- `AuthFailure` — sealed union: `network`, `invalidOtp`, `sessionExpired`, `client`, `server`, `unknown`
- `TokenStorage` — session persistence interface (app-implemented)
- `SessionRepository` — `refresh()` / `logout()` interface (app-implemented)
- `RefreshSession`, `Logout` — session use cases
- `AuthCubit` / `AuthState` — app-wide session guardian
- `AuthInterceptor` — token attachment + single-flight 401 refresh, reading from `TokenStorage`
- `mapNetworkFailureToAuthFailure` — maps `atomise_network`'s `NetworkFailure` to `AuthFailure`
- `registerAuthModule` — wires the session lifecycle + interceptor into get_it

### Structure
- Method-agnostic core: login methods (OTP, password, social) live in their own
  packages (e.g. `atomise_auth_otp`) that depend on this one
- Two-barrel import surface: `atomise_auth_core.dart` (types, no get_it) and
  `atomise_auth_core_di.dart` (registration + type re-export, for the composition root)

### Depends on
- `atomise_network` v0.2.0
