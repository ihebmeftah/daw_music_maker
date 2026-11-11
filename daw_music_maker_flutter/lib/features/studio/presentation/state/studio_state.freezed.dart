// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudioState {

/// The project open in the studio.
 ProjectResponse get project;/// Current tempo (may be ahead of [savedBpm] while editing).
 double get bpm;/// Last tempo stored on the server.
 double get savedBpm;/// Whether the metronome is playing.
 bool get isPlaying;/// Whether the metronome clicks are muted (beats keep running).
 bool get isMuted;/// Whether a tempo save is in flight.
 bool get isSaving;/// Error of the last save.
 Failure? get failure;
/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioStateCopyWith<StudioState> get copyWith => _$StudioStateCopyWithImpl<StudioState>(this as StudioState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StudioState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioState&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.bpm, _this.bpm) || other.bpm == _this.bpm)&&(identical(other.savedBpm, _this.savedBpm) || other.savedBpm == _this.savedBpm)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.isMuted, _this.isMuted) || other.isMuted == _this.isMuted)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as StudioState;
  return Object.hash(runtimeType,_this.project,_this.bpm,_this.savedBpm,_this.isPlaying,_this.isMuted,_this.isSaving,_this.failure);
}

@override
String toString() {
  final _this = this as StudioState;
  return 'StudioState(project: ${_this.project}, bpm: ${_this.bpm}, savedBpm: ${_this.savedBpm}, isPlaying: ${_this.isPlaying}, isMuted: ${_this.isMuted}, isSaving: ${_this.isSaving}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $StudioStateCopyWith<$Res>  {
  factory $StudioStateCopyWith(StudioState value, $Res Function(StudioState) _then) = _$StudioStateCopyWithImpl;
@useResult
$Res call({
 ProjectResponse project, double bpm, double savedBpm, bool isPlaying, bool isMuted, bool isSaving, Failure? failure
});




}
/// @nodoc
class _$StudioStateCopyWithImpl<$Res>
    implements $StudioStateCopyWith<$Res> {
  _$StudioStateCopyWithImpl(this._self, this._then);

  final StudioState _self;
  final $Res Function(StudioState) _then;

/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? project = null,Object? bpm = null,Object? savedBpm = null,Object? isPlaying = null,Object? isMuted = null,Object? isSaving = null,Object? failure = freezed,}) {
  return _then(StudioState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,bpm: null == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as double,savedBpm: null == savedBpm ? _self.savedBpm : savedBpm // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioState].
extension StudioStatePatterns on StudioState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioState value)  $default,){
final _that = this;
switch (_that) {
case _StudioState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioState value)?  $default,){
final _that = this;
switch (_that) {
case _StudioState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioState() when $default != null:
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _StudioState():
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _StudioState() when $default != null:
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _StudioState extends StudioState {
  const _StudioState({required this.project, required this.bpm, required this.savedBpm, this.isPlaying = false, this.isMuted = false, this.isSaving = false, this.failure}): super._();
  

/// The project open in the studio.
@override final  ProjectResponse project;
/// Current tempo (may be ahead of [savedBpm] while editing).
@override final  double bpm;
/// Last tempo stored on the server.
@override final  double savedBpm;
/// Whether the metronome is playing.
@override@JsonKey() final  bool isPlaying;
/// Whether the metronome clicks are muted (beats keep running).
@override@JsonKey() final  bool isMuted;
/// Whether a tempo save is in flight.
@override@JsonKey() final  bool isSaving;
/// Error of the last save.
@override final  Failure? failure;

/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioStateCopyWith<_StudioState> get copyWith => __$StudioStateCopyWithImpl<_StudioState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioState&&(identical(other.project, project) || other.project == project)&&(identical(other.bpm, bpm) || other.bpm == bpm)&&(identical(other.savedBpm, savedBpm) || other.savedBpm == savedBpm)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,project,bpm,savedBpm,isPlaying,isMuted,isSaving,failure);
}

@override
String toString() {
    return 'StudioState(project: $project, bpm: $bpm, savedBpm: $savedBpm, isPlaying: $isPlaying, isMuted: $isMuted, isSaving: $isSaving, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$StudioStateCopyWith<$Res> implements $StudioStateCopyWith<$Res> {
  factory _$StudioStateCopyWith(_StudioState value, $Res Function(_StudioState) _then) = __$StudioStateCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse project, double bpm, double savedBpm, bool isPlaying, bool isMuted, bool isSaving, Failure? failure
});




}
/// @nodoc
class __$StudioStateCopyWithImpl<$Res>
    implements _$StudioStateCopyWith<$Res> {
  __$StudioStateCopyWithImpl(this._self, this._then);

  final _StudioState _self;
  final $Res Function(_StudioState) _then;

/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? project = null,Object? bpm = null,Object? savedBpm = null,Object? isPlaying = null,Object? isMuted = null,Object? isSaving = null,Object? failure = freezed,}) {
  return _then(_StudioState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,bpm: null == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as double,savedBpm: null == savedBpm ? _self.savedBpm : savedBpm // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
