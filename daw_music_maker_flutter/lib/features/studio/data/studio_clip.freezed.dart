// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_clip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudioClip {

/// The pattern it plays (its length is the clip's length).
 UuidValue? get patternId;/// The uploaded sample of an audio clip.
 UuidValue? get sampleId;/// Length of an audio clip in bars.
 int? get lengthBars;/// Playlist track (row), 0-based.
 int get track;/// Start in steps (1/16 notes) from the song start.
 int get startStep;
/// Create a copy of StudioClip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioClipCopyWith<StudioClip> get copyWith => _$StudioClipCopyWithImpl<StudioClip>(this as StudioClip, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StudioClip;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioClip&&(identical(other.patternId, _this.patternId) || other.patternId == _this.patternId)&&(identical(other.sampleId, _this.sampleId) || other.sampleId == _this.sampleId)&&(identical(other.lengthBars, _this.lengthBars) || other.lengthBars == _this.lengthBars)&&(identical(other.track, _this.track) || other.track == _this.track)&&(identical(other.startStep, _this.startStep) || other.startStep == _this.startStep));
}


@override
int get hashCode {
  final _this = this as StudioClip;
  return Object.hash(runtimeType,_this.patternId,_this.sampleId,_this.lengthBars,_this.track,_this.startStep);
}

@override
String toString() {
  final _this = this as StudioClip;
  return 'StudioClip(patternId: ${_this.patternId}, sampleId: ${_this.sampleId}, lengthBars: ${_this.lengthBars}, track: ${_this.track}, startStep: ${_this.startStep})';
}


}

/// @nodoc
abstract mixin class $StudioClipCopyWith<$Res>  {
  factory $StudioClipCopyWith(StudioClip value, $Res Function(StudioClip) _then) = _$StudioClipCopyWithImpl;
@useResult
$Res call({
 UuidValue? patternId, UuidValue? sampleId, int? lengthBars, int track, int startStep
});




}
/// @nodoc
class _$StudioClipCopyWithImpl<$Res>
    implements $StudioClipCopyWith<$Res> {
  _$StudioClipCopyWithImpl(this._self, this._then);

  final StudioClip _self;
  final $Res Function(StudioClip) _then;

/// Create a copy of StudioClip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patternId = freezed,Object? sampleId = freezed,Object? lengthBars = freezed,Object? track = null,Object? startStep = null,}) {
  return _then(StudioClip(
patternId: freezed == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as UuidValue?,sampleId: freezed == sampleId ? _self.sampleId : sampleId // ignore: cast_nullable_to_non_nullable
as UuidValue?,lengthBars: freezed == lengthBars ? _self.lengthBars : lengthBars // ignore: cast_nullable_to_non_nullable
as int?,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as int,startStep: null == startStep ? _self.startStep : startStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioClip].
extension StudioClipPatterns on StudioClip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioClip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioClip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioClip value)  $default,){
final _that = this;
switch (_that) {
case _StudioClip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioClip value)?  $default,){
final _that = this;
switch (_that) {
case _StudioClip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UuidValue? patternId,  UuidValue? sampleId,  int? lengthBars,  int track,  int startStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioClip() when $default != null:
return $default(_that.patternId,_that.sampleId,_that.lengthBars,_that.track,_that.startStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UuidValue? patternId,  UuidValue? sampleId,  int? lengthBars,  int track,  int startStep)  $default,) {final _that = this;
switch (_that) {
case _StudioClip():
return $default(_that.patternId,_that.sampleId,_that.lengthBars,_that.track,_that.startStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UuidValue? patternId,  UuidValue? sampleId,  int? lengthBars,  int track,  int startStep)?  $default,) {final _that = this;
switch (_that) {
case _StudioClip() when $default != null:
return $default(_that.patternId,_that.sampleId,_that.lengthBars,_that.track,_that.startStep);case _:
  return null;

}
}

}

/// @nodoc


class _StudioClip extends StudioClip {
  const _StudioClip({this.patternId, this.sampleId, this.lengthBars, required this.track, required this.startStep}): super._();
  

/// The pattern it plays (its length is the clip's length).
@override final  UuidValue? patternId;
/// The uploaded sample of an audio clip.
@override final  UuidValue? sampleId;
/// Length of an audio clip in bars.
@override final  int? lengthBars;
/// Playlist track (row), 0-based.
@override final  int track;
/// Start in steps (1/16 notes) from the song start.
@override final  int startStep;

/// Create a copy of StudioClip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioClipCopyWith<_StudioClip> get copyWith => __$StudioClipCopyWithImpl<_StudioClip>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioClip&&(identical(other.patternId, patternId) || other.patternId == patternId)&&(identical(other.sampleId, sampleId) || other.sampleId == sampleId)&&(identical(other.lengthBars, lengthBars) || other.lengthBars == lengthBars)&&(identical(other.track, track) || other.track == track)&&(identical(other.startStep, startStep) || other.startStep == startStep));
}


@override
int get hashCode {
    return Object.hash(runtimeType,patternId,sampleId,lengthBars,track,startStep);
}

@override
String toString() {
    return 'StudioClip(patternId: $patternId, sampleId: $sampleId, lengthBars: $lengthBars, track: $track, startStep: $startStep)';
}


}

/// @nodoc
abstract mixin class _$StudioClipCopyWith<$Res> implements $StudioClipCopyWith<$Res> {
  factory _$StudioClipCopyWith(_StudioClip value, $Res Function(_StudioClip) _then) = __$StudioClipCopyWithImpl;
@override @useResult
$Res call({
 UuidValue? patternId, UuidValue? sampleId, int? lengthBars, int track, int startStep
});




}
/// @nodoc
class __$StudioClipCopyWithImpl<$Res>
    implements _$StudioClipCopyWith<$Res> {
  __$StudioClipCopyWithImpl(this._self, this._then);

  final _StudioClip _self;
  final $Res Function(_StudioClip) _then;

/// Create a copy of StudioClip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patternId = freezed,Object? sampleId = freezed,Object? lengthBars = freezed,Object? track = null,Object? startStep = null,}) {
  return _then(_StudioClip(
patternId: freezed == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as UuidValue?,sampleId: freezed == sampleId ? _self.sampleId : sampleId // ignore: cast_nullable_to_non_nullable
as UuidValue?,lengthBars: freezed == lengthBars ? _self.lengthBars : lengthBars // ignore: cast_nullable_to_non_nullable
as int?,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as int,startStep: null == startStep ? _self.startStep : startStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
