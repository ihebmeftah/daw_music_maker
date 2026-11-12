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
CREATE TABLE "channel" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "projectId" uuid NOT NULL,
    "name" text NOT NULL,
    "sample" text NOT NULL,
    "volume" double precision NOT NULL DEFAULT 0.8,
    "muted" boolean NOT NULL DEFAULT false,
    "position" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "channel_project_position_idx" ON "channel" USING btree ("projectId", "position");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pattern_note" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "patternId" uuid NOT NULL,
    "channelId" uuid NOT NULL,
    "tick" bigint NOT NULL,
    "lengthTicks" bigint NOT NULL,
    "pitch" bigint NOT NULL,
    "velocity" bigint NOT NULL
);

-- Indexes
CREATE INDEX "pattern_note_pattern_idx" ON "pattern_note" USING btree ("patternId");
CREATE INDEX "pattern_note_channel_idx" ON "pattern_note" USING btree ("channelId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "channel"
    ADD CONSTRAINT "channel_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pattern_note"
    ADD CONSTRAINT "pattern_note_fk_0"
    FOREIGN KEY("patternId")
    REFERENCES "pattern"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "pattern_note"
    ADD CONSTRAINT "pattern_note_fk_1"
    FOREIGN KEY("channelId")
    REFERENCES "channel"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- DATA: give every existing project the default drum rack (hand-written; the
-- schema is unchanged, so it still matches definition.sql).
--
INSERT INTO "channel" ("projectId", "name", "sample", "volume", "muted", "position")
    SELECT p."id", d."name", d."sample", 0.8, false, d."position"
    FROM "project" p
    CROSS JOIN (VALUES
        ('Kick', 'kick', 0),
        ('Snare', 'snare', 1),
        ('Hat', 'closedHat', 2),
        ('Open Hat', 'openHat', 3)
    ) AS d("name", "sample", "position");

--
-- MIGRATION VERSION FOR daw_music_maker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('daw_music_maker', '20261111165902517', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111165902517', "timestamp" = now();

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
