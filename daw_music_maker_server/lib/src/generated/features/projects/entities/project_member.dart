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

/// A user (other than the owner) who collaborates on a project.
abstract class ProjectMember
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProjectMember._({
    this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProjectMember({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required _is.UuidValue userId,
    required _ix943hb1.ProjectRole role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectMemberImpl;

  factory ProjectMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectMember(
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

  static final t = ProjectMemberTable();

  static const db = ProjectMemberRepository._();

  @override
  _is.UuidValue? id;

  /// The project; members are deleted with it.
  _is.UuidValue projectId;

  /// The member's auth user id.
  _is.UuidValue userId;

  /// What the member may do.
  _ix943hb1.ProjectRole role;

  /// When the member joined.
  DateTime createdAt;

  /// Last role change.
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProjectMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectMember copyWith({
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
      '__className__': 'ProjectMember',
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

  static ProjectMemberInclude include() {
    return ProjectMemberInclude._();
  }

  static ProjectMemberIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    ProjectMemberInclude? include,
  }) {
    return ProjectMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProjectMemberImpl extends ProjectMember {
  _ProjectMemberImpl({
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

  /// Returns a shallow copy of this [ProjectMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectMember copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    _is.UuidValue? userId,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectMember(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProjectMemberUpdateTable extends _is.UpdateTable<ProjectMemberTable> {
  ProjectMemberUpdateTable(super.table);

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

class ProjectMemberTable extends _is.Table<_is.UuidValue?> {
  ProjectMemberTable({super.tableRelation})
    : super(tableName: 'project_member') {
    updateTable = ProjectMemberUpdateTable(this);
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

  late final ProjectMemberUpdateTable updateTable;

  /// The project; members are deleted with it.
  late final _is.ColumnUuid projectId;

  /// The member's auth user id.
  late final _is.ColumnUuid userId;

  /// What the member may do.
  late final _is.ColumnEnum<_ix943hb1.ProjectRole> role;

  /// When the member joined.
  late final _is.ColumnDateTime createdAt;

  /// Last role change.
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

class ProjectMemberInclude extends _is.IncludeObject {
  ProjectMemberInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectMember.t;
}

class ProjectMemberIncludeList extends _is.IncludeList {
  ProjectMemberIncludeList._({
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProjectMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectMember.t;
}

class ProjectMemberRepository {
  const ProjectMemberRepository._();

  /// Returns a list of [ProjectMember]s matching the given query parameters.
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
  Future<List<ProjectMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectMember>(
      where: where?.call(ProjectMember.t),
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProjectMember]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProjectMember.t`.
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
  _ida.Stream<List<ProjectMember>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProjectMember>(
      where: where?.call(ProjectMember.t),
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProjectMember] matching the given query parameters.
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
  Future<ProjectMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectMember>(
      where: where?.call(ProjectMember.t),
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectMember] by its [id] or null if no such row exists.
  Future<ProjectMember?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectMember]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectMember]s will have their `id` fields set.
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
  Future<List<ProjectMember>> insert(
    _is.DatabaseSession session,
    List<ProjectMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectMember] and returns the inserted row.
  ///
  /// The returned [ProjectMember] will have its `id` field set.
  Future<ProjectMember> insertRow(
    _is.DatabaseSession session,
    ProjectMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectMember]s in the list and returns the resulting rows.
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
  /// The returned [ProjectMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectMember>> upsert(
    _is.DatabaseSession session,
    List<ProjectMember> rows, {
    required _is.ColumnSelections<ProjectMemberTable> conflictColumns,
    _is.ColumnSelections<ProjectMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectMember>(
      rows,
      conflictColumns: conflictColumns(ProjectMember.t),
      updateColumns: updateColumns?.call(ProjectMember.t),
      updateWhere: updateWhere?.call(ProjectMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectMember] and returns the resulting row.
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
  /// The returned [ProjectMember] will have its `id` field set.
  Future<ProjectMember?> upsertRow(
    _is.DatabaseSession session,
    ProjectMember row, {
    required _is.ColumnSelections<ProjectMemberTable> conflictColumns,
    _is.ColumnSelections<ProjectMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectMember>(
      row,
      conflictColumns: conflictColumns(ProjectMember.t),
      updateColumns: updateColumns?.call(ProjectMember.t),
      updateWhere: updateWhere?.call(ProjectMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectMember>> update(
    _is.DatabaseSession session,
    List<ProjectMember> rows, {
    _is.ColumnSelections<ProjectMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectMember>(
      rows,
      columns: columns?.call(ProjectMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectMember> updateRow(
    _is.DatabaseSession session,
    ProjectMember row, {
    _is.ColumnSelections<ProjectMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectMember>(
      row,
      columns: columns?.call(ProjectMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectMember?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectMemberUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectMember>(
      id,
      columnValues: columnValues(ProjectMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectMemberUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProjectMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectMember>(
      columnValues: columnValues(ProjectMember.t.updateTable),
      where: where(ProjectMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectMember]s in the list and returns the deleted rows.
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
  Future<List<ProjectMember>> delete(
    _is.DatabaseSession session,
    List<ProjectMember> rows, {
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectMember>(
      rows,
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectMember].
  Future<ProjectMember> deleteRow(
    _is.DatabaseSession session,
    ProjectMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectMember>(
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
  Future<List<ProjectMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectMemberTable> where,
    _is.OrderByBuilder<ProjectMemberTable>? orderBy,
    _is.OrderByListBuilder<ProjectMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectMember>(
      where: where(ProjectMember.t),
      orderBy: orderBy?.call(ProjectMember.t),
      orderByList: orderByList?.call(ProjectMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectMember>(
      where: where?.call(ProjectMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectMember>(
      where: where(ProjectMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
