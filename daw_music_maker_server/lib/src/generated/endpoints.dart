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
import 'package:daw_music_maker_server/src/generated/features/channels/dtos/chop_channel_request.dart'
    as _itu3v1bi;
import 'package:daw_music_maker_server/src/generated/features/channels/dtos/create_channel_request.dart'
    as _irlycisz;
import 'package:daw_music_maker_server/src/generated/features/channels/dtos/update_channel_request.dart'
    as _ixxw5pq0;
import 'package:daw_music_maker_server/src/generated/features/patterns/dtos/create_pattern_request.dart'
    as _imwjcbyb;
import 'package:daw_music_maker_server/src/generated/features/patterns/dtos/save_pattern_notes_request.dart'
    as _iiba76m5;
import 'package:daw_music_maker_server/src/generated/features/patterns/dtos/update_pattern_request.dart'
    as _ii8qu4lm;
import 'package:daw_music_maker_server/src/generated/features/playlist/dtos/save_playlist_request.dart'
    as _i0cr8q5v;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/create_project_request.dart'
    as _i81edeh2;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/invite_member_request.dart'
    as _iu5utbnt;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/join_project_request.dart'
    as _iargkymj;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/update_member_role_request.dart'
    as _it611bmf;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/update_project_request.dart'
    as _ido95wja;
import 'package:daw_music_maker_server/src/generated/features/projects/dtos/update_project_tempo_request.dart'
    as _ipesbjbp;
import 'package:daw_music_maker_server/src/generated/features/samples/dtos/finish_sample_upload_request.dart'
    as _islo2yap;
import 'package:daw_music_maker_server/src/generated/features/samples/dtos/request_sample_upload_request.dart'
    as _inm8vvkw;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../features/channels/endpoints/channel_endpoint.dart' as _ip0u7shr;
import '../features/patterns/endpoints/pattern_endpoint.dart' as _id08qiz9;
import '../features/playlist/endpoints/playlist_endpoint.dart' as _iac13vr7;
import '../features/projects/endpoints/project_collaboration_endpoint.dart'
    as _ipatzhet;
