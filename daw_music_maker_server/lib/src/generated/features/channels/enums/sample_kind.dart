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
import 'package:serverpod/serverpod.dart' as _is;

/// Built-in samples a channel can play (bundled with the app).
enum SampleKind implements _is.SerializableModel {
  /// Kick drum.
  kick,

  /// Snare drum.
  snare,

  /// Closed hi-hat.
  closedHat,

  /// Open hi-hat.
  openHat;

  static SampleKind fromJson(String name) {
    switch (name) {
      case 'kick':
        return SampleKind.kick;
      case 'snare':
        return SampleKind.snare;
      case 'closedHat':
        return SampleKind.closedHat;
      case 'openHat':
        return SampleKind.openHat;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SampleKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
