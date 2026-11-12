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
import 'package:daw_music_maker_server/src/generated/features/channels/responses/channel_response.dart'
    as _igiqa0h9;
import 'package:daw_music_maker_server/src/generated/features/patterns/responses/note_response.dart'
    as _i94bjwze;
import 'package:daw_music_maker_server/src/generated/features/patterns/responses/pattern_response.dart'
    as _iu7h5j9u;
import 'package:daw_music_maker_server/src/generated/features/playlist/responses/clip_response.dart'
    as _i2l284jn;
import 'package:daw_music_maker_server/src/generated/features/projects/responses/join_request_response.dart'
    as _i2s7w22c;
import 'package:daw_music_maker_server/src/generated/features/projects/responses/project_invitation_response.dart'
    as _i4423fmy;
import 'package:daw_music_maker_server/src/generated/features/projects/responses/project_member_response.dart'
    as _izpn6734;
import 'package:daw_music_maker_server/src/generated/features/samples/responses/sample_response.dart'
    as _i4a061a0;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'core/exceptions/app_exception.dart' as _i6tx3c89;
import 'core/exceptions/error_code.dart' as _io9cb3tb;
import 'features/channels/dtos/chop_channel_request.dart' as _iy34xg5v;
import 'features/channels/dtos/create_channel_request.dart' as _id4clhx3;
import 'features/channels/dtos/update_channel_request.dart' as _ilow414e;
import 'features/channels/entities/channel.dart' as _ieigt45v;
import 'features/channels/enums/sample_kind.dart' as _ifulnrpk;
import 'features/channels/responses/channel_response.dart' as _i10ps8ah;
import 'features/patterns/dtos/create_pattern_request.dart' as _itx0jlus;
import 'features/patterns/dtos/note_input.dart' as _it24l6jz;
import 'features/patterns/dtos/save_pattern_notes_request.dart' as _i94a5nv7;
import 'features/patterns/dtos/update_pattern_request.dart' as _ijqlx5cm;
import 'features/patterns/entities/pattern.dart' as _ilg4ajav;
import 'features/patterns/entities/pattern_note.dart' as _iosgrgu2;
import 'features/patterns/responses/note_response.dart' as _ixbtfmd4;
import 'features/patterns/responses/pattern_response.dart' as _igqezmee;
import 'features/playlist/dtos/clip_input.dart' as _iyf4rlk9;
import 'features/playlist/dtos/save_playlist_request.dart' as _ibthtwn5;
import 'features/playlist/entities/playlist_clip.dart' as _iefqzdw4;
import 'features/playlist/responses/clip_response.dart' as _i1hvruqf;
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
import 'features/samples/dtos/finish_sample_upload_request.dart' as _ivyd8fkl;
import 'features/samples/dtos/request_sample_upload_request.dart' as _i2fe4muu;
import 'features/samples/entities/sample.dart' as _i2x10ica;
import 'features/samples/enums/audio_format.dart' as _imcw5m05;
import 'features/samples/responses/sample_response.dart' as _ik3o3wfy;
import 'features/samples/responses/sample_upload_ticket.dart' as _is3b4l09;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'core/exceptions/app_exception.dart';
export 'core/exceptions/error_code.dart';
export 'features/channels/dtos/chop_channel_request.dart';
export 'features/channels/dtos/create_channel_request.dart';
export 'features/channels/dtos/update_channel_request.dart';
export 'features/channels/entities/channel.dart';
export 'features/channels/enums/sample_kind.dart';
export 'features/channels/responses/channel_response.dart';
export 'features/patterns/dtos/create_pattern_request.dart';
export 'features/patterns/dtos/note_input.dart';
export 'features/patterns/dtos/save_pattern_notes_request.dart';
export 'features/patterns/dtos/update_pattern_request.dart';
export 'features/patterns/entities/pattern.dart';
export 'features/patterns/entities/pattern_note.dart';
export 'features/patterns/responses/note_response.dart';
export 'features/patterns/responses/pattern_response.dart';
export 'features/playlist/dtos/clip_input.dart';
export 'features/playlist/dtos/save_playlist_request.dart';
export 'features/playlist/entities/playlist_clip.dart';
export 'features/playlist/responses/clip_response.dart';
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
export 'features/samples/dtos/finish_sample_upload_request.dart';
export 'features/samples/dtos/request_sample_upload_request.dart';
export 'features/samples/entities/sample.dart';
export 'features/samples/enums/audio_format.dart';
export 'features/samples/responses/sample_response.dart';
export 'features/samples/responses/sample_upload_ticket.dart';
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
          _is.getType<_iy34xg5v.ChopChannelRequest>,
          _is.getType<_id4clhx3.CreateChannelRequest>,
          _is.getType<_ilow414e.UpdateChannelRequest>,
          _is.getType<_ieigt45v.Channel>,
          _is.getType<_ifulnrpk.SampleKind>,
          _is.getType<_i10ps8ah.ChannelResponse>,
          _is.getType<_itx0jlus.CreatePatternRequest>,
          _is.getType<_it24l6jz.NoteInput>,
          _is.getType<_i94a5nv7.SavePatternNotesRequest>,
          _is.getType<_ijqlx5cm.UpdatePatternRequest>,
          _is.getType<_ilg4ajav.Pattern>,
          _is.getType<_iosgrgu2.PatternNote>,
          _is.getType<_ixbtfmd4.NoteResponse>,
          _is.getType<_igqezmee.PatternResponse>,
          _is.getType<_iyf4rlk9.ClipInput>,
          _is.getType<_ibthtwn5.SavePlaylistRequest>,
          _is.getType<_iefqzdw4.PlaylistClip>,
          _is.getType<_i1hvruqf.ClipResponse>,
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
          _is.getType<_ivyd8fkl.FinishSampleUploadRequest>,
          _is.getType<_i2fe4muu.RequestSampleUploadRequest>,
          _is.getType<_i2x10ica.Sample>,
          _is.getType<_imcw5m05.AudioFormat>,
          _is.getType<_ik3o3wfy.SampleResponse>,
          _is.getType<_is3b4l09.SampleUploadTicket>,
          _is.getType<_izw8z7ou.Greeting>,
          _is.getType<_i6tx3c89.AppException?>,
          _is.getType<_io9cb3tb.ErrorCode?>,
          _is.getType<_iy34xg5v.ChopChannelRequest?>,
          _is.getType<_id4clhx3.CreateChannelRequest?>,
          _is.getType<_ilow414e.UpdateChannelRequest?>,
          _is.getType<_ieigt45v.Channel?>,
          _is.getType<_ifulnrpk.SampleKind?>,
          _is.getType<_i10ps8ah.ChannelResponse?>,
          _is.getType<_itx0jlus.CreatePatternRequest?>,
          _is.getType<_it24l6jz.NoteInput?>,
          _is.getType<_i94a5nv7.SavePatternNotesRequest?>,
          _is.getType<_ijqlx5cm.UpdatePatternRequest?>,
          _is.getType<_ilg4ajav.Pattern?>,
          _is.getType<_iosgrgu2.PatternNote?>,
          _is.getType<_ixbtfmd4.NoteResponse?>,
          _is.getType<_igqezmee.PatternResponse?>,
          _is.getType<_iyf4rlk9.ClipInput?>,
          _is.getType<_ibthtwn5.SavePlaylistRequest?>,
          _is.getType<_iefqzdw4.PlaylistClip?>,
          _is.getType<_i1hvruqf.ClipResponse?>,
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
          _is.getType<_ivyd8fkl.FinishSampleUploadRequest?>,
          _is.getType<_i2fe4muu.RequestSampleUploadRequest?>,
          _is.getType<_i2x10ica.Sample?>,
          _is.getType<_imcw5m05.AudioFormat?>,
          _is.getType<_ik3o3wfy.SampleResponse?>,
          _is.getType<_is3b4l09.SampleUploadTicket?>,
          _is.getType<_izw8z7ou.Greeting?>,
          _is.getType<Map<String, String>>,
          _is.getType<Map<String, String>?>,
          _is.getType<List<_it24l6jz.NoteInput>>,
          _is.getType<List<_iyf4rlk9.ClipInput>>,
          _is.getType<List<String>>,
          _is.getType<List<_il1b74wc.ProjectMember>>,
          _is.getType<List<_il1b74wc.ProjectMember>?>,
          _is.getType<List<_iefrfged.ProjectResponse>>,
          _is.getType<List<double>>,
          _is.getType<List<double>?>,
          _is.getType<List<_igiqa0h9.ChannelResponse>>,
          _is.getType<List<_iu7h5j9u.PatternResponse>>,
          _is.getType<List<_i94bjwze.NoteResponse>>,
          _is.getType<List<_i2l284jn.ClipResponse>>,
          _is.getType<List<_izpn6734.ProjectMemberResponse>>,
          _is.getType<List<_i4423fmy.ProjectInvitationResponse>>,
          _is.getType<List<_i2s7w22c.JoinRequestResponse>>,
          _is.getType<List<_i4a061a0.SampleResponse>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
        ],
        classNames: const [
          'AppException',
          'ErrorCode',
          'ChopChannelRequest',
          'CreateChannelRequest',
          'UpdateChannelRequest',
          'Channel',
          'SampleKind',
          'ChannelResponse',
          'CreatePatternRequest',
          'NoteInput',
          'SavePatternNotesRequest',
          'UpdatePatternRequest',
          'Pattern',
          'PatternNote',
          'NoteResponse',
          'PatternResponse',
          'ClipInput',
          'SavePlaylistRequest',
          'PlaylistClip',
          'ClipResponse',
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
          'FinishSampleUploadRequest',
          'RequestSampleUploadRequest',
          'Sample',
          'AudioFormat',
          'SampleResponse',
          'SampleUploadTicket',
          'Greeting',
        ],
      );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'channel',
      dartName: 'Channel',
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
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sample',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:SampleKind?',
        ),
        _isp.ColumnDefinition(
          name: 'sampleId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'volume',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.8',
        ),
        _isp.ColumnDefinition(
          name: 'muted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'pan',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.0',
        ),
        _isp.ColumnDefinition(
          name: 'pitch',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'startFrac',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.0',
        ),
        _isp.ColumnDefinition(
          name: 'endFrac',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '1.0',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
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
          constraintName: 'channel_fk_0',
          columns: ['projectId'],
          referenceTable: 'project',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'channel_fk_1',
          columns: ['sampleId'],
          referenceTable: 'sample',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'channel_project_position_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'position',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'pattern',
      dartName: 'Pattern',
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
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'colorIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'lengthBars',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '4',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
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
          constraintName: 'pattern_fk_0',
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
          indexName: 'pattern_project_position_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'position',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'pattern_note',
      dartName: 'PatternNote',
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
          name: 'patternId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'channelId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'tick',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'lengthTicks',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'pitch',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'velocity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'pattern_note_fk_0',
          columns: ['patternId'],
          referenceTable: 'pattern',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'pattern_note_fk_1',
          columns: ['channelId'],
          referenceTable: 'channel',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'pattern_note_pattern_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patternId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'pattern_note_channel_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'channelId',
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
      name: 'playlist_clip',
      dartName: 'PlaylistClip',
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
          name: 'patternId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'sampleId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'lengthBars',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'track',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'startStep',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'playlist_clip_fk_0',
          columns: ['projectId'],
          referenceTable: 'project',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'playlist_clip_fk_1',
          columns: ['patternId'],
          referenceTable: 'pattern',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'playlist_clip_fk_2',
          columns: ['sampleId'],
          referenceTable: 'sample',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'playlist_clip_project_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'playlist_clip_pattern_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patternId',
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
    _isp.TableDefinition(
      name: 'sample',
      dartName: 'Sample',
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
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AudioFormat',
        ),
        _isp.ColumnDefinition(
          name: 'sizeBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'durationMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'peaks',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<double>?',
        ),
        _isp.ColumnDefinition(
          name: 'storagePath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'uploadedById',
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
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'sample_fk_0',
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
          indexName: 'sample_project_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'sample_path_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'storagePath',
            ),
          ],
          type: 'btree',
          isUnique: true,
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
    if (t == _iy34xg5v.ChopChannelRequest) {
      return _iy34xg5v.ChopChannelRequest.fromJson(data) as T;
    }
    if (t == _id4clhx3.CreateChannelRequest) {
      return _id4clhx3.CreateChannelRequest.fromJson(data) as T;
    }
    if (t == _ilow414e.UpdateChannelRequest) {
      return _ilow414e.UpdateChannelRequest.fromJson(data) as T;
    }
    if (t == _ieigt45v.Channel) {
      return _ieigt45v.Channel.fromJson(data) as T;
    }
    if (t == _ifulnrpk.SampleKind) {
      return _ifulnrpk.SampleKind.fromJson(data) as T;
    }
    if (t == _i10ps8ah.ChannelResponse) {
      return _i10ps8ah.ChannelResponse.fromJson(data) as T;
    }
    if (t == _itx0jlus.CreatePatternRequest) {
      return _itx0jlus.CreatePatternRequest.fromJson(data) as T;
    }
    if (t == _it24l6jz.NoteInput) {
      return _it24l6jz.NoteInput.fromJson(data) as T;
    }
    if (t == _i94a5nv7.SavePatternNotesRequest) {
      return _i94a5nv7.SavePatternNotesRequest.fromJson(data) as T;
    }
    if (t == _ijqlx5cm.UpdatePatternRequest) {
      return _ijqlx5cm.UpdatePatternRequest.fromJson(data) as T;
    }
    if (t == _ilg4ajav.Pattern) {
      return _ilg4ajav.Pattern.fromJson(data) as T;
    }
    if (t == _iosgrgu2.PatternNote) {
      return _iosgrgu2.PatternNote.fromJson(data) as T;
    }
    if (t == _ixbtfmd4.NoteResponse) {
      return _ixbtfmd4.NoteResponse.fromJson(data) as T;
    }
    if (t == _igqezmee.PatternResponse) {
      return _igqezmee.PatternResponse.fromJson(data) as T;
    }
    if (t == _iyf4rlk9.ClipInput) {
      return _iyf4rlk9.ClipInput.fromJson(data) as T;
    }
    if (t == _ibthtwn5.SavePlaylistRequest) {
      return _ibthtwn5.SavePlaylistRequest.fromJson(data) as T;
    }
    if (t == _iefqzdw4.PlaylistClip) {
      return _iefqzdw4.PlaylistClip.fromJson(data) as T;
    }
    if (t == _i1hvruqf.ClipResponse) {
      return _i1hvruqf.ClipResponse.fromJson(data) as T;
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
    if (t == _ivyd8fkl.FinishSampleUploadRequest) {
      return _ivyd8fkl.FinishSampleUploadRequest.fromJson(data) as T;
    }
    if (t == _i2fe4muu.RequestSampleUploadRequest) {
      return _i2fe4muu.RequestSampleUploadRequest.fromJson(data) as T;
    }
    if (t == _i2x10ica.Sample) {
      return _i2x10ica.Sample.fromJson(data) as T;
    }
    if (t == _imcw5m05.AudioFormat) {
      return _imcw5m05.AudioFormat.fromJson(data) as T;
    }
    if (t == _ik3o3wfy.SampleResponse) {
      return _ik3o3wfy.SampleResponse.fromJson(data) as T;
    }
    if (t == _is3b4l09.SampleUploadTicket) {
      return _is3b4l09.SampleUploadTicket.fromJson(data) as T;
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
    if (t == _is.getType<_iy34xg5v.ChopChannelRequest?>()) {
      return (data != null ? _iy34xg5v.ChopChannelRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id4clhx3.CreateChannelRequest?>()) {
      return (data != null
              ? _id4clhx3.CreateChannelRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilow414e.UpdateChannelRequest?>()) {
      return (data != null
              ? _ilow414e.UpdateChannelRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ieigt45v.Channel?>()) {
      return (data != null ? _ieigt45v.Channel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifulnrpk.SampleKind?>()) {
      return (data != null ? _ifulnrpk.SampleKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i10ps8ah.ChannelResponse?>()) {
      return (data != null ? _i10ps8ah.ChannelResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itx0jlus.CreatePatternRequest?>()) {
      return (data != null
              ? _itx0jlus.CreatePatternRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it24l6jz.NoteInput?>()) {
      return (data != null ? _it24l6jz.NoteInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i94a5nv7.SavePatternNotesRequest?>()) {
      return (data != null
              ? _i94a5nv7.SavePatternNotesRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijqlx5cm.UpdatePatternRequest?>()) {
      return (data != null
              ? _ijqlx5cm.UpdatePatternRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilg4ajav.Pattern?>()) {
      return (data != null ? _ilg4ajav.Pattern.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iosgrgu2.PatternNote?>()) {
      return (data != null ? _iosgrgu2.PatternNote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixbtfmd4.NoteResponse?>()) {
      return (data != null ? _ixbtfmd4.NoteResponse.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igqezmee.PatternResponse?>()) {
      return (data != null ? _igqezmee.PatternResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iyf4rlk9.ClipInput?>()) {
      return (data != null ? _iyf4rlk9.ClipInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibthtwn5.SavePlaylistRequest?>()) {
      return (data != null
              ? _ibthtwn5.SavePlaylistRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iefqzdw4.PlaylistClip?>()) {
      return (data != null ? _iefqzdw4.PlaylistClip.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1hvruqf.ClipResponse?>()) {
      return (data != null ? _i1hvruqf.ClipResponse.fromJson(data) : null) as T;
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
    if (t == _is.getType<_ivyd8fkl.FinishSampleUploadRequest?>()) {
      return (data != null
              ? _ivyd8fkl.FinishSampleUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2fe4muu.RequestSampleUploadRequest?>()) {
      return (data != null
              ? _i2fe4muu.RequestSampleUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2x10ica.Sample?>()) {
      return (data != null ? _i2x10ica.Sample.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imcw5m05.AudioFormat?>()) {
      return (data != null ? _imcw5m05.AudioFormat.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik3o3wfy.SampleResponse?>()) {
      return (data != null ? _ik3o3wfy.SampleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is3b4l09.SampleUploadTicket?>()) {
      return (data != null ? _is3b4l09.SampleUploadTicket.fromJson(data) : null)
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
    if (t == List<_it24l6jz.NoteInput>) {
      return (data as List)
              .map((e) => deserialize<_it24l6jz.NoteInput>(e))
              .toList()
          as T;
    }
    if (t == List<_iyf4rlk9.ClipInput>) {
      return (data as List)
              .map((e) => deserialize<_iyf4rlk9.ClipInput>(e))
              .toList()
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
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == _is.getType<List<double>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<double>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_igiqa0h9.ChannelResponse>) {
      return (data as List)
              .map((e) => deserialize<_igiqa0h9.ChannelResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_iu7h5j9u.PatternResponse>) {
      return (data as List)
              .map((e) => deserialize<_iu7h5j9u.PatternResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i94bjwze.NoteResponse>) {
      return (data as List)
              .map((e) => deserialize<_i94bjwze.NoteResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i2l284jn.ClipResponse>) {
      return (data as List)
              .map((e) => deserialize<_i2l284jn.ClipResponse>(e))
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
    if (t == List<_i4a061a0.SampleResponse>) {
      return (data as List)
              .map((e) => deserialize<_i4a061a0.SampleResponse>(e))
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
      _iy34xg5v.ChopChannelRequest => 'ChopChannelRequest',
      _id4clhx3.CreateChannelRequest => 'CreateChannelRequest',
      _ilow414e.UpdateChannelRequest => 'UpdateChannelRequest',
      _ieigt45v.Channel => 'Channel',
      _ifulnrpk.SampleKind => 'SampleKind',
      _i10ps8ah.ChannelResponse => 'ChannelResponse',
      _itx0jlus.CreatePatternRequest => 'CreatePatternRequest',
      _it24l6jz.NoteInput => 'NoteInput',
      _i94a5nv7.SavePatternNotesRequest => 'SavePatternNotesRequest',
      _ijqlx5cm.UpdatePatternRequest => 'UpdatePatternRequest',
      _ilg4ajav.Pattern => 'Pattern',
      _iosgrgu2.PatternNote => 'PatternNote',
      _ixbtfmd4.NoteResponse => 'NoteResponse',
      _igqezmee.PatternResponse => 'PatternResponse',
      _iyf4rlk9.ClipInput => 'ClipInput',
      _ibthtwn5.SavePlaylistRequest => 'SavePlaylistRequest',
      _iefqzdw4.PlaylistClip => 'PlaylistClip',
      _i1hvruqf.ClipResponse => 'ClipResponse',
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
      _ivyd8fkl.FinishSampleUploadRequest => 'FinishSampleUploadRequest',
      _i2fe4muu.RequestSampleUploadRequest => 'RequestSampleUploadRequest',
      _i2x10ica.Sample => 'Sample',
      _imcw5m05.AudioFormat => 'AudioFormat',
      _ik3o3wfy.SampleResponse => 'SampleResponse',
      _is3b4l09.SampleUploadTicket => 'SampleUploadTicket',
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
      case _iy34xg5v.ChopChannelRequest():
        return 'ChopChannelRequest';
      case _id4clhx3.CreateChannelRequest():
        return 'CreateChannelRequest';
      case _ilow414e.UpdateChannelRequest():
        return 'UpdateChannelRequest';
      case _ieigt45v.Channel():
        return 'Channel';
      case _ifulnrpk.SampleKind():
        return 'SampleKind';
      case _i10ps8ah.ChannelResponse():
        return 'ChannelResponse';
      case _itx0jlus.CreatePatternRequest():
        return 'CreatePatternRequest';
      case _it24l6jz.NoteInput():
        return 'NoteInput';
      case _i94a5nv7.SavePatternNotesRequest():
        return 'SavePatternNotesRequest';
      case _ijqlx5cm.UpdatePatternRequest():
        return 'UpdatePatternRequest';
      case _ilg4ajav.Pattern():
        return 'Pattern';
      case _iosgrgu2.PatternNote():
        return 'PatternNote';
      case _ixbtfmd4.NoteResponse():
        return 'NoteResponse';
      case _igqezmee.PatternResponse():
        return 'PatternResponse';
      case _iyf4rlk9.ClipInput():
        return 'ClipInput';
      case _ibthtwn5.SavePlaylistRequest():
        return 'SavePlaylistRequest';
      case _iefqzdw4.PlaylistClip():
        return 'PlaylistClip';
      case _i1hvruqf.ClipResponse():
        return 'ClipResponse';
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
      case _ivyd8fkl.FinishSampleUploadRequest():
        return 'FinishSampleUploadRequest';
      case _i2fe4muu.RequestSampleUploadRequest():
        return 'RequestSampleUploadRequest';
      case _i2x10ica.Sample():
        return 'Sample';
      case _imcw5m05.AudioFormat():
        return 'AudioFormat';
      case _ik3o3wfy.SampleResponse():
        return 'SampleResponse';
      case _is3b4l09.SampleUploadTicket():
        return 'SampleUploadTicket';
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
    if (dataClassName == 'ChopChannelRequest') {
      return deserialize<_iy34xg5v.ChopChannelRequest>(data['data']);
    }
    if (dataClassName == 'CreateChannelRequest') {
      return deserialize<_id4clhx3.CreateChannelRequest>(data['data']);
    }
    if (dataClassName == 'UpdateChannelRequest') {
      return deserialize<_ilow414e.UpdateChannelRequest>(data['data']);
    }
    if (dataClassName == 'Channel') {
      return deserialize<_ieigt45v.Channel>(data['data']);
    }
    if (dataClassName == 'SampleKind') {
      return deserialize<_ifulnrpk.SampleKind>(data['data']);
    }
    if (dataClassName == 'ChannelResponse') {
      return deserialize<_i10ps8ah.ChannelResponse>(data['data']);
    }
    if (dataClassName == 'CreatePatternRequest') {
      return deserialize<_itx0jlus.CreatePatternRequest>(data['data']);
    }
    if (dataClassName == 'NoteInput') {
      return deserialize<_it24l6jz.NoteInput>(data['data']);
    }
    if (dataClassName == 'SavePatternNotesRequest') {
      return deserialize<_i94a5nv7.SavePatternNotesRequest>(data['data']);
    }
    if (dataClassName == 'UpdatePatternRequest') {
      return deserialize<_ijqlx5cm.UpdatePatternRequest>(data['data']);
    }
    if (dataClassName == 'Pattern') {
      return deserialize<_ilg4ajav.Pattern>(data['data']);
    }
    if (dataClassName == 'PatternNote') {
      return deserialize<_iosgrgu2.PatternNote>(data['data']);
    }
    if (dataClassName == 'NoteResponse') {
      return deserialize<_ixbtfmd4.NoteResponse>(data['data']);
    }
    if (dataClassName == 'PatternResponse') {
      return deserialize<_igqezmee.PatternResponse>(data['data']);
    }
    if (dataClassName == 'ClipInput') {
      return deserialize<_iyf4rlk9.ClipInput>(data['data']);
    }
    if (dataClassName == 'SavePlaylistRequest') {
      return deserialize<_ibthtwn5.SavePlaylistRequest>(data['data']);
    }
    if (dataClassName == 'PlaylistClip') {
      return deserialize<_iefqzdw4.PlaylistClip>(data['data']);
    }
    if (dataClassName == 'ClipResponse') {
      return deserialize<_i1hvruqf.ClipResponse>(data['data']);
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
    if (dataClassName == 'FinishSampleUploadRequest') {
      return deserialize<_ivyd8fkl.FinishSampleUploadRequest>(data['data']);
    }
    if (dataClassName == 'RequestSampleUploadRequest') {
      return deserialize<_i2fe4muu.RequestSampleUploadRequest>(data['data']);
    }
    if (dataClassName == 'Sample') {
      return deserialize<_i2x10ica.Sample>(data['data']);
    }
    if (dataClassName == 'AudioFormat') {
      return deserialize<_imcw5m05.AudioFormat>(data['data']);
    }
    if (dataClassName == 'SampleResponse') {
      return deserialize<_ik3o3wfy.SampleResponse>(data['data']);
    }
    if (dataClassName == 'SampleUploadTicket') {
      return deserialize<_is3b4l09.SampleUploadTicket>(data['data']);
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
      case _ieigt45v.Channel:
        return _ieigt45v.Channel.t;
      case _ilg4ajav.Pattern:
        return _ilg4ajav.Pattern.t;
      case _iosgrgu2.PatternNote:
        return _iosgrgu2.PatternNote.t;
      case _iefqzdw4.PlaylistClip:
        return _iefqzdw4.PlaylistClip.t;
      case _ie16xf8k.Project:
        return _ie16xf8k.Project.t;
      case _irpprho8.ProjectInvitation:
        return _irpprho8.ProjectInvitation.t;
      case _idf344jl.ProjectJoinRequest:
        return _idf344jl.ProjectJoinRequest.t;
      case _il1b74wc.ProjectMember:
        return _il1b74wc.ProjectMember.t;
      case _i2x10ica.Sample:
        return _i2x10ica.Sample.t;
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
