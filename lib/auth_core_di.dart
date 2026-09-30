// Separate from the main barrel: the app's composition root imports this
// directly to wire DI, keeping `auth_core.dart` to domain + presentation.
export 'src/di/auth_module.dart';

//for types
export 'auth_core.dart';
