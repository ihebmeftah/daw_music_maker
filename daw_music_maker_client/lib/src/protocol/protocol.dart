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
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/join_request_response.dart'
    as _i9kix0wi;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_invitation_response.dart'
    as _inz5k6t4;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_member_response.dart'
    as _ic4cvzfq;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'core/exceptions/app_exception.dart' as _i6tx3c89;
import 'core/exceptions/error_code.dart' as _io9cb3tb;
import 'features/projects/dtos/create_project_request.dart' as _i0xj56nk;
import 'features/projects/dtos/invite_member_request.dart' as _i5w541ev;
import 'features/projects/dtos/join_project_request.dart' as _i0ycjkhg;
import 'features/projects/dtos/update_member_role_request.dart' as _i3b4trqk;
import 'features/projects/dtos/update_project_request.dart' as _irgz1vpl;
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
export 'features/projects/enums/project_access.dart';
export 'features/projects/enums/project_role.dart';
export 'features/projects/enums/project_visibility.dart';
export 'features/projects/responses/join_request_response.dart';
export 'features/projects/responses/project_invitation_response.dart';
export 'features/projects/responses/project_member_response.dart';
export 'features/projects/responses/project_page_response.dart';
export 'features/projects/responses/project_response.dart';
export 'greetings/greeting.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_i6tx3c89.AppException>,
          _isc.getType<_io9cb3tb.ErrorCode>,
          _isc.getType<_i0xj56nk.CreateProjectRequest>,
          _isc.getType<_i5w541ev.InviteMemberRequest>,
          _isc.getType<_i0ycjkhg.JoinProjectRequest>,
          _isc.getType<_i3b4trqk.UpdateMemberRoleRequest>,
          _isc.getType<_irgz1vpl.UpdateProjectRequest>,
          _isc.getType<_i6vudz19.ProjectAccess>,
          _isc.getType<_ila8m0sm.ProjectRole>,
          _isc.getType<_idtmlsij.ProjectVisibility>,
          _isc.getType<_i8vdw8uk.JoinRequestResponse>,
          _isc.getType<_iaq84bw0.ProjectInvitationResponse>,
          _isc.getType<_igc9pbfz.ProjectMemberResponse>,
          _isc.getType<_i9wl0ad1.ProjectPageResponse>,
          _isc.getType<_iefrfged.ProjectResponse>,
          _isc.getType<_izw8z7ou.Greeting>,
          _isc.getType<_i6tx3c89.AppException?>,
          _isc.getType<_io9cb3tb.ErrorCode?>,
          _isc.getType<_i0xj56nk.CreateProjectRequest?>,
          _isc.getType<_i5w541ev.InviteMemberRequest?>,
          _isc.getType<_i0ycjkhg.JoinProjectRequest?>,
          _isc.getType<_i3b4trqk.UpdateMemberRoleRequest?>,
          _isc.getType<_irgz1vpl.UpdateProjectRequest?>,
          _isc.getType<_i6vudz19.ProjectAccess?>,
          _isc.getType<_ila8m0sm.ProjectRole?>,
          _isc.getType<_idtmlsij.ProjectVisibility?>,
          _isc.getType<_i8vdw8uk.JoinRequestResponse?>,
          _isc.getType<_iaq84bw0.ProjectInvitationResponse?>,
          _isc.getType<_igc9pbfz.ProjectMemberResponse?>,
          _isc.getType<_i9wl0ad1.ProjectPageResponse?>,
          _isc.getType<_iefrfged.ProjectResponse?>,
          _isc.getType<_izw8z7ou.Greeting?>,
          _isc.getType<Map<String, String>>,
          _isc.getType<Map<String, String>?>,
          _isc.getType<List<String>>,
          _isc.getType<List<_iefrfged.ProjectResponse>>,
          _isc.getType<List<_ic4cvzfq.ProjectMemberResponse>>,
          _isc.getType<List<_inz5k6t4.ProjectInvitationResponse>>,
          _isc.getType<List<_i9kix0wi.JoinRequestResponse>>,
        ],
        modules: const [
          _iaic.Protocol.new,
          _iacc.Protocol.new,
        ],
        classNames: const [
          'AppException',
          'ErrorCode',
          'CreateProjectRequest',
          'InviteMemberRequest',
          'JoinProjectRequest',
          'UpdateMemberRoleRequest',
          'UpdateProjectRequest',
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

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _isc.getType<_i6tx3c89.AppException?>()) {
      return (data != null ? _i6tx3c89.AppException.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_io9cb3tb.ErrorCode?>()) {
      return (data != null ? _io9cb3tb.ErrorCode.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0xj56nk.CreateProjectRequest?>()) {
      return (data != null
              ? _i0xj56nk.CreateProjectRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i5w541ev.InviteMemberRequest?>()) {
      return (data != null
              ? _i5w541ev.InviteMemberRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i0ycjkhg.JoinProjectRequest?>()) {
      return (data != null ? _i0ycjkhg.JoinProjectRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3b4trqk.UpdateMemberRoleRequest?>()) {
      return (data != null
              ? _i3b4trqk.UpdateMemberRoleRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_irgz1vpl.UpdateProjectRequest?>()) {
      return (data != null
              ? _irgz1vpl.UpdateProjectRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6vudz19.ProjectAccess?>()) {
      return (data != null ? _i6vudz19.ProjectAccess.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ila8m0sm.ProjectRole?>()) {
      return (data != null ? _ila8m0sm.ProjectRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idtmlsij.ProjectVisibility?>()) {
      return (data != null ? _idtmlsij.ProjectVisibility.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8vdw8uk.JoinRequestResponse?>()) {
      return (data != null
              ? _i8vdw8uk.JoinRequestResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iaq84bw0.ProjectInvitationResponse?>()) {
      return (data != null
              ? _iaq84bw0.ProjectInvitationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_igc9pbfz.ProjectMemberResponse?>()) {
      return (data != null
              ? _igc9pbfz.ProjectMemberResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9wl0ad1.ProjectPageResponse?>()) {
      return (data != null
              ? _i9wl0ad1.ProjectPageResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iefrfged.ProjectResponse?>()) {
      return (data != null ? _iefrfged.ProjectResponse.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
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
    if (t == List<_iefrfged.ProjectResponse>) {
      return (data as List)
              .map((e) => deserialize<_iefrfged.ProjectResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_ic4cvzfq.ProjectMemberResponse>) {
      return (data as List)
              .map((e) => deserialize<_ic4cvzfq.ProjectMemberResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_inz5k6t4.ProjectInvitationResponse>) {
      return (data as List)
              .map((e) => deserialize<_inz5k6t4.ProjectInvitationResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i9kix0wi.JoinRequestResponse>) {
      return (data as List)
              .map((e) => deserialize<_i9kix0wi.JoinRequestResponse>(e))
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
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
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
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
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
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('daw_music_maker', this);
    _iacc.Protocol().registerHostProtocol('daw_music_maker', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
