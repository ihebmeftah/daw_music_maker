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
 bool get isSaving;/// Patterns of the project, in order.
 List<PatternResponse> get patterns;/// The pattern being edited / looped.
 UuidValue? get selectedPatternId;/// Whether a pattern change is in flight.
 bool get isPatternBusy;/// Channels of the rack, in order.
 List<ChannelResponse> get channels;/// Notes per pattern id (patterns are loaded on first selection).
 Map<UuidValue, List<StudioNote>> get notes;/// Channel shown in the piano roll.
 UuidValue? get selectedChannelId;/// What the workspace shows.
 StudioWorkspace get workspace;/// Whether note edits are waiting to be saved or being saved.
 bool get notesDirty;/// PAT (loop the pattern) or SONG (play the playlist).
 TransportMode get mode;/// Clips of the playlist.
 List<StudioClip> get clips;/// Audio files uploaded to the project.
 List<SampleResponse> get samples;/// Uploads in progress or failed (until dismissed).
 List<SampleUpload> get uploads;/// Snap grid of the piano roll (where clicks land, new note length).
 GridSnap get pianoRollSnap;/// Snap grid of the playlist (where clips land).
 GridSnap get playlistSnap;/// Whether playlist edits are waiting to be saved.
 bool get playlistDirty;/// Error of the last save.
 Failure? get failure;
/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioStateCopyWith<StudioState> get copyWith => _$StudioStateCopyWithImpl<StudioState>(this as StudioState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StudioState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioState&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.bpm, _this.bpm) || other.bpm == _this.bpm)&&(identical(other.savedBpm, _this.savedBpm) || other.savedBpm == _this.savedBpm)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.isMuted, _this.isMuted) || other.isMuted == _this.isMuted)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&const DeepCollectionEquality().equals(other.patterns, _this.patterns)&&(identical(other.selectedPatternId, _this.selectedPatternId) || other.selectedPatternId == _this.selectedPatternId)&&(identical(other.isPatternBusy, _this.isPatternBusy) || other.isPatternBusy == _this.isPatternBusy)&&const DeepCollectionEquality().equals(other.channels, _this.channels)&&const DeepCollectionEquality().equals(other.notes, _this.notes)&&(identical(other.selectedChannelId, _this.selectedChannelId) || other.selectedChannelId == _this.selectedChannelId)&&(identical(other.workspace, _this.workspace) || other.workspace == _this.workspace)&&(identical(other.notesDirty, _this.notesDirty) || other.notesDirty == _this.notesDirty)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.clips, _this.clips)&&const DeepCollectionEquality().equals(other.samples, _this.samples)&&const DeepCollectionEquality().equals(other.uploads, _this.uploads)&&(identical(other.pianoRollSnap, _this.pianoRollSnap) || other.pianoRollSnap == _this.pianoRollSnap)&&(identical(other.playlistSnap, _this.playlistSnap) || other.playlistSnap == _this.playlistSnap)&&(identical(other.playlistDirty, _this.playlistDirty) || other.playlistDirty == _this.playlistDirty)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as StudioState;
  return Object.hashAll([runtimeType,_this.project,_this.bpm,_this.savedBpm,_this.isPlaying,_this.isMuted,_this.isSaving,const DeepCollectionEquality().hash(_this.patterns),_this.selectedPatternId,_this.isPatternBusy,const DeepCollectionEquality().hash(_this.channels),const DeepCollectionEquality().hash(_this.notes),_this.selectedChannelId,_this.workspace,_this.notesDirty,_this.mode,const DeepCollectionEquality().hash(_this.clips),const DeepCollectionEquality().hash(_this.samples),const DeepCollectionEquality().hash(_this.uploads),_this.pianoRollSnap,_this.playlistSnap,_this.playlistDirty,_this.failure]);
}

