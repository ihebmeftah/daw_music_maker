import 'package:daw_music_maker_server/src/core/validation/validator.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Validator', () {
    test('when no error was added, then it is valid and does not throw', () {
      final v = Validator();
      expect(v.isValid, isTrue);
      expect(v.throwIfInvalid, returnsNormally);
    });

    test('when errors were added, then throws a validation AppException', () {
      final v = Validator()
        ..add('name', 'Name is required')
        ..add('genres', 'Too many');

      expect(
        v.throwIfInvalid,
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', ErrorCode.validation)
              .having((e) => e.fieldErrors, 'fieldErrors', {
                'name': 'Name is required',
                'genres': 'Too many',
              }),
        ),
      );
    });

    test('when a field gets two errors, then the first one is kept', () {
      final v = Validator()
        ..add('name', 'first')
        ..add('name', 'second');
      expect(v.errors, {'name': 'first'});
    });
  });
}
