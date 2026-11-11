// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the app's [ThemeMode] and lets the user flip between dark and light.
///
/// Starts from [ThemeMode.system]; [toggle] resolves the system brightness to
/// an explicit mode the first time it is used.

@ProviderFor(ThemeModeController)
final themeModeControllerProvider = ThemeModeControllerProvider._();

/// Holds the app's [ThemeMode] and lets the user flip between dark and light.
///
/// Starts from [ThemeMode.system]; [toggle] resolves the system brightness to
/// an explicit mode the first time it is used.
final class ThemeModeControllerProvider
    extends $NotifierProvider<ThemeModeController, ThemeMode> {
  /// Holds the app's [ThemeMode] and lets the user flip between dark and light.
  ///
  /// Starts from [ThemeMode.system]; [toggle] resolves the system brightness to
  /// an explicit mode the first time it is used.
  ThemeModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeControllerHash();

  @$internal
  @override
  ThemeModeController create() => ThemeModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeControllerHash() =>
    r'07171c8f60eb3aea5ce31b56bb15e44e29e5c02c';

/// Holds the app's [ThemeMode] and lets the user flip between dark and light.
///
/// Starts from [ThemeMode.system]; [toggle] resolves the system brightness to
/// an explicit mode the first time it is used.

abstract class _$ThemeModeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
