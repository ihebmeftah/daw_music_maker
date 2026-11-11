// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_code_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmailCodeFlowState {

/// The current step.
 EmailCodeFlowStep get step;/// The email the code was sent to (normalized), empty on the first step.
 String get email;/// Server request id returned when the code was sent.
 UuidValue? get requestId;/// Token returned after the code was verified; used to set the password.
 String? get token;/// Whether a request is in flight (disables the form).
 bool get isSubmitting;/// Whether a new code was just sent (shows a confirmation hint).
 bool get codeResent;/// Error of the last request, shown above the form.
 Failure? get failure;
/// Create a copy of EmailCodeFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailCodeFlowStateCopyWith<EmailCodeFlowState> get copyWith => _$EmailCodeFlowStateCopyWithImpl<EmailCodeFlowState>(this as EmailCodeFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EmailCodeFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailCodeFlowState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.codeResent, _this.codeResent) || other.codeResent == _this.codeResent)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as EmailCodeFlowState;
  return Object.hash(runtimeType,_this.step,_this.email,_this.requestId,_this.token,_this.isSubmitting,_this.codeResent,_this.failure);
}

@override
String toString() {
  final _this = this as EmailCodeFlowState;
  return 'EmailCodeFlowState(step: ${_this.step}, email: ${_this.email}, requestId: ${_this.requestId}, token: ${_this.token}, isSubmitting: ${_this.isSubmitting}, codeResent: ${_this.codeResent}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $EmailCodeFlowStateCopyWith<$Res>  {
  factory $EmailCodeFlowStateCopyWith(EmailCodeFlowState value, $Res Function(EmailCodeFlowState) _then) = _$EmailCodeFlowStateCopyWithImpl;
@useResult
$Res call({
 EmailCodeFlowStep step, String email, UuidValue? requestId, String? token, bool isSubmitting, bool codeResent, Failure? failure
});




}
/// @nodoc
class _$EmailCodeFlowStateCopyWithImpl<$Res>
    implements $EmailCodeFlowStateCopyWith<$Res> {
  _$EmailCodeFlowStateCopyWithImpl(this._self, this._then);

  final EmailCodeFlowState _self;
  final $Res Function(EmailCodeFlowState) _then;

/// Create a copy of EmailCodeFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? email = null,Object? requestId = freezed,Object? token = freezed,Object? isSubmitting = null,Object? codeResent = null,Object? failure = freezed,}) {
  return _then(EmailCodeFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as EmailCodeFlowStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as UuidValue?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,codeResent: null == codeResent ? _self.codeResent : codeResent // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailCodeFlowState].
extension EmailCodeFlowStatePatterns on EmailCodeFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailCodeFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailCodeFlowState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailCodeFlowState value)  $default,){
final _that = this;
switch (_that) {
case _EmailCodeFlowState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailCodeFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _EmailCodeFlowState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmailCodeFlowStep step,  String email,  UuidValue? requestId,  String? token,  bool isSubmitting,  bool codeResent,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailCodeFlowState() when $default != null:
return $default(_that.step,_that.email,_that.requestId,_that.token,_that.isSubmitting,_that.codeResent,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmailCodeFlowStep step,  String email,  UuidValue? requestId,  String? token,  bool isSubmitting,  bool codeResent,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EmailCodeFlowState():
return $default(_that.step,_that.email,_that.requestId,_that.token,_that.isSubmitting,_that.codeResent,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmailCodeFlowStep step,  String email,  UuidValue? requestId,  String? token,  bool isSubmitting,  bool codeResent,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EmailCodeFlowState() when $default != null:
return $default(_that.step,_that.email,_that.requestId,_that.token,_that.isSubmitting,_that.codeResent,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EmailCodeFlowState implements EmailCodeFlowState {
  const _EmailCodeFlowState({this.step = EmailCodeFlowStep.email, this.email = '', this.requestId, this.token, this.isSubmitting = false, this.codeResent = false, this.failure});
  

/// The current step.
@override@JsonKey() final  EmailCodeFlowStep step;
/// The email the code was sent to (normalized), empty on the first step.
@override@JsonKey() final  String email;
/// Server request id returned when the code was sent.
@override final  UuidValue? requestId;
/// Token returned after the code was verified; used to set the password.
@override final  String? token;
/// Whether a request is in flight (disables the form).
@override@JsonKey() final  bool isSubmitting;
/// Whether a new code was just sent (shows a confirmation hint).
@override@JsonKey() final  bool codeResent;
/// Error of the last request, shown above the form.
@override final  Failure? failure;

/// Create a copy of EmailCodeFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailCodeFlowStateCopyWith<_EmailCodeFlowState> get copyWith => __$EmailCodeFlowStateCopyWithImpl<_EmailCodeFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailCodeFlowState&&(identical(other.step, step) || other.step == step)&&(identical(other.email, email) || other.email == email)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.token, token) || other.token == token)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.codeResent, codeResent) || other.codeResent == codeResent)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,email,requestId,token,isSubmitting,codeResent,failure);
}

@override
String toString() {
    return 'EmailCodeFlowState(step: $step, email: $email, requestId: $requestId, token: $token, isSubmitting: $isSubmitting, codeResent: $codeResent, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EmailCodeFlowStateCopyWith<$Res> implements $EmailCodeFlowStateCopyWith<$Res> {
  factory _$EmailCodeFlowStateCopyWith(_EmailCodeFlowState value, $Res Function(_EmailCodeFlowState) _then) = __$EmailCodeFlowStateCopyWithImpl;
@override @useResult
$Res call({
 EmailCodeFlowStep step, String email, UuidValue? requestId, String? token, bool isSubmitting, bool codeResent, Failure? failure
});




}
/// @nodoc
class __$EmailCodeFlowStateCopyWithImpl<$Res>
    implements _$EmailCodeFlowStateCopyWith<$Res> {
  __$EmailCodeFlowStateCopyWithImpl(this._self, this._then);

  final _EmailCodeFlowState _self;
  final $Res Function(_EmailCodeFlowState) _then;

/// Create a copy of EmailCodeFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? email = null,Object? requestId = freezed,Object? token = freezed,Object? isSubmitting = null,Object? codeResent = null,Object? failure = freezed,}) {
  return _then(_EmailCodeFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as EmailCodeFlowStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as UuidValue?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,codeResent: null == codeResent ? _self.codeResent : codeResent // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
