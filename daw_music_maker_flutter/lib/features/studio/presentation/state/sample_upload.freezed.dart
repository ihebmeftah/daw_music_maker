// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SampleUpload {

/// Local id of the entry.
 int get id;/// File name.
 String get fileName;/// Share sent so far (0–1).
 double get progress;/// Why the upload failed (shown until dismissed).
 String? get error;/// Server failure, if any.
 Failure? get failure;
/// Create a copy of SampleUpload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleUploadCopyWith<SampleUpload> get copyWith => _$SampleUploadCopyWithImpl<SampleUpload>(this as SampleUpload, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SampleUpload;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleUpload&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as SampleUpload;
  return Object.hash(runtimeType,_this.id,_this.fileName,_this.progress,_this.error,_this.failure);
}

@override
String toString() {
  final _this = this as SampleUpload;
  return 'SampleUpload(id: ${_this.id}, fileName: ${_this.fileName}, progress: ${_this.progress}, error: ${_this.error}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $SampleUploadCopyWith<$Res>  {
  factory $SampleUploadCopyWith(SampleUpload value, $Res Function(SampleUpload) _then) = _$SampleUploadCopyWithImpl;
@useResult
$Res call({
 int id, String fileName, double progress, String? error, Failure? failure
});




}
/// @nodoc
class _$SampleUploadCopyWithImpl<$Res>
    implements $SampleUploadCopyWith<$Res> {
  _$SampleUploadCopyWithImpl(this._self, this._then);

  final SampleUpload _self;
  final $Res Function(SampleUpload) _then;

/// Create a copy of SampleUpload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileName = null,Object? progress = null,Object? error = freezed,Object? failure = freezed,}) {
  return _then(SampleUpload(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SampleUpload].
extension SampleUploadPatterns on SampleUpload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SampleUpload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SampleUpload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SampleUpload value)  $default,){
final _that = this;
switch (_that) {
case _SampleUpload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SampleUpload value)?  $default,){
final _that = this;
switch (_that) {
case _SampleUpload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String fileName,  double progress,  String? error,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SampleUpload() when $default != null:
return $default(_that.id,_that.fileName,_that.progress,_that.error,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String fileName,  double progress,  String? error,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SampleUpload():
return $default(_that.id,_that.fileName,_that.progress,_that.error,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String fileName,  double progress,  String? error,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SampleUpload() when $default != null:
return $default(_that.id,_that.fileName,_that.progress,_that.error,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SampleUpload implements SampleUpload {
  const _SampleUpload({required this.id, required this.fileName, this.progress = 0, this.error, this.failure});
  

/// Local id of the entry.
@override final  int id;
/// File name.
@override final  String fileName;
/// Share sent so far (0–1).
@override@JsonKey() final  double progress;
/// Why the upload failed (shown until dismissed).
@override final  String? error;
/// Server failure, if any.
@override final  Failure? failure;

/// Create a copy of SampleUpload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SampleUploadCopyWith<_SampleUpload> get copyWith => __$SampleUploadCopyWithImpl<_SampleUpload>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SampleUpload&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.error, error) || other.error == error)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fileName,progress,error,failure);
}

@override
String toString() {
    return 'SampleUpload(id: $id, fileName: $fileName, progress: $progress, error: $error, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SampleUploadCopyWith<$Res> implements $SampleUploadCopyWith<$Res> {
  factory _$SampleUploadCopyWith(_SampleUpload value, $Res Function(_SampleUpload) _then) = __$SampleUploadCopyWithImpl;
@override @useResult
$Res call({
 int id, String fileName, double progress, String? error, Failure? failure
});




}
/// @nodoc
class __$SampleUploadCopyWithImpl<$Res>
    implements _$SampleUploadCopyWith<$Res> {
  __$SampleUploadCopyWithImpl(this._self, this._then);

  final _SampleUpload _self;
  final $Res Function(_SampleUpload) _then;

/// Create a copy of SampleUpload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileName = null,Object? progress = null,Object? error = freezed,Object? failure = freezed,}) {
  return _then(_SampleUpload(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
