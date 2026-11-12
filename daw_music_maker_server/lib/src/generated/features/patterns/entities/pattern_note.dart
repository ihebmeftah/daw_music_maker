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

/// A note of a pattern on one channel. Step-sequencer steps are notes on the
/// 1/16 grid at the default pitch. Times are in ticks (960 per quarter note).
abstract class PatternNote
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PatternNote._({
    this.id,
    required this.patternId,
    required this.channelId,
    required this.tick,
    required this.lengthTicks,
    required this.pitch,
    required this.velocity,
  });

  factory PatternNote({
    _is.UuidValue? id,
    required _is.UuidValue patternId,
    required _is.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) = _PatternNoteImpl;

  factory PatternNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatternNote(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      patternId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['patternId'],
      ),
      channelId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['channelId'],
      ),
      tick: jsonSerialization['tick'] as int,
      lengthTicks: jsonSerialization['lengthTicks'] as int,
      pitch: jsonSerialization['pitch'] as int,
      velocity: jsonSerialization['velocity'] as int,
    );
  }

  static final t = PatternNoteTable();

  static const db = PatternNoteRepository._();

  @override
  _is.UuidValue? id;

  /// The pattern; notes are deleted with it.
  _is.UuidValue patternId;

  /// The channel that plays the note; notes are deleted with it.
  _is.UuidValue channelId;

  /// Start, in ticks from the start of the pattern (≥ 0).
  int tick;

  /// Duration in ticks (≥ 1, must end within the pattern).
  int lengthTicks;

  /// MIDI pitch 0–127 (60 = C5 plays the sample unpitched).
  int pitch;

  /// MIDI velocity 1–127.
  int velocity;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PatternNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PatternNote copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? patternId,
    _is.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatternNote',
      if (id != null) 'id': id?.toJson(),
      'patternId': patternId.toJson(),
      'channelId': channelId.toJson(),
      'tick': tick,
      'lengthTicks': lengthTicks,
      'pitch': pitch,
      'velocity': velocity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PatternNoteInclude include() {
    return PatternNoteInclude._();
  }

  static PatternNoteIncludeList includeList({
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    PatternNoteInclude? include,
  }) {
    return PatternNoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PatternNoteImpl extends PatternNote {
  _PatternNoteImpl({
    _is.UuidValue? id,
    required _is.UuidValue patternId,
    required _is.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) : super._(
         id: id,
         patternId: patternId,
         channelId: channelId,
         tick: tick,
         lengthTicks: lengthTicks,
         pitch: pitch,
         velocity: velocity,
       );

  /// Returns a shallow copy of this [PatternNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PatternNote copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? patternId,
    _is.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  }) {
    return PatternNote(
      id: id is _is.UndefinedSentinel ? this.id : id,
      patternId: patternId ?? this.patternId,
      channelId: channelId ?? this.channelId,
      tick: tick ?? this.tick,
      lengthTicks: lengthTicks ?? this.lengthTicks,
      pitch: pitch ?? this.pitch,
      velocity: velocity ?? this.velocity,
    );
  }
}

class PatternNoteUpdateTable extends _is.UpdateTable<PatternNoteTable> {
  PatternNoteUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> patternId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.patternId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> channelId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.channelId,
    value,
  );

  _is.ColumnValue<int, int> tick(int value) => _is.ColumnValue(
    table.tick,
    value,
  );

  _is.ColumnValue<int, int> lengthTicks(int value) => _is.ColumnValue(
    table.lengthTicks,
    value,
  );

  _is.ColumnValue<int, int> pitch(int value) => _is.ColumnValue(
    table.pitch,
    value,
  );

  _is.ColumnValue<int, int> velocity(int value) => _is.ColumnValue(
    table.velocity,
    value,
  );
}

class PatternNoteTable extends _is.Table<_is.UuidValue?> {
  PatternNoteTable({super.tableRelation}) : super(tableName: 'pattern_note') {
    updateTable = PatternNoteUpdateTable(this);
    patternId = _is.ColumnUuid(
      'patternId',
      this,
    );
    channelId = _is.ColumnUuid(
      'channelId',
      this,
    );
    tick = _is.ColumnInt(
      'tick',
      this,
    );
    lengthTicks = _is.ColumnInt(
      'lengthTicks',
      this,
    );
    pitch = _is.ColumnInt(
      'pitch',
      this,
    );
    velocity = _is.ColumnInt(
      'velocity',
      this,
    );
  }

  late final PatternNoteUpdateTable updateTable;

  /// The pattern; notes are deleted with it.
  late final _is.ColumnUuid patternId;

  /// The channel that plays the note; notes are deleted with it.
  late final _is.ColumnUuid channelId;

