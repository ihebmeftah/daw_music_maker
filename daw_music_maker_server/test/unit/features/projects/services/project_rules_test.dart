import 'package:daw_music_maker_server/src/core/validation/validation_rules.dart';
import 'package:daw_music_maker_server/src/features/projects/services/project_rules.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

Matcher _validationError(String field) => isA<AppException>()
    .having((e) => e.code, 'code', ErrorCode.validation)
    .having((e) => e.fieldErrors?.containsKey(field), 'has $field', isTrue);

ProjectDetails _validate({
  String name = 'Night Drive',
  String description = '',
  List<String> genres = const [],
}) => ProjectRules.validateDetails(
  name: name,
  description: description,
  genres: genres,
  visibility: ProjectVisibility.private,
  allowContributions: false,
);

Project _project({
  ProjectVisibility visibility = ProjectVisibility.private,
  bool allowContributions = false,
}) => Project(
  ownerId: UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e5f'),
  name: 'P',
  genres: const [],
  visibility: visibility,
  allowContributions: allowContributions,
);

void main() {
  group('Given ProjectRules.validateDetails', () {
    test('when the name is blank, then a name error is thrown', () {
      expect(() => _validate(name: '   '), throwsA(_validationError('name')));
    });

    test('when the name is too long, then a name error is thrown', () {
      final name = 'a' * (ValidationRules.projectNameMaxLength + 1);
      expect(() => _validate(name: name), throwsA(_validationError('name')));
    });

    test('when the name is exactly the maximum, then it is accepted', () {
      final name = 'a' * ValidationRules.projectNameMaxLength;
      expect(_validate(name: name).name, name);
    });

    test('when fields have surrounding whitespace, then they are trimmed', () {
      final details = _validate(name: '  Night Drive ', description: ' dub ');
      expect(details.name, 'Night Drive');
      expect(details.description, 'dub');
    });

    test(
      'when the description is too long, then a description error is thrown',
      () {
        final description =
            'a' * (ValidationRules.projectDescriptionMaxLength + 1);
        expect(
          () => _validate(description: description),
          throwsA(_validationError('description')),
        );
      },
    );

    test(
      'when there are more than 8 genres, then a genres error is thrown',
      () {
        final genres = [for (var i = 0; i < 9; i++) 'g$i'];
        expect(
          () => _validate(genres: genres),
          throwsA(_validationError('genres')),
        );
      },
    );

    test('when a genre is too long, then a genres error is thrown', () {
      final genres = ['a' * (ValidationRules.genreMaxLength + 1)];
      expect(
        () => _validate(genres: genres),
        throwsA(_validationError('genres')),
      );
    });

    test(
      'when genres repeat case-insensitively, then they are trimmed and deduplicated',
      () {
        final details = _validate(
          genres: [' Techno ', 'techno', 'House', '', '  '],
        );
        expect(details.genres, ['Techno', 'House']);
      },
    );

    test(
      'when 9 genres collapse to 8 after dedupe, then they are accepted',
      () {
        final genres = [for (var i = 0; i < 8; i++) 'g$i', 'G0'];
        expect(_validate(genres: genres).genres, hasLength(8));
      },
    );

    test('when several fields are invalid, then all errors are reported', () {
      expect(
        () => _validate(name: '', genres: ['a' * 30]),
        throwsA(
          isA<AppException>().having(
            (e) => e.fieldErrors?.keys.toSet(),
            'fields',
            {'name', 'genres'},
          ),
        ),
      );
    });
  });

  group('Given ProjectRules.validateEmail', () {
    test('when valid, then it is trimmed and lower-cased', () {
      expect(ProjectRules.validateEmail('  Bob@Studio.FM '), 'bob@studio.fm');
    });

    test('when empty or malformed, then an email error is thrown', () {
      expect(
        () => ProjectRules.validateEmail(' '),
        throwsA(_validationError('email')),
      );
      expect(
        () => ProjectRules.validateEmail('bob@studio'),
        throwsA(_validationError('email')),
      );
      expect(
        () => ProjectRules.validateEmail('${'a' * 250}@b.fm'),
        throwsA(_validationError('email')),
      );
    });
  });

  group('Given ProjectRules.normalizeQuery', () {
    test('when null or blank, then returns null', () {
      expect(ProjectRules.normalizeQuery(null), isNull);
      expect(ProjectRules.normalizeQuery('   '), isNull);
    });

    test('when padded, then trims it', () {
      expect(ProjectRules.normalizeQuery('  dub '), 'dub');
    });

    test('when too long, then caps its length', () {
      final q = ProjectRules.normalizeQuery('a' * 200)!;
      expect(q, hasLength(ValidationRules.searchQueryMaxLength));
    });
  });

  group('Given ProjectRules.escapeLike', () {
    test('when the text has LIKE wildcards, then they are escaped', () {
      expect(ProjectRules.escapeLike(r'50%_off\x'), r'50\%\_off\\x');
    });

    test('when the text is plain, then it is unchanged', () {
      expect(ProjectRules.escapeLike('night drive'), 'night drive');
    });
  });

  group('Given ProjectRules.canEditDetails', () {
    test('when owner or writer, then may edit; reader or viewer may not', () {
      expect(ProjectRules.canEditDetails(ProjectAccess.owner), isTrue);
      expect(ProjectRules.canEditDetails(ProjectAccess.write), isTrue);
      expect(ProjectRules.canEditDetails(ProjectAccess.read), isFalse);
      expect(ProjectRules.canEditDetails(ProjectAccess.none), isFalse);
    });
  });

  group('Given ProjectRules.changesOwnerSettings', () {
    final project = _project();

    test('when only details change, then returns false', () {
      final details = _validate(name: 'Other');
      expect(ProjectRules.changesOwnerSettings(project, details), isFalse);
    });

    test('when visibility or contributions change, then returns true', () {
      ProjectDetails details({ProjectVisibility? v, bool? c}) =>
          ProjectRules.validateDetails(
            name: 'P',
            description: '',
            genres: const [],
            visibility: v ?? ProjectVisibility.private,
            allowContributions: c ?? false,
          );
      expect(
        ProjectRules.changesOwnerSettings(
          project,
          details(v: ProjectVisibility.public),
        ),
        isTrue,
      );
      expect(
        ProjectRules.changesOwnerSettings(project, details(c: true)),
        isTrue,
      );
    });
  });

  group('Given ProjectRules.acceptsJoinRequests', () {
    test('when public and open to contributions, then accepts', () {
      expect(
        ProjectRules.acceptsJoinRequests(
          _project(
            visibility: ProjectVisibility.public,
            allowContributions: true,
          ),
        ),
        isTrue,
      );
    });

    test('when private or closed, then does not accept', () {
      expect(
        ProjectRules.acceptsJoinRequests(_project(allowContributions: true)),
        isFalse,
      );
      expect(
        ProjectRules.acceptsJoinRequests(
          _project(visibility: ProjectVisibility.public),
        ),
        isFalse,
      );
    });
  });
}
