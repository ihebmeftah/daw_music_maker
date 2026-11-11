// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectDetailState {

/// The project.
 ProjectResponse get project;/// Owner and members (empty for non-member viewers).
 List<ProjectMemberResponse> get members;/// Pending invitations (owner only).
 List<ProjectInvitationResponse> get invitations;/// Pending join requests (owner only).
 List<JoinRequestResponse> get joinRequests;/// Whether an action is in flight.
 bool get isBusy;/// Error of the last action.
 Failure? get actionFailure;
/// Create a copy of ProjectDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDetailStateCopyWith<ProjectDetailState> get copyWith => _$ProjectDetailStateCopyWithImpl<ProjectDetailState>(this as ProjectDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProjectDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailState&&(identical(other.project, _this.project) || other.project == _this.project)&&const DeepCollectionEquality().equals(other.members, _this.members)&&const DeepCollectionEquality().equals(other.invitations, _this.invitations)&&const DeepCollectionEquality().equals(other.joinRequests, _this.joinRequests)&&(identical(other.isBusy, _this.isBusy) || other.isBusy == _this.isBusy)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as ProjectDetailState;
  return Object.hash(runtimeType,_this.project,const DeepCollectionEquality().hash(_this.members),const DeepCollectionEquality().hash(_this.invitations),const DeepCollectionEquality().hash(_this.joinRequests),_this.isBusy,_this.actionFailure);
}

@override
String toString() {
  final _this = this as ProjectDetailState;
  return 'ProjectDetailState(project: ${_this.project}, members: ${_this.members}, invitations: ${_this.invitations}, joinRequests: ${_this.joinRequests}, isBusy: ${_this.isBusy}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $ProjectDetailStateCopyWith<$Res>  {
  factory $ProjectDetailStateCopyWith(ProjectDetailState value, $Res Function(ProjectDetailState) _then) = _$ProjectDetailStateCopyWithImpl;
@useResult
$Res call({
 ProjectResponse project, List<ProjectMemberResponse> members, List<ProjectInvitationResponse> invitations, List<JoinRequestResponse> joinRequests, bool isBusy, Failure? actionFailure
});




}
/// @nodoc
class _$ProjectDetailStateCopyWithImpl<$Res>
    implements $ProjectDetailStateCopyWith<$Res> {
  _$ProjectDetailStateCopyWithImpl(this._self, this._then);

  final ProjectDetailState _self;
  final $Res Function(ProjectDetailState) _then;

/// Create a copy of ProjectDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? project = null,Object? members = null,Object? invitations = null,Object? joinRequests = null,Object? isBusy = null,Object? actionFailure = freezed,}) {
  return _then(ProjectDetailState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectMemberResponse>,invitations: null == invitations ? _self.invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<ProjectInvitationResponse>,joinRequests: null == joinRequests ? _self.joinRequests : joinRequests // ignore: cast_nullable_to_non_nullable
as List<JoinRequestResponse>,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDetailState].
extension ProjectDetailStatePatterns on ProjectDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse project,  List<ProjectMemberResponse> members,  List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDetailState() when $default != null:
return $default(_that.project,_that.members,_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse project,  List<ProjectMemberResponse> members,  List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _ProjectDetailState():
return $default(_that.project,_that.members,_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse project,  List<ProjectMemberResponse> members,  List<ProjectInvitationResponse> invitations,  List<JoinRequestResponse> joinRequests,  bool isBusy,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDetailState() when $default != null:
return $default(_that.project,_that.members,_that.invitations,_that.joinRequests,_that.isBusy,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectDetailState extends ProjectDetailState {
  const _ProjectDetailState({required this.project,  List<ProjectMemberResponse> members = const <ProjectMemberResponse>[],  List<ProjectInvitationResponse> invitations = const <ProjectInvitationResponse>[],  List<JoinRequestResponse> joinRequests = const <JoinRequestResponse>[], this.isBusy = false, this.actionFailure}): _members = members,_invitations = invitations,_joinRequests = joinRequests,super._();
  

/// The project.
@override final  ProjectResponse project;
/// Owner and members (empty for non-member viewers).
 final  List<ProjectMemberResponse> _members;
/// Owner and members (empty for non-member viewers).
@override@JsonKey() List<ProjectMemberResponse> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

/// Pending invitations (owner only).
 final  List<ProjectInvitationResponse> _invitations;
/// Pending invitations (owner only).
@override@JsonKey() List<ProjectInvitationResponse> get invitations {
  if (_invitations is EqualUnmodifiableListView) return _invitations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invitations);
}

/// Pending join requests (owner only).
 final  List<JoinRequestResponse> _joinRequests;
/// Pending join requests (owner only).
@override@JsonKey() List<JoinRequestResponse> get joinRequests {
  if (_joinRequests is EqualUnmodifiableListView) return _joinRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_joinRequests);
}

/// Whether an action is in flight.
@override@JsonKey() final  bool isBusy;
/// Error of the last action.
@override final  Failure? actionFailure;

/// Create a copy of ProjectDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDetailStateCopyWith<_ProjectDetailState> get copyWith => __$ProjectDetailStateCopyWithImpl<_ProjectDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDetailState&&(identical(other.project, project) || other.project == project)&&const DeepCollectionEquality().equals(other.members, _members)&&const DeepCollectionEquality().equals(other.invitations, _invitations)&&const DeepCollectionEquality().equals(other.joinRequests, _joinRequests)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,project,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_invitations),const DeepCollectionEquality().hash(_joinRequests),isBusy,actionFailure);
}

@override
String toString() {
    return 'ProjectDetailState(project: $project, members: $members, invitations: $invitations, joinRequests: $joinRequests, isBusy: $isBusy, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$ProjectDetailStateCopyWith<$Res> implements $ProjectDetailStateCopyWith<$Res> {
  factory _$ProjectDetailStateCopyWith(_ProjectDetailState value, $Res Function(_ProjectDetailState) _then) = __$ProjectDetailStateCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse project, List<ProjectMemberResponse> members, List<ProjectInvitationResponse> invitations, List<JoinRequestResponse> joinRequests, bool isBusy, Failure? actionFailure
});




}
/// @nodoc
class __$ProjectDetailStateCopyWithImpl<$Res>
    implements _$ProjectDetailStateCopyWith<$Res> {
  __$ProjectDetailStateCopyWithImpl(this._self, this._then);

  final _ProjectDetailState _self;
  final $Res Function(_ProjectDetailState) _then;

/// Create a copy of ProjectDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? project = null,Object? members = null,Object? invitations = null,Object? joinRequests = null,Object? isBusy = null,Object? actionFailure = freezed,}) {
  return _then(_ProjectDetailState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectMemberResponse>,invitations: null == invitations ? _self._invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<ProjectInvitationResponse>,joinRequests: null == joinRequests ? _self._joinRequests : joinRequests // ignore: cast_nullable_to_non_nullable
as List<JoinRequestResponse>,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
