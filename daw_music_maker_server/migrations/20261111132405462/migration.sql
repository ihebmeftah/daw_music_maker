BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL DEFAULT ''::text,
    "genres" json NOT NULL,
    "visibility" text NOT NULL DEFAULT 'private'::text,
    "allowContributions" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "project_owner_idx" ON "project" USING btree ("ownerId");
CREATE INDEX "project_visibility_idx" ON "project" USING btree ("visibility", "updatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project_invitation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "projectId" uuid NOT NULL,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "invitedById" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "project_invitation_unique_idx" ON "project_invitation" USING btree ("projectId", "email");
CREATE INDEX "project_invitation_email_idx" ON "project_invitation" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project_join_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "projectId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "project_join_request_unique_idx" ON "project_join_request" USING btree ("projectId", "userId");
CREATE INDEX "project_join_request_user_idx" ON "project_join_request" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project_member" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "projectId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "project_member_unique_idx" ON "project_member" USING btree ("projectId", "userId");
CREATE INDEX "project_member_user_idx" ON "project_member" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "project_invitation"
    ADD CONSTRAINT "project_invitation_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "project_join_request"
    ADD CONSTRAINT "project_join_request_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "project_member"
    ADD CONSTRAINT "project_member_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR daw_music_maker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('daw_music_maker', '20261111132405462', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111132405462', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
