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

/// Permission granted to a project member (also requested by invitations and
/// join requests).
enum ProjectRole implements _is.SerializableModel {
  /// Can view the project.
  read,

  /// Can view and edit the project's content and details (not visibility,
  /// contributions or membership, which stay with the owner).
  write;

  static ProjectRole fromJson(String name) {
    switch (name) {
      case 'read':
        return ProjectRole.read;
      case 'write':
        return ProjectRole.write;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ProjectRole"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
