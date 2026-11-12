// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudioNote {

/// The channel that plays it.
 UuidValue get channelId;/// Start in ticks from the start of the pattern.
 int get tick;/// Duration in ticks.
 int get lengthTicks;/// MIDI pitch (60 = C5, the sample's original pitch).
 int get pitch;/// MIDI velocity 1–127.
 int get velocity;
/// Create a copy of StudioNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioNoteCopyWith<StudioNote> get copyWith => _$StudioNoteCopyWithImpl<StudioNote>(this as StudioNote, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StudioNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioNote&&(identical(other.channelId, _this.channelId) || other.channelId == _this.channelId)&&(identical(other.tick, _this.tick) || other.tick == _this.tick)&&(identical(other.lengthTicks, _this.lengthTicks) || other.lengthTicks == _this.lengthTicks)&&(identical(other.pitch, _this.pitch) || other.pitch == _this.pitch)&&(identical(other.velocity, _this.velocity) || other.velocity == _this.velocity));
}


@override
int get hashCode {
  final _this = this as StudioNote;
  return Object.hash(runtimeType,_this.channelId,_this.tick,_this.lengthTicks,_this.pitch,_this.velocity);
}

@override
String toString() {
  final _this = this as StudioNote;
  return 'StudioNote(channelId: ${_this.channelId}, tick: ${_this.tick}, lengthTicks: ${_this.lengthTicks}, pitch: ${_this.pitch}, velocity: ${_this.velocity})';
}


}

/// @nodoc
abstract mixin class $StudioNoteCopyWith<$Res>  {
  factory $StudioNoteCopyWith(StudioNote value, $Res Function(StudioNote) _then) = _$StudioNoteCopyWithImpl;
@useResult
$Res call({
 UuidValue channelId, int tick, int lengthTicks, int pitch, int velocity
});




}
/// @nodoc
class _$StudioNoteCopyWithImpl<$Res>
    implements $StudioNoteCopyWith<$Res> {
  _$StudioNoteCopyWithImpl(this._self, this._then);

  final StudioNote _self;
  final $Res Function(StudioNote) _then;

/// Create a copy of StudioNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelId = null,Object? tick = null,Object? lengthTicks = null,Object? pitch = null,Object? velocity = null,}) {
  return _then(StudioNote(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as UuidValue,tick: null == tick ? _self.tick : tick // ignore: cast_nullable_to_non_nullable
as int,lengthTicks: null == lengthTicks ? _self.lengthTicks : lengthTicks // ignore: cast_nullable_to_non_nullable
as int,pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int,velocity: null == velocity ? _self.velocity : velocity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioNote].
extension StudioNotePatterns on StudioNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioNote value)  $default,){
final _that = this;
switch (_that) {
case _StudioNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioNote value)?  $default,){
final _that = this;
switch (_that) {
case _StudioNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UuidValue channelId,  int tick,  int lengthTicks,  int pitch,  int velocity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioNote() when $default != null:
return $default(_that.channelId,_that.tick,_that.lengthTicks,_that.pitch,_that.velocity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UuidValue channelId,  int tick,  int lengthTicks,  int pitch,  int velocity)  $default,) {final _that = this;
switch (_that) {
case _StudioNote():
return $default(_that.channelId,_that.tick,_that.lengthTicks,_that.pitch,_that.velocity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UuidValue channelId,  int tick,  int lengthTicks,  int pitch,  int velocity)?  $default,) {final _that = this;
switch (_that) {
case _StudioNote() when $default != null:
return $default(_that.channelId,_that.tick,_that.lengthTicks,_that.pitch,_that.velocity);case _:
  return null;

}
}

}

/// @nodoc


class _StudioNote extends StudioNote {
  const _StudioNote({required this.channelId, required this.tick, this.lengthTicks = ValidationRules.stepTicks, this.pitch = ValidationRules.rootPitch, this.velocity = ValidationRules.defaultVelocity}): super._();
  

/// The channel that plays it.
@override final  UuidValue channelId;
/// Start in ticks from the start of the pattern.
@override final  int tick;
/// Duration in ticks.
@override@JsonKey() final  int lengthTicks;
/// MIDI pitch (60 = C5, the sample's original pitch).
@override@JsonKey() final  int pitch;
/// MIDI velocity 1–127.
@override@JsonKey() final  int velocity;

/// Create a copy of StudioNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioNoteCopyWith<_StudioNote> get copyWith => __$StudioNoteCopyWithImpl<_StudioNote>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioNote&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.tick, tick) || other.tick == tick)&&(identical(other.lengthTicks, lengthTicks) || other.lengthTicks == lengthTicks)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.velocity, velocity) || other.velocity == velocity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,channelId,tick,lengthTicks,pitch,velocity);
}

@override
String toString() {
    return 'StudioNote(channelId: $channelId, tick: $tick, lengthTicks: $lengthTicks, pitch: $pitch, velocity: $velocity)';
}


}

/// @nodoc
abstract mixin class _$StudioNoteCopyWith<$Res> implements $StudioNoteCopyWith<$Res> {
  factory _$StudioNoteCopyWith(_StudioNote value, $Res Function(_StudioNote) _then) = __$StudioNoteCopyWithImpl;
@override @useResult
$Res call({
 UuidValue channelId, int tick, int lengthTicks, int pitch, int velocity
});




}
/// @nodoc
class __$StudioNoteCopyWithImpl<$Res>
    implements _$StudioNoteCopyWith<$Res> {
  __$StudioNoteCopyWithImpl(this._self, this._then);

  final _StudioNote _self;
  final $Res Function(_StudioNote) _then;

/// Create a copy of StudioNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelId = null,Object? tick = null,Object? lengthTicks = null,Object? pitch = null,Object? velocity = null,}) {
  return _then(_StudioNote(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as UuidValue,tick: null == tick ? _self.tick : tick // ignore: cast_nullable_to_non_nullable
as int,lengthTicks: null == lengthTicks ? _self.lengthTicks : lengthTicks // ignore: cast_nullable_to_non_nullable
as int,pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int,velocity: null == velocity ? _self.velocity : velocity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
