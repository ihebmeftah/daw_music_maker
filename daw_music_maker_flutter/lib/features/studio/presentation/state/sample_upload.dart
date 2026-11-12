import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'sample_upload.freezed.dart';

/// An audio file being uploaded (shown with a progress bar in the browser).
@freezed
abstract class SampleUpload with _$SampleUpload {
  /// Creates the upload entry.
  const factory SampleUpload({
    /// Local id of the entry.
    required int id,

    /// File name.
    required String fileName,

    /// Share sent so far (0–1).
    @Default(0) double progress,

    /// Why the upload failed (shown until dismissed).
    String? error,

    /// Server failure, if any.
    Failure? failure,
  }) = _SampleUpload;
}
