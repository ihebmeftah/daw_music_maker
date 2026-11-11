import 'package:daw_music_maker/shared/widgets/inputs/daw_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a DawTextField', () {
    testWidgets('when rendered, then shows its label', (tester) async {
      await tester.pumpApp(const Form(child: DawTextField(label: 'Email')));

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('when the form is validated, then shows the validator error', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpApp(
        Form(
          key: formKey,
          child: DawTextField(
            label: 'Email',
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('when obscured, then the visibility toggle reveals the text', (
      tester,
    ) async {
      await tester.pumpApp(
        const Form(child: DawTextField(label: 'Password', obscure: true)),
      );
      EditableText editable() =>
          tester.widget<EditableText>(find.byType(EditableText));

      expect(editable().obscureText, isTrue);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();

      expect(editable().obscureText, isFalse);
      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets('when typing, then reports changes', (tester) async {
      String? changed;
      await tester.pumpApp(
        Form(
          child: DawTextField(label: 'Name', onChanged: (v) => changed = v),
        ),
      );

      await tester.enterText(find.byType(DawTextField), 'Kick');

      expect(changed, 'Kick');
    });

    testWidgets('when maxLength is set, then input is capped', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpApp(
        Form(
          child: DawTextField(
            label: 'Code',
            controller: controller,
            monospace: true,
            maxLength: 4,
          ),
        ),
      );

      await tester.enterText(find.byType(DawTextField), '123456');

      expect(controller.text, '1234');
    });
  });
}
