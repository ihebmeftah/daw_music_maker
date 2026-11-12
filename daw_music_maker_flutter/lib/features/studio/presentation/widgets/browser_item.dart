import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// A sound dragged from the sample browser: a built-in [kind] or an
/// uploaded [sampleId] (exactly one is set).
class BrowserItem {
  /// A built-in drum.
  const BrowserItem.builtin(SampleKind this.kind) : sampleId = null;

  /// An uploaded sample.
  const BrowserItem.uploaded(UuidValue this.sampleId) : kind = null;

  /// The built-in drum, if any.
  final SampleKind? kind;

  /// The uploaded sample, if any.
  final UuidValue? sampleId;
}
