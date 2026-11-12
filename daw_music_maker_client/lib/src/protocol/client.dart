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
import 'package:daw_music_maker_client/src/protocol/features/channels/dtos/chop_channel_request.dart'
    as _iroonklb;
import 'package:daw_music_maker_client/src/protocol/features/channels/dtos/create_channel_request.dart'
    as _ix8m1nad;
import 'package:daw_music_maker_client/src/protocol/features/channels/dtos/update_channel_request.dart'
    as _itrlqtj1;
import 'package:daw_music_maker_client/src/protocol/features/channels/responses/channel_response.dart'
    as _io54avb8;
import 'package:daw_music_maker_client/src/protocol/features/patterns/dtos/create_pattern_request.dart'
    as _iyp770n4;
import 'package:daw_music_maker_client/src/protocol/features/patterns/dtos/save_pattern_notes_request.dart'
    as _i8a3qaoj;
import 'package:daw_music_maker_client/src/protocol/features/patterns/dtos/update_pattern_request.dart'
    as _i29cq5tg;
import 'package:daw_music_maker_client/src/protocol/features/patterns/responses/note_response.dart'
    as _ij5vkych;
import 'package:daw_music_maker_client/src/protocol/features/patterns/responses/pattern_response.dart'
    as _idk43ht2;
import 'package:daw_music_maker_client/src/protocol/features/playlist/dtos/save_playlist_request.dart'
    as _ikmgaklg;
import 'package:daw_music_maker_client/src/protocol/features/playlist/responses/clip_response.dart'
    as _i0zaexo5;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/create_project_request.dart'
    as _igj9gzmx;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/invite_member_request.dart'
    as _ifw5qbat;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/join_project_request.dart'
    as _immwh6ll;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/update_member_role_request.dart'
    as _ig0a8nmn;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/update_project_request.dart'
    as _i4ow79ga;
import 'package:daw_music_maker_client/src/protocol/features/projects/dtos/update_project_tempo_request.dart'
    as _if2prfhr;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/join_request_response.dart'
    as _i9kix0wi;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_invitation_response.dart'
    as _inz5k6t4;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_member_response.dart'
    as _ic4cvzfq;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_page_response.dart'
    as _iiazmhcc;
import 'package:daw_music_maker_client/src/protocol/features/projects/responses/project_response.dart'
    as _ia3hvpml;
import 'package:daw_music_maker_client/src/protocol/features/samples/dtos/finish_sample_upload_request.dart'
    as _i5duwawj;
import 'package:daw_music_maker_client/src/protocol/features/samples/dtos/request_sample_upload_request.dart'
    as _ix1enysx;
import 'package:daw_music_maker_client/src/protocol/features/samples/responses/sample_response.dart'
    as _ilv1w5af;
import 'package:daw_music_maker_client/src/protocol/features/samples/responses/sample_upload_ticket.dart'
    as _iv3w8q6y;
import 'package:daw_music_maker_client/src/protocol/greetings/greeting.dart'
    as _iruhsk5y;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailOtpIdpBaseEndpoint], the email identity provider
/// endpoints, including the passwordless sign-in with one-time passwords, are
/// made available on the server and enable the corresponding sign-in widget on
/// the client.
///
/// Extend [EmailIdpBaseEndpoint] instead for the password based sign-in only.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailOtpIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// The code is sent whether or not an account is registered for the email.
  /// If none is, verifying the code lets the user create a new account.
  ///
  /// Always returns a login request ID, which must be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the email is
  ///   not valid.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if too many
  ///   one-time passwords have been requested for the email.
  @override
  _ida.Future<_isc.UuidValue> startOtpLogin({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startOtpLogin',
        {'email': email},
      );

  /// Verifies a one-time password and returns a token to complete the login.
  ///
  /// If [EmailAccountOtpVerificationResult.accountExists] is `true`, pass the
  /// token to [finishOtpLogin] to sign in. Otherwise, have the user accept the
  /// terms (and optionally set a password if
  /// [EmailAccountOtpVerificationResult.allowPassword] is `true`) and pass it
  /// to [finishOtpRegistration] to create the account.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the code.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists for
  ///   the given [otpLoginRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<_iaic.EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required _isc.UuidValue otpLoginRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<_iaic.EmailAccountOtpVerificationResult>(
    'emailIdp',
    'verifyOtpLoginCode',
    {
      'otpLoginRequestId': otpLoginRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a passwordless login for an existing account and returns a new
  /// session.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or no account exists for the email.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpLogin({
    required String otpLoginToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpLogin',
    {'otpLoginToken': otpLoginToken},
  );

  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user with a profile and attaching the verified email
  /// to it.
  ///
  /// Must only be called after the user accepted the terms. The [password] is
  /// optional, and may only be set if
  /// [EmailAccountOtpVerificationResult.allowPassword] was `true`.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if a password is
  ///   given but not allowed, or it does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or an account already exists for the email.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpRegistration',
    {
      'otpLoginToken': otpLoginToken,
      'password': password,
    },
  );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// The channel rack of a project (`client.channel`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation],
