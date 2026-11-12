import 'package:daw_music_maker/features/studio/data/studio_clip.dart';
import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/presentation/state/studio_state.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/timeline_wave.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';

void main() {
  final introId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ee1');
  final intro = testPattern(id: introId, name: 'Intro', lengthBars: 1);
  final kick = testChannelIds[0];
  final snare = testChannelIds[1];

  StudioState state({
    TransportMode mode = TransportMode.pattern,
    List<ChannelResponse>? channels,
    List<StudioClip> clips = const [],
  }) => StudioState(
    project: testProject(),
    bpm: 120,
    savedBpm: 120,
    patterns: [intro],
    selectedPatternId: introId,
    channels: channels ?? testChannels(),
    mode: mode,
    clips: clips,
    notes: {
      introId: [
        StudioNote(channelId: kick, tick: 0, velocity: 127),
        StudioNote(channelId: snare, tick: 960, velocity: 127),
      ],
    },
  );

  group('Given timelineHits', () {
    test('when in pattern mode, then uses the selected pattern notes', () {
      final hits = timelineHits(state());

      expect(hits.map((h) => h.step), [0, 4]);
      expect(hits.map((h) => h.sample), [SampleKind.kick, SampleKind.snare]);
      // Channel volume 0.8 × full velocity.
      expect(hits.first.level, closeTo(0.8, 1e-9));
    });

    test('when in song mode, then places each clip at its bar', () {
      final hits = timelineHits(
        state(
          mode: TransportMode.song,
          clips: [
            StudioClip(patternId: introId, track: 0, startBar: 0),
            StudioClip(patternId: introId, track: 1, startBar: 2),
          ],
        ),
      );

      expect(hits.map((h) => h.step), [0, 4, 32, 36]);
    });

    test('when the song is empty, then there is nothing to draw', () {
      expect(timelineHits(state(mode: TransportMode.song)), isEmpty);
    });

    test('when a channel is muted, then its notes are left out', () {
      final channels = testChannels();
      channels[0] = channels[0].copyWith(muted: true);

      final hits = timelineHits(state(channels: channels));

      expect(hits.single.sample, SampleKind.snare);
    });
  });

  group('Given waveformEnvelope', () {
    test('when a hit starts, then the wave peaks there and decays', () {
      final env = waveformEnvelope([
        (step: 4, level: 0.8, sample: SampleKind.kick),
      ], 16);

      expect(env, hasLength(16 * waveResolution));
      expect(env[4 * waveResolution], closeTo(0.8, 1e-9));
      expect(env[3 * waveResolution], 0);
      expect(env[6 * waveResolution], lessThan(0.8));
      expect(env[6 * waveResolution], greaterThan(0));
    });

    test('when comparing sounds, then a closed hat is shorter than a kick', () {
      double after(SampleKind sample) => waveformEnvelope([
        (step: 0, level: 1, sample: sample),
      ], 16)[2 * waveResolution];

      expect(after(SampleKind.closedHat), lessThan(after(SampleKind.kick)));
      expect(after(SampleKind.openHat), greaterThan(after(SampleKind.snare)));
    });

    test('when sounds overlap, then they add up but never pass 1', () {
      final env = waveformEnvelope([
        (step: 0, level: 0.7, sample: SampleKind.kick),
        (step: 0, level: 0.7, sample: SampleKind.snare),
      ], 4);

      expect(env.first, 1);
    });

    test('when a hit lies outside the loop, then it is ignored', () {
      final env = waveformEnvelope([
        (step: 20, level: 1, sample: SampleKind.kick),
      ], 16);

      expect(env.every((v) => v == 0), isTrue);
    });
  });
}
