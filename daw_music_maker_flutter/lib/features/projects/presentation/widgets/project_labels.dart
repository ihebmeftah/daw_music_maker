import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

/// Display labels for [ProjectRole].
extension ProjectRoleLabel on ProjectRole {
  /// Short label.
  String get label => switch (this) {
    ProjectRole.read => 'Read',
    ProjectRole.write => 'Write',
  };

  /// One-line explanation.
  String get description => switch (this) {
    ProjectRole.read => 'Can open and listen to the project',
    ProjectRole.write => 'Can also edit the project and its details',
  };

  /// Icon.
  IconData get icon => switch (this) {
    ProjectRole.read => Icons.headphones_rounded,
    ProjectRole.write => Icons.edit_note_rounded,
  };
}

/// Display labels for [ProjectVisibility].
extension ProjectVisibilityLabel on ProjectVisibility {
  /// Short label.
  String get label => switch (this) {
    ProjectVisibility.private => 'Private',
    ProjectVisibility.public => 'Public',
  };

  /// Icon.
  IconData get icon => switch (this) {
    ProjectVisibility.private => Icons.lock_outline_rounded,
    ProjectVisibility.public => Icons.public_rounded,
  };
}

/// Display labels for [ProjectAccess].
extension ProjectAccessLabel on ProjectAccess {
  /// Upper-case badge text.
  String get badge => switch (this) {
    ProjectAccess.owner => 'OWNER',
    ProjectAccess.write => 'WRITE',
    ProjectAccess.read => 'READ',
    ProjectAccess.none => 'VISITOR',
  };
}
