# atomise_auth_core

The auth foundation for Atomise Flutter apps — the **session lifecycle** (token
storage, attachment, refresh, logout, app-wide status) and the shared types
every auth method builds on: `AuthSession`, `AuthFailure`, `TokenStorage`, and
an auth-aware Chopper interceptor with single-flight 401 refresh.

> **This package does not log users in.** It manages an *existing* session —
> token storage, token attachment, silent refresh, logout, and app-wide auth
> state. Acquiring a session (the actual login) requires an auth-method package
> such as `atomise_auth_otp`, or your own login code that produces an
> `AuthSession` and saves it via `TokenStorage`.

This package is **method-agnostic**. It knows nothing about *how* a session is
acquired — OTP, password, Google, etc. Each login method lives in its own
package (e.g. `atomise_auth_otp`) that depends on this one. A consuming app
depends on `atomise_auth_core` for session management plus whichever method
package(s) it actually uses.

It builds on [`atomise_network`](https://github.com/sunpreet-singh_atomise/atomise_network)
and maps its transport-level `NetworkFailure` into the domain-level `AuthFailure`.

## What's in here

| Export | Purpose |
| --- | --- |
| `AuthSession` | The persisted session: access + refresh tokens. |
| `AuthFailure` | Sealed, freezed union of auth failures: `network`, `sessionExpired`, `client`, `server`, `unknown`. The single failure type every method package and app maps to UI copy. |
| `TokenStorage` | Interface — persist / read / clear the session. Implemented by the app (e.g. backed by `flutter_secure_storage`) and registered in get_it. The one place tokens are read from. |
| `SessionRepository` | Interface — `refresh()` and `logout()`. Mechanism-agnostic; implemented by the app against its backend. |
| `RefreshSession`, `Logout` | Session use cases. `RefreshSession` persists the new session; `Logout` clears storage even if the backend call fails. |
| `AuthCubit` / `AuthState` | App-wide session guardian. `checkInitialSession()` resolves `unknown` → authenticated/unauthenticated at startup; `signOut()` logs out. |
| `AuthInterceptor` | Attaches the access token to every request; on a `401`, single-flights a refresh and retries once. Reads the token from `TokenStorage`. |
| `mapNetworkFailureToAuthFailure` | Maps `atomise_network`'s `NetworkFailure` into `AuthFailure`. |
| `registerAuthModule` (via `atomise_auth_core_di.dart`) | Wires the session lifecycle + interceptor into get_it on top of the app-registered `TokenStorage` and `SessionRepository`. |

## What's NOT in here

- **Login methods** — OTP, password, social, registration. Each lives in its
  own package depending on this one. `atomise_auth_core` ships no `LoginBloc`.
- **Repository implementations** — `TokenStorage` and `SessionRepository` are
  interfaces. The app provides the concrete adapters (backend/storage-specific)
  and registers them in get_it.
- **DTOs / swagger models** — these belong in the app, generated against its
  own API spec.

## Import surface

Two barrels, two audiences:

- `package:atomise_auth_core/atomise_auth_core.dart` — types only (`AuthSession`,
  `AuthFailure`, `AuthCubit`, …). Imported by UI / feature code. No get_it.
- `package:atomise_auth_core/atomise_auth_core_di.dart` — `registerAuthModule` plus a
  re-export of the types barrel. Imported by the composition root only.

UI code never sees the service locator; the composition root gets everything
from one import.

## Usage

In the app's composition root:

```dart
import 'package:atomise_auth_core/atomise_auth_core_di.dart';

// 1. Register the app's own implementations.
sl.registerLazySingleton<TokenStorage>(() => SecureTokenStorage());

// 2. Wire the session lifecycle + interceptor.
registerAuthModule(sl);

// 3. Build an authenticated client and register the backend adapter.
final client = buildChopperClient(
  baseUrl: 'https://api.atomise.com',
  httpClient: httpClient,
  converter: MyService.$JsonSerializableConverter(),
  interceptors: [sl<AuthInterceptor>()],   // pre-wired refresh
);
sl.registerLazySingleton<SessionRepository>(() => MyBackendSessionRepository(...));

// 4. Register whichever method package(s) the app uses.
registerOtpAuthModule(sl);   // from atomise_auth_otp
```

At startup, drive `AuthCubit` to pick the first route:

```dart
final cubit = sl<AuthCubit>()..checkInitialSession();
// AuthUnknown -> splash, AuthUnauthenticated -> login, AuthAuthenticated -> home
```

The interceptor handles token attachment and 401 refresh transparently — feature
code just makes API calls and never touches tokens.

## Versioning

Consumed via pinned git tags, not a moving branch:

```yaml
dependencies:
  atomise_auth_core:
    git:
      url: git@github.com:sunpreet-singh_atomise/atomise_auth_core.git
      ref: v0.1.0
```

Depends on `atomise_network` (pinned) and follows semver: PATCH for fixes,
MINOR for additive changes, MAJOR for breaking changes to the public surface.

## Development

```bash
flutter pub get
dart run build_runner build   # regen freezed code
flutter analyze
flutter test
```

Generated code (`*.freezed.dart`) is committed — consumers pull this package
via git and don't run codegen themselves.



## Not feeling confident to use it? Follow the below steps

This package does not log the user in. It only manages the session — storing tokens, refreshing them, and telling the app 
whether the user is logged in or not. To get a session, normally a login package (like atomise_auth_otp) or your own login code 
will save the session. For testing, we will simply save a dummy session ourselves.

**Step 1 — Create a small test app -**
Make a new Flutter project (or use any sample project you have).

**Step 2 — Add the package in pubspec.yaml -**

```yaml
dependencies:
  atomise_auth_core:
    git:
      url: git@github.com:sunpreet-singh_atomise/atomise_auth_core.git
      ref: v0.1.0
  get_it: ^9.2.1
  fpdart: ^1.2.0
```

Then run flutter pub get. (atomise_network comes automatically, no need to add it.)

**Step 3 — Add two small dummy classes -**
The package needs you to provide storage and a backend. For testing, use these simple dummy versions:

```dart
class InMemoryTokenStorage implements TokenStorage {
  AuthSession? _session;
  @override Future<void> save(AuthSession s) async => _session = s;
  @override Future<AuthSession?> read() async => _session;
  @override Future<String?> readAccessToken() async => _session?.accessToken;
  @override Future<void> clear() async => _session = null;
}

class FakeSessionRepository implements SessionRepository {
  @override
  Future<Either<AuthFailure, AuthSession>> refresh() async =>
      right(const AuthSession(accessToken: 'new-token', refreshToken: 'new-refresh'));
  @override
  Future<Either<AuthFailure, Unit>> logout() async => right(unit);
}
```


**Step 4 — Wire it up (composition root) -**
```dart
final sl = GetIt.instance;
sl.registerLazySingleton<TokenStorage>(() => InMemoryTokenStorage());
sl.registerLazySingleton<SessionRepository>(() => FakeSessionRepository());
registerAuthModule(sl);
```

**Step 5 — Try the session flow -**

```dart
final auth = sl<AuthCubit>();

await auth.checkInitialSession();
print(auth.state); // unauthenticated (no session yet)

// Simulate a login by saving a session directly:
await sl<TokenStorage>().save(
  const AuthSession(accessToken: 'abc', refreshToken: 'xyz'),
);

await auth.checkInitialSession();
print(auth.state); // authenticated

await auth.signOut();
print(auth.state); // unauthenticated (storage cleared)
```


**Step 6 — Read the tests (recommended) -**
Clone the repo and run flutter test. The test names read like a checklist and explain exactly how each part behaves (token attachment, 401 refresh, logout, etc.). This is the best way to understand the package.


<img src='https://github.com/sunpreet-singh_atomise/atomise_auth_core/blob/main/dependency_graph.png?raw=true'>
