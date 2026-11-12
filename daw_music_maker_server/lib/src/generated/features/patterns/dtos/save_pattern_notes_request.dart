/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:daw_music_maker_server/src/generated/protocol.dart'
    as _iau3psze;
import 'package:serverpod/serverpod.dart' as _is;
import '../../../features/patterns/dtos/note_input.dart' as _ihyzbelf;

/// Replaces all notes of a pattern at once (owner or write member).
abstract class SavePatternNotesRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SavePatternNotesRequest._({required this.notes});

  factory SavePatternNotesRequest({required List<_ihyzbelf.NoteInput> notes}) =
      _SavePatternNotesRequestImpl;

  factory SavePatternNotesRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SavePatternNotesRequest(
      notes: _iau3psze.Protocol().deserialize<List<_ihyzbelf.NoteInput>>(
        jsonSerialization['notes'],
      ),
    );
  }

  /// The pattern's complete note list (max 4096).
  List<_ihyzbelf.NoteInput> notes;

  /// Returns a shallow copy of this [SavePatternNotesRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SavePatternNotesRequest copyWith({List<_ihyzbelf.NoteInput>? notes});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavePatternNotesRequest',
      'notes': notes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavePatternNotesRequest',
      'notes': notes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SavePatternNotesRequestImpl extends SavePatternNotesRequest {
  _SavePatternNotesRequestImpl({required List<_ihyzbelf.NoteInput> notes})
    : super._(notes: notes);

  /// Returns a shallow copy of this [SavePatternNotesRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SavePatternNotesRequest copyWith({List<_ihyzbelf.NoteInput>? notes}) {
    return SavePatternNotesRequest(
      notes: notes ?? this.notes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
