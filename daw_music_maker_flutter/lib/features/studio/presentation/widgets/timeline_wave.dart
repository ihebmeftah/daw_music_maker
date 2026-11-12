import 'dart:math' as math;

import 'package:daw_music_maker_client/daw_music_maker_client.dart';

import '../../../../core/validation/validation_rules.dart';
import '../state/studio_state.dart';

/// One sound in the loop the transport plays: when it starts (in steps from
/// the loop start), how loud it is (0–1) and which built-in sample it is
/// (null for uploaded audio).
typedef TimelineHit = ({double step, double level, SampleKind? sample});

/// Sub-step resolution of [waveformEnvelope] (values per 1/16 step).
const int waveResolution = 8;

/// How fast each sample fades, per step (larger = shorter sound). Uploaded
/// audio (null) is drawn with a long, gentle tail.
double sampleDecay(SampleKind? sample) => switch (sample) {
  null => 0.12,
  SampleKind.kick => 0.45,
  SampleKind.snare => 0.7,
  SampleKind.closedHat => 1.8,
  SampleKind.openHat => 0.3,
};

/// The sounds of what the transport plays, so the timeline wave shows the
/// music instead of the metronome:
/// - pattern mode: the selected pattern's notes,
/// - song mode: every playlist clip's notes at its position.
///
/// Muted channels are left out; level = channel volume × velocity / 127.
List<TimelineHit> timelineHits(StudioState state) {
  final channels = {for (final c in state.channels) c.id: c};
  final hits = <TimelineHit>[];

  void addNotes(UuidValue patternId, double offsetSteps) {
    for (final note in state.notes[patternId] ?? const []) {
      final channel = channels[note.channelId];
      if (channel == null || channel.muted) continue;
      hits.add((
        step: offsetSteps + note.tick / ValidationRules.stepTicks,
        level: channel.volume * note.velocity / 127,
        sample: channel.sample,
      ));
    }
  }

  if (state.mode == TransportMode.song) {
    for (final clip in state.clips) {
      final offset = clip.startStep.toDouble();
      if (clip.patternId case final patternId?) {
        addNotes(patternId, offset);
      } else {
        // An audio clip: its file starts at the clip's first step.
        hits.add((step: offset, level: 0.8, sample: null));
      }
    }
  } else if (state.selectedPattern case final pattern?) {
    addNotes(pattern.id, 0);
  }
  return hits;
}

/// Amplitude (0–1) of the loop at [waveResolution] points per step: every
/// hit starts at its level and decays exponentially; overlapping sounds add
/// up (clamped to 1).
List<double> waveformEnvelope(List<TimelineHit> hits, int totalSteps) {
  final length = totalSteps * waveResolution;
  final envelope = List<double>.filled(length, 0);
  // A hit is inaudible after ~this many steps for its decay.
  for (final hit in hits) {
    final decay = sampleDecay(hit.sample);
    final start = (hit.step * waveResolution).round();
    final span = (6 / decay * waveResolution).ceil();
    for (var i = 0; i < span; i++) {
      final index = start + i;
      if (index < 0 || index >= length) continue;
      envelope[index] += hit.level * math.exp(-decay * i / waveResolution);
    }
  }
  for (var i = 0; i < length; i++) {
    if (envelope[i] > 1) envelope[i] = 1;
  }
  return envelope;
}
