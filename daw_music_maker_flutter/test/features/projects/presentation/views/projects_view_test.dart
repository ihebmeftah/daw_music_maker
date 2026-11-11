import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('Given a signed-in user on /projects', () {
    testWidgets('when opened, then shows the placeholder', (tester) async {
      await tester.pumpDawApp(
        session: FakeAuthSession(signedIn: true),
        repository: MockAuthRepository(),
      );

      expect(find.byType(ProjectsView), findsOneWidget);
      expect(find.text('Your studio is ready'), findsOneWidget);
    });

    testWidgets('when signing out, then returns to the login screen', (
      tester,
    ) async {
      final session = FakeAuthSession(signedIn: true);
      await tester.pumpDawApp(
        session: session,
        repository: MockAuthRepository(),
      );

      await tester.tap(find.byKey(ProjectsView.signOutKey));
      await tester.pumpAndSettle();

      expect(session.signOutCalls, 1);
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
