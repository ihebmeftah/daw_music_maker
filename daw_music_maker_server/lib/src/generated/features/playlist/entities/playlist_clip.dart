/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

/// A clip on the project's playlist (song arrangement), FL Studio style:
/// either a pattern (lasting as long as the pattern) or an audio clip of an
/// uploaded sample (lasting [lengthBars]).
abstract class PlaylistClip
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PlaylistClip._({
    this.id,
    required this.projectId,
    this.patternId,
    this.sampleId,
    this.lengthBars,
    required this.track,
    required this.startStep,
  });

  factory PlaylistClip({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startStep,
  }) = _PlaylistClipImpl;

  factory PlaylistClip.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaylistClip(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      patternId: jsonSerialization['patternId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['patternId']),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      lengthBars: jsonSerialization['lengthBars'] as int?,
      track: jsonSerialization['track'] as int,
      startStep: jsonSerialization['startStep'] as int,
    );
  }

  static final t = PlaylistClipTable();

  static const db = PlaylistClipRepository._();

  @override
  _is.UuidValue? id;

  /// The project; clips are deleted with it.
  _is.UuidValue projectId;

  /// The pattern played by the clip; clips are deleted with it.
  _is.UuidValue? patternId;

  /// The uploaded sample played by an audio clip; deleted with it.
  _is.UuidValue? sampleId;

  /// Length of an audio clip in bars (1–64); null for pattern clips.
  int? lengthBars;

  /// Playlist track (row), 0–15.
  int track;

  /// Start of the clip in steps (1/16 notes) from the song start, so clips
  /// can snap to bars, beats or steps.
  int startStep;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PlaylistClip]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlaylistClip copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    int? lengthBars,
    int? track,
    int? startStep,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaylistClip',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      if (patternId != null) 'patternId': patternId?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (lengthBars != null) 'lengthBars': lengthBars,
      'track': track,
      'startStep': startStep,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PlaylistClipInclude include() {
    return PlaylistClipInclude._();
  }

  static PlaylistClipIncludeList includeList({
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    PlaylistClipInclude? include,
  }) {
    return PlaylistClipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlaylistClipImpl extends PlaylistClip {
  _PlaylistClipImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startStep,
  }) : super._(
         id: id,
         projectId: projectId,
         patternId: patternId,
         sampleId: sampleId,
         lengthBars: lengthBars,
         track: track,
         startStep: startStep,
       );

  /// Returns a shallow copy of this [PlaylistClip]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlaylistClip copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    Object? lengthBars = _Undefined,
    int? track,
    int? startStep,
  }) {
    return PlaylistClip(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      patternId: patternId is _is.UndefinedSentinel
          ? this.patternId
          : patternId,
      sampleId: sampleId is _is.UndefinedSentinel ? this.sampleId : sampleId,
      lengthBars: lengthBars is int? ? lengthBars : this.lengthBars,
      track: track ?? this.track,
      startStep: startStep ?? this.startStep,
    );
  }
}

class PlaylistClipUpdateTable extends _is.UpdateTable<PlaylistClipTable> {
  PlaylistClipUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> projectId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.projectId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> patternId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.patternId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sampleId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.sampleId,
    value,
  );

  _is.ColumnValue<int, int> lengthBars(int? value) => _is.ColumnValue(
    table.lengthBars,
    value,
  );

  _is.ColumnValue<int, int> track(int value) => _is.ColumnValue(
    table.track,
    value,
  );

  _is.ColumnValue<int, int> startStep(int value) => _is.ColumnValue(
    table.startStep,
    value,
  );
}

class PlaylistClipTable extends _is.Table<_is.UuidValue?> {
  PlaylistClipTable({super.tableRelation}) : super(tableName: 'playlist_clip') {
    updateTable = PlaylistClipUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    patternId = _is.ColumnUuid(
      'patternId',
      this,
    );
    sampleId = _is.ColumnUuid(
      'sampleId',
      this,
    );
    lengthBars = _is.ColumnInt(
      'lengthBars',
      this,
    );
    track = _is.ColumnInt(
      'track',
      this,
    );
    startStep = _is.ColumnInt(
      'startStep',
      this,
    );
  }

  late final PlaylistClipUpdateTable updateTable;

  /// The project; clips are deleted with it.
  late final _is.ColumnUuid projectId;

  /// The pattern played by the clip; clips are deleted with it.
  late final _is.ColumnUuid patternId;

  /// The uploaded sample played by an audio clip; deleted with it.
  late final _is.ColumnUuid sampleId;

  /// Length of an audio clip in bars (1–64); null for pattern clips.
  late final _is.ColumnInt lengthBars;