/// [ErrorCode.limitReached] (32 channels).
/// {@category Endpoint}
class EndpointChannel extends _isc.EndpointRef {
  EndpointChannel(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'channel';

  /// Channels of a project, in rack order.
  _ida.Future<List<_io54avb8.ChannelResponse>> list(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<List<_io54avb8.ChannelResponse>>(
        'channel',
        'list',
        {'projectId': projectId},
      );

  /// Adds a channel playing a built-in sample.
  _ida.Future<_io54avb8.ChannelResponse> create(
    _ix8m1nad.CreateChannelRequest request,
  ) => caller.callServerEndpoint<_io54avb8.ChannelResponse>(
    'channel',
    'create',
    {'request': request},
  );

  /// Renames a channel and sets volume / mute.
  _ida.Future<_io54avb8.ChannelResponse> update(
    _isc.UuidValue channelId,
    _itrlqtj1.UpdateChannelRequest request,
  ) => caller.callServerEndpoint<_io54avb8.ChannelResponse>(
    'channel',
    'update',
    {
      'channelId': channelId,
      'request': request,
    },
  );

  /// Chops a channel's region into 2/4/8/16 slices, one new channel each.
  _ida.Future<List<_io54avb8.ChannelResponse>> chop(
    _isc.UuidValue channelId,
    _iroonklb.ChopChannelRequest request,
  ) => caller.callServerEndpoint<List<_io54avb8.ChannelResponse>>(
    'channel',
    'chop',
    {
      'channelId': channelId,
      'request': request,
    },
  );

  /// Deletes a channel and its notes.
  _ida.Future<void> delete(_isc.UuidValue channelId) =>
      caller.callServerEndpoint<void>(
        'channel',
        'delete',
        {'channelId': channelId},
      );
}

/// Patterns of a project (`client.pattern`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound] (project/pattern not visible), [ErrorCode.forbidden]
/// (read member or visitor), [ErrorCode.validation], [ErrorCode.conflict]
/// (deleting the last pattern), [ErrorCode.limitReached] (99 patterns).
/// {@category Endpoint}
class EndpointPattern extends _isc.EndpointRef {
  EndpointPattern(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pattern';

  /// Patterns of a project, in order.
  _ida.Future<List<_idk43ht2.PatternResponse>> list(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<List<_idk43ht2.PatternResponse>>(
        'pattern',
        'list',
        {'projectId': projectId},
      );

  /// Adds a pattern (defaults: "Pattern N", next color, 4 bars).
  _ida.Future<_idk43ht2.PatternResponse> create(
    _iyp770n4.CreatePatternRequest request,
  ) => caller.callServerEndpoint<_idk43ht2.PatternResponse>(
    'pattern',
    'create',
    {'request': request},
  );

  /// Renames / recolors / resizes a pattern.
  _ida.Future<_idk43ht2.PatternResponse> update(
    _isc.UuidValue patternId,
    _i29cq5tg.UpdatePatternRequest request,
  ) => caller.callServerEndpoint<_idk43ht2.PatternResponse>(
    'pattern',
    'update',
    {
      'patternId': patternId,
      'request': request,
    },
  );

  /// Duplicates a pattern at the end of the list.
  _ida.Future<_idk43ht2.PatternResponse> clone(_isc.UuidValue patternId) =>
      caller.callServerEndpoint<_idk43ht2.PatternResponse>(
        'pattern',
        'clone',
        {'patternId': patternId},
      );

  /// Notes of a pattern (anyone who can see the project).
  _ida.Future<List<_ij5vkych.NoteResponse>> listNotes(
    _isc.UuidValue patternId,
  ) => caller.callServerEndpoint<List<_ij5vkych.NoteResponse>>(
    'pattern',
    'listNotes',
    {'patternId': patternId},
  );

  /// Replaces all notes of a pattern (owner or write member). Notes must
  /// fit in the pattern, use the project's channels, pitch 0–127 and
  /// velocity 1–127; at most 4096 notes.
  _ida.Future<List<_ij5vkych.NoteResponse>> saveNotes(
    _isc.UuidValue patternId,
    _i8a3qaoj.SavePatternNotesRequest request,
  ) => caller.callServerEndpoint<List<_ij5vkych.NoteResponse>>(
    'pattern',
    'saveNotes',
    {
      'patternId': patternId,
      'request': request,
    },
  );

  /// Deletes a pattern (never the last one).
  _ida.Future<void> delete(_isc.UuidValue patternId) =>
      caller.callServerEndpoint<void>(
        'pattern',
        'delete',
        {'patternId': patternId},
      );
}

/// The playlist (song arrangement) of a project (`client.playlist`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// saving needs owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation]
/// (unknown pattern, out of range, overlapping clips),
/// [ErrorCode.limitReached] (2048 clips).
/// {@category Endpoint}
class EndpointPlaylist extends _isc.EndpointRef {
  EndpointPlaylist(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'playlist';

  /// Clips of the project's playlist, ordered by track then start bar.
  _ida.Future<List<_i0zaexo5.ClipResponse>> list(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<List<_i0zaexo5.ClipResponse>>(
        'playlist',
        'list',
        {'projectId': projectId},
      );

  /// Replaces the whole playlist.
  _ida.Future<List<_i0zaexo5.ClipResponse>> save(
    _isc.UuidValue projectId,
    _ikmgaklg.SavePlaylistRequest request,
  ) => caller.callServerEndpoint<List<_i0zaexo5.ClipResponse>>(
    'playlist',
    'save',
    {
      'projectId': projectId,
      'request': request,
    },
  );
}

/// Members, invitations and join requests (`client.projectCollaboration`).
///
/// Requires a signed-in user. Throws [AppException]: [ErrorCode.notFound]
/// for projects/invitations/requests the caller cannot see,
/// [ErrorCode.forbidden] when the caller's role does not allow the action or
/// contributions are disabled, [ErrorCode.conflict] (already a member, owner
/// leaving), [ErrorCode.limitReached] (collaborator cap) and
/// [ErrorCode.validation].
/// {@category Endpoint}
class EndpointProjectCollaboration extends _isc.EndpointRef {
  EndpointProjectCollaboration(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'projectCollaboration';

  /// Owner and members of a project, owner first (owner and members only).
  _ida.Future<List<_ic4cvzfq.ProjectMemberResponse>> listMembers(
    _isc.UuidValue projectId,
  ) => caller.callServerEndpoint<List<_ic4cvzfq.ProjectMemberResponse>>(
    'projectCollaboration',
    'listMembers',
    {'projectId': projectId},
  );

  /// Changes a member's role (owner only).
  _ida.Future<_ic4cvzfq.ProjectMemberResponse> updateMemberRole(
    _ig0a8nmn.UpdateMemberRoleRequest request,
  ) => caller.callServerEndpoint<_ic4cvzfq.ProjectMemberResponse>(
    'projectCollaboration',
    'updateMemberRole',
    {'request': request},
  );

  /// Removes a member (owner only).
  _ida.Future<void> removeMember(
    _isc.UuidValue projectId,
    _isc.UuidValue userId,
  ) => caller.callServerEndpoint<void>(
    'projectCollaboration',
    'removeMember',
    {
      'projectId': projectId,
      'userId': userId,
    },
  );

  /// Leaves a project the caller is a member of.
  _ida.Future<void> leave(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<void>(
        'projectCollaboration',
        'leave',
        {'projectId': projectId},
      );

  /// Invites an email address with a role (owner only, contributions open).
  /// Behaves identically whether or not the email has an account.
  _ida.Future<_inz5k6t4.ProjectInvitationResponse> invite(
    _ifw5qbat.InviteMemberRequest request,
  ) => caller.callServerEndpoint<_inz5k6t4.ProjectInvitationResponse>(
    'projectCollaboration',
    'invite',
    {'request': request},
  );

  /// Pending invitations of a project (owner only).
  _ida.Future<List<_inz5k6t4.ProjectInvitationResponse>> listProjectInvitations(
    _isc.UuidValue projectId,
  ) => caller.callServerEndpoint<List<_inz5k6t4.ProjectInvitationResponse>>(
    'projectCollaboration',
    'listProjectInvitations',
    {'projectId': projectId},
  );

  /// Cancels a pending invitation (owner only).
  _ida.Future<void> cancelInvitation(_isc.UuidValue invitationId) =>
      caller.callServerEndpoint<void>(
        'projectCollaboration',
        'cancelInvitation',
        {'invitationId': invitationId},
      );

  /// Pending invitations addressed to the caller's email.
  _ida.Future<List<_inz5k6t4.ProjectInvitationResponse>> myInvitations() =>
      caller.callServerEndpoint<List<_inz5k6t4.ProjectInvitationResponse>>(
        'projectCollaboration',
        'myInvitations',
        {},
      );

  /// Accepts or declines an invitation addressed to the caller.
  _ida.Future<void> respondToInvitation(
    _isc.UuidValue invitationId,
    bool accept,
  ) => caller.callServerEndpoint<void>(
    'projectCollaboration',
    'respondToInvitation',
    {
      'invitationId': invitationId,
      'accept': accept,
    },
  );

  /// Asks to join a public project that accepts contributions.
  _ida.Future<_i9kix0wi.JoinRequestResponse> requestToJoin(
    _immwh6ll.JoinProjectRequest request,
  ) => caller.callServerEndpoint<_i9kix0wi.JoinRequestResponse>(
    'projectCollaboration',
    'requestToJoin',
    {'request': request},
  );

  /// Cancels the caller's own pending join request.
  _ida.Future<void> cancelJoinRequest(_isc.UuidValue requestId) =>
      caller.callServerEndpoint<void>(
        'projectCollaboration',
        'cancelJoinRequest',
        {'requestId': requestId},
      );

  /// The caller's pending join requests.
  _ida.Future<List<_i9kix0wi.JoinRequestResponse>> myJoinRequests() =>
      caller.callServerEndpoint<List<_i9kix0wi.JoinRequestResponse>>(
        'projectCollaboration',
        'myJoinRequests',
        {},
      );

  /// Pending join requests of a project with requester emails (owner only).
  _ida.Future<List<_i9kix0wi.JoinRequestResponse>> listJoinRequests(
    _isc.UuidValue projectId,
  ) => caller.callServerEndpoint<List<_i9kix0wi.JoinRequestResponse>>(
    'projectCollaboration',
    'listJoinRequests',
    {'projectId': projectId},
  );

  /// Accepts or declines a join request (owner only).
  _ida.Future<void> respondToJoinRequest(
    _isc.UuidValue requestId,
    bool accept,
  ) => caller.callServerEndpoint<void>(
    'projectCollaboration',
    'respondToJoinRequest',
    {
      'requestId': requestId,
      'accept': accept,
    },
  );
}

/// Project CRUD and listing (`client.project`).
///
/// Requires a signed-in user. Every method throws [AppException]:
/// [ErrorCode.notFound] for projects the caller cannot see (private and not a
/// member, or nonexistent), [ErrorCode.forbidden] for actions the caller's
/// role does not allow, [ErrorCode.validation] with `fieldErrors` for invalid
/// input.
/// {@category Endpoint}
class EndpointProject extends _isc.EndpointRef {
  EndpointProject(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'project';

  /// Creates a project owned by the caller.
  _ida.Future<_ia3hvpml.ProjectResponse> create(
    _igj9gzmx.CreateProjectRequest request,
  ) => caller.callServerEndpoint<_ia3hvpml.ProjectResponse>(
    'project',
    'create',
    {'request': request},
  );

  /// Returns a project the caller owns, is a member of, or that is public.
  _ida.Future<_ia3hvpml.ProjectResponse> getById(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<_ia3hvpml.ProjectResponse>(
        'project',
        'getById',
        {'projectId': projectId},
      );

  /// Projects owned by the caller, most recently changed first.
  /// [limit] is capped at 50 (default 20).
  _ida.Future<_iiazmhcc.ProjectPageResponse> listMine({
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_iiazmhcc.ProjectPageResponse>(
    'project',
    'listMine',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Projects the caller collaborates on (member, not owner).
  _ida.Future<_iiazmhcc.ProjectPageResponse> listShared({
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_iiazmhcc.ProjectPageResponse>(
    'project',
    'listShared',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Public projects of other users, optionally filtered by a case-insensitive
  /// name [query] (max 80 chars).
  _ida.Future<_iiazmhcc.ProjectPageResponse> discover({
    String? query,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_iiazmhcc.ProjectPageResponse>(
    'project',
    'discover',
    {
      'query': query,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Replaces a project's details. Owner: everything; write members: name,
  /// description and genres only.
  _ida.Future<_ia3hvpml.ProjectResponse> update(
    _isc.UuidValue projectId,
    _i4ow79ga.UpdateProjectRequest request,
  ) => caller.callServerEndpoint<_ia3hvpml.ProjectResponse>(
    'project',
    'update',
    {
      'projectId': projectId,
      'request': request,
    },
  );

  /// Sets the project's tempo (20–999 BPM, rounded to 2 decimals). Owner and
  /// write members only.
  _ida.Future<_ia3hvpml.ProjectResponse> updateTempo(
    _isc.UuidValue projectId,
    _if2prfhr.UpdateProjectTempoRequest request,
  ) => caller.callServerEndpoint<_ia3hvpml.ProjectResponse>(
    'project',
    'updateTempo',
    {
      'projectId': projectId,
      'request': request,
    },
  );

  /// Deletes a project with its members, invitations and join requests
  /// (owner only).
  _ida.Future<void> delete(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<void>(
        'project',
        'delete',
        {'projectId': projectId},
      );
}

/// Audio uploads of a project (`client.sample`).
///
/// Upload flow: [requestUpload] → `FileUploader(ticket.uploadDescription)`
/// → [finishUpload]. Requires a signed-in user; listing needs the project to
/// be visible, changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation]
/// (type, size > 10 MB, bytes not matching the format),
/// [ErrorCode.limitReached] (64 samples).
/// {@category Endpoint}
class EndpointSample extends _isc.EndpointRef {
  EndpointSample(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sample';

  /// Issues an upload description for one file (WAV/MP3/OGG/FLAC, ≤ 10 MB).
  _ida.Future<_iv3w8q6y.SampleUploadTicket> requestUpload(
    _ix1enysx.RequestSampleUploadRequest request,
  ) => caller.callServerEndpoint<_iv3w8q6y.SampleUploadTicket>(
    'sample',
    'requestUpload',
    {'request': request},
  );

  /// Verifies and registers an uploaded file.
  _ida.Future<_ilv1w5af.SampleResponse> finishUpload(
    _i5duwawj.FinishSampleUploadRequest request,
  ) => caller.callServerEndpoint<_ilv1w5af.SampleResponse>(
    'sample',
    'finishUpload',
    {'request': request},
  );

  /// Samples of a project, newest first, with 12-hour download URLs.
  _ida.Future<List<_ilv1w5af.SampleResponse>> list(_isc.UuidValue projectId) =>
      caller.callServerEndpoint<List<_ilv1w5af.SampleResponse>>(
        'sample',
        'list',
        {'projectId': projectId},
      );

  /// Deletes a sample and the channels / playlist clips using it.
  _ida.Future<void> delete(_isc.UuidValue sampleId) =>
      caller.callServerEndpoint<void>(
        'sample',
        'delete',
        {'sampleId': sampleId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_iruhsk5y.Greeting> hello(String name) =>
      caller.callServerEndpoint<_iruhsk5y.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    channel = EndpointChannel(this);
    pattern = EndpointPattern(this);
    playlist = EndpointPlaylist(this);
    projectCollaboration = EndpointProjectCollaboration(this);
    project = EndpointProject(this);
    sample = EndpointSample(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointChannel channel;

  late final EndpointPattern pattern;

  late final EndpointPlaylist playlist;

  late final EndpointProjectCollaboration projectCollaboration;

  late final EndpointProject project;

  late final EndpointSample sample;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'channel': channel,
    'pattern': pattern,
    'playlist': playlist,
    'projectCollaboration': projectCollaboration,
    'project': project,
    'sample': sample,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