@override
String toString() {
  final _this = this as StudioState;
  return 'StudioState(project: ${_this.project}, bpm: ${_this.bpm}, savedBpm: ${_this.savedBpm}, isPlaying: ${_this.isPlaying}, isMuted: ${_this.isMuted}, isSaving: ${_this.isSaving}, patterns: ${_this.patterns}, selectedPatternId: ${_this.selectedPatternId}, isPatternBusy: ${_this.isPatternBusy}, channels: ${_this.channels}, notes: ${_this.notes}, selectedChannelId: ${_this.selectedChannelId}, workspace: ${_this.workspace}, notesDirty: ${_this.notesDirty}, mode: ${_this.mode}, clips: ${_this.clips}, samples: ${_this.samples}, uploads: ${_this.uploads}, pianoRollSnap: ${_this.pianoRollSnap}, playlistSnap: ${_this.playlistSnap}, playlistDirty: ${_this.playlistDirty}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $StudioStateCopyWith<$Res>  {
  factory $StudioStateCopyWith(StudioState value, $Res Function(StudioState) _then) = _$StudioStateCopyWithImpl;
@useResult
$Res call({
 ProjectResponse project, double bpm, double savedBpm, bool isPlaying, bool isMuted, bool isSaving, List<PatternResponse> patterns, UuidValue? selectedPatternId, bool isPatternBusy, List<ChannelResponse> channels, Map<UuidValue, List<StudioNote>> notes, UuidValue? selectedChannelId, StudioWorkspace workspace, bool notesDirty, TransportMode mode, List<StudioClip> clips, List<SampleResponse> samples, List<SampleUpload> uploads, GridSnap pianoRollSnap, GridSnap playlistSnap, bool playlistDirty, Failure? failure
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
@pragma('vm:prefer-inline') @override $Res call({Object? project = null,Object? bpm = null,Object? savedBpm = null,Object? isPlaying = null,Object? isMuted = null,Object? isSaving = null,Object? patterns = null,Object? selectedPatternId = freezed,Object? isPatternBusy = null,Object? channels = null,Object? notes = null,Object? selectedChannelId = freezed,Object? workspace = null,Object? notesDirty = null,Object? mode = null,Object? clips = null,Object? samples = null,Object? uploads = null,Object? pianoRollSnap = null,Object? playlistSnap = null,Object? playlistDirty = null,Object? failure = freezed,}) {
  return _then(StudioState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,bpm: null == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as double,savedBpm: null == savedBpm ? _self.savedBpm : savedBpm // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,patterns: null == patterns ? _self.patterns : patterns // ignore: cast_nullable_to_non_nullable
as List<PatternResponse>,selectedPatternId: freezed == selectedPatternId ? _self.selectedPatternId : selectedPatternId // ignore: cast_nullable_to_non_nullable
as UuidValue?,isPatternBusy: null == isPatternBusy ? _self.isPatternBusy : isPatternBusy // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<ChannelResponse>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as Map<UuidValue, List<StudioNote>>,selectedChannelId: freezed == selectedChannelId ? _self.selectedChannelId : selectedChannelId // ignore: cast_nullable_to_non_nullable
as UuidValue?,workspace: null == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as StudioWorkspace,notesDirty: null == notesDirty ? _self.notesDirty : notesDirty // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransportMode,clips: null == clips ? _self.clips : clips // ignore: cast_nullable_to_non_nullable
as List<StudioClip>,samples: null == samples ? _self.samples : samples // ignore: cast_nullable_to_non_nullable
as List<SampleResponse>,uploads: null == uploads ? _self.uploads : uploads // ignore: cast_nullable_to_non_nullable
as List<SampleUpload>,pianoRollSnap: null == pianoRollSnap ? _self.pianoRollSnap : pianoRollSnap // ignore: cast_nullable_to_non_nullable
as GridSnap,playlistSnap: null == playlistSnap ? _self.playlistSnap : playlistSnap // ignore: cast_nullable_to_non_nullable
as GridSnap,playlistDirty: null == playlistDirty ? _self.playlistDirty : playlistDirty // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  List<PatternResponse> patterns,  UuidValue? selectedPatternId,  bool isPatternBusy,  List<ChannelResponse> channels,  Map<UuidValue, List<StudioNote>> notes,  UuidValue? selectedChannelId,  StudioWorkspace workspace,  bool notesDirty,  TransportMode mode,  List<StudioClip> clips,  List<SampleResponse> samples,  List<SampleUpload> uploads,  GridSnap pianoRollSnap,  GridSnap playlistSnap,  bool playlistDirty,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioState() when $default != null:
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.patterns,_that.selectedPatternId,_that.isPatternBusy,_that.channels,_that.notes,_that.selectedChannelId,_that.workspace,_that.notesDirty,_that.mode,_that.clips,_that.samples,_that.uploads,_that.pianoRollSnap,_that.playlistSnap,_that.playlistDirty,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  List<PatternResponse> patterns,  UuidValue? selectedPatternId,  bool isPatternBusy,  List<ChannelResponse> channels,  Map<UuidValue, List<StudioNote>> notes,  UuidValue? selectedChannelId,  StudioWorkspace workspace,  bool notesDirty,  TransportMode mode,  List<StudioClip> clips,  List<SampleResponse> samples,  List<SampleUpload> uploads,  GridSnap pianoRollSnap,  GridSnap playlistSnap,  bool playlistDirty,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _StudioState():
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.patterns,_that.selectedPatternId,_that.isPatternBusy,_that.channels,_that.notes,_that.selectedChannelId,_that.workspace,_that.notesDirty,_that.mode,_that.clips,_that.samples,_that.uploads,_that.pianoRollSnap,_that.playlistSnap,_that.playlistDirty,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse project,  double bpm,  double savedBpm,  bool isPlaying,  bool isMuted,  bool isSaving,  List<PatternResponse> patterns,  UuidValue? selectedPatternId,  bool isPatternBusy,  List<ChannelResponse> channels,  Map<UuidValue, List<StudioNote>> notes,  UuidValue? selectedChannelId,  StudioWorkspace workspace,  bool notesDirty,  TransportMode mode,  List<StudioClip> clips,  List<SampleResponse> samples,  List<SampleUpload> uploads,  GridSnap pianoRollSnap,  GridSnap playlistSnap,  bool playlistDirty,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _StudioState() when $default != null:
return $default(_that.project,_that.bpm,_that.savedBpm,_that.isPlaying,_that.isMuted,_that.isSaving,_that.patterns,_that.selectedPatternId,_that.isPatternBusy,_that.channels,_that.notes,_that.selectedChannelId,_that.workspace,_that.notesDirty,_that.mode,_that.clips,_that.samples,_that.uploads,_that.pianoRollSnap,_that.playlistSnap,_that.playlistDirty,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _StudioState extends StudioState {
  const _StudioState({required this.project, required this.bpm, required this.savedBpm, this.isPlaying = false, this.isMuted = false, this.isSaving = false,  List<PatternResponse> patterns = const <PatternResponse>[], this.selectedPatternId, this.isPatternBusy = false,  List<ChannelResponse> channels = const <ChannelResponse>[],  Map<UuidValue, List<StudioNote>> notes = const <UuidValue, List<StudioNote>>{}, this.selectedChannelId, this.workspace = StudioWorkspace.channelRack, this.notesDirty = false, this.mode = TransportMode.pattern,  List<StudioClip> clips = const <StudioClip>[],  List<SampleResponse> samples = const <SampleResponse>[],  List<SampleUpload> uploads = const <SampleUpload>[], this.pianoRollSnap = GridSnap.step, this.playlistSnap = GridSnap.bar, this.playlistDirty = false, this.failure}): _patterns = patterns,_channels = channels,_notes = notes,_clips = clips,_samples = samples,_uploads = uploads,super._();
  

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
/// Patterns of the project, in order.
 final  List<PatternResponse> _patterns;
/// Patterns of the project, in order.
@override@JsonKey() List<PatternResponse> get patterns {
  if (_patterns is EqualUnmodifiableListView) return _patterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_patterns);
}

/// The pattern being edited / looped.
@override final  UuidValue? selectedPatternId;
/// Whether a pattern change is in flight.
@override@JsonKey() final  bool isPatternBusy;
/// Channels of the rack, in order.
 final  List<ChannelResponse> _channels;
/// Channels of the rack, in order.
@override@JsonKey() List<ChannelResponse> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

/// Notes per pattern id (patterns are loaded on first selection).
 final  Map<UuidValue, List<StudioNote>> _notes;
/// Notes per pattern id (patterns are loaded on first selection).
@override@JsonKey() Map<UuidValue, List<StudioNote>> get notes {
  if (_notes is EqualUnmodifiableMapView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_notes);
}

/// Channel shown in the piano roll.
@override final  UuidValue? selectedChannelId;
/// What the workspace shows.
@override@JsonKey() final  StudioWorkspace workspace;
/// Whether note edits are waiting to be saved or being saved.
@override@JsonKey() final  bool notesDirty;
/// PAT (loop the pattern) or SONG (play the playlist).
@override@JsonKey() final  TransportMode mode;
/// Clips of the playlist.
 final  List<StudioClip> _clips;
/// Clips of the playlist.
@override@JsonKey() List<StudioClip> get clips {
  if (_clips is EqualUnmodifiableListView) return _clips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clips);
}

/// Audio files uploaded to the project.
 final  List<SampleResponse> _samples;
/// Audio files uploaded to the project.
@override@JsonKey() List<SampleResponse> get samples {
  if (_samples is EqualUnmodifiableListView) return _samples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_samples);
}

/// Uploads in progress or failed (until dismissed).
 final  List<SampleUpload> _uploads;
/// Uploads in progress or failed (until dismissed).
@override@JsonKey() List<SampleUpload> get uploads {
  if (_uploads is EqualUnmodifiableListView) return _uploads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploads);
}

/// Snap grid of the piano roll (where clicks land, new note length).
@override@JsonKey() final  GridSnap pianoRollSnap;
/// Snap grid of the playlist (where clips land).
@override@JsonKey() final  GridSnap playlistSnap;
/// Whether playlist edits are waiting to be saved.
@override@JsonKey() final  bool playlistDirty;
/// Error of the last save.
@override final  Failure? failure;

/// Create a copy of StudioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioStateCopyWith<_StudioState> get copyWith => __$StudioStateCopyWithImpl<_StudioState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioState&&(identical(other.project, project) || other.project == project)&&(identical(other.bpm, bpm) || other.bpm == bpm)&&(identical(other.savedBpm, savedBpm) || other.savedBpm == savedBpm)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&const DeepCollectionEquality().equals(other.patterns, _patterns)&&(identical(other.selectedPatternId, selectedPatternId) || other.selectedPatternId == selectedPatternId)&&(identical(other.isPatternBusy, isPatternBusy) || other.isPatternBusy == isPatternBusy)&&const DeepCollectionEquality().equals(other.channels, _channels)&&const DeepCollectionEquality().equals(other.notes, _notes)&&(identical(other.selectedChannelId, selectedChannelId) || other.selectedChannelId == selectedChannelId)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.notesDirty, notesDirty) || other.notesDirty == notesDirty)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.clips, _clips)&&const DeepCollectionEquality().equals(other.samples, _samples)&&const DeepCollectionEquality().equals(other.uploads, _uploads)&&(identical(other.pianoRollSnap, pianoRollSnap) || other.pianoRollSnap == pianoRollSnap)&&(identical(other.playlistSnap, playlistSnap) || other.playlistSnap == playlistSnap)&&(identical(other.playlistDirty, playlistDirty) || other.playlistDirty == playlistDirty)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,project,bpm,savedBpm,isPlaying,isMuted,isSaving,const DeepCollectionEquality().hash(_patterns),selectedPatternId,isPatternBusy,const DeepCollectionEquality().hash(_channels),const DeepCollectionEquality().hash(_notes),selectedChannelId,workspace,notesDirty,mode,const DeepCollectionEquality().hash(_clips),const DeepCollectionEquality().hash(_samples),const DeepCollectionEquality().hash(_uploads),pianoRollSnap,playlistSnap,playlistDirty,failure]);
}

@override
String toString() {
    return 'StudioState(project: $project, bpm: $bpm, savedBpm: $savedBpm, isPlaying: $isPlaying, isMuted: $isMuted, isSaving: $isSaving, patterns: $patterns, selectedPatternId: $selectedPatternId, isPatternBusy: $isPatternBusy, channels: $channels, notes: $notes, selectedChannelId: $selectedChannelId, workspace: $workspace, notesDirty: $notesDirty, mode: $mode, clips: $clips, samples: $samples, uploads: $uploads, pianoRollSnap: $pianoRollSnap, playlistSnap: $playlistSnap, playlistDirty: $playlistDirty, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$StudioStateCopyWith<$Res> implements $StudioStateCopyWith<$Res> {
  factory _$StudioStateCopyWith(_StudioState value, $Res Function(_StudioState) _then) = __$StudioStateCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse project, double bpm, double savedBpm, bool isPlaying, bool isMuted, bool isSaving, List<PatternResponse> patterns, UuidValue? selectedPatternId, bool isPatternBusy, List<ChannelResponse> channels, Map<UuidValue, List<StudioNote>> notes, UuidValue? selectedChannelId, StudioWorkspace workspace, bool notesDirty, TransportMode mode, List<StudioClip> clips, List<SampleResponse> samples, List<SampleUpload> uploads, GridSnap pianoRollSnap, GridSnap playlistSnap, bool playlistDirty, Failure? failure
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
@override @pragma('vm:prefer-inline') $Res call({Object? project = null,Object? bpm = null,Object? savedBpm = null,Object? isPlaying = null,Object? isMuted = null,Object? isSaving = null,Object? patterns = null,Object? selectedPatternId = freezed,Object? isPatternBusy = null,Object? channels = null,Object? notes = null,Object? selectedChannelId = freezed,Object? workspace = null,Object? notesDirty = null,Object? mode = null,Object? clips = null,Object? samples = null,Object? uploads = null,Object? pianoRollSnap = null,Object? playlistSnap = null,Object? playlistDirty = null,Object? failure = freezed,}) {
  return _then(_StudioState(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,bpm: null == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as double,savedBpm: null == savedBpm ? _self.savedBpm : savedBpm // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,patterns: null == patterns ? _self._patterns : patterns // ignore: cast_nullable_to_non_nullable
as List<PatternResponse>,selectedPatternId: freezed == selectedPatternId ? _self.selectedPatternId : selectedPatternId // ignore: cast_nullable_to_non_nullable
as UuidValue?,isPatternBusy: null == isPatternBusy ? _self.isPatternBusy : isPatternBusy // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<ChannelResponse>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as Map<UuidValue, List<StudioNote>>,selectedChannelId: freezed == selectedChannelId ? _self.selectedChannelId : selectedChannelId // ignore: cast_nullable_to_non_nullable
as UuidValue?,workspace: null == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as StudioWorkspace,notesDirty: null == notesDirty ? _self.notesDirty : notesDirty // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransportMode,clips: null == clips ? _self._clips : clips // ignore: cast_nullable_to_non_nullable
as List<StudioClip>,samples: null == samples ? _self._samples : samples // ignore: cast_nullable_to_non_nullable
as List<SampleResponse>,uploads: null == uploads ? _self._uploads : uploads // ignore: cast_nullable_to_non_nullable
as List<SampleUpload>,pianoRollSnap: null == pianoRollSnap ? _self.pianoRollSnap : pianoRollSnap // ignore: cast_nullable_to_non_nullable
as GridSnap,playlistSnap: null == playlistSnap ? _self.playlistSnap : playlistSnap // ignore: cast_nullable_to_non_nullable
as GridSnap,playlistDirty: null == playlistDirty ? _self.playlistDirty : playlistDirty // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
