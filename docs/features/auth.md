# Auth — sign in, register, forgot password

## 1. Purpose and user stories

Email + password authentication built on Serverpod's email identity provider.

- As a new user I register with my email, confirm it with an emailed code and choose a
  password; I am then signed in and land on `/projects`.
- As a returning user I sign in with email and password and land on `/projects`.
- As a user who forgot my password I request a reset code by email, confirm it, choose a new
  password and am signed in with it, landing on `/projects`.
- As a signed-in user I can sign out (from `/projects`) and return to `/login`.
- I can switch between dark and light mode from the top bar.

## 2. Screens / routes and endpoints

| Route              | View                 | ViewModel                 |
| ------------------ | -------------------- | ------------------------- |
| `/login`           | `LoginView`          | `LoginViewModel`          |
| `/register`        | `RegisterView`       | `RegisterViewModel`       |
| `/forgot-password` | `ForgotPasswordView` | `ForgotPasswordViewModel` |
| `/projects`        | `ProjectsView` (see [projects.md](projects.md)) | `ProjectsViewModel` (sign out) |

Routing (`app/router/`): `authRedirect` in `route_guards.dart` sends signed-out users on a
protected path to `/login`, and signed-in users on an auth path to `/projects`. The router
listens to `AuthSession.changes`, so every successful sign-in (login, registration, reset)
ends on `/projects` without views navigating explicitly.

Flows:

- **Login**: `emailIdp.login` → session stored with `FlutterAuthSessionManager.updateSignedInUser`.
- **Register** (email → code → password): `startRegistration` → `verifyRegistrationCode`
  → `finishRegistration` (returns a session).
- **Forgot password** (email → code → new password): `startPasswordReset` →
  `verifyPasswordResetCode` → `finishPasswordReset`, then `login` with the new password.

Server: no custom endpoints. `EmailIdpEndpoint` (`lib/src/auth/email_idp_endpoint.dart`)
extends Serverpod's `EmailOtpIdpBaseEndpoint`; it is configured in `lib/server.dart` with
`ServerpodCloudEmailIdpConfig`. In development the codes are **logged to the server
console** (`Registration code for …` / `Password reset code for …`) instead of being emailed.

Flutter structure:

- `features/auth/data/` — `AuthRepository` (interface), `AuthRepositoryImpl` (calls
  `EndpointEmailIdp`, maps exceptions to `Failure`), `authRepositoryProvider` (get_it bridge).
- `features/auth/presentation/state/` — `LoginState`, `EmailCodeFlowState` (shared by
  register and reset, with `EmailCodeFlowStep`).
- `features/auth/presentation/widgets/` — `AuthShell` (layout), `AuthHero`,
  `SpectrumBars`, `TransportReadout`, `AuthCardHeader`, `AuthLink`, `StepIndicator`,
  `EmailStepForm`, `CodeStepForm`, `PasswordStepForm`, `EmailCodeFlowBody`.
- `core/auth/` — `AuthSession` (signed-in state + sign out), used by the router and features.

### UI / motion

- `WaveCursorBackground` (shared): a field of sine waves that swell around the mouse, a soft
  glow and a circular "oscilloscope" ring trailing the pointer. On touch devices a virtual
  cursor drifts. Painted with a `Ticker` + `CustomPainter`, no rebuilds per frame.
- `SpotlightPanel` (shared): frosted form card lit by the cursor (surface and border glow,
  shadow moves away from the pointer).
- Staggered entrance reveals, slide transitions between flow steps, fade/scale page
  transitions, equalizer loading state in `DawButton`, sequencer-pad step indicator,
  level-meter password length hint.
- All continuous animations stop when the platform's "reduce motion" setting is on.
- Theme: `AppTheme.dark` ("midnight studio", amber/red) and `AppTheme.light` ("paper studio",
  burnt orange); toggle via `ThemeModeToggle` (`ThemeModeController`, starts at system).

## 3. Models

No project models. Uses the generated auth models: `AuthSuccess`, `EmailAccountLoginException`,
`EmailAccountRequestException`, `EmailAccountPasswordResetException` (+ `…Reason` enums),
`AuthUserBlockedException`. These map to `Failure(FailureCode)` with user-friendly messages
(`core/errors/failure.dart`); raw server text is never shown.

## 4. Validation rules and security notes

`ValidationRules` exists on both sides and must stay in sync:
`daw_music_maker_server/lib/src/core/validation/validation_rules.dart` ↔
`daw_music_maker_flutter/lib/core/validation/validation_rules.dart`.

| Rule                     | Value                                   |
| ------------------------ | --------------------------------------- |
| Email max length         | 254, shape `local@domain.tld`           |
| Password length          | 8–128, no leading/trailing whitespace   |
| Verification code        | 8 digits, 1–9                           |

- The server enforces the password policy and code format itself (Serverpod defaults);
  a server unit test pins `ValidationRules` to those defaults.
- Sign-in only checks that the password is non-empty (the policy may change after sign-up).
- Emails are trimmed and lower-cased before being sent.
- No account enumeration: `startRegistration` / `startPasswordReset` always return a
  request id, and the reset flow always advances to the code step.
- Rate limits (failed logins, code attempts, reset requests) surface as "too many attempts".
- Tokens are stored by Serverpod's secure storage; the app holds no secrets.

## 5. How it is tested

Flutter (`daw_music_maker_flutter/test/`):

- Unit: `core/validation/validators_test.dart`, `app/router/route_guards_test.dart`,
  `core/errors/error_mapper_test.dart`, `core/theme/theme_mode_controller_test.dart`,
  `features/auth/data/auth_repository_impl_test.dart` (mocked endpoint + session manager),
  the three ViewModel tests (state transitions, failures, double-submit guard).
- Widget: `login_view_test`, `register_view_test`, `forgot_password_view_test`,
  `projects_view_test` run the real `DawApp` (router + guard) with a fake `AuthSession` and
  a mocked repository, covering validation, server errors, navigation and each full flow
  ending on `/projects`. `auth_shell_test` checks desktop/phone layouts (no overflow) and
  light mode. Every shared widget has its own test.
- `test/flutter_test_config.dart` disables Google Fonts fetching; `pumpApp` / `pumpDawApp`
  turn on "reduce motion" so infinite animations stop.

Server (`daw_music_maker_server/test/`):

- Unit: `unit/core/validation/validation_rules_test.dart` (rules match Serverpod defaults).
- Integration: `integration/email_idp_endpoint_test.dart` — unknown account login rejected,
  reset for unknown email returns an id (no enumeration), wrong registration code and invalid
  registration token rejected. Uses `RollbackDatabase.disabled` because the email provider
  runs concurrent transactions; created rows are cleaned up in `tearDown`.
