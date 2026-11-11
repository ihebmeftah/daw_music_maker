import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../../generated/protocol.dart';

/// Access to the authenticated caller.
extension AuthGuard on Session {
  /// The caller's auth user id.
  ///
  /// The only allowed source of the caller's identity: never accept a user id
  /// from a DTO. Endpoints using it set `requireLogin => true`, so this only
  /// throws if that guard is missing.
  ///
  /// Throws [AppException] with [ErrorCode.forbidden] when unauthenticated.
  UuidValue get requireUserId {
    final id = authenticated?.authUserId;
    if (id == null) throw AppException(code: ErrorCode.forbidden);
    return id;
  }
}
