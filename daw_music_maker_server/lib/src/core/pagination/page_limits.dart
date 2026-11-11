/// Limits applied to every paginated list endpoint.
abstract final class PageLimits {
  /// Page size used when the client sends none.
  static const int defaultLimit = 20;

  /// Largest page size a client may request.
  static const int max = 50;

  /// Clamps a requested page size to `1..max` ([defaultLimit] when null).
  static int clampLimit(int? limit) =>
      limit == null ? defaultLimit : limit.clamp(1, max);

  /// Clamps a requested offset to `>= 0`.
  static int clampOffset(int? offset) =>
      offset == null || offset < 0 ? 0 : offset;
}
