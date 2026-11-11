import 'package:daw_music_maker/core/validation/validation_rules.dart';
import 'package:daw_music_maker/core/validation/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given ValidationRules mirrored from the server', () {
    test('when compared to the server values, then they match', () {
      // Keep in sync with
      // daw_music_maker_server/lib/src/core/validation/validation_rules.dart.
      expect(ValidationRules.emailMaxLength, 254);
      expect(ValidationRules.passwordMinLength, 8);
      expect(ValidationRules.passwordMaxLength, 128);
      expect(ValidationRules.verificationCodeLength, 8);
      expect(ValidationRules.projectNameMaxLength, 80);
      expect(ValidationRules.projectDescriptionMaxLength, 1000);
      expect(ValidationRules.projectGenresMax, 8);
      expect(ValidationRules.genreMaxLength, 24);
      expect(ValidationRules.projectMembersMax, 50);
      expect(ValidationRules.searchQueryMaxLength, 80);
    });
  });

  group('Given Validators.email', () {
    test('when empty, then asks for an email', () {
      expect(Validators.email(''), 'Enter your email');
      expect(Validators.email(null), 'Enter your email');
      expect(Validators.email('   '), 'Enter your email');
    });

    test('when malformed, then rejects it', () {
      expect(Validators.email('producer'), isNotNull);
      expect(Validators.email('producer@studio'), isNotNull);
      expect(Validators.email('pro ducer@studio.fm'), isNotNull);
    });

    test('when too long, then rejects it', () {
      final email = '${'a' * 250}@b.fm';
      expect(Validators.email(email), contains('at most'));
    });

    test('when valid (with surrounding spaces), then accepts it', () {
      expect(Validators.email('producer@studio.fm'), isNull);
      expect(Validators.email('  producer@studio.fm  '), isNull);
    });
  });

  group('Given Validators.loginPassword', () {
    test('when empty, then asks for a password', () {
      expect(Validators.loginPassword(''), isNotNull);
    });

    test('when short, then accepts it (policy is checked by the server)', () {
      expect(Validators.loginPassword('abc'), isNull);
    });
  });

  group('Given Validators.newPassword', () {
    test('when empty, then asks for a password', () {
      expect(Validators.newPassword(''), 'Choose a password');
    });

    test('when one character below the minimum, then rejects it', () {
      final password = 'a' * (ValidationRules.passwordMinLength - 1);
      expect(Validators.newPassword(password), contains('at least'));
    });

    test('when exactly the minimum length, then accepts it', () {
      final password = 'a' * ValidationRules.passwordMinLength;
      expect(Validators.newPassword(password), isNull);
    });

    test('when above the maximum length, then rejects it', () {
      final password = 'a' * (ValidationRules.passwordMaxLength + 1);
      expect(Validators.newPassword(password), contains('at most'));
    });

    test('when it has surrounding whitespace, then rejects it', () {
      expect(Validators.newPassword(' abcdefgh'), contains('space'));
      expect(Validators.newPassword('abcdefgh '), contains('space'));
    });
  });

  group('Given Validators.confirmPassword', () {
    final validator = Validators.confirmPassword(() => 'abcdefgh');

    test('when empty, then asks to repeat it', () {
      expect(validator(''), 'Repeat your password');
    });

    test('when different, then reports a mismatch', () {
      expect(validator('abcdefgX'), 'Passwords do not match');
    });

    test('when equal, then accepts it', () {
      expect(validator('abcdefgh'), isNull);
    });
  });

  group('Given Validators.verificationCode', () {
    test('when empty, then asks for the code', () {
      expect(Validators.verificationCode(''), isNotNull);
    });

    test('when too short or too long, then rejects it', () {
      expect(Validators.verificationCode('1234567'), isNotNull);
      expect(Validators.verificationCode('123456789'), isNotNull);
    });

    test('when it contains a 0 or letters, then rejects it', () {
      expect(Validators.verificationCode('12345670'), isNotNull);
      expect(Validators.verificationCode('1234567a'), isNotNull);
    });

    test('when it has 8 digits 1–9, then accepts it', () {
      expect(Validators.verificationCode('12345678'), isNull);
      expect(Validators.verificationCode(' 98765432 '), isNull);
    });
  });

  group('Given Validators.projectName', () {
    test('when blank, then asks for a name', () {
      expect(Validators.projectName(''), 'Give your project a name');
      expect(Validators.projectName('   '), 'Give your project a name');
      expect(Validators.projectName(null), 'Give your project a name');
    });

    test('when exactly the maximum length, then accepts it', () {
      expect(Validators.projectName('a' * 80), isNull);
    });

    test('when above the maximum length, then rejects it', () {
      expect(Validators.projectName('a' * 81), contains('at most'));
    });

    test('when padded with spaces, then validates the trimmed value', () {
      expect(Validators.projectName('  ${'a' * 80}  '), isNull);
    });
  });

  group('Given Validators.projectDescription', () {
    test('when empty, then accepts it (optional)', () {
      expect(Validators.projectDescription(''), isNull);
      expect(Validators.projectDescription(null), isNull);
    });

    test('when at the limit, then accepts it', () {
      expect(Validators.projectDescription('a' * 1000), isNull);
    });

    test('when above the limit, then rejects it', () {
      expect(Validators.projectDescription('a' * 1001), contains('at most'));
    });
  });

  group('Given Validators.genreTag', () {
    test('when blank, then asks for a genre', () {
      expect(Validators.genreTag(' ', const []), 'Type a genre');
    });

    test('when too long, then rejects it', () {
      expect(Validators.genreTag('a' * 25, const []), contains('at most'));
      expect(Validators.genreTag('a' * 24, const []), isNull);
    });

    test('when the maximum count is reached, then rejects another tag', () {
      final full = [for (var i = 0; i < 8; i++) 'g$i'];
      expect(Validators.genreTag('house', full), 'Up to 8 genres');
      expect(Validators.genreTag('house', full.take(7).toList()), isNull);
    });

    test('when it duplicates a tag case-insensitively, then rejects it', () {
      expect(
        Validators.genreTag(' TECHNO ', const ['techno']),
        'Already added',
      );
    });
  });
}
