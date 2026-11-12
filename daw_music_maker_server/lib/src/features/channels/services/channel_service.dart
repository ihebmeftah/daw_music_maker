import 'package:serverpod/serverpod.dart';

import '../../../core/validation/validation_rules.dart';
import '../../../generated/protocol.dart';
import '../../projects/services/project_access_service.dart';
import '../../projects/services/project_rules.dart';
import '../mappers/channel_mapper.dart';
import '../../samples/repositories/samples_repository.dart';
import '../repositories/channels_repository.dart';
import 'channel_rules.dart';

/// Channel rack management. Anyone who can see a project can list its
/// channels; owners and write members can change them.
class ChannelService {
  /// Creates the service.
  const ChannelService();

  static const _channels = ChannelsRepository();
  static const _samples = SamplesRepository();
  static const _access = ProjectAccessService();

  /// Channels of a visible project, in rack order.
  Future<List<ChannelResponse>> list(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    await _access.load(session, projectId, userId);
    final rows = await _channels.listForProject(session, projectId);
    return [for (final c in rows) c.toResponse()];
  }

  /// Adds a channel at the end of the rack, playing a built-in sample or an
  /// uploaded sample of the same project (exactly one of the two).
  Future<ChannelResponse> create(
    Session session,
    UuidValue userId,
    CreateChannelRequest request,
  ) async {
    await _requireEditor(session, request.projectId, userId);
    if ((request.sample == null) == (request.sampleId == null)) {
      throw AppException(
        code: ErrorCode.validation,
        fieldErrors: {'sample': 'Choose a built-in or an uploaded sample'},
      );
    }
    String? uploadedName;
    if (request.sampleId case final sampleId?) {
      final sample = await _samples.findById(session, sampleId);
      if (sample == null || sample.projectId != request.projectId) {
        throw AppException(
          code: ErrorCode.validation,
          fieldErrors: {'sampleId': 'Unknown sample'},
        );
      }
      uploadedName = sample.name.length > ValidationRules.channelNameMaxLength
          ? sample.name.substring(0, ValidationRules.channelNameMaxLength)
          : sample.name;
    }
    final existing = await _channels.listForProject(session, request.projectId);
    _requireCapacity(existing.length);
    final settings = ChannelRules.validate(
      name:
          request.name ??
          uploadedName ??
          ChannelRules.defaultName(request.sample!),
      volume: 0.8,
    );
    final saved = await _channels.insert(
      session,
      Channel(
        projectId: request.projectId,
        name: settings.name,
        sample: request.sample,
        sampleId: request.sampleId,
        volume: settings.volume,
        position: _nextPosition(existing),
      ),
    );
    return saved.toResponse();
  }

  /// Splits a channel's region into [ChopChannelRequest.slices] equal parts,
  /// each added as a new channel (`<name> 1…N`) with the same sound and
  /// settings. Returns the new channels.
  Future<List<ChannelResponse>> chop(
    Session session,
    UuidValue userId,
    UuidValue channelId,
    ChopChannelRequest request,
  ) async {
    final source = await _requireChannel(session, channelId, userId);
    if (!ValidationRules.chopSlices.contains(request.slices)) {
      throw AppException(
        code: ErrorCode.validation,
        fieldErrors: {'slices': 'Chop into 2, 4, 8 or 16 slices'},
      );
    }
    final existing = await _channels.listForProject(session, source.projectId);
    if (existing.length + request.slices > ValidationRules.channelsMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A project can have at most ${ValidationRules.channelsMax} '
            'channels',
      );
    }
    final base = source.name.length > ValidationRules.channelNameMaxLength - 3
        ? source.name.substring(0, ValidationRules.channelNameMaxLength - 3)
        : source.name;
    var position = _nextPosition(existing);
    final created = <Channel>[];
    await session.db.transaction((tx) async {
      for (final (i, (start, end)) in ChannelRules.slices(
        source.startFrac,
        source.endFrac,
        request.slices,
      ).indexed) {
        created.add(
          await _channels.insert(
            session,
            Channel(
              projectId: source.projectId,
              name: '$base ${i + 1}',
              sample: source.sample,
              sampleId: source.sampleId,
              volume: source.volume,
              pan: source.pan,
              pitch: source.pitch,
              startFrac: start,
              endFrac: end,
              position: position++,
            ),
            transaction: tx,
          ),
        );
      }
    });
    return [for (final c in created) c.toResponse()];
  }

  /// Renames a channel and sets its volume and mute state.
  Future<ChannelResponse> update(
    Session session,
    UuidValue userId,
    UuidValue channelId,
    UpdateChannelRequest request,
  ) async {
    final channel = await _requireChannel(session, channelId, userId);
    final settings = ChannelRules.validate(
      name: request.name,
      volume: request.volume,
      pan: request.pan,
      pitch: request.pitch,
      startFrac: request.startFrac,
      endFrac: request.endFrac,
    );
    final saved = await _channels.update(
      session,
      channel.copyWith(
        name: settings.name,
        volume: settings.volume,
        muted: request.muted,
        pan: request.pan,
        pitch: request.pitch,
        startFrac: request.startFrac,
        endFrac: request.endFrac,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return saved.toResponse();
  }

  /// Deletes a channel and all its notes.
  Future<void> delete(
    Session session,
    UuidValue userId,
    UuidValue channelId,
  ) async {
    final channel = await _requireChannel(session, channelId, userId);
    await _channels.delete(session, channel);
  }

  /// Inserts the default rack (Kick, Snare, Hat, Open Hat) of a new project.
  Future<void> createDefaults(
    Session session,
    UuidValue projectId, {
    required Transaction transaction,
  }) async {
    for (final (i, (name, sample)) in ChannelRules.defaults.indexed) {
      await _channels.insert(
        session,
        Channel(
          projectId: projectId,
          name: name,
          sample: sample,
          volume: 0.8,
          position: i,
        ),
        transaction: transaction,
      );
    }
  }

  void _requireCapacity(int count) {
    if (count >= ValidationRules.channelsMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A project can have at most ${ValidationRules.channelsMax} '
            'channels',
      );
    }
  }

  static int _nextPosition(List<Channel> existing) => existing.isEmpty
      ? 0
      : existing.map((c) => c.position).reduce((a, b) => a > b ? a : b) + 1;

  Future<Channel> _requireChannel(
    Session session,
    UuidValue channelId,
    UuidValue userId,
  ) async {
    final channel = await _channels.findById(session, channelId);
    if (channel == null) throw AppException(code: ErrorCode.notFound);
    await _requireEditor(session, channel.projectId, userId);
    return channel;
  }

  Future<void> _requireEditor(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) async {
    final (_, access) = await _access.load(session, projectId, userId);
    if (!ProjectRules.canEditDetails(access)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'You cannot change the channels of this project',
      );
    }
  }
}

