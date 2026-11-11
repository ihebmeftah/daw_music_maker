/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:daw_music_maker_server/src/generated/features/projects/responses/join_request_response.dart'
    as _i2s7w22c;
import 'package:daw_music_maker_server/src/generated/features/projects/responses/project_invitation_response.dart'
    as _i4423fmy;
import 'package:daw_music_maker_server/src/generated/features/projects/responses/project_member_response.dart'
    as _izpn6734;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'core/exceptions/app_exception.dart' as _i6tx3c89;
import 'core/exceptions/error_code.dart' as _io9cb3tb;
import 'features/projects/dtos/create_project_request.dart' as _i0xj56nk;
import 'features/projects/dtos/invite_member_request.dart' as _i5w541ev;
import 'features/projects/dtos/join_project_request.dart' as _i0ycjkhg;
import 'features/projects/dtos/update_member_role_request.dart' as _i3b4trqk;
import 'features/projects/dtos/update_project_request.dart' as _irgz1vpl;
import 'features/projects/dtos/update_project_tempo_request.dart' as _i9oua2ep;
import 'features/projects/entities/project.dart' as _ie16xf8k;
import 'features/projects/entities/project_invitation.dart' as _irpprho8;
import 'features/projects/entities/project_join_request.dart' as _idf344jl;
import 'features/projects/entities/project_member.dart' as _il1b74wc;
import 'features/projects/enums/project_access.dart' as _i6vudz19;
import 'features/projects/enums/project_role.dart' as _ila8m0sm;
import 'features/projects/enums/project_visibility.dart' as _idtmlsij;
import 'features/projects/responses/join_request_response.dart' as _i8vdw8uk;
import 'features/projects/responses/project_invitation_response.dart'
    as _iaq84bw0;
