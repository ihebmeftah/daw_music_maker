import 'package:flutter/painting.dart';

/// Corner radii used across the app.
abstract final class AppRadii {
  /// 4 px — chips, tags, step buttons.
  static const double sm = 4;

  /// 10 px — inputs and buttons.
  static const double md = 10;

  /// 20 px — panels and cards.
  static const double lg = 20;

  /// Fully rounded (pills).
  static const double pill = 999;

  /// [BorderRadius] for inputs and buttons.
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));

  /// [BorderRadius] for cards and panels.
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));

  /// [BorderRadius] for small tags.
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));

  /// [BorderRadius] for pills.
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
