import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/validation/validation_rules.dart';

part 'studio_note.freezed.dart';

/// A note being edited in the studio (no server id: a pattern's notes are
/// saved as a whole list). Times are in ticks (960 per quarter note).
@freezed
abstract class StudioNote with _$StudioNote {
  /// Creates a note.
  const factory StudioNote({
    /// The channel that plays it.
    required UuidValue channelId,

    /// Start in ticks from the start of the pattern.
    required int tick,

    /// Duration in ticks.
    @Default(ValidationRules.stepTicks) int lengthTicks,

    /// MIDI pitch (60 = C5, the sample's original pitch).
    @Default(ValidationRules.rootPitch) int pitch,

    /// MIDI velocity 1–127.
    @Default(ValidationRules.defaultVelocity) int velocity,
  }) = _StudioNote;

  const StudioNote._();

  /// Builds a note from a server response.
  factory StudioNote.fromResponse(NoteResponse note) => StudioNote(
    channelId: note.channelId,
    tick: note.tick,
    lengthTicks: note.lengthTicks,
    pitch: note.pitch,
    velocity: note.velocity,
  );

  /// The step (1/16) this note starts on.
  int get step => tick ~/ ValidationRules.stepTicks;

  /// Whether the note sounds at [atTick] (start inclusive, end exclusive).
  bool covers(int atTick) => atTick >= tick && atTick < tick + lengthTicks;

  /// The request form sent to the server.
  NoteInput toInput() => NoteInput(
    channelId: channelId,
    tick: tick,
    lengthTicks: lengthTicks,
    pitch: pitch,
    velocity: velocity,
  );
}
