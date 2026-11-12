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

/// A pattern of a project (FL Studio style): a named, colored loop of a
/// given length. Its content (channel steps, notes) comes with the channel
/// rack; the playlist will arrange patterns into a song.
abstract class Pattern
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Pattern._({
    this.id,
    required this.projectId,
    required this.name,
    int? colorIndex,
    int? lengthBars,
    required this.position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : colorIndex = colorIndex ?? 0,
       lengthBars = lengthBars ?? 4,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Pattern({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    int? colorIndex,
    int? lengthBars,
    required int position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PatternImpl;

  factory Pattern.fromJson(Map<String, dynamic> jsonSerialization) {
    return Pattern(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      colorIndex: jsonSerialization['colorIndex'] as int?,
      lengthBars: jsonSerialization['lengthBars'] as int?,
      position: jsonSerialization['position'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PatternTable();

  static const db = PatternRepository._();

  @override
  _is.UuidValue? id;

  /// The project; patterns are deleted with it.
  _is.UuidValue projectId;

  /// Display name, 1–40 chars, trimmed.
  String name;

  /// Index into the app's track color palette (0–7).
  int colorIndex;

  /// Loop length in bars (1–16, 4/4).
  int lengthBars;

  /// Sort order within the project (ascending, gaps allowed).
  int position;

  /// Creation time.
  DateTime createdAt;

  /// Last modification time.
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Pattern]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Pattern copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Pattern',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'colorIndex': colorIndex,
      'lengthBars': lengthBars,
      'position': position,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PatternInclude include() {
    return PatternInclude._();
  }

  static PatternIncludeList includeList({
    _is.WhereExpressionBuilder<PatternTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    PatternInclude? include,
  }) {
    return PatternIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PatternImpl extends Pattern {
  _PatternImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    int? colorIndex,
    int? lengthBars,
    required int position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         colorIndex: colorIndex,
         lengthBars: lengthBars,
         position: position,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Pattern]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Pattern copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pattern(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      lengthBars: lengthBars ?? this.lengthBars,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PatternUpdateTable extends _is.UpdateTable<PatternTable> {
  PatternUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> projectId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.projectId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> colorIndex(int value) => _is.ColumnValue(
    table.colorIndex,
    value,
  );

  _is.ColumnValue<int, int> lengthBars(int value) => _is.ColumnValue(
    table.lengthBars,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class PatternTable extends _is.Table<_is.UuidValue?> {
  PatternTable({super.tableRelation}) : super(tableName: 'pattern') {
    updateTable = PatternUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    colorIndex = _is.ColumnInt(
      'colorIndex',
      this,
      hasDefault: true,
    );
    lengthBars = _is.ColumnInt(
      'lengthBars',
      this,
      hasDefault: true,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final PatternUpdateTable updateTable;

  /// The project; patterns are deleted with it.
  late final _is.ColumnUuid projectId;

  /// Display name, 1–40 chars, trimmed.
  late final _is.ColumnString name;

  /// Index into the app's track color palette (0–7).
  late final _is.ColumnInt colorIndex;

  /// Loop length in bars (1–16, 4/4).
  late final _is.ColumnInt lengthBars;

  /// Sort order within the project (ascending, gaps allowed).
  late final _is.ColumnInt position;

  /// Creation time.
  late final _is.ColumnDateTime createdAt;

  /// Last modification time.
  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    name,
    colorIndex,
    lengthBars,
    position,
    createdAt,
    updatedAt,
  ];
}

class PatternInclude extends _is.IncludeObject {
  PatternInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Pattern.t;
}

class PatternIncludeList extends _is.IncludeList {
  PatternIncludeList._({
    _is.WhereExpressionBuilder<PatternTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Pattern.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Pattern.t;
}

class PatternRepository {
  const PatternRepository._();

  /// Returns a list of [Pattern]s matching the given query parameters.
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
  Future<List<Pattern>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Pattern>(
      where: where?.call(Pattern.t),
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Pattern]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Pattern.t`.
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
  _ida.Stream<List<Pattern>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Pattern>(
      where: where?.call(Pattern.t),
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Pattern] matching the given query parameters.
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
  Future<Pattern?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternTable>? where,
    int? offset,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Pattern>(
      where: where?.call(Pattern.t),
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Pattern] by its [id] or null if no such row exists.
  Future<Pattern?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Pattern>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Pattern]s in the list and returns the inserted rows.
  ///
  /// The returned [Pattern]s will have their `id` fields set.
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
  Future<List<Pattern>> insert(
    _is.DatabaseSession session,
    List<Pattern> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Pattern>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Pattern] and returns the inserted row.
  ///
  /// The returned [Pattern] will have its `id` field set.
  Future<Pattern> insertRow(
    _is.DatabaseSession session,
    Pattern row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Pattern>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Pattern]s in the list and returns the resulting rows.
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
  /// The returned [Pattern]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pattern>> upsert(
    _is.DatabaseSession session,
    List<Pattern> rows, {
    required _is.ColumnSelections<PatternTable> conflictColumns,
    _is.ColumnSelections<PatternTable>? updateColumns,
    _is.WhereExpressionBuilder<PatternTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Pattern>(
      rows,
      conflictColumns: conflictColumns(Pattern.t),
      updateColumns: updateColumns?.call(Pattern.t),
      updateWhere: updateWhere?.call(Pattern.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Pattern] and returns the resulting row.
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
  /// The returned [Pattern] will have its `id` field set.
  Future<Pattern?> upsertRow(
    _is.DatabaseSession session,
    Pattern row, {
    required _is.ColumnSelections<PatternTable> conflictColumns,
    _is.ColumnSelections<PatternTable>? updateColumns,
    _is.WhereExpressionBuilder<PatternTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Pattern>(
      row,
      conflictColumns: conflictColumns(Pattern.t),
      updateColumns: updateColumns?.call(Pattern.t),
      updateWhere: updateWhere?.call(Pattern.t),
      transaction: transaction,
    );
  }

  /// Updates all [Pattern]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pattern>> update(
    _is.DatabaseSession session,
    List<Pattern> rows, {
    _is.ColumnSelections<PatternTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Pattern>(
      rows,
      columns: columns?.call(Pattern.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Pattern]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Pattern> updateRow(
    _is.DatabaseSession session,
    Pattern row, {
    _is.ColumnSelections<PatternTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Pattern>(
      row,
      columns: columns?.call(Pattern.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Pattern] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Pattern?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PatternUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Pattern>(
      id,
      columnValues: columnValues(Pattern.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Pattern]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Pattern>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PatternUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PatternTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Pattern>(
      columnValues: columnValues(Pattern.t.updateTable),
      where: where(Pattern.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Pattern]s in the list and returns the deleted rows.
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
  Future<List<Pattern>> delete(
    _is.DatabaseSession session,
    List<Pattern> rows, {
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Pattern>(
      rows,
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Pattern].
  Future<Pattern> deleteRow(
    _is.DatabaseSession session,
    Pattern row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Pattern>(
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
  Future<List<Pattern>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatternTable> where,
    _is.OrderByBuilder<PatternTable>? orderBy,
    _is.OrderByListBuilder<PatternTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Pattern>(
      where: where(Pattern.t),
      orderBy: orderBy?.call(Pattern.t),
      orderByList: orderByList?.call(Pattern.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatternTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Pattern>(
      where: where?.call(Pattern.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Pattern] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatternTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Pattern>(
      where: where(Pattern.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
