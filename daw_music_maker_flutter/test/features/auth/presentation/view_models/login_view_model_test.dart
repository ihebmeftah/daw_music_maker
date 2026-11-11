import 'dart:async';

import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_provider.dart';
import 'package:daw_music_maker/features/auth/presentation/state/login_state.dart';
import 'package:daw_music_maker/features/auth/presentation/view_models/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    // Keep the auto-dispose ViewModel alive for the whole test.
    container.listen(loginViewModelProvider, (_, _) {});
  });

  void stubLogin(Future<void> Function() answer) {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => answer());
  }

  group('Given the LoginViewModel', () {
    test('when created, then is idle without error', () {
      expect(container.read(loginViewModelProvider), const LoginState());
    });

    test(
      'when submitting, then is submitting until the call completes',
      () async {
        final completer = Completer<void>();
        stubLogin(() => completer.future);

        final future = container
            .read(loginViewModelProvider.notifier)
            .submit(email: 'a@b.fm', password: 'secret123');

        expect(container.read(loginViewModelProvider).isSubmitting, isTrue);
        completer.complete();
        await future;
        expect(container.read(loginViewModelProvider), const LoginState());
        verify(
          () => repository.login(email: 'a@b.fm', password: 'secret123'),
        ).called(1);
      },
    );

    test('when the repository fails, then exposes the failure', () async {
      stubLogin(
        () async => throw const Failure(FailureCode.invalidCredentials),
      );

      await container
          .read(loginViewModelProvider.notifier)
          .submit(email: 'a@b.fm', password: 'nope');

      expect(
        container.read(loginViewModelProvider),
        const LoginState(failure: Failure(FailureCode.invalidCredentials)),
      );
    });

    test('when an unexpected error occurs, then maps it to unknown', () async {
      stubLogin(() async => throw StateError('boom'));

      await container
          .read(loginViewModelProvider.notifier)
          .submit(email: 'a@b.fm', password: 'x');

      expect(
        container.read(loginViewModelProvider).failure,
        const Failure(FailureCode.unknown),
      );
    });

    test(
      'when submitting twice concurrently, then calls the repository once',
      () async {
        final completer = Completer<void>();
        stubLogin(() => completer.future);
        final notifier = container.read(loginViewModelProvider.notifier);

        final first = notifier.submit(email: 'a@b.fm', password: 'x');
        await notifier.submit(email: 'a@b.fm', password: 'x');
        completer.complete();
        await first;

        verify(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );

    test('when clearing the failure, then removes it', () async {
      stubLogin(() async => throw const Failure(FailureCode.network));
      final notifier = container.read(loginViewModelProvider.notifier);
      await notifier.submit(email: 'a@b.fm', password: 'x');

      notifier.clearFailure();

      expect(container.read(loginViewModelProvider).failure, isNull);
    });
  });
}
