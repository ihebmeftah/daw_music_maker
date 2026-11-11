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
import '../../../features/projects/enums/project_role.dart' as _ix943hb1;

/// A pending request from a user to join a public project that is open to
/// contributions. Deleted when accepted, declined or cancelled.
abstract class ProjectJoinRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProjectJoinRequest._({
    this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProjectJoinRequest({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required _is.UuidValue userId,
    required _ix943hb1.ProjectRole role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectJoinRequestImpl;

  factory ProjectJoinRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectJoinRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProjectJoinRequestTable();

  static const db = ProjectJoinRequestRepository._();

  @override
  _is.UuidValue? id;

  /// The project; requests are deleted with it.
  _is.UuidValue projectId;

  /// The requesting auth user.
  _is.UuidValue userId;

  /// Role the user asks for.
  _ix943hb1.ProjectRole role;

  /// When the request was sent.
  DateTime createdAt;

  /// Last change (e.g. role updated by re-requesting).
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProjectJoinRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectJoinRequest copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    _is.UuidValue? userId,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectJoinRequest',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      'userId': userId.toJson(),
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProjectJoinRequestInclude include() {
    return ProjectJoinRequestInclude._();
  }

  static ProjectJoinRequestIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    ProjectJoinRequestInclude? include,
  }) {
    return ProjectJoinRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProjectJoinRequestImpl extends ProjectJoinRequest {
  _ProjectJoinRequestImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required _is.UuidValue userId,
    required _ix943hb1.ProjectRole role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         userId: userId,
         role: role,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProjectJoinRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectJoinRequest copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    _is.UuidValue? userId,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectJoinRequest(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProjectJoinRequestUpdateTable
    extends _is.UpdateTable<ProjectJoinRequestTable> {
  ProjectJoinRequestUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> projectId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.projectId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<_ix943hb1.ProjectRole, _ix943hb1.ProjectRole> role(
    _ix943hb1.ProjectRole value,
  ) => _is.ColumnValue(
    table.role,
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

class ProjectJoinRequestTable extends _is.Table<_is.UuidValue?> {
  ProjectJoinRequestTable({super.tableRelation})
    : super(tableName: 'project_join_request') {
    updateTable = ProjectJoinRequestUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
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

  late final ProjectJoinRequestUpdateTable updateTable;

  /// The project; requests are deleted with it.
  late final _is.ColumnUuid projectId;

  /// The requesting auth user.
  late final _is.ColumnUuid userId;

  /// Role the user asks for.
  late final _is.ColumnEnum<_ix943hb1.ProjectRole> role;

  /// When the request was sent.
  late final _is.ColumnDateTime createdAt;

  /// Last change (e.g. role updated by re-requesting).
  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    userId,
    role,
    createdAt,
    updatedAt,
  ];
}

class ProjectJoinRequestInclude extends _is.IncludeObject {
  ProjectJoinRequestInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectJoinRequest.t;
}

class ProjectJoinRequestIncludeList extends _is.IncludeList {
  ProjectJoinRequestIncludeList._({
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProjectJoinRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectJoinRequest.t;
}

class ProjectJoinRequestRepository {
  const ProjectJoinRequestRepository._();

  /// Returns a list of [ProjectJoinRequest]s matching the given query parameters.
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
  Future<List<ProjectJoinRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectJoinRequest>(
      where: where?.call(ProjectJoinRequest.t),
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProjectJoinRequest]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProjectJoinRequest.t`.
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
  _ida.Stream<List<ProjectJoinRequest>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProjectJoinRequest>(
      where: where?.call(ProjectJoinRequest.t),
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProjectJoinRequest] matching the given query parameters.
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
  Future<ProjectJoinRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectJoinRequest>(
      where: where?.call(ProjectJoinRequest.t),
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectJoinRequest] by its [id] or null if no such row exists.
  Future<ProjectJoinRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectJoinRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectJoinRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectJoinRequest]s will have their `id` fields set.
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
  Future<List<ProjectJoinRequest>> insert(
    _is.DatabaseSession session,
    List<ProjectJoinRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectJoinRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectJoinRequest] and returns the inserted row.
  ///
  /// The returned [ProjectJoinRequest] will have its `id` field set.
  Future<ProjectJoinRequest> insertRow(
    _is.DatabaseSession session,
    ProjectJoinRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectJoinRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectJoinRequest]s in the list and returns the resulting rows.
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
  /// The returned [ProjectJoinRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectJoinRequest>> upsert(
    _is.DatabaseSession session,
    List<ProjectJoinRequest> rows, {
    required _is.ColumnSelections<ProjectJoinRequestTable> conflictColumns,
    _is.ColumnSelections<ProjectJoinRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectJoinRequest>(
      rows,
      conflictColumns: conflictColumns(ProjectJoinRequest.t),
      updateColumns: updateColumns?.call(ProjectJoinRequest.t),
      updateWhere: updateWhere?.call(ProjectJoinRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectJoinRequest] and returns the resulting row.
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
  /// The returned [ProjectJoinRequest] will have its `id` field set.
  Future<ProjectJoinRequest?> upsertRow(
    _is.DatabaseSession session,
    ProjectJoinRequest row, {
    required _is.ColumnSelections<ProjectJoinRequestTable> conflictColumns,
    _is.ColumnSelections<ProjectJoinRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectJoinRequest>(
      row,
      conflictColumns: conflictColumns(ProjectJoinRequest.t),
      updateColumns: updateColumns?.call(ProjectJoinRequest.t),
      updateWhere: updateWhere?.call(ProjectJoinRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectJoinRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectJoinRequest>> update(
    _is.DatabaseSession session,
    List<ProjectJoinRequest> rows, {
    _is.ColumnSelections<ProjectJoinRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectJoinRequest>(
      rows,
      columns: columns?.call(ProjectJoinRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectJoinRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectJoinRequest> updateRow(
    _is.DatabaseSession session,
    ProjectJoinRequest row, {
    _is.ColumnSelections<ProjectJoinRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectJoinRequest>(
      row,
      columns: columns?.call(ProjectJoinRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectJoinRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectJoinRequest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectJoinRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectJoinRequest>(
      id,
      columnValues: columnValues(ProjectJoinRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectJoinRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectJoinRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectJoinRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectJoinRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectJoinRequest>(
      columnValues: columnValues(ProjectJoinRequest.t.updateTable),
      where: where(ProjectJoinRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectJoinRequest]s in the list and returns the deleted rows.
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
  Future<List<ProjectJoinRequest>> delete(
    _is.DatabaseSession session,
    List<ProjectJoinRequest> rows, {
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectJoinRequest>(
      rows,
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectJoinRequest].
  Future<ProjectJoinRequest> deleteRow(
    _is.DatabaseSession session,
    ProjectJoinRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectJoinRequest>(
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
  Future<List<ProjectJoinRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectJoinRequestTable> where,
    _is.OrderByBuilder<ProjectJoinRequestTable>? orderBy,
    _is.OrderByListBuilder<ProjectJoinRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectJoinRequest>(
      where: where(ProjectJoinRequest.t),
      orderBy: orderBy?.call(ProjectJoinRequest.t),
      orderByList: orderByList?.call(ProjectJoinRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectJoinRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectJoinRequest>(
      where: where?.call(ProjectJoinRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectJoinRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectJoinRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectJoinRequest>(
      where: where(ProjectJoinRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
