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

/// A pending invitation from a project owner to an email address.
///
/// Stored by email (not user id) so inviting never reveals whether an account
/// exists, and invitations reach people who register later. The row is
/// deleted when accepted, declined or cancelled.
abstract class ProjectInvitation
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProjectInvitation._({
    this.id,
    required this.projectId,
    required this.email,
    required this.role,
    required this.invitedById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProjectInvitation({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String email,
    required _ix943hb1.ProjectRole role,
    required _is.UuidValue invitedById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectInvitationImpl;

  factory ProjectInvitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectInvitation(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      email: jsonSerialization['email'] as String,
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      invitedById: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['invitedById'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProjectInvitationTable();

  static const db = ProjectInvitationRepository._();

  @override
  _is.UuidValue? id;

  /// The project; invitations are deleted with it.
  _is.UuidValue projectId;

  /// Invitee email, normalized (trimmed, lower case).
  String email;

  /// Role granted on acceptance.
  _ix943hb1.ProjectRole role;

  /// The owner who sent the invitation.
  _is.UuidValue invitedById;

  /// When the invitation was sent.
  DateTime createdAt;

  /// Last change (e.g. role updated by re-inviting).
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProjectInvitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectInvitation copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? email,
    _ix943hb1.ProjectRole? role,
    _is.UuidValue? invitedById,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectInvitation',
      if (id != null) 'id': id?.toJson(),
      'projectId': projectId.toJson(),
      'email': email,
      'role': role.toJson(),
      'invitedById': invitedById.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProjectInvitationInclude include() {
    return ProjectInvitationInclude._();
  }

  static ProjectInvitationIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    ProjectInvitationInclude? include,
  }) {
    return ProjectInvitationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProjectInvitationImpl extends ProjectInvitation {
  _ProjectInvitationImpl({
    _is.UuidValue? id,
    required _is.UuidValue projectId,
    required String email,
    required _ix943hb1.ProjectRole role,
    required _is.UuidValue invitedById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         email: email,
         role: role,
         invitedById: invitedById,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProjectInvitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectInvitation copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? projectId,
    String? email,
    _ix943hb1.ProjectRole? role,
    _is.UuidValue? invitedById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectInvitation(
      id: id is _is.UndefinedSentinel ? this.id : id,
      projectId: projectId ?? this.projectId,
      email: email ?? this.email,
      role: role ?? this.role,
      invitedById: invitedById ?? this.invitedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProjectInvitationUpdateTable
    extends _is.UpdateTable<ProjectInvitationTable> {
  ProjectInvitationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> projectId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.projectId,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<_ix943hb1.ProjectRole, _ix943hb1.ProjectRole> role(
    _ix943hb1.ProjectRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> invitedById(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.invitedById,
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

class ProjectInvitationTable extends _is.Table<_is.UuidValue?> {
  ProjectInvitationTable({super.tableRelation})
    : super(tableName: 'project_invitation') {
    updateTable = ProjectInvitationUpdateTable(this);
    projectId = _is.ColumnUuid(
      'projectId',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    invitedById = _is.ColumnUuid(
      'invitedById',
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

  late final ProjectInvitationUpdateTable updateTable;

  /// The project; invitations are deleted with it.
  late final _is.ColumnUuid projectId;

  /// Invitee email, normalized (trimmed, lower case).
  late final _is.ColumnString email;

  /// Role granted on acceptance.
  late final _is.ColumnEnum<_ix943hb1.ProjectRole> role;

  /// The owner who sent the invitation.
  late final _is.ColumnUuid invitedById;

  /// When the invitation was sent.
  late final _is.ColumnDateTime createdAt;

  /// Last change (e.g. role updated by re-inviting).
  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    email,
    role,
    invitedById,
    createdAt,
    updatedAt,
  ];
}

class ProjectInvitationInclude extends _is.IncludeObject {
  ProjectInvitationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectInvitation.t;
}

class ProjectInvitationIncludeList extends _is.IncludeList {
  ProjectInvitationIncludeList._({
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProjectInvitation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectInvitation.t;
}

class ProjectInvitationRepository {
  const ProjectInvitationRepository._();

  /// Returns a list of [ProjectInvitation]s matching the given query parameters.
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
  Future<List<ProjectInvitation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectInvitation>(
      where: where?.call(ProjectInvitation.t),
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProjectInvitation]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProjectInvitation.t`.
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
  _ida.Stream<List<ProjectInvitation>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProjectInvitation>(
      where: where?.call(ProjectInvitation.t),
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProjectInvitation] matching the given query parameters.
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
  Future<ProjectInvitation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectInvitation>(
      where: where?.call(ProjectInvitation.t),
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectInvitation] by its [id] or null if no such row exists.
  Future<ProjectInvitation?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectInvitation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectInvitation]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectInvitation]s will have their `id` fields set.
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
  Future<List<ProjectInvitation>> insert(
    _is.DatabaseSession session,
    List<ProjectInvitation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectInvitation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectInvitation] and returns the inserted row.
  ///
  /// The returned [ProjectInvitation] will have its `id` field set.
  Future<ProjectInvitation> insertRow(
    _is.DatabaseSession session,
    ProjectInvitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectInvitation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectInvitation]s in the list and returns the resulting rows.
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
  /// The returned [ProjectInvitation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectInvitation>> upsert(
    _is.DatabaseSession session,
    List<ProjectInvitation> rows, {
    required _is.ColumnSelections<ProjectInvitationTable> conflictColumns,
    _is.ColumnSelections<ProjectInvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectInvitationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectInvitation>(
      rows,
      conflictColumns: conflictColumns(ProjectInvitation.t),
      updateColumns: updateColumns?.call(ProjectInvitation.t),
      updateWhere: updateWhere?.call(ProjectInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectInvitation] and returns the resulting row.
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
  /// The returned [ProjectInvitation] will have its `id` field set.
  Future<ProjectInvitation?> upsertRow(
    _is.DatabaseSession session,
    ProjectInvitation row, {
    required _is.ColumnSelections<ProjectInvitationTable> conflictColumns,
    _is.ColumnSelections<ProjectInvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectInvitationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectInvitation>(
      row,
      conflictColumns: conflictColumns(ProjectInvitation.t),
      updateColumns: updateColumns?.call(ProjectInvitation.t),
      updateWhere: updateWhere?.call(ProjectInvitation.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectInvitation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectInvitation>> update(
    _is.DatabaseSession session,
    List<ProjectInvitation> rows, {
    _is.ColumnSelections<ProjectInvitationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectInvitation>(
      rows,
      columns: columns?.call(ProjectInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectInvitation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectInvitation> updateRow(
    _is.DatabaseSession session,
    ProjectInvitation row, {
    _is.ColumnSelections<ProjectInvitationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectInvitation>(
      row,
      columns: columns?.call(ProjectInvitation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectInvitation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectInvitation?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectInvitationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectInvitation>(
      id,
      columnValues: columnValues(ProjectInvitation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectInvitation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectInvitation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectInvitationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectInvitationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectInvitation>(
      columnValues: columnValues(ProjectInvitation.t.updateTable),
      where: where(ProjectInvitation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectInvitation]s in the list and returns the deleted rows.
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
  Future<List<ProjectInvitation>> delete(
    _is.DatabaseSession session,
    List<ProjectInvitation> rows, {
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectInvitation>(
      rows,
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectInvitation].
  Future<ProjectInvitation> deleteRow(
    _is.DatabaseSession session,
    ProjectInvitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectInvitation>(
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
  Future<List<ProjectInvitation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectInvitationTable> where,
    _is.OrderByBuilder<ProjectInvitationTable>? orderBy,
    _is.OrderByListBuilder<ProjectInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectInvitation>(
      where: where(ProjectInvitation.t),
      orderBy: orderBy?.call(ProjectInvitation.t),
      orderByList: orderByList?.call(ProjectInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectInvitationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectInvitation>(
      where: where?.call(ProjectInvitation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectInvitation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectInvitationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectInvitation>(
      where: where(ProjectInvitation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
