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
import '../../../features/channels/enums/sample_kind.dart' as _ixhlpt54;

/// A channel of a project's channel rack: one instrument (a built-in drum
/// or an uploaded sample) with sampler settings; its notes live in patterns.
abstract class Channel
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Channel._({
    this.id,
    required this.projectId,
    required this.name,
    this.sample,
    this.sampleId,
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    required this.position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : volume = volume ?? 0.8,
       muted = muted ?? false,
       pan = pan ?? 0.0,
       pitch = pitch ?? 0,
       startFrac = startFrac ?? 0.0,
       endFrac = endFrac ?? 1.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Channel({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    _ixhlpt54.SampleKind? sample,
    _is.UuidValue? sampleId,
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    required int position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChannelImpl;

  factory Channel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Channel(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      sample: jsonSerialization['sample'] == null
          ? null
          : _ixhlpt54.SampleKind.fromJson(
              (jsonSerialization['sample'] as String),
            ),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      volume: (jsonSerialization['volume'] as num?)?.toDouble(),
      muted: jsonSerialization['muted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['muted']),
      pan: (jsonSerialization['pan'] as num?)?.toDouble(),
      pitch: jsonSerialization['pitch'] as int?,
      startFrac: (jsonSerialization['startFrac'] as num?)?.toDouble(),
      endFrac: (jsonSerialization['endFrac'] as num?)?.toDouble(),
      position: jsonSerialization['position'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ChannelTable();

  static const db = ChannelRepository._();

  @override
  _is.UuidValue? id;

  /// The project; channels are deleted with it.
  _is.UuidValue projectId;

  /// Display name, 1–40 chars, trimmed.
  String name;

  /// The built-in sample this channel plays (null when [sampleId] is set).
  _ixhlpt54.SampleKind? sample;

  /// The uploaded sample this channel plays; channels go with their sample.
  _is.UuidValue? sampleId;

  /// Volume, 0.0–1.0.
  double volume;

  /// Whether the channel is silenced.
  bool muted;

  /// Stereo position, -1.0 (left) – 1.0 (right).
  double pan;

  /// Transposition in semitones (-24 – 24), applied to every note.
  int pitch;

  /// Start of the played region, fraction of the sample (0.0–1.0).
  double startFrac;

  /// End of the played region, fraction of the sample (> start, ≤ 1.0).
  double endFrac;

  /// Order in the rack (ascending, gaps allowed).
  int position;

  /// Creation time.
  DateTime createdAt;

  /// Last modification time.
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Channel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Channel copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    _ixhlpt54.SampleKind? sample,
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Channel',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      if (sample != null) 'sample': sample?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      'volume': volume,
      'muted': muted,
      'pan': pan,
      'pitch': pitch,
      'startFrac': startFrac,
      'endFrac': endFrac,
      'position': position,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ChannelInclude include() {
    return ChannelInclude._();
  }

  static ChannelIncludeList includeList({
    _is.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    ChannelInclude? include,
  }) {
    return ChannelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelImpl extends Channel {
  _ChannelImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String name,
    _ixhlpt54.SampleKind? sample,
    _is.UuidValue? sampleId,
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    required int position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         sample: sample,
         sampleId: sampleId,
         volume: volume,
         muted: muted,
         pan: pan,
         pitch: pitch,
         startFrac: startFrac,
         endFrac: endFrac,
         position: position,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Channel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Channel copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? name,
    Object? sample = _Undefined,
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Channel(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      sample: sample is _ixhlpt54.SampleKind? ? sample : this.sample,
      sampleId: sampleId is _is.UndefinedSentinel ? this.sampleId : sampleId,
      volume: volume ?? this.volume,
      muted: muted ?? this.muted,
      pan: pan ?? this.pan,
      pitch: pitch ?? this.pitch,
      startFrac: startFrac ?? this.startFrac,
      endFrac: endFrac ?? this.endFrac,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ChannelUpdateTable extends _is.UpdateTable<ChannelTable> {
  ChannelUpdateTable(super.table);

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

  _is.ColumnValue<_ixhlpt54.SampleKind, _ixhlpt54.SampleKind> sample(
    _ixhlpt54.SampleKind? value,
  ) => _is.ColumnValue(
    table.sample,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sampleId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.sampleId,
    value,
  );

  _is.ColumnValue<double, double> volume(double value) => _is.ColumnValue(
    table.volume,
    value,
  );

  _is.ColumnValue<bool, bool> muted(bool value) => _is.ColumnValue(
    table.muted,
    value,
  );

  _is.ColumnValue<double, double> pan(double value) => _is.ColumnValue(
    table.pan,
    value,
  );

  _is.ColumnValue<int, int> pitch(int value) => _is.ColumnValue(
    table.pitch,
    value,
  );

  _is.ColumnValue<double, double> startFrac(double value) => _is.ColumnValue(
    table.startFrac,
    value,
  );

  _is.ColumnValue<double, double> endFrac(double value) => _is.ColumnValue(
    table.endFrac,
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

class ChannelTable extends _is.Table<_is.UuidValue?> {
  ChannelTable({super.tableRelation}) : super(tableName: 'channel') {
    updateTable = ChannelUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    sample = _is.ColumnEnum(
      'sample',
      this,
      _is.EnumSerialization.byName,
    );
    sampleId = _is.ColumnUuid(
      'sampleId',
      this,
    );
    volume = _is.ColumnDouble(
      'volume',
      this,
      hasDefault: true,
    );
    muted = _is.ColumnBool(
      'muted',
      this,
      hasDefault: true,
    );
    pan = _is.ColumnDouble(
      'pan',
      this,
      hasDefault: true,
    );
    pitch = _is.ColumnInt(
      'pitch',
      this,
      hasDefault: true,
    );
    startFrac = _is.ColumnDouble(
      'startFrac',
      this,
      hasDefault: true,
    );
    endFrac = _is.ColumnDouble(
      'endFrac',
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

  late final ChannelUpdateTable updateTable;

  /// The project; channels are deleted with it.
  late final _is.ColumnUuid projectId;

  /// Display name, 1–40 chars, trimmed.
  late final _is.ColumnString name;

  /// The built-in sample this channel plays (null when [sampleId] is set).
  late final _is.ColumnEnum<_ixhlpt54.SampleKind> sample;

  /// The uploaded sample this channel plays; channels go with their sample.
  late final _is.ColumnUuid sampleId;

  /// Volume, 0.0–1.0.
  late final _is.ColumnDouble volume;

  /// Whether the channel is silenced.
  late final _is.ColumnBool muted;

  /// Stereo position, -1.0 (left) – 1.0 (right).
  late final _is.ColumnDouble pan;

  /// Transposition in semitones (-24 – 24), applied to every note.
  late final _is.ColumnInt pitch;

  /// Start of the played region, fraction of the sample (0.0–1.0).
  late final _is.ColumnDouble startFrac;

  /// End of the played region, fraction of the sample (> start, ≤ 1.0).
  late final _is.ColumnDouble endFrac;

  /// Order in the rack (ascending, gaps allowed).
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
    sample,
    sampleId,
    volume,
    muted,
    pan,
    pitch,
    startFrac,
    endFrac,
    position,
    createdAt,
    updatedAt,
  ];
}

class ChannelInclude extends _is.IncludeObject {
  ChannelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Channel.t;
}

class ChannelIncludeList extends _is.IncludeList {
  ChannelIncludeList._({
    _is.WhereExpressionBuilder<ChannelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Channel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Channel.t;
}

class ChannelRepository {
  const ChannelRepository._();

  /// Returns a list of [Channel]s matching the given query parameters.
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
  Future<List<Channel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Channel>(
      where: where?.call(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Channel]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Channel.t`.
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
  _ida.Stream<List<Channel>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Channel>(
      where: where?.call(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Channel] matching the given query parameters.
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
  Future<Channel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChannelTable>? where,
    int? offset,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Channel>(
      where: where?.call(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Channel] by its [id] or null if no such row exists.
  Future<Channel?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Channel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Channel]s in the list and returns the inserted rows.
  ///
  /// The returned [Channel]s will have their `id` fields set.
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
  Future<List<Channel>> insert(
    _is.DatabaseSession session,
    List<Channel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Channel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Channel] and returns the inserted row.
  ///
  /// The returned [Channel] will have its `id` field set.
  Future<Channel> insertRow(
    _is.DatabaseSession session,
    Channel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Channel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Channel]s in the list and returns the resulting rows.
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
  /// The returned [Channel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Channel>> upsert(
    _is.DatabaseSession session,
    List<Channel> rows, {
    required _is.ColumnSelections<ChannelTable> conflictColumns,
    _is.ColumnSelections<ChannelTable>? updateColumns,
    _is.WhereExpressionBuilder<ChannelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Channel>(
      rows,
      conflictColumns: conflictColumns(Channel.t),
      updateColumns: updateColumns?.call(Channel.t),
      updateWhere: updateWhere?.call(Channel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Channel] and returns the resulting row.
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
  /// The returned [Channel] will have its `id` field set.
  Future<Channel?> upsertRow(
    _is.DatabaseSession session,
    Channel row, {
    required _is.ColumnSelections<ChannelTable> conflictColumns,
    _is.ColumnSelections<ChannelTable>? updateColumns,
    _is.WhereExpressionBuilder<ChannelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Channel>(
      row,
      conflictColumns: conflictColumns(Channel.t),
      updateColumns: updateColumns?.call(Channel.t),
      updateWhere: updateWhere?.call(Channel.t),
      transaction: transaction,
    );
  }

  /// Updates all [Channel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Channel>> update(
    _is.DatabaseSession session,
    List<Channel> rows, {
    _is.ColumnSelections<ChannelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Channel>(
      rows,
      columns: columns?.call(Channel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Channel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Channel> updateRow(
    _is.DatabaseSession session,
    Channel row, {
    _is.ColumnSelections<ChannelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Channel>(
      row,
      columns: columns?.call(Channel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Channel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Channel?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ChannelUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Channel>(
      id,
      columnValues: columnValues(Channel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Channel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Channel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChannelUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ChannelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Channel>(
      columnValues: columnValues(Channel.t.updateTable),
      where: where(Channel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Channel]s in the list and returns the deleted rows.
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
  Future<List<Channel>> delete(
    _is.DatabaseSession session,
    List<Channel> rows, {
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Channel>(
      rows,
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Channel].
  Future<Channel> deleteRow(
    _is.DatabaseSession session,
    Channel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Channel>(
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
  Future<List<Channel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChannelTable> where,
    _is.OrderByBuilder<ChannelTable>? orderBy,
    _is.OrderByListBuilder<ChannelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Channel>(
      where: where(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Channel>(
      where: where?.call(Channel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Channel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChannelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Channel>(
      where: where(Channel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
