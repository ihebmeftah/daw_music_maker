import 'package:daw_music_maker/core/audio/sound_source.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mocks.dart';

void main() {
  group('Given SoundSource', () {
    test(
      'when built-in, then the key names the sample and equality is by kind',
      () {
        expect(const BuiltinSound(SampleKind.kick).key, 'builtin:kick');
        expect(
          const BuiltinSound(SampleKind.kick),
          const BuiltinSound(SampleKind.kick),
        );
        expect(
          const BuiltinSound(SampleKind.kick),
          isNot(const BuiltinSound(SampleKind.snare)),
        );
      },
    );

    test(
      'when uploaded, then the key is the sample id and the url is ignored',
      () {
        final a = UploadedSound(testRequestId, 'https://a');
        final b = UploadedSound(testRequestId, 'https://b');

        expect(a.key, 'sample:$testRequestId');
        expect(a, b);
        expect(a.hashCode, b.hashCode);
        expect(a, isNot(UploadedSound(otherTestId, 'https://a')));
      },
    );

    test('when comparing kinds, then built-in and uploaded differ', () {
      expect(
        const BuiltinSound(SampleKind.kick) ==
            UploadedSound(testRequestId, 'u') as Object,
        isFalse,
      );
    });
  });
}
