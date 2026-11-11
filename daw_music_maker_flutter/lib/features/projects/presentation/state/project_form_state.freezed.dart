// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectFormState {

/// The project being edited, or null when creating.
 ProjectResponse? get initial;/// Whether a save is in flight.
 bool get isSubmitting;/// Error of the last save (may carry server field errors).
 Failure? get failure;
/// Create a copy of ProjectFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFormStateCopyWith<ProjectFormState> get copyWith => _$ProjectFormStateCopyWithImpl<ProjectFormState>(this as ProjectFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProjectFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFormState&&(identical(other.initial, _this.initial) || other.initial == _this.initial)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ProjectFormState;
  return Object.hash(runtimeType,_this.initial,_this.isSubmitting,_this.failure);
}

@override
String toString() {
  final _this = this as ProjectFormState;
  return 'ProjectFormState(initial: ${_this.initial}, isSubmitting: ${_this.isSubmitting}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ProjectFormStateCopyWith<$Res>  {
  factory $ProjectFormStateCopyWith(ProjectFormState value, $Res Function(ProjectFormState) _then) = _$ProjectFormStateCopyWithImpl;
@useResult
$Res call({
 ProjectResponse? initial, bool isSubmitting, Failure? failure
});




}
/// @nodoc
class _$ProjectFormStateCopyWithImpl<$Res>
    implements $ProjectFormStateCopyWith<$Res> {
  _$ProjectFormStateCopyWithImpl(this._self, this._then);

  final ProjectFormState _self;
  final $Res Function(ProjectFormState) _then;

/// Create a copy of ProjectFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initial = freezed,Object? isSubmitting = null,Object? failure = freezed,}) {
  return _then(ProjectFormState(
initial: freezed == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as ProjectResponse?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectFormState].
extension ProjectFormStatePatterns on ProjectFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectFormState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse? initial,  bool isSubmitting,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectFormState() when $default != null:
return $default(_that.initial,_that.isSubmitting,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse? initial,  bool isSubmitting,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ProjectFormState():
return $default(_that.initial,_that.isSubmitting,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse? initial,  bool isSubmitting,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ProjectFormState() when $default != null:
return $default(_that.initial,_that.isSubmitting,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectFormState implements ProjectFormState {
  const _ProjectFormState({this.initial, this.isSubmitting = false, this.failure});
  

/// The project being edited, or null when creating.
@override final  ProjectResponse? initial;
/// Whether a save is in flight.
@override@JsonKey() final  bool isSubmitting;
/// Error of the last save (may carry server field errors).
@override final  Failure? failure;

/// Create a copy of ProjectFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectFormStateCopyWith<_ProjectFormState> get copyWith => __$ProjectFormStateCopyWithImpl<_ProjectFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectFormState&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,initial,isSubmitting,failure);
}

@override
String toString() {
    return 'ProjectFormState(initial: $initial, isSubmitting: $isSubmitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ProjectFormStateCopyWith<$Res> implements $ProjectFormStateCopyWith<$Res> {
  factory _$ProjectFormStateCopyWith(_ProjectFormState value, $Res Function(_ProjectFormState) _then) = __$ProjectFormStateCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse? initial, bool isSubmitting, Failure? failure
});




}
/// @nodoc
class __$ProjectFormStateCopyWithImpl<$Res>
    implements _$ProjectFormStateCopyWith<$Res> {
  __$ProjectFormStateCopyWithImpl(this._self, this._then);

  final _ProjectFormState _self;
  final $Res Function(_ProjectFormState) _then;

/// Create a copy of ProjectFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initial = freezed,Object? isSubmitting = null,Object? failure = freezed,}) {
  return _then(_ProjectFormState(
initial: freezed == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as ProjectResponse?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
