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
import '../../../features/playlist/dtos/clip_input.dart' as _ir99m4um;

/// Replaces the project's whole playlist (owner or write member).
abstract class SavePlaylistRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SavePlaylistRequest._({required this.clips});

  factory SavePlaylistRequest({required List<_ir99m4um.ClipInput> clips}) =
      _SavePlaylistRequestImpl;

  factory SavePlaylistRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavePlaylistRequest(
      clips: _iau3psze.Protocol().deserialize<List<_ir99m4um.ClipInput>>(
        jsonSerialization['clips'],
      ),
    );
  }

  /// All clips (max 2048; clips on one track must not overlap).
  List<_ir99m4um.ClipInput> clips;

  /// Returns a shallow copy of this [SavePlaylistRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SavePlaylistRequest copyWith({List<_ir99m4um.ClipInput>? clips});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavePlaylistRequest',
      'clips': clips.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavePlaylistRequest',
      'clips': clips.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SavePlaylistRequestImpl extends SavePlaylistRequest {
  _SavePlaylistRequestImpl({required List<_ir99m4um.ClipInput> clips})
    : super._(clips: clips);

  /// Returns a shallow copy of this [SavePlaylistRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SavePlaylistRequest copyWith({List<_ir99m4um.ClipInput>? clips}) {
    return SavePlaylistRequest(
      clips: clips ?? this.clips.map((e0) => e0.copyWith()).toList(),
    );
  }
}
