# Security conventions

The server is the trust boundary. The Flutter app is untrusted input.

## Authentication & authorization (server)

- Use Serverpod's built-in auth (configured in `lib/server.dart`). Never roll custom auth,
  token or password handling.
- Every feature endpoint sets `bool get requireLogin => true;`. Admin-only endpoints also set
  `requiredScopes => {Scope.admin}`. Public endpoints must be explicitly justified in a comment.
- Get the caller's id **only** from `session.authenticated` (via
  `core/security/auth_guard.dart`). Never accept `ownerId`/`userId` from a DTO.
- **Ownership on every access by id**: load the row with `where: id == x & ownerId == caller`.
  Missing or not owned → `AppException(code: ErrorCode.notFound)` (prevents IDOR and id probing).
- UUID v7 ids are not a security control on their own — still check ownership.

## Input validation (server — mandatory)

- Every DTO is validated in the service before any DB write: required fields, string
  trimming + length limits, numeric ranges (e.g. BPM 20–999, velocity 0–127, tick ≥ 0),
  enum membership, list size caps (max notes per pattern, max tracks per project).
- Limits live in `core/validation/validation_rules.dart` and are mirrored in the Flutter app.
- Validation failures throw `AppException(code: ErrorCode.validation, fieldErrors: {...})`.
- List endpoints always paginate with a capped `limit`.

## Data & errors

- Use the ORM with typed `where` expressions; raw SQL only with parameter binding — never
  string-concatenated input.
- Entities are `serverOnly: true`; Responses expose only fields the client needs (no internal
  flags, no other users' emails).
- Never return exception messages, stack traces or SQL errors to the client. Log server-side.
- Never log passwords, tokens, verification codes (outside development), or full request
  bodies containing personal data.

## Files (samples, audio exports)

- Use Serverpod file uploads with upload descriptions; verify the upload server-side
  (`verifyUpload`), enforce max size and allowed MIME types/extensions (wav, mp3, flac, ogg),
  and store under a server-generated UUID path scoped to the owner — never a client-supplied path.

## Secrets & config

- Secrets live in `config/passwords.yaml` (git-ignored) or environment variables — never in code,
  `.spy.yaml` files, `config/*.yaml` committed values, or the Flutter app.
- The Flutter app holds no secrets; auth tokens are stored by Serverpod's secure storage.

## Flutter

- Validate forms for UX, but assume the server will re-validate.
- Don't display raw server errors; map `AppException.code` to user-friendly messages.
- Don't log tokens or user personal data with `debugPrint`.
