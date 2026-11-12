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
import 'package:daw_music_maker_server/src/generated/protocol.dart'
    as _iau3psze;
import 'package:serverpod/serverpod.dart' as _is;
import '../../../features/samples/enums/audio_format.dart' as _irh2gchs;

/// An audio file uploaded to a project (stored in private cloud storage).
abstract class Sample
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Sample._({
    this.id,
    required this.projectId,
    required this.name,
    required this.format,
    required this.sizeBytes,
    this.durationMs,
    this.peaks,
    required this.storagePath,
    required this.uploadedById,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Sample({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    required _irh2gchs.AudioFormat format,
    required int sizeBytes,
    int? durationMs,
    List<double>? peaks,
    required String storagePath,
    required _is.UuidValue uploadedById,
    DateTime? createdAt,
  }) = _SampleImpl;

  factory Sample.fromJson(Map<String, dynamic> jsonSerialization) {
    return Sample(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      format: _irh2gchs.AudioFormat.fromJson(
        (jsonSerialization['format'] as String),
      ),
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      durationMs: jsonSerialization['durationMs'] as int?,
      peaks: jsonSerialization['peaks'] == null
          ? null
          : _iau3psze.Protocol().deserialize<List<double>>(
              jsonSerialization['peaks'],
            ),
      storagePath: jsonSerialization['storagePath'] as String,
      uploadedById: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploadedById'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SampleTable();

  static const db = SampleRepository._();

  @override
  _is.UuidValue? id;

  /// The project; samples are deleted with it.
  _is.UuidValue projectId;

  /// Display name (file name without extension), 1–80 chars.
  String name;

  /// File format (checked against the file's bytes).
  _irh2gchs.AudioFormat format;

  /// File size in bytes (≤ 10 MB).
  int sizeBytes;

  /// Duration in milliseconds, if known.
  int? durationMs;

  /// Waveform outline (200 peaks, 0–1) for WAV files.
  List<double>? peaks;

  /// Server-generated storage path in the private storage.
  String storagePath;

  /// The user who uploaded it.
  _is.UuidValue uploadedById;

  /// Upload time.
  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Sample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Sample copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    int? durationMs,
    List<double>? peaks = const _is.$UndefinedList<double>(),
    String? storagePath,
    _is.UuidValue? uploadedById,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Sample',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'format': format.toJson(),
      'sizeBytes': sizeBytes,
      if (durationMs != null) 'durationMs': durationMs,
      if (peaks != null) 'peaks': peaks?.toJson(),
      'storagePath': storagePath,
      'uploadedById': uploadedById.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SampleInclude include() {
    return SampleInclude._();
  }

  static SampleIncludeList includeList({
    _is.WhereExpressionBuilder<SampleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    SampleInclude? include,
  }) {
    return SampleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SampleImpl extends Sample {
  _SampleImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    required _irh2gchs.AudioFormat format,
    required int sizeBytes,
    int? durationMs,
    List<double>? peaks,
    required String storagePath,
    required _is.UuidValue uploadedById,
    DateTime? createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         format: format,
         sizeBytes: sizeBytes,
         durationMs: durationMs,
         peaks: peaks,
         storagePath: storagePath,
         uploadedById: uploadedById,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Sample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Sample copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    Object? durationMs = _Undefined,
    List<double>? peaks = const _is.$UndefinedList<double>(),
    String? storagePath,
    _is.UuidValue? uploadedById,
    DateTime? createdAt,
  }) {
    return Sample(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      peaks: peaks is _is.UndefinedSentinel
          ? this.peaks?.map((e0) => e0).toList()
          : peaks,
      storagePath: storagePath ?? this.storagePath,
      uploadedById: uploadedById ?? this.uploadedById,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SampleUpdateTable extends _is.UpdateTable<SampleTable> {
  SampleUpdateTable(super.table);

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

  _is.ColumnValue<_irh2gchs.AudioFormat, _irh2gchs.AudioFormat> format(
    _irh2gchs.AudioFormat value,
  ) => _is.ColumnValue(
    table.format,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<int, int> durationMs(int? value) => _is.ColumnValue(
    table.durationMs,
    value,
  );

  _is.ColumnValue<List<double>, List<double>> peaks(List<double>? value) =>
      _is.ColumnValue(
        table.peaks,
        value,
      );

  _is.ColumnValue<String, String> storagePath(String value) => _is.ColumnValue(
    table.storagePath,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uploadedById(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uploadedById,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SampleTable extends _is.Table<_is.UuidValue?> {
  SampleTable({super.tableRelation}) : super(tableName: 'sample') {
    updateTable = SampleUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    format = _is.ColumnEnum(
      'format',
      this,
      _is.EnumSerialization.byName,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    durationMs = _is.ColumnInt(
      'durationMs',
      this,
    );
    peaks = _is.ColumnSerializable<List<double>>(
      'peaks',
      this,
    );
    storagePath = _is.ColumnString(
      'storagePath',
      this,
    );
    uploadedById = _is.ColumnUuid(
      'uploadedById',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SampleUpdateTable updateTable;

  /// The project; samples are deleted with it.
  late final _is.ColumnUuid projectId;

  /// Display name (file name without extension), 1–80 chars.
  late final _is.ColumnString name;

  /// File format (checked against the file's bytes).
  late final _is.ColumnEnum<_irh2gchs.AudioFormat> format;

  /// File size in bytes (≤ 10 MB).
  late final _is.ColumnInt sizeBytes;

  /// Duration in milliseconds, if known.
  late final _is.ColumnInt durationMs;

  /// Waveform outline (200 peaks, 0–1) for WAV files.
  late final _is.ColumnSerializable<List<double>> peaks;

  /// Server-generated storage path in the private storage.
  late final _is.ColumnString storagePath;

  /// The user who uploaded it.
  late final _is.ColumnUuid uploadedById;

  /// Upload time.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    name,
    format,
    sizeBytes,
    durationMs,
    peaks,
    storagePath,
    uploadedById,
    createdAt,
  ];
}

class SampleInclude extends _is.IncludeObject {
  SampleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Sample.t;
}

class SampleIncludeList extends _is.IncludeList {
  SampleIncludeList._({
    _is.WhereExpressionBuilder<SampleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Sample.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Sample.t;
}

class SampleRepository {
  const SampleRepository._();

  /// Returns a list of [Sample]s matching the given query parameters.
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
  Future<List<Sample>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SampleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Sample>(
      where: where?.call(Sample.t),
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Sample]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Sample.t`.
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
  _ida.Stream<List<Sample>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SampleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Sample>(
      where: where?.call(Sample.t),
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Sample] matching the given query parameters.
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
  Future<Sample?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SampleTable>? where,
    int? offset,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Sample>(
      where: where?.call(Sample.t),
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Sample] by its [id] or null if no such row exists.
  Future<Sample?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Sample>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Sample]s in the list and returns the inserted rows.
  ///
  /// The returned [Sample]s will have their `id` fields set.
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
  Future<List<Sample>> insert(
    _is.DatabaseSession session,
    List<Sample> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Sample>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Sample] and returns the inserted row.
  ///
  /// The returned [Sample] will have its `id` field set.
  Future<Sample> insertRow(
    _is.DatabaseSession session,
    Sample row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Sample>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Sample]s in the list and returns the resulting rows.
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
  /// The returned [Sample]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sample>> upsert(
    _is.DatabaseSession session,
    List<Sample> rows, {
    required _is.ColumnSelections<SampleTable> conflictColumns,
    _is.ColumnSelections<SampleTable>? updateColumns,
    _is.WhereExpressionBuilder<SampleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Sample>(
      rows,
      conflictColumns: conflictColumns(Sample.t),
      updateColumns: updateColumns?.call(Sample.t),
      updateWhere: updateWhere?.call(Sample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Sample] and returns the resulting row.
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
  /// The returned [Sample] will have its `id` field set.
  Future<Sample?> upsertRow(
    _is.DatabaseSession session,
    Sample row, {
    required _is.ColumnSelections<SampleTable> conflictColumns,
    _is.ColumnSelections<SampleTable>? updateColumns,
    _is.WhereExpressionBuilder<SampleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Sample>(
      row,
      conflictColumns: conflictColumns(Sample.t),
      updateColumns: updateColumns?.call(Sample.t),
      updateWhere: updateWhere?.call(Sample.t),
      transaction: transaction,
    );
  }

  /// Updates all [Sample]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sample>> update(
    _is.DatabaseSession session,
    List<Sample> rows, {
    _is.ColumnSelections<SampleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Sample>(
      rows,
      columns: columns?.call(Sample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Sample]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Sample> updateRow(
    _is.DatabaseSession session,
    Sample row, {
    _is.ColumnSelections<SampleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Sample>(
      row,
      columns: columns?.call(Sample.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Sample] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Sample?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SampleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Sample>(
      id,
      columnValues: columnValues(Sample.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Sample]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sample>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SampleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SampleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Sample>(
      columnValues: columnValues(Sample.t.updateTable),
      where: where(Sample.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Sample]s in the list and returns the deleted rows.
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
  Future<List<Sample>> delete(
    _is.DatabaseSession session,
    List<Sample> rows, {
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Sample>(
      rows,
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Sample].
  Future<Sample> deleteRow(
    _is.DatabaseSession session,
    Sample row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Sample>(
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
  Future<List<Sample>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SampleTable> where,
    _is.OrderByBuilder<SampleTable>? orderBy,
    _is.OrderByListBuilder<SampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Sample>(
      where: where(Sample.t),
      orderBy: orderBy?.call(Sample.t),
      orderByList: orderByList?.call(Sample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SampleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Sample>(
      where: where?.call(Sample.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Sample] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SampleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Sample>(
      where: where(Sample.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
