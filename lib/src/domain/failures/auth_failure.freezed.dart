// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthNetworkFailure value)?  network,TResult Function( AuthSessionExpiredFailure value)?  sessionExpired,TResult Function( AuthServerFailure value)?  server,TResult Function( AuthClientFailure value)?  client,TResult Function( AuthUnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthNetworkFailure() when network != null:
return network(_that);case AuthSessionExpiredFailure() when sessionExpired != null:
return sessionExpired(_that);case AuthServerFailure() when server != null:
return server(_that);case AuthClientFailure() when client != null:
return client(_that);case AuthUnknownFailure() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthNetworkFailure value)  network,required TResult Function( AuthSessionExpiredFailure value)  sessionExpired,required TResult Function( AuthServerFailure value)  server,required TResult Function( AuthClientFailure value)  client,required TResult Function( AuthUnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case AuthNetworkFailure():
return network(_that);case AuthSessionExpiredFailure():
return sessionExpired(_that);case AuthServerFailure():
return server(_that);case AuthClientFailure():
return client(_that);case AuthUnknownFailure():
return unknown(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthNetworkFailure value)?  network,TResult? Function( AuthSessionExpiredFailure value)?  sessionExpired,TResult? Function( AuthServerFailure value)?  server,TResult? Function( AuthClientFailure value)?  client,TResult? Function( AuthUnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case AuthNetworkFailure() when network != null:
return network(_that);case AuthSessionExpiredFailure() when sessionExpired != null:
return sessionExpired(_that);case AuthServerFailure() when server != null:
return server(_that);case AuthClientFailure() when client != null:
return client(_that);case AuthUnknownFailure() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  network,TResult Function()?  sessionExpired,TResult Function( int? statusCode)?  server,TResult Function( int? statusCode)?  client,TResult Function( Object? error)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthNetworkFailure() when network != null:
return network();case AuthSessionExpiredFailure() when sessionExpired != null:
return sessionExpired();case AuthServerFailure() when server != null:
return server(_that.statusCode);case AuthClientFailure() when client != null:
return client(_that.statusCode);case AuthUnknownFailure() when unknown != null:
return unknown(_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  network,required TResult Function()  sessionExpired,required TResult Function( int? statusCode)  server,required TResult Function( int? statusCode)  client,required TResult Function( Object? error)  unknown,}) {final _that = this;
switch (_that) {
case AuthNetworkFailure():
return network();case AuthSessionExpiredFailure():
return sessionExpired();case AuthServerFailure():
return server(_that.statusCode);case AuthClientFailure():
return client(_that.statusCode);case AuthUnknownFailure():
return unknown(_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  network,TResult? Function()?  sessionExpired,TResult? Function( int? statusCode)?  server,TResult? Function( int? statusCode)?  client,TResult? Function( Object? error)?  unknown,}) {final _that = this;
switch (_that) {
case AuthNetworkFailure() when network != null:
return network();case AuthSessionExpiredFailure() when sessionExpired != null:
return sessionExpired();case AuthServerFailure() when server != null:
return server(_that.statusCode);case AuthClientFailure() when client != null:
return client(_that.statusCode);case AuthUnknownFailure() when unknown != null:
return unknown(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class AuthNetworkFailure implements AuthFailure {
  const AuthNetworkFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthNetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.network()';
}


}




/// @nodoc


class AuthSessionExpiredFailure implements AuthFailure {
  const AuthSessionExpiredFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionExpiredFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.sessionExpired()';
}


}




/// @nodoc


class AuthServerFailure implements AuthFailure {
  const AuthServerFailure({this.statusCode});
  

 final  int? statusCode;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthServerFailureCopyWith<AuthServerFailure> get copyWith => _$AuthServerFailureCopyWithImpl<AuthServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'AuthFailure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $AuthServerFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthServerFailureCopyWith(AuthServerFailure value, $Res Function(AuthServerFailure) _then) = _$AuthServerFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$AuthServerFailureCopyWithImpl<$Res>
    implements $AuthServerFailureCopyWith<$Res> {
  _$AuthServerFailureCopyWithImpl(this._self, this._then);

  final AuthServerFailure _self;
  final $Res Function(AuthServerFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(AuthServerFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class AuthClientFailure implements AuthFailure {
  const AuthClientFailure({this.statusCode});
  

 final  int? statusCode;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthClientFailureCopyWith<AuthClientFailure> get copyWith => _$AuthClientFailureCopyWithImpl<AuthClientFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthClientFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'AuthFailure.client(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $AuthClientFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthClientFailureCopyWith(AuthClientFailure value, $Res Function(AuthClientFailure) _then) = _$AuthClientFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$AuthClientFailureCopyWithImpl<$Res>
    implements $AuthClientFailureCopyWith<$Res> {
  _$AuthClientFailureCopyWithImpl(this._self, this._then);

  final AuthClientFailure _self;
  final $Res Function(AuthClientFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(AuthClientFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class AuthUnknownFailure implements AuthFailure {
  const AuthUnknownFailure({this.error});
  

 final  Object? error;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUnknownFailureCopyWith<AuthUnknownFailure> get copyWith => _$AuthUnknownFailureCopyWithImpl<AuthUnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknownFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AuthFailure.unknown(error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthUnknownFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthUnknownFailureCopyWith(AuthUnknownFailure value, $Res Function(AuthUnknownFailure) _then) = _$AuthUnknownFailureCopyWithImpl;
@useResult
$Res call({
 Object? error
});




}
/// @nodoc
class _$AuthUnknownFailureCopyWithImpl<$Res>
    implements $AuthUnknownFailureCopyWith<$Res> {
  _$AuthUnknownFailureCopyWithImpl(this._self, this._then);

  final AuthUnknownFailure _self;
  final $Res Function(AuthUnknownFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(AuthUnknownFailure(
error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
