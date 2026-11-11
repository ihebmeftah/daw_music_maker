// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectListState {

/// Projects loaded so far.
 List<ProjectResponse> get items;/// Whether another page can be loaded.
 bool get hasMore;/// Whether the next page is loading.
 bool get isLoadingMore;/// Current discover search query (empty = no filter).
 String get query;/// Error of the last "load more" attempt.
 Failure? get loadMoreFailure;
/// Create a copy of ProjectListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectListStateCopyWith<ProjectListState> get copyWith => _$ProjectListStateCopyWithImpl<ProjectListState>(this as ProjectListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProjectListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectListState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.loadMoreFailure, _this.loadMoreFailure) || other.loadMoreFailure == _this.loadMoreFailure));
}


@override
int get hashCode {
  final _this = this as ProjectListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.hasMore,_this.isLoadingMore,_this.query,_this.loadMoreFailure);
}

@override
String toString() {
  final _this = this as ProjectListState;
  return 'ProjectListState(items: ${_this.items}, hasMore: ${_this.hasMore}, isLoadingMore: ${_this.isLoadingMore}, query: ${_this.query}, loadMoreFailure: ${_this.loadMoreFailure})';
}


}

/// @nodoc
abstract mixin class $ProjectListStateCopyWith<$Res>  {
  factory $ProjectListStateCopyWith(ProjectListState value, $Res Function(ProjectListState) _then) = _$ProjectListStateCopyWithImpl;
@useResult
$Res call({
 List<ProjectResponse> items, bool hasMore, bool isLoadingMore, String query, Failure? loadMoreFailure
});




}
/// @nodoc
class _$ProjectListStateCopyWithImpl<$Res>
    implements $ProjectListStateCopyWith<$Res> {
  _$ProjectListStateCopyWithImpl(this._self, this._then);

  final ProjectListState _self;
  final $Res Function(ProjectListState) _then;

/// Create a copy of ProjectListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasMore = null,Object? isLoadingMore = null,Object? query = null,Object? loadMoreFailure = freezed,}) {
  return _then(ProjectListState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectResponse>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectListState].
extension ProjectListStatePatterns on ProjectListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectListState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectListState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectResponse> items,  bool hasMore,  bool isLoadingMore,  String query,  Failure? loadMoreFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectListState() when $default != null:
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.query,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectResponse> items,  bool hasMore,  bool isLoadingMore,  String query,  Failure? loadMoreFailure)  $default,) {final _that = this;
switch (_that) {
case _ProjectListState():
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.query,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectResponse> items,  bool hasMore,  bool isLoadingMore,  String query,  Failure? loadMoreFailure)?  $default,) {final _that = this;
switch (_that) {
case _ProjectListState() when $default != null:
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.query,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectListState implements ProjectListState {
  const _ProjectListState({ List<ProjectResponse> items = const <ProjectResponse>[], this.hasMore = false, this.isLoadingMore = false, this.query = '', this.loadMoreFailure}): _items = items;
  

/// Projects loaded so far.
 final  List<ProjectResponse> _items;
/// Projects loaded so far.
@override@JsonKey() List<ProjectResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Whether another page can be loaded.
@override@JsonKey() final  bool hasMore;
/// Whether the next page is loading.
@override@JsonKey() final  bool isLoadingMore;
/// Current discover search query (empty = no filter).
@override@JsonKey() final  String query;
/// Error of the last "load more" attempt.
@override final  Failure? loadMoreFailure;

/// Create a copy of ProjectListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectListStateCopyWith<_ProjectListState> get copyWith => __$ProjectListStateCopyWithImpl<_ProjectListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectListState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,isLoadingMore,query,loadMoreFailure);
}

@override
String toString() {
    return 'ProjectListState(items: $items, hasMore: $hasMore, isLoadingMore: $isLoadingMore, query: $query, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class _$ProjectListStateCopyWith<$Res> implements $ProjectListStateCopyWith<$Res> {
  factory _$ProjectListStateCopyWith(_ProjectListState value, $Res Function(_ProjectListState) _then) = __$ProjectListStateCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectResponse> items, bool hasMore, bool isLoadingMore, String query, Failure? loadMoreFailure
});




}
/// @nodoc
class __$ProjectListStateCopyWithImpl<$Res>
    implements _$ProjectListStateCopyWith<$Res> {
  __$ProjectListStateCopyWithImpl(this._self, this._then);

  final _ProjectListState _self;
  final $Res Function(_ProjectListState) _then;

/// Create a copy of ProjectListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? isLoadingMore = null,Object? query = null,Object? loadMoreFailure = freezed,}) {
  return _then(_ProjectListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectResponse>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
