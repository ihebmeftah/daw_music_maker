import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/audio/audio_providers.dart';
import '../../../../core/audio/metronome.dart';
import '../../../../core/audio/tap_tempo.dart';
import '../../../../core/audio/transport_position.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../data/studio_providers.dart';
import '../state/studio_state.dart';

part 'studio_view_model.g.dart';

/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.
@riverpod
class StudioViewModel extends _$StudioViewModel {
  final TapTempo _tapTempo = TapTempo();
  bool _resaveRequested = false;

  Metronome get _metronome => ref.read(metronomeProvider);

  @override
  Future<StudioState> build(UuidValue projectId) async {
    // Watching keeps one metronome alive for this screen; it is disposed
    // (and stops) together with the ViewModel.
    final metronome = ref.watch(metronomeProvider);
    ref.onDispose(metronome.stop);
    try {
      final project = await ref
          .read(studioRepositoryProvider)
          .loadProject(projectId);
      metronome.bpm = project.bpm;
      return StudioState(
        project: project,
        bpm: project.bpm,
        savedBpm: project.bpm,
      );
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  /// The beat currently playing (0-based in the bar), null when stopped.
  ValueListenable<int?> get beat => _metronome.beat;

  /// Live playback position (for the playhead), sampled at frame rate.
  TransportPosition get position => _metronome;

  /// Mutes or unmutes the metronome clicks; playback keeps running.
  void toggleMute() {
    final current = state.value;
    if (current == null) return;
    final muted = !current.isMuted;
    _metronome.muted = muted;
    state = AsyncData(current.copyWith(isMuted: muted));
  }

  /// Clamps [bpm] to the allowed range and rounds it to 2 decimals.
  static double normalize(double bpm) =>
      (bpm.clamp(ValidationRules.bpmMin, ValidationRules.bpmMax) * 100)
          .roundToDouble() /
      100;

  /// Changes the tempo locally (heard immediately). Call [save] to persist.
  /// Ignored for read-only users.
  void setBpm(double bpm) {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    final value = normalize(bpm);
    _metronome.bpm = value;
    state = AsyncData(current.copyWith(bpm: value, failure: null));
  }

  /// Changes the tempo by [delta] BPM without saving — used while the user
  /// holds the BPM display and scrolls or drags; [save] runs on release.
  void adjust(double delta) {
    final current = state.value;
    if (current == null) return;
    setBpm(current.bpm + delta);
  }

  /// Changes the tempo by [delta] BPM and saves it.
  Future<void> nudge(double delta) async {
    final current = state.value;
    if (current == null) return;
    setBpm(current.bpm + delta);
    await save();
  }

  /// Registers a tap; after two taps the tempo follows the tapping and is
  /// saved.
  Future<void> tap() async {
    final bpm = _tapTempo.tap();
    if (bpm == null) return;
    setBpm(bpm);
    await save();
  }

  /// Starts or stops the metronome at the current tempo.
  Future<void> togglePlay() async {
    final current = state.value;
    if (current == null) return;
    if (current.isPlaying) {
      _metronome.stop();
      state = AsyncData(current.copyWith(isPlaying: false));
    } else {
      state = AsyncData(current.copyWith(isPlaying: true));
      await _metronome.start(current.bpm);
    }
  }

  /// Persists the current tempo if it changed. While a save is in flight,
  /// one more save is queued so the last value always wins.
  Future<void> save() async {
    final current = state.value;
    if (current == null || !current.canEdit || !current.isDirty) return;
    if (current.isSaving) {
      _resaveRequested = true;
      return;
    }
    state = AsyncData(current.copyWith(isSaving: true, failure: null));
    try {
      final saved = await ref
          .read(studioRepositoryProvider)
          .saveTempo(projectId, current.bpm);
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isSaving: false,
          savedBpm: saved.bpm,
          project: saved,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isSaving: false,
          failure: mapGenericError(error),
        ),
      );
      _resaveRequested = false;
      return;
    }
    if (_resaveRequested) {
      _resaveRequested = false;
      await save();
    }
  }
}
