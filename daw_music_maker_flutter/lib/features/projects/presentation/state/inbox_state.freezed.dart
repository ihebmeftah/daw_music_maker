// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InboxState {

/// Invitations addressed to the user.
 List<ProjectInvitationResponse> get invitations;/// Join requests the user sent.
 List<JoinRequestResponse> get joinRequests;/// Whether an action is in flight.
 bool get isBusy;/// Error of the last action.
 Failure? get actionFailure;
/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxStateCopyWith<InboxState> get copyWith => _$InboxStateCopyWithImpl<InboxState>(this as InboxState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InboxState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxState&&const DeepCollectionEquality().equals(other.invitations, _this.invitations)&&const DeepCollectionEquality().equals(other.joinRequests, _this.joinRequests)&&(identical(other.isBusy, _this.isBusy) || other.isBusy == _this.isBusy)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as InboxState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.invitations),const DeepCollectionEquality().hash(_this.joinRequests),_this.isBusy,_this.actionFailure);
}

@override
String toString() {
  final _this = this as InboxState;
  return 'InboxState(invitations: ${_this.invitations}, joinRequests: ${_this.joinRequests}, isBusy: ${_this.isBusy}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $InboxStateCopyWith<$Res>  {
  factory $InboxStateCopyWith(InboxState value, $Res Function(InboxState) _then) = _$InboxStateCopyWithImpl;
@useResult
$Res call({
 List<ProjectInvitationResponse> invitations, List<JoinRequestResponse> joinRequests, bool isBusy, Failure? actionFailure
});




}
/// @nodoc
class _$InboxStateCopyWithImpl<$Res>
    implements $InboxStateCopyWith<$Res> {
  _$InboxStateCopyWithImpl(this._self, this._then);

  final InboxState _self;
  final $Res Function(InboxState) _then;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invitations = null,Object? joinRequests = null,Object? isBusy = null,Object? actionFailure = freezed,}) {
  return _then(InboxState(
invitations: null == invitations ? _self.invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<ProjectInvitationResponse>,joinRequests: null == joinRequests ? _self.joinRequests : joinRequests // ignore: cast_nullable_to_non_nullable
as List<JoinRequestResponse>,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxState].
extension InboxStatePatterns on InboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxState value)  $default,){
final _that = this;
switch (_that) {
case _InboxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxState value)?  $default,){
final _that = this;
switch (_that) {
case _InboxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxState() when $default != null:
return $default(_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _InboxState():
return $default(_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _InboxState() when $default != null:
return $default(_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _InboxState implements InboxState {
  const _InboxState({ List<ProjectInvitationResponse> invitations = const <ProjectInvitationResponse>[],  List<JoinRequestResponse> joinRequests = const <JoinRequestResponse>[], this.isBusy = false, this.actionFailure}): _invitations = invitations,_joinRequests = joinRequests;
  

/// Invitations addressed to the user.
 final  List<ProjectInvitationResponse> _invitations;
/// Invitations addressed to the user.
@override@JsonKey() List<ProjectInvitationResponse> get invitations {
  if (_invitations is EqualUnmodifiableListView) return _invitations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invitations);
}

/// Join requests the user sent.
 final  List<JoinRequestResponse> _joinRequests;
/// Join requests the user sent.
@override@JsonKey() List<JoinRequestResponse> get joinRequests {
  if (_joinRequests is EqualUnmodifiableListView) return _joinRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_joinRequests);
}

/// Whether an action is in flight.
@override@JsonKey() final  bool isBusy;
/// Error of the last action.
@override final  Failure? actionFailure;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxStateCopyWith<_InboxState> get copyWith => __$InboxStateCopyWithImpl<_InboxState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxState&&const DeepCollectionEquality().equals(other.invitations, _invitations)&&const DeepCollectionEquality().equals(other.joinRequests, _joinRequests)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_invitations),const DeepCollectionEquality().hash(_joinRequests),isBusy,actionFailure);
}

@override
String toString() {
    return 'InboxState(invitations: $invitations, joinRequests: $joinRequests, isBusy: $isBusy, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$InboxStateCopyWith<$Res> implements $InboxStateCopyWith<$Res> {
  factory _$InboxStateCopyWith(_InboxState value, $Res Function(_InboxState) _then) = __$InboxStateCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectInvitationResponse> invitations, List<JoinRequestResponse> joinRequests, bool isBusy, Failure? actionFailure
});




}
/// @nodoc
class __$InboxStateCopyWithImpl<$Res>
    implements _$InboxStateCopyWith<$Res> {
  __$InboxStateCopyWithImpl(this._self, this._then);

  final _InboxState _self;
  final $Res Function(_InboxState) _then;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invitations = null,Object? joinRequests = null,Object? isBusy = null,Object? actionFailure = freezed,}) {
  return _then(_InboxState(
invitations: null == invitations ? _self._invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<ProjectInvitationResponse>,joinRequests: null == joinRequests ? _self._joinRequests : joinRequests // ignore: cast_nullable_to_non_nullable
as List<JoinRequestResponse>,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