import '../features/projects/endpoints/project_endpoint.dart' as _inmisbug;
import '../features/samples/endpoints/sample_endpoint.dart' as _ifo0hjx7;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'channel': _ip0u7shr.ChannelEndpoint()
        ..initialize(
          server,
          'channel',
          null,
        ),
      'pattern': _id08qiz9.PatternEndpoint()
        ..initialize(
          server,
          'pattern',
          null,
        ),
      'playlist': _iac13vr7.PlaylistEndpoint()
        ..initialize(
          server,
          'playlist',
          null,
        ),
      'projectCollaboration': _ipatzhet.ProjectCollaborationEndpoint()
        ..initialize(
          server,
          'projectCollaboration',
          null,
        ),
      'project': _inmisbug.ProjectEndpoint()
        ..initialize(
          server,
          'project',
          null,
        ),
      'sample': _ifo0hjx7.SampleEndpoint()
        ..initialize(
          server,
          'sample',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startOtpLogin': _is.MethodConnector(
          name: 'startOtpLogin',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startOtpLogin(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyOtpLoginCode': _is.MethodConnector(
          name: 'verifyOtpLoginCode',
          params: {
            'otpLoginRequestId': _is.ParameterDescription(
              name: 'otpLoginRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyOtpLoginCode(
                    session,
                    otpLoginRequestId: params['otpLoginRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishOtpLogin': _is.MethodConnector(
          name: 'finishOtpLogin',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpLogin(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                  ),
        ),
        'finishOtpRegistration': _is.MethodConnector(
          name: 'finishOtpRegistration',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpRegistration(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                    password: params['password'],
                  ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['channel'] = _is.EndpointConnector(
      name: 'channel',
      endpoint: endpoints['channel']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['channel'] as _ip0u7shr.ChannelEndpoint).list(
                    session,
                    params['projectId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_irlycisz.CreateChannelRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['channel'] as _ip0u7shr.ChannelEndpoint).create(
                    session,
                    params['request'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'channelId': _is.ParameterDescription(
              name: 'channelId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ixxw5pq0.UpdateChannelRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['channel'] as _ip0u7shr.ChannelEndpoint).update(
                    session,
                    params['channelId'],
                    params['request'],
                  ),
        ),
        'chop': _is.MethodConnector(
          name: 'chop',
          params: {
            'channelId': _is.ParameterDescription(
              name: 'channelId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_itu3v1bi.ChopChannelRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['channel'] as _ip0u7shr.ChannelEndpoint).chop(
                    session,
                    params['channelId'],
                    params['request'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'channelId': _is.ParameterDescription(
              name: 'channelId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['channel'] as _ip0u7shr.ChannelEndpoint).delete(
                    session,
                    params['channelId'],
                  ),
        ),
      },
    );
    connectors['pattern'] = _is.EndpointConnector(
      name: 'pattern',
      endpoint: endpoints['pattern']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).list(
                    session,
                    params['projectId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_imwjcbyb.CreatePatternRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).create(
                    session,
                    params['request'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'patternId': _is.ParameterDescription(
              name: 'patternId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ii8qu4lm.UpdatePatternRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).update(
                    session,
                    params['patternId'],
                    params['request'],
                  ),
        ),
        'clone': _is.MethodConnector(
          name: 'clone',
          params: {
            'patternId': _is.ParameterDescription(
              name: 'patternId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).clone(
                    session,
                    params['patternId'],
                  ),
        ),
        'listNotes': _is.MethodConnector(
          name: 'listNotes',
          params: {
            'patternId': _is.ParameterDescription(
              name: 'patternId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).listNotes(
                    session,
                    params['patternId'],
                  ),
        ),
        'saveNotes': _is.MethodConnector(
          name: 'saveNotes',
          params: {
            'patternId': _is.ParameterDescription(
              name: 'patternId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iiba76m5.SavePatternNotesRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).saveNotes(
                    session,
                    params['patternId'],
                    params['request'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'patternId': _is.ParameterDescription(
              name: 'patternId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pattern'] as _id08qiz9.PatternEndpoint).delete(
                    session,
                    params['patternId'],
                  ),
        ),
      },
    );
    connectors['playlist'] = _is.EndpointConnector(
      name: 'playlist',
      endpoint: endpoints['playlist']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['playlist'] as _iac13vr7.PlaylistEndpoint).list(
                    session,
                    params['projectId'],
                  ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i0cr8q5v.SavePlaylistRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['playlist'] as _iac13vr7.PlaylistEndpoint).save(
                    session,
                    params['projectId'],
                    params['request'],
                  ),
        ),
      },
    );
    connectors['projectCollaboration'] = _is.EndpointConnector(
      name: 'projectCollaboration',
      endpoint: endpoints['projectCollaboration']!,
      methodConnectors: {
        'listMembers': _is.MethodConnector(
          name: 'listMembers',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .listMembers(
                        session,
                        params['projectId'],
                      ),
        ),
        'updateMemberRole': _is.MethodConnector(
          name: 'updateMemberRole',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_it611bmf.UpdateMemberRoleRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .updateMemberRole(
                        session,
                        params['request'],
                      ),
        ),
        'removeMember': _is.MethodConnector(
          name: 'removeMember',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .removeMember(
                        session,
                        params['projectId'],
                        params['userId'],
                      ),
        ),
        'leave': _is.MethodConnector(
          name: 'leave',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .leave(
                        session,
                        params['projectId'],
                      ),
        ),
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iu5utbnt.InviteMemberRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .invite(
                        session,
                        params['request'],
                      ),
        ),
        'listProjectInvitations': _is.MethodConnector(
          name: 'listProjectInvitations',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .listProjectInvitations(
                        session,
                        params['projectId'],
                      ),
        ),
        'cancelInvitation': _is.MethodConnector(
          name: 'cancelInvitation',
          params: {
            'invitationId': _is.ParameterDescription(
              name: 'invitationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .cancelInvitation(
                        session,
                        params['invitationId'],
                      ),
        ),
        'myInvitations': _is.MethodConnector(
          name: 'myInvitations',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .myInvitations(session),
        ),
        'respondToInvitation': _is.MethodConnector(
          name: 'respondToInvitation',
          params: {
            'invitationId': _is.ParameterDescription(
              name: 'invitationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'accept': _is.ParameterDescription(
              name: 'accept',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .respondToInvitation(
                        session,
                        params['invitationId'],
                        params['accept'],
                      ),
        ),
        'requestToJoin': _is.MethodConnector(
          name: 'requestToJoin',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iargkymj.JoinProjectRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .requestToJoin(
                        session,
                        params['request'],
                      ),
        ),
        'cancelJoinRequest': _is.MethodConnector(
          name: 'cancelJoinRequest',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .cancelJoinRequest(
                        session,
                        params['requestId'],
                      ),
        ),
        'myJoinRequests': _is.MethodConnector(
          name: 'myJoinRequests',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .myJoinRequests(session),
        ),
        'listJoinRequests': _is.MethodConnector(
          name: 'listJoinRequests',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .listJoinRequests(
                        session,
                        params['projectId'],
                      ),
        ),
        'respondToJoinRequest': _is.MethodConnector(
          name: 'respondToJoinRequest',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'accept': _is.ParameterDescription(
              name: 'accept',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['projectCollaboration']
                          as _ipatzhet.ProjectCollaborationEndpoint)
                      .respondToJoinRequest(
                        session,
                        params['requestId'],
                        params['accept'],
                      ),
        ),
      },
    );
    connectors['project'] = _is.EndpointConnector(
      name: 'project',
      endpoint: endpoints['project']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i81edeh2.CreateProjectRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).create(
                    session,
                    params['request'],
                  ),
        ),
        'getById': _is.MethodConnector(
          name: 'getById',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).getById(
                    session,
                    params['projectId'],
                  ),
        ),
        'listMine': _is.MethodConnector(
          name: 'listMine',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).listMine(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'listShared': _is.MethodConnector(
          name: 'listShared',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _inmisbug.ProjectEndpoint)
                  .listShared(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'discover': _is.MethodConnector(
          name: 'discover',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).discover(
                    session,
                    query: params['query'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ido95wja.UpdateProjectRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).update(
                    session,
                    params['projectId'],
                    params['request'],
                  ),
        ),
        'updateTempo': _is.MethodConnector(
          name: 'updateTempo',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ipesbjbp.UpdateProjectTempoRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _inmisbug.ProjectEndpoint)
                  .updateTempo(
                    session,
                    params['projectId'],
                    params['request'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['project'] as _inmisbug.ProjectEndpoint).delete(
                    session,
                    params['projectId'],
                  ),
        ),
      },
    );
    connectors['sample'] = _is.EndpointConnector(
      name: 'sample',
      endpoint: endpoints['sample']!,
      methodConnectors: {
        'requestUpload': _is.MethodConnector(
          name: 'requestUpload',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_inm8vvkw.RequestSampleUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sample'] as _ifo0hjx7.SampleEndpoint)
                  .requestUpload(
                    session,
                    params['request'],
                  ),
        ),
        'finishUpload': _is.MethodConnector(
          name: 'finishUpload',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_islo2yap.FinishSampleUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sample'] as _ifo0hjx7.SampleEndpoint)
                  .finishUpload(
                    session,
                    params['request'],
                  ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sample'] as _ifo0hjx7.SampleEndpoint).list(
                session,
                params['projectId'],
              ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'sampleId': _is.ParameterDescription(
              name: 'sampleId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sample'] as _ifo0hjx7.SampleEndpoint).delete(
                    session,
                    params['sampleId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
