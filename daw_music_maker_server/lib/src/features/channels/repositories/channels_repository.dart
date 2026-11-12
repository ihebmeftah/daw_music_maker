import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [Channel] rows. No business rules.
///
/// Pluralized because Serverpod generates `ChannelRepository` for the ORM.
class ChannelsRepository {
  /// Creates the repository.
  const ChannelsRepository();

  /// Finds a channel by id (no access check — callers must check).
  Future<Channel?> findById(Session session, UuidValue id) =>
      Channel.db.findById(session, id);

  /// Channels of [projectId] in rack order.
  Future<List<Channel>> listForProject(
    Session session,
    UuidValue projectId,
  ) => Channel.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderBy: (t) => t.position,
  );

  /// Ids of the channels of [projectId].
  Future<Set<UuidValue>> idsForProject(
    Session session,
    UuidValue projectId,
  ) async => {
    for (final c in await listForProject(session, projectId)) c.id!,
  };

  /// Inserts [channel].
  Future<Channel> insert(
    Session session,
    Channel channel, {
    Transaction? transaction,
  }) => Channel.db.insertRow(session, channel, transaction: transaction);

  /// Updates [channel].
  Future<Channel> update(Session session, Channel channel) =>
      Channel.db.updateRow(session, channel);

  /// Deletes [channel] (its notes cascade).
  Future<void> delete(Session session, Channel channel) =>
      Channel.db.deleteRow(session, channel);
}