import 'features/projects/responses/project_member_response.dart' as _igc9pbfz;
import 'features/projects/responses/project_page_response.dart' as _i9wl0ad1;
import 'features/projects/responses/project_response.dart' as _iefrfged;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'core/exceptions/app_exception.dart';
export 'core/exceptions/error_code.dart';
export 'features/projects/dtos/create_project_request.dart';
export 'features/projects/dtos/invite_member_request.dart';
export 'features/projects/dtos/join_project_request.dart';
export 'features/projects/dtos/update_member_role_request.dart';
export 'features/projects/dtos/update_project_request.dart';
export 'features/projects/dtos/update_project_tempo_request.dart';
export 'features/projects/entities/project.dart';
export 'features/projects/entities/project_invitation.dart';
export 'features/projects/entities/project_join_request.dart';
export 'features/projects/entities/project_member.dart';
export 'features/projects/enums/project_access.dart';
export 'features/projects/enums/project_role.dart';
export 'features/projects/enums/project_visibility.dart';
export 'features/projects/responses/join_request_response.dart';
export 'features/projects/responses/project_invitation_response.dart';
export 'features/projects/responses/project_member_response.dart';
export 'features/projects/responses/project_page_response.dart';
export 'features/projects/responses/project_response.dart';
export 'greetings/greeting.dart';

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_i6tx3c89.AppException>,
          _is.getType<_io9cb3tb.ErrorCode>,
          _is.getType<_i0xj56nk.CreateProjectRequest>,
          _is.getType<_i5w541ev.InviteMemberRequest>,
          _is.getType<_i0ycjkhg.JoinProjectRequest>,
          _is.getType<_i3b4trqk.UpdateMemberRoleRequest>,
          _is.getType<_irgz1vpl.UpdateProjectRequest>,
          _is.getType<_i9oua2ep.UpdateProjectTempoRequest>,
          _is.getType<_ie16xf8k.Project>,
          _is.getType<_irpprho8.ProjectInvitation>,
          _is.getType<_idf344jl.ProjectJoinRequest>,
          _is.getType<_il1b74wc.ProjectMember>,
          _is.getType<_i6vudz19.ProjectAccess>,
          _is.getType<_ila8m0sm.ProjectRole>,
          _is.getType<_idtmlsij.ProjectVisibility>,
          _is.getType<_i8vdw8uk.JoinRequestResponse>,
          _is.getType<_iaq84bw0.ProjectInvitationResponse>,
          _is.getType<_igc9pbfz.ProjectMemberResponse>,
          _is.getType<_i9wl0ad1.ProjectPageResponse>,
          _is.getType<_iefrfged.ProjectResponse>,
          _is.getType<_izw8z7ou.Greeting>,
          _is.getType<_i6tx3c89.AppException?>,
          _is.getType<_io9cb3tb.ErrorCode?>,
          _is.getType<_i0xj56nk.CreateProjectRequest?>,
          _is.getType<_i5w541ev.InviteMemberRequest?>,
          _is.getType<_i0ycjkhg.JoinProjectRequest?>,
          _is.getType<_i3b4trqk.UpdateMemberRoleRequest?>,
          _is.getType<_irgz1vpl.UpdateProjectRequest?>,
          _is.getType<_i9oua2ep.UpdateProjectTempoRequest?>,
          _is.getType<_ie16xf8k.Project?>,
          _is.getType<_irpprho8.ProjectInvitation?>,
          _is.getType<_idf344jl.ProjectJoinRequest?>,
          _is.getType<_il1b74wc.ProjectMember?>,
          _is.getType<_i6vudz19.ProjectAccess?>,
          _is.getType<_ila8m0sm.ProjectRole?>,
          _is.getType<_idtmlsij.ProjectVisibility?>,
          _is.getType<_i8vdw8uk.JoinRequestResponse?>,
          _is.getType<_iaq84bw0.ProjectInvitationResponse?>,
          _is.getType<_igc9pbfz.ProjectMemberResponse?>,
          _is.getType<_i9wl0ad1.ProjectPageResponse?>,
          _is.getType<_iefrfged.ProjectResponse?>,
          _is.getType<_izw8z7ou.Greeting?>,
          _is.getType<Map<String, String>>,
          _is.getType<Map<String, String>?>,
          _is.getType<List<String>>,
          _is.getType<List<_il1b74wc.ProjectMember>>,
          _is.getType<List<_il1b74wc.ProjectMember>?>,
          _is.getType<List<_iefrfged.ProjectResponse>>,
          _is.getType<List<_izpn6734.ProjectMemberResponse>>,
          _is.getType<List<_i4423fmy.ProjectInvitationResponse>>,
          _is.getType<List<_i2s7w22c.JoinRequestResponse>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
        ],
        classNames: const [
          'AppException',
          'ErrorCode',
          'CreateProjectRequest',
          'InviteMemberRequest',
          'JoinProjectRequest',
          'UpdateMemberRoleRequest',
          'UpdateProjectRequest',
          'UpdateProjectTempoRequest',
          'Project',
          'ProjectInvitation',
          'ProjectJoinRequest',
          'ProjectMember',
          'ProjectAccess',
          'ProjectRole',
          'ProjectVisibility',
          'JoinRequestResponse',
          'ProjectInvitationResponse',
          'ProjectMemberResponse',
          'ProjectPageResponse',
          'ProjectResponse',
          'Greeting',
        ],
      );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'project',
      dartName: 'Project',
      schema: 'public',
      module: 'daw_music_maker',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'genres',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'visibility',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProjectVisibility',
          columnDefault: '\'private\'',
        ),
        _isp.ColumnDefinition(
          name: 'allowContributions',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'bpm',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '120.0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'project_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'project_visibility_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'visibility',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'updatedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'project_invitation',
      dartName: 'ProjectInvitation',
      schema: 'public',
      module: 'daw_music_maker',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'projectId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProjectRole',
        ),
        _isp.ColumnDefinition(
          name: 'invitedById',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'project_invitation_fk_0',
          columns: ['projectId'],
          referenceTable: 'project',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'project_invitation_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'project_invitation_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'project_join_request',
      dartName: 'ProjectJoinRequest',
      schema: 'public',
      module: 'daw_music_maker',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'projectId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProjectRole',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'project_join_request_fk_0',
          columns: ['projectId'],
          referenceTable: 'project',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'project_join_request_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'project_join_request_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'project_member',
      dartName: 'ProjectMember',
      schema: 'public',
      module: 'daw_music_maker',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'projectId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProjectRole',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'project_member_fk_0',
          columns: ['projectId'],
          referenceTable: 'project',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'project_member_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'project_member_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i6tx3c89.AppException) {
      return _i6tx3c89.AppException.fromJson(data) as T;
    }
    if (t == _io9cb3tb.ErrorCode) {
      return _io9cb3tb.ErrorCode.fromJson(data) as T;
    }
    if (t == _i0xj56nk.CreateProjectRequest) {
      return _i0xj56nk.CreateProjectRequest.fromJson(data) as T;
    }
    if (t == _i5w541ev.InviteMemberRequest) {
      return _i5w541ev.InviteMemberRequest.fromJson(data) as T;
    }
    if (t == _i0ycjkhg.JoinProjectRequest) {
      return _i0ycjkhg.JoinProjectRequest.fromJson(data) as T;
    }
    if (t == _i3b4trqk.UpdateMemberRoleRequest) {
      return _i3b4trqk.UpdateMemberRoleRequest.fromJson(data) as T;
    }
    if (t == _irgz1vpl.UpdateProjectRequest) {
      return _irgz1vpl.UpdateProjectRequest.fromJson(data) as T;
    }
    if (t == _i9oua2ep.UpdateProjectTempoRequest) {
      return _i9oua2ep.UpdateProjectTempoRequest.fromJson(data) as T;
    }
    if (t == _ie16xf8k.Project) {
      return _ie16xf8k.Project.fromJson(data) as T;
    }
    if (t == _irpprho8.ProjectInvitation) {
      return _irpprho8.ProjectInvitation.fromJson(data) as T;
    }
    if (t == _idf344jl.ProjectJoinRequest) {
      return _idf344jl.ProjectJoinRequest.fromJson(data) as T;
    }
    if (t == _il1b74wc.ProjectMember) {
      return _il1b74wc.ProjectMember.fromJson(data) as T;
    }
    if (t == _i6vudz19.ProjectAccess) {
      return _i6vudz19.ProjectAccess.fromJson(data) as T;
    }
    if (t == _ila8m0sm.ProjectRole) {
      return _ila8m0sm.ProjectRole.fromJson(data) as T;
    }
    if (t == _idtmlsij.ProjectVisibility) {
      return _idtmlsij.ProjectVisibility.fromJson(data) as T;
    }
    if (t == _i8vdw8uk.JoinRequestResponse) {
      return _i8vdw8uk.JoinRequestResponse.fromJson(data) as T;
    }
    if (t == _iaq84bw0.ProjectInvitationResponse) {
      return _iaq84bw0.ProjectInvitationResponse.fromJson(data) as T;
    }
    if (t == _igc9pbfz.ProjectMemberResponse) {
      return _igc9pbfz.ProjectMemberResponse.fromJson(data) as T;
    }
    if (t == _i9wl0ad1.ProjectPageResponse) {
      return _i9wl0ad1.ProjectPageResponse.fromJson(data) as T;
    }
    if (t == _iefrfged.ProjectResponse) {
      return _iefrfged.ProjectResponse.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _is.getType<_i6tx3c89.AppException?>()) {
      return (data != null ? _i6tx3c89.AppException.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_io9cb3tb.ErrorCode?>()) {
      return (data != null ? _io9cb3tb.ErrorCode.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0xj56nk.CreateProjectRequest?>()) {
      return (data != null
              ? _i0xj56nk.CreateProjectRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5w541ev.InviteMemberRequest?>()) {
      return (data != null
              ? _i5w541ev.InviteMemberRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i0ycjkhg.JoinProjectRequest?>()) {
      return (data != null ? _i0ycjkhg.JoinProjectRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3b4trqk.UpdateMemberRoleRequest?>()) {
      return (data != null
              ? _i3b4trqk.UpdateMemberRoleRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irgz1vpl.UpdateProjectRequest?>()) {
      return (data != null
              ? _irgz1vpl.UpdateProjectRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9oua2ep.UpdateProjectTempoRequest?>()) {
      return (data != null
              ? _i9oua2ep.UpdateProjectTempoRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ie16xf8k.Project?>()) {
      return (data != null ? _ie16xf8k.Project.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irpprho8.ProjectInvitation?>()) {
      return (data != null ? _irpprho8.ProjectInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idf344jl.ProjectJoinRequest?>()) {
      return (data != null ? _idf344jl.ProjectJoinRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il1b74wc.ProjectMember?>()) {
      return (data != null ? _il1b74wc.ProjectMember.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6vudz19.ProjectAccess?>()) {
      return (data != null ? _i6vudz19.ProjectAccess.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ila8m0sm.ProjectRole?>()) {
      return (data != null ? _ila8m0sm.ProjectRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idtmlsij.ProjectVisibility?>()) {
      return (data != null ? _idtmlsij.ProjectVisibility.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8vdw8uk.JoinRequestResponse?>()) {
      return (data != null
              ? _i8vdw8uk.JoinRequestResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iaq84bw0.ProjectInvitationResponse?>()) {
      return (data != null
              ? _iaq84bw0.ProjectInvitationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_igc9pbfz.ProjectMemberResponse?>()) {
      return (data != null
              ? _igc9pbfz.ProjectMemberResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9wl0ad1.ProjectPageResponse?>()) {
      return (data != null
              ? _i9wl0ad1.ProjectPageResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iefrfged.ProjectResponse?>()) {
      return (data != null ? _iefrfged.ProjectResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _is.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_il1b74wc.ProjectMember>) {
      return (data as List)
              .map((e) => deserialize<_il1b74wc.ProjectMember>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_il1b74wc.ProjectMember>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_il1b74wc.ProjectMember>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iefrfged.ProjectResponse>) {
      return (data as List)
              .map((e) => deserialize<_iefrfged.ProjectResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_izpn6734.ProjectMemberResponse>) {
      return (data as List)
              .map((e) => deserialize<_izpn6734.ProjectMemberResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i4423fmy.ProjectInvitationResponse>) {
      return (data as List)
              .map((e) => deserialize<_i4423fmy.ProjectInvitationResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i2s7w22c.JoinRequestResponse>) {
      return (data as List)
              .map((e) => deserialize<_i2s7w22c.JoinRequestResponse>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i6tx3c89.AppException => 'AppException',
      _io9cb3tb.ErrorCode => 'ErrorCode',
      _i0xj56nk.CreateProjectRequest => 'CreateProjectRequest',
      _i5w541ev.InviteMemberRequest => 'InviteMemberRequest',
      _i0ycjkhg.JoinProjectRequest => 'JoinProjectRequest',
      _i3b4trqk.UpdateMemberRoleRequest => 'UpdateMemberRoleRequest',
      _irgz1vpl.UpdateProjectRequest => 'UpdateProjectRequest',
      _i9oua2ep.UpdateProjectTempoRequest => 'UpdateProjectTempoRequest',
      _ie16xf8k.Project => 'Project',
      _irpprho8.ProjectInvitation => 'ProjectInvitation',
      _idf344jl.ProjectJoinRequest => 'ProjectJoinRequest',
      _il1b74wc.ProjectMember => 'ProjectMember',
      _i6vudz19.ProjectAccess => 'ProjectAccess',
      _ila8m0sm.ProjectRole => 'ProjectRole',
      _idtmlsij.ProjectVisibility => 'ProjectVisibility',
      _i8vdw8uk.JoinRequestResponse => 'JoinRequestResponse',
      _iaq84bw0.ProjectInvitationResponse => 'ProjectInvitationResponse',
      _igc9pbfz.ProjectMemberResponse => 'ProjectMemberResponse',
      _i9wl0ad1.ProjectPageResponse => 'ProjectPageResponse',
      _iefrfged.ProjectResponse => 'ProjectResponse',
      _izw8z7ou.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'daw_music_maker.',
        '',
      );
    }

    switch (data) {
      case _i6tx3c89.AppException():
        return 'AppException';
      case _io9cb3tb.ErrorCode():
        return 'ErrorCode';
      case _i0xj56nk.CreateProjectRequest():
        return 'CreateProjectRequest';
      case _i5w541ev.InviteMemberRequest():
        return 'InviteMemberRequest';
      case _i0ycjkhg.JoinProjectRequest():
        return 'JoinProjectRequest';
      case _i3b4trqk.UpdateMemberRoleRequest():
        return 'UpdateMemberRoleRequest';
      case _irgz1vpl.UpdateProjectRequest():
        return 'UpdateProjectRequest';
      case _i9oua2ep.UpdateProjectTempoRequest():
        return 'UpdateProjectTempoRequest';
      case _ie16xf8k.Project():
        return 'Project';
      case _irpprho8.ProjectInvitation():
        return 'ProjectInvitation';
      case _idf344jl.ProjectJoinRequest():
        return 'ProjectJoinRequest';
      case _il1b74wc.ProjectMember():
        return 'ProjectMember';
      case _i6vudz19.ProjectAccess():
        return 'ProjectAccess';
      case _ila8m0sm.ProjectRole():
        return 'ProjectRole';
      case _idtmlsij.ProjectVisibility():
        return 'ProjectVisibility';
      case _i8vdw8uk.JoinRequestResponse():
        return 'JoinRequestResponse';
      case _iaq84bw0.ProjectInvitationResponse():
        return 'ProjectInvitationResponse';
      case _igc9pbfz.ProjectMemberResponse():
        return 'ProjectMemberResponse';
      case _i9wl0ad1.ProjectPageResponse():
        return 'ProjectPageResponse';
      case _iefrfged.ProjectResponse():
        return 'ProjectResponse';
      case _izw8z7ou.Greeting():
        return 'Greeting';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppException') {
      return deserialize<_i6tx3c89.AppException>(data['data']);
    }
    if (dataClassName == 'ErrorCode') {
      return deserialize<_io9cb3tb.ErrorCode>(data['data']);
    }
    if (dataClassName == 'CreateProjectRequest') {
      return deserialize<_i0xj56nk.CreateProjectRequest>(data['data']);
    }
    if (dataClassName == 'InviteMemberRequest') {
      return deserialize<_i5w541ev.InviteMemberRequest>(data['data']);
    }
    if (dataClassName == 'JoinProjectRequest') {
      return deserialize<_i0ycjkhg.JoinProjectRequest>(data['data']);
    }
    if (dataClassName == 'UpdateMemberRoleRequest') {
      return deserialize<_i3b4trqk.UpdateMemberRoleRequest>(data['data']);
    }
    if (dataClassName == 'UpdateProjectRequest') {
      return deserialize<_irgz1vpl.UpdateProjectRequest>(data['data']);
    }
    if (dataClassName == 'UpdateProjectTempoRequest') {
      return deserialize<_i9oua2ep.UpdateProjectTempoRequest>(data['data']);
    }
    if (dataClassName == 'Project') {
      return deserialize<_ie16xf8k.Project>(data['data']);
    }
    if (dataClassName == 'ProjectInvitation') {
      return deserialize<_irpprho8.ProjectInvitation>(data['data']);
    }
    if (dataClassName == 'ProjectJoinRequest') {
      return deserialize<_idf344jl.ProjectJoinRequest>(data['data']);
    }
    if (dataClassName == 'ProjectMember') {
      return deserialize<_il1b74wc.ProjectMember>(data['data']);
    }
    if (dataClassName == 'ProjectAccess') {
      return deserialize<_i6vudz19.ProjectAccess>(data['data']);
    }
    if (dataClassName == 'ProjectRole') {
      return deserialize<_ila8m0sm.ProjectRole>(data['data']);
    }
    if (dataClassName == 'ProjectVisibility') {
      return deserialize<_idtmlsij.ProjectVisibility>(data['data']);
    }
    if (dataClassName == 'JoinRequestResponse') {
      return deserialize<_i8vdw8uk.JoinRequestResponse>(data['data']);
    }
    if (dataClassName == 'ProjectInvitationResponse') {
      return deserialize<_iaq84bw0.ProjectInvitationResponse>(data['data']);
    }
    if (dataClassName == 'ProjectMemberResponse') {
      return deserialize<_igc9pbfz.ProjectMemberResponse>(data['data']);
    }
    if (dataClassName == 'ProjectPageResponse') {
      return deserialize<_i9wl0ad1.ProjectPageResponse>(data['data']);
    }
    if (dataClassName == 'ProjectResponse') {
      return deserialize<_iefrfged.ProjectResponse>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('daw_music_maker', this);
    _iacs.Protocol().registerHostProtocol('daw_music_maker', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ie16xf8k.Project:
        return _ie16xf8k.Project.t;
      case _irpprho8.ProjectInvitation:
        return _irpprho8.ProjectInvitation.t;
      case _idf344jl.ProjectJoinRequest:
        return _idf344jl.ProjectJoinRequest.t;
      case _il1b74wc.ProjectMember:
        return _il1b74wc.ProjectMember.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'daw_music_maker';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
