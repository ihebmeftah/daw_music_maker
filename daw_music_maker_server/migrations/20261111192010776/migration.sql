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
-- ACTION ALTER TABLE
--
ALTER TABLE "channel" ADD COLUMN "sampleId" uuid;
ALTER TABLE "channel" ADD COLUMN "pan" double precision NOT NULL DEFAULT 0.0;
ALTER TABLE "channel" ADD COLUMN "pitch" bigint NOT NULL DEFAULT 0;
ALTER TABLE "channel" ADD COLUMN "startFrac" double precision NOT NULL DEFAULT 0.0;
ALTER TABLE "channel" ADD COLUMN "endFrac" double precision NOT NULL DEFAULT 1.0;
ALTER TABLE "channel" ALTER COLUMN "sample" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "playlist_clip" ADD COLUMN "sampleId" uuid;
ALTER TABLE "playlist_clip" ADD COLUMN "lengthBars" bigint;
ALTER TABLE "playlist_clip" ALTER COLUMN "patternId" DROP NOT NULL;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "sample" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "projectId" uuid NOT NULL,
    "name" text NOT NULL,
    "format" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "durationMs" bigint,
    "peaks" json,
    "storagePath" text NOT NULL,
    "uploadedById" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "sample_project_idx" ON "sample" USING btree ("projectId");
CREATE UNIQUE INDEX "sample_path_idx" ON "sample" USING btree ("storagePath");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "channel"
    ADD CONSTRAINT "channel_fk_1"
    FOREIGN KEY("sampleId")
    REFERENCES "sample"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "playlist_clip"
    ADD CONSTRAINT "playlist_clip_fk_2"
    FOREIGN KEY("sampleId")
    REFERENCES "sample"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "sample"
    ADD CONSTRAINT "sample_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR daw_music_maker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('daw_music_maker', '20261111192010776', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111192010776', "timestamp" = now();

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