  /// Playlist track (row), 0–15.
  late final _is.ColumnInt track;

  /// Start of the clip in steps (1/16 notes) from the song start, so clips
  /// can snap to bars, beats or steps.
  late final _is.ColumnInt startStep;

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    patternId,
    sampleId,
    lengthBars,
    track,
    startStep,
  ];
}

class PlaylistClipInclude extends _is.IncludeObject {
  PlaylistClipInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PlaylistClip.t;
}

class PlaylistClipIncludeList extends _is.IncludeList {
  PlaylistClipIncludeList._({
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlaylistClip.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PlaylistClip.t;
}

class PlaylistClipRepository {
  const PlaylistClipRepository._();

  /// Returns a list of [PlaylistClip]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<PlaylistClip>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PlaylistClip>(
      where: where?.call(PlaylistClip.t),
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PlaylistClip]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `PlaylistClip.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<PlaylistClip>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PlaylistClip>(
      where: where?.call(PlaylistClip.t),
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PlaylistClip] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<PlaylistClip?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    int? offset,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PlaylistClip>(
      where: where?.call(PlaylistClip.t),
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PlaylistClip] by its [id] or null if no such row exists.
  Future<PlaylistClip?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PlaylistClip>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PlaylistClip]s in the list and returns the inserted rows.
  ///
  /// The returned [PlaylistClip]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> insert(
    _is.DatabaseSession session,
    List<PlaylistClip> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PlaylistClip>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PlaylistClip] and returns the inserted row.
  ///
  /// The returned [PlaylistClip] will have its `id` field set.
  Future<PlaylistClip> insertRow(
    _is.DatabaseSession session,
    PlaylistClip row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlaylistClip>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PlaylistClip]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [PlaylistClip]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> upsert(
    _is.DatabaseSession session,
    List<PlaylistClip> rows, {
    required _is.ColumnSelections<PlaylistClipTable> conflictColumns,
    _is.ColumnSelections<PlaylistClipTable>? updateColumns,
    _is.WhereExpressionBuilder<PlaylistClipTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PlaylistClip>(
      rows,
      conflictColumns: conflictColumns(PlaylistClip.t),
      updateColumns: updateColumns?.call(PlaylistClip.t),
      updateWhere: updateWhere?.call(PlaylistClip.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PlaylistClip] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [PlaylistClip] will have its `id` field set.
  Future<PlaylistClip?> upsertRow(
    _is.DatabaseSession session,
    PlaylistClip row, {
    required _is.ColumnSelections<PlaylistClipTable> conflictColumns,
    _is.ColumnSelections<PlaylistClipTable>? updateColumns,
    _is.WhereExpressionBuilder<PlaylistClipTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PlaylistClip>(
      row,
      conflictColumns: conflictColumns(PlaylistClip.t),
      updateColumns: updateColumns?.call(PlaylistClip.t),
      updateWhere: updateWhere?.call(PlaylistClip.t),
      transaction: transaction,
    );
  }

  /// Updates all [PlaylistClip]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> update(
    _is.DatabaseSession session,
    List<PlaylistClip> rows, {
    _is.ColumnSelections<PlaylistClipTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PlaylistClip>(
      rows,
      columns: columns?.call(PlaylistClip.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PlaylistClip]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlaylistClip> updateRow(
    _is.DatabaseSession session,
    PlaylistClip row, {
    _is.ColumnSelections<PlaylistClipTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlaylistClip>(
      row,
      columns: columns?.call(PlaylistClip.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlaylistClip] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlaylistClip?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PlaylistClipUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PlaylistClip>(
      id,
      columnValues: columnValues(PlaylistClip.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlaylistClip]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PlaylistClipUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PlaylistClipTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PlaylistClip>(
      columnValues: columnValues(PlaylistClip.t.updateTable),
      where: where(PlaylistClip.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PlaylistClip]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> delete(
    _is.DatabaseSession session,
    List<PlaylistClip> rows, {
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PlaylistClip>(
      rows,
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PlaylistClip].
  Future<PlaylistClip> deleteRow(
    _is.DatabaseSession session,
    PlaylistClip row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlaylistClip>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlaylistClip>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlaylistClipTable> where,
    _is.OrderByBuilder<PlaylistClipTable>? orderBy,
    _is.OrderByListBuilder<PlaylistClipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PlaylistClip>(
      where: where(PlaylistClip.t),
      orderBy: orderBy?.call(PlaylistClip.t),
      orderByList: orderByList?.call(PlaylistClip.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlaylistClipTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PlaylistClip>(
      where: where?.call(PlaylistClip.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PlaylistClip] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlaylistClipTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PlaylistClip>(
      where: where(PlaylistClip.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
