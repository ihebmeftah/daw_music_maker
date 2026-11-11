/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:daw_music_maker_server/src/generated/protocol.dart'
    as _iau3psze;
import 'package:serverpod/serverpod.dart' as _is;
import '../../../features/projects/entities/project_member.dart' as _i029m83h;
import '../../../features/projects/enums/project_visibility.dart' as _iih43j5r;

/// A music project owned by a user.
abstract class Project
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Project._({
    this.id,
    required this.ownerId,
    required this.name,
    String? description,
    required this.genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    this.members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : description = description ?? '',
       visibility = visibility ?? _iih43j5r.ProjectVisibility.private,
       allowContributions = allowContributions ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Project({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String name,
    String? description,
    required List<String> genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    List<_i029m83h.ProjectMember>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectImpl;

  factory Project.fromJson(Map<String, dynamic> jsonSerialization) {
    return Project(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      genres: _iau3psze.Protocol().deserialize<List<String>>(
        jsonSerialization['genres'],
      ),
      visibility: jsonSerialization['visibility'] == null
          ? null
          : _iih43j5r.ProjectVisibility.fromJson(
              (jsonSerialization['visibility'] as String),
            ),
      allowContributions: jsonSerialization['allowContributions'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['allowContributions'],
            ),
      members: jsonSerialization['members'] == null
          ? null
          : _iau3psze.Protocol().deserialize<List<_i029m83h.ProjectMember>>(
              jsonSerialization['members'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProjectTable();

  static const db = ProjectRepository._();

  @override
  _is.UuidValue? id;

  /// The auth user that owns the project.
  _is.UuidValue ownerId;

  /// Display name, 1–80 chars, trimmed.
  String name;

  /// Free-text description, 0–1000 chars, trimmed.
  String description;

  /// Genre tags (max 8, each 1–24 chars, unique case-insensitively).
  List<String> genres;

  /// Who can see the project.
  _iih43j5r.ProjectVisibility visibility;

  /// Whether the owner accepts collaborators (invitations and join requests).
  bool allowContributions;

  /// Members of the project (excluding the owner).
  List<_i029m83h.ProjectMember>? members;

  /// Creation time.
  DateTime createdAt;

  /// Last modification time.
  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Project copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? ownerId,
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    List<_i029m83h.ProjectMember>? members =
        const _is.$UndefinedList<_i029m83h.ProjectMember>(),
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Project',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      'description': description,
      'genres': genres.toJson(),
      'visibility': visibility.toJson(),
      'allowContributions': allowContributions,
      if (members != null)
        'members': members?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProjectInclude include({_i029m83h.ProjectMemberIncludeList? members}) {
    return ProjectInclude._(members: members);
  }

  static ProjectIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    ProjectInclude? include,
  }) {
    return ProjectIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProjectImpl extends Project {
  _ProjectImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String name,
    String? description,
    required List<String> genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    List<_i029m83h.ProjectMember>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         name: name,
         description: description,
         genres: genres,
         visibility: visibility,
         allowContributions: allowContributions,
         members: members,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Project copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    _is.UuidValue? ownerId,
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    List<_i029m83h.ProjectMember>? members =
        const _is.$UndefinedList<_i029m83h.ProjectMember>(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id is _is.UndefinedSentinel ? this.id : id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      genres: genres ?? this.genres.map((e0) => e0).toList(),
      visibility: visibility ?? this.visibility,
      allowContributions: allowContributions ?? this.allowContributions,
      members: members is _is.UndefinedSentinel
          ? this.members?.map((e0) => e0.copyWith()).toList()
          : members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProjectUpdateTable extends _is.UpdateTable<ProjectTable> {
  ProjectUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> genres(List<String> value) =>
      _is.ColumnValue(
        table.genres,
        value,
      );

  _is.ColumnValue<_iih43j5r.ProjectVisibility, _iih43j5r.ProjectVisibility>
  visibility(_iih43j5r.ProjectVisibility value) => _is.ColumnValue(
    table.visibility,
    value,
  );

  _is.ColumnValue<bool, bool> allowContributions(bool value) => _is.ColumnValue(
    table.allowContributions,
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

class ProjectTable extends _is.Table<_is.UuidValue?> {
  ProjectTable({super.tableRelation}) : super(tableName: 'project') {
    updateTable = ProjectUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
      hasDefault: true,
    );
    genres = _is.ColumnSerializable<List<String>>(
      'genres',
      this,
    );
    visibility = _is.ColumnEnum(
      'visibility',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    allowContributions = _is.ColumnBool(
      'allowContributions',
      this,
      hasDefault: true,
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

  late final ProjectUpdateTable updateTable;

  /// The auth user that owns the project.
  late final _is.ColumnUuid ownerId;

  /// Display name, 1–80 chars, trimmed.
  late final _is.ColumnString name;

  /// Free-text description, 0–1000 chars, trimmed.
  late final _is.ColumnString description;

  /// Genre tags (max 8, each 1–24 chars, unique case-insensitively).
  late final _is.ColumnSerializable<List<String>> genres;

  /// Who can see the project.
  late final _is.ColumnEnum<_iih43j5r.ProjectVisibility> visibility;

  /// Whether the owner accepts collaborators (invitations and join requests).
  late final _is.ColumnBool allowContributions;

  /// Members of the project (excluding the owner).
  _i029m83h.ProjectMemberTable? ___members;

  /// Members of the project (excluding the owner).
  _is.ManyRelation<_i029m83h.ProjectMemberTable>? _members;

  /// Creation time.
  late final _is.ColumnDateTime createdAt;

  /// Last modification time.
  late final _is.ColumnDateTime updatedAt;

  _i029m83h.ProjectMemberTable get __members {
    if (___members != null) return ___members!;
    ___members = _is.createRelationTable(
      relationFieldName: '__members',
      field: Project.t.id,
      foreignField: _i029m83h.ProjectMember.t.projectId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i029m83h.ProjectMemberTable(tableRelation: foreignTableRelation),
    );
    return ___members!;
  }

  _is.ManyRelation<_i029m83h.ProjectMemberTable> get members {
    if (_members != null) return _members!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'members',
      field: Project.t.id,
      foreignField: _i029m83h.ProjectMember.t.projectId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i029m83h.ProjectMemberTable(tableRelation: foreignTableRelation),
    );
    _members = _is.ManyRelation<_i029m83h.ProjectMemberTable>(
      tableWithRelations: relationTable,
      table: _i029m83h.ProjectMemberTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _members!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    name,
    description,
    genres,
    visibility,
    allowContributions,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'members') {
      return __members;
    }
    return null;
  }
}

class ProjectInclude extends _is.IncludeObject {
  ProjectInclude._({_i029m83h.ProjectMemberIncludeList? members}) {
    _members = members;
  }

  _i029m83h.ProjectMemberIncludeList? _members;

  @override
  Map<String, _is.Include?> get includes => {'members': _members};

  @override
  _is.Table<_is.UuidValue?> get table => Project.t;
}

class ProjectIncludeList extends _is.IncludeList {
  ProjectIncludeList._({
    _is.WhereExpressionBuilder<ProjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Project.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Project.t;
}

class ProjectRepository {
  const ProjectRepository._();

  final attach = const ProjectAttachRepository._();

  final attachRow = const ProjectAttachRowRepository._();

  /// Returns a list of [Project]s matching the given query parameters.
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
  Future<List<Project>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Project>(
      where: where?.call(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Project]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Project.t`.
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
  _ida.Stream<List<Project>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    ProjectInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Project>(
      where: where?.call(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Project] matching the given query parameters.
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
  Future<Project?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Project>(
      where: where?.call(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Project] by its [id] or null if no such row exists.
  Future<Project?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Project>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Project]s in the list and returns the inserted rows.
  ///
  /// The returned [Project]s will have their `id` fields set.
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
  Future<List<Project>> insert(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Project>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Project] and returns the inserted row.
  ///
  /// The returned [Project] will have its `id` field set.
  Future<Project> insertRow(
    _is.DatabaseSession session,
    Project row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Project>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Project]s in the list and returns the resulting rows.
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
  /// The returned [Project]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> upsert(
    _is.DatabaseSession session,
    List<Project> rows, {
    required _is.ColumnSelections<ProjectTable> conflictColumns,
    _is.ColumnSelections<ProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Project>(
      rows,
      conflictColumns: conflictColumns(Project.t),
      updateColumns: updateColumns?.call(Project.t),
      updateWhere: updateWhere?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Project] and returns the resulting row.
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
  /// The returned [Project] will have its `id` field set.
  Future<Project?> upsertRow(
    _is.DatabaseSession session,
    Project row, {
    required _is.ColumnSelections<ProjectTable> conflictColumns,
    _is.ColumnSelections<ProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Project>(
      row,
      conflictColumns: conflictColumns(Project.t),
      updateColumns: updateColumns?.call(Project.t),
      updateWhere: updateWhere?.call(Project.t),
      transaction: transaction,
    );
  }

  /// Updates all [Project]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> update(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.ColumnSelections<ProjectTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Project>(
      rows,
      columns: columns?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Project]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Project> updateRow(
    _is.DatabaseSession session,
    Project row, {
    _is.ColumnSelections<ProjectTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Project>(
      row,
      columns: columns?.call(Project.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Project] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Project?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Project>(
      id,
      columnValues: columnValues(Project.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Project]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProjectTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Project>(
      columnValues: columnValues(Project.t.updateTable),
      where: where(Project.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Project]s in the list and returns the deleted rows.
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
  Future<List<Project>> delete(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Project>(
      rows,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Project].
  Future<Project> deleteRow(
    _is.DatabaseSession session,
    Project row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Project>(
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
  Future<List<Project>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectTable> where,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Project>(
      where: where(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Project>(
      where: where?.call(Project.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Project] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Project>(
      where: where(Project.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectAttachRepository {
  const ProjectAttachRepository._();

  /// Creates a relation between this [Project] and the given [ProjectMember]s
  /// by setting each [ProjectMember]'s foreign key `projectId` to refer to this [Project].
  Future<void> members(
    _is.DatabaseSession session,
    Project project,
    List<_i029m83h.ProjectMember> projectMember, {
    _is.Transaction? transaction,
  }) async {
    if (projectMember.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectMember.id');
    }
    if (project.id == null) {
      throw ArgumentError.notNull('project.id');
    }

    var $projectMember = projectMember
        .map((e) => e.copyWith(projectId: project.id))
        .toList();
    await session.db.update<_i029m83h.ProjectMember>(
      $projectMember,
      columns: [_i029m83h.ProjectMember.t.projectId],
      transaction: transaction,
    );
  }
}

class ProjectAttachRowRepository {
  const ProjectAttachRowRepository._();

  /// Creates a relation between this [Project] and the given [ProjectMember]
  /// by setting the [ProjectMember]'s foreign key `projectId` to refer to this [Project].
  Future<void> members(
    _is.DatabaseSession session,
    Project project,
    _i029m83h.ProjectMember projectMember, {
    _is.Transaction? transaction,
  }) async {
    if (projectMember.id == null) {
      throw ArgumentError.notNull('projectMember.id');
    }
    if (project.id == null) {
      throw ArgumentError.notNull('project.id');
    }

    var $projectMember = projectMember.copyWith(projectId: project.id);
    await session.db.updateRow<_i029m83h.ProjectMember>(
      $projectMember,
      columns: [_i029m83h.ProjectMember.t.projectId],
      transaction: transaction,
    );
  }
}
