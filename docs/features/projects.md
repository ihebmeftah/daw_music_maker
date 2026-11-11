# Projects — CRUD, sharing, invitations and join requests

## 1. Purpose and user stories

A project is a music session owned by one user, with collaborators.

- As a producer I create, edit and delete projects with a **name**, **description**,
  **genre tags**, **visibility** (private / public) and **contributions** on/off.
- As an owner of a project open to contributions I **invite** people by email with **read**
  or **write** access, see pending invitations and cancel them.
- As an invitee I see invitations in my **inbox** and accept or decline them.
- As any user I **discover** public projects of others (searchable by name) and open them
  read-only.
- If a public project is open to contributions, I **request to join** with read or write
  access, and can cancel my request. The owner accepts or declines.
- As an owner I change members' roles and remove them; as a member I can leave.

## 2. Screens / routes and endpoints

| Route                 | View                 | ViewModel                         |
| --------------------- | -------------------- | --------------------------------- |
| `/projects`           | `ProjectsView` — tabs Mine / Shared / Discover (search), inbox badge, sign out | `ProjectListViewModel(kind)`, `InboxViewModel` (badge), `ProjectsViewModel` (sign out) |
| `/projects/new`       | `ProjectFormView`    | `ProjectFormViewModel(null)`      |
| `/projects/:id`       | `ProjectDetailView`  | `ProjectDetailViewModel(id)`      |
| `/projects/:id/edit`  | `ProjectFormView`    | `ProjectFormViewModel(id)`        |
| `/inbox`              | `InboxView`          | `InboxViewModel`                  |

Invalid UUIDs in the URL show `NotFoundView`. All routes require sign-in (route guard).

Server endpoints (`requireLogin`, caller id only from the session):

- `client.project` (`ProjectEndpoint`): `create`, `getById`, `listMine`, `listShared`,
  `discover(query?)`, `update`, `delete`. Lists are paginated (`limit` ≤ 50, default 20,
  `offset`) and return `ProjectPageResponse { items, hasMore }`.
- `client.projectCollaboration` (`ProjectCollaborationEndpoint`): `listMembers`,
  `updateMemberRole`, `removeMember`, `leave`, `invite`, `listProjectInvitations`,
  `cancelInvitation`, `myInvitations`, `respondToInvitation`, `requestToJoin`,
  `cancelJoinRequest`, `myJoinRequests`, `listJoinRequests`, `respondToJoinRequest`.

Layers: endpoints → `ProjectService` / `CollaborationService` (rules, ownership,
transactions) → `ProjectAccessService` (resolves the caller's `ProjectAccess`) →
repositories (`ProjectsRepository`, `ProjectMembersRepository`,
`ProjectInvitationsRepository`, `ProjectJoinRequestsRepository` — pluralized because
Serverpod generates `ProjectRepository` etc. for the ORM). Pure rules live in
`ProjectRules` (unit tested).

## 3. Models

Entities (`serverOnly`, UUID v7 ids, `createdAt`/`updatedAt`):

- `Project` (`project`): `ownerId`, `name`, `description`, `genres: List<String>`,
  `visibility`, `allowContributions`.
- `ProjectMember` (`project_member`): `projectId` (cascade), `userId`, `role`; unique
  `(projectId, userId)`. The owner is **not** a member row.
- `ProjectInvitation` (`project_invitation`): `projectId` (cascade), `email` (normalized),
  `role`, `invitedById`; unique `(projectId, email)`. Stored **by email**, so inviting never
  reveals whether an account exists and invitations reach people who sign up later.
- `ProjectJoinRequest` (`project_join_request`): `projectId` (cascade), `userId`, `role`;
  unique `(projectId, userId)`.

Invitations and join requests are **pending-only**: they are deleted when accepted, declined
or cancelled.

Enums: `ProjectVisibility { private, public }`, `ProjectRole { read, write }`,
`ProjectAccess { owner, write, read, none }`.

DTOs: `CreateProjectRequest`, `UpdateProjectRequest`, `InviteMemberRequest`,
`JoinProjectRequest`, `UpdateMemberRoleRequest`.

Responses: `ProjectResponse` (includes the caller's `access`, `memberCount`,
`hasPendingJoinRequest`), `ProjectPageResponse`, `ProjectMemberResponse`,
`ProjectInvitationResponse`, `JoinRequestResponse`.

Errors: `AppException { code: ErrorCode, message?, fieldErrors? }` with
`ErrorCode { notFound, forbidden, validation, conflict, limitReached }`, mapped on the
client to `Failure(FailureCode…, fieldErrors)`.

## 4. Validation rules and security notes

`ValidationRules` (server ↔ Flutter, kept in sync):

| Rule                         | Value                                               |
| ---------------------------- | --------------------------------------------------- |
| Name                         | 1–80 chars after trimming                           |
| Description                  | ≤ 1000 chars after trimming                         |
| Genres                       | ≤ 8 tags, each 1–24 chars; trimmed; case-insensitive duplicates removed |
| Collaborators per project    | ≤ 50 (members + pending invitations)                |
| Discover search              | ≤ 80 chars; `%`, `_` and `\` matched literally      |
| Page size                    | 1–50 (default 20)                                   |

Access rules:

- **Visible** = owner, member, or public project. Anything else → `notFound` (ids can't
  be probed).
- **Edit** name/description/genres: owner or write member. **Visibility and
  contributions**: owner only (`forbidden` for write members). Read members and visitors
  → `forbidden`.
- **Delete**, members management, invitations, join request decisions: owner only.
- **Invite** requires `allowContributions`; inviting your own email → `validation`;
  an existing member's email → `conflict`; re-inviting updates the role.
- **Join request** requires the project to be public **and** open to contributions
  (`forbidden` otherwise); owner/members get `conflict`.
- Turning contributions **off** deletes pending invitations and join requests; making the
  project **private** deletes pending join requests. Existing members stay.
- The owner cannot leave (`conflict`); they delete the project instead.

Personal data: member emails are visible to the project's owner and members (collaborators
need to know who they work with); a join request shares the requester's email with the
owner (stated in the request dialog). Discover and project responses expose no emails.

## 5. How it is tested

Server (`daw_music_maker_server/test/`):

- Unit: `unit/features/projects/services/project_rules_test.dart`,
  `unit/core/pagination/page_limits_test.dart`, `unit/core/validation/validator_test.dart`,
  `unit/core/validation/validation_rules_test.dart`.
- Integration (`withServerpod`): `project_endpoint_test.dart`,
  `project_collaboration_endpoint_test.dart` — every method covers unauthenticated,
  another user's private resource (`notFound`), invalid input and the happy path, plus the
  access rules, cleanup on settings changes, cascades, discover filtering and pagination.
  Users are created with `integration/helpers/project_fixtures.dart`.

Flutter (`daw_music_maker_flutter/test/`):

- Unit: repositories (mocked endpoints, `AppException` → `Failure`), all four ViewModels,
  validators and error mapper.
- Widget: `projects_view_test`, `project_form_view_test`, `project_detail_view_test`,
  `inbox_view_test` drive the real router with mocked repositories (create/edit flows,
  server field errors, invite dialog, join requests, member menu, delete/leave confirms,
  visitor join flow, not-found ids, phone layout). Shared widgets (`Panel`,
  `StudioScaffold`, `DawSegmentedControl`, `TagChip`, `EmptyState`, `ErrorView`,
  `LoadingView`, `NotFoundView`, `BrandMark`, `showConfirmDialog`) and feature widgets
  (`GenreTagsField`, `ProjectCard`) have their own tests.
