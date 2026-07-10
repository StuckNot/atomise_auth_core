import 'package:atomise_network/atomise_network.dart';

import '../../domain/failures/auth_failure.dart';

/// Translates infrastructure-level [NetworkFailure] into domain-level
/// [AuthFailure]. Lives in atomise_auth so every consuming app gets this
/// mapping for free — apps only need to map [AuthFailure] to UI copy.
AuthFailure mapNetworkFailureToAuthFailure(NetworkFailure failure) {
  return failure.when(
    network: () => const AuthFailure.network(),
    timeout: () => const AuthFailure.network(),
    unauthorized: () => const AuthFailure.sessionExpired(),
    server: (statusCode, message) => AuthFailure.server(statusCode: statusCode),
    unknown: (error) => AuthFailure.unknown(error: error),
    clientError: (statusCode, message) => AuthFailure.client(statusCode: statusCode),
  );
}