  /// Start, in ticks from the start of the pattern (≥ 0).
  late final _is.ColumnInt tick;

  /// Duration in ticks (≥ 1, must end within the pattern).
  late final _is.ColumnInt lengthTicks;

  /// MIDI pitch 0–127 (60 = C5 plays the sample unpitched).
  late final _is.ColumnInt pitch;

  /// MIDI velocity 1–127.
  late final _is.ColumnInt velocity;

  @override
  List<_is.Column> get columns => [
    id,
    patternId,
    channelId,
    tick,
    lengthTicks,
    pitch,
    velocity,
  ];
}

class PatternNoteInclude extends _is.IncludeObject {
  PatternNoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PatternNote.t;
}

class PatternNoteIncludeList extends _is.IncludeList {
  PatternNoteIncludeList._({
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PatternNote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PatternNote.t;
}

class PatternNoteRepository {
  const PatternNoteRepository._();

  /// Returns a list of [PatternNote]s matching the given query parameters.
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
  Future<List<PatternNote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PatternNote>(
      where: where?.call(PatternNote.t),
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PatternNote]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `PatternNote.t`.
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
  _ida.Stream<List<PatternNote>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PatternNote>(
      where: where?.call(PatternNote.t),
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PatternNote] matching the given query parameters.
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
  Future<PatternNote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    int? offset,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PatternNote>(
      where: where?.call(PatternNote.t),
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PatternNote] by its [id] or null if no such row exists.
  Future<PatternNote?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PatternNote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PatternNote]s in the list and returns the inserted rows.
  ///
  /// The returned [PatternNote]s will have their `id` fields set.
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
  Future<List<PatternNote>> insert(
    _is.DatabaseSession session,
    List<PatternNote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PatternNote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PatternNote] and returns the inserted row.
  ///
  /// The returned [PatternNote] will have its `id` field set.
  Future<PatternNote> insertRow(
    _is.DatabaseSession session,
    PatternNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PatternNote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PatternNote]s in the list and returns the resulting rows.
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
  /// The returned [PatternNote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatternNote>> upsert(
    _is.DatabaseSession session,
    List<PatternNote> rows, {
    required _is.ColumnSelections<PatternNoteTable> conflictColumns,
    _is.ColumnSelections<PatternNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<PatternNoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PatternNote>(
      rows,
      conflictColumns: conflictColumns(PatternNote.t),
      updateColumns: updateColumns?.call(PatternNote.t),
      updateWhere: updateWhere?.call(PatternNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PatternNote] and returns the resulting row.
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
  /// The returned [PatternNote] will have its `id` field set.
  Future<PatternNote?> upsertRow(
    _is.DatabaseSession session,
    PatternNote row, {
    required _is.ColumnSelections<PatternNoteTable> conflictColumns,
    _is.ColumnSelections<PatternNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<PatternNoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PatternNote>(
      row,
      conflictColumns: conflictColumns(PatternNote.t),
      updateColumns: updateColumns?.call(PatternNote.t),
      updateWhere: updateWhere?.call(PatternNote.t),
      transaction: transaction,
    );
  }

  /// Updates all [PatternNote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatternNote>> update(
    _is.DatabaseSession session,
    List<PatternNote> rows, {
    _is.ColumnSelections<PatternNoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PatternNote>(
      rows,
      columns: columns?.call(PatternNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PatternNote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PatternNote> updateRow(
    _is.DatabaseSession session,
    PatternNote row, {
    _is.ColumnSelections<PatternNoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PatternNote>(
      row,
      columns: columns?.call(PatternNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PatternNote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PatternNote?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PatternNoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PatternNote>(
      id,
      columnValues: columnValues(PatternNote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PatternNote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatternNote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PatternNoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PatternNoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PatternNote>(
      columnValues: columnValues(PatternNote.t.updateTable),
      where: where(PatternNote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PatternNote]s in the list and returns the deleted rows.
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
  Future<List<PatternNote>> delete(
    _is.DatabaseSession session,
    List<PatternNote> rows, {
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PatternNote>(
      rows,
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PatternNote].
  Future<PatternNote> deleteRow(
    _is.DatabaseSession session,
    PatternNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PatternNote>(
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
  Future<List<PatternNote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatternNoteTable> where,
    _is.OrderByBuilder<PatternNoteTable>? orderBy,
    _is.OrderByListBuilder<PatternNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PatternNote>(
      where: where(PatternNote.t),
      orderBy: orderBy?.call(PatternNote.t),
      orderByList: orderByList?.call(PatternNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternNoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PatternNote>(
      where: where?.call(PatternNote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PatternNote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatternNoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PatternNote>(
      where: where(PatternNote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
