-- =============================================================================
-- 001_init.sql
-- Youth Basketball League Database
-- PostgreSQL / Supabase version
--
-- This file builds the entire database from scratch.
-- Run it once on a fresh database before running 002_seed_data.sql.
-- =============================================================================


-- LOOKUP TABLES
-- Small reference tables that hold valid status values.
-- Using these instead of plain text columns keeps data clean and consistent.

-- Holds the valid states a payment can be in (Pending, Completed, Refunded, etc.)
CREATE TABLE "PaymentStatus" (
  "status_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "status_name" varchar(255) UNIQUE NOT NULL
);

-- Holds the valid states a registration can be in (Active, Waitlisted, Withdrawn, etc.)
CREATE TABLE "RegistrationStatus" (
  "status_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "status_name" varchar(255) UNIQUE NOT NULL
);


-- CORE TABLES
-- The main "things" the league cares about: seasons, gyms, people, and teams.

-- A season is a defined window of time (e.g., "Spring 2026").
-- The CHECK constraint stops anyone from saving a season that ends before it begins.
CREATE TABLE "Season" (
  "season_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "season_name" varchar(255) NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  
  CONSTRAINT "chk_season_dates"
  CHECK ("end_date" > "start_date")
);

-- A gym is a physical location where games are played.
-- Capacity is optional, but useful for picking the right venue for big games.
CREATE TABLE "Gym" (
  "gym_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "gym_name" varchar(255) NOT NULL,
  "address" varchar(255) NOT NULL,
  "city" varchar(255) NOT NULL,
  "capacity" int
);

-- A guardian is the parent or legal contact responsible for a player.
-- Email must be unique so the league has a reliable way to reach each family.
CREATE TABLE "Guardian" (
  "guardian_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "phone" varchar(255)
);

-- A player is a kid in the league. Every player must have a guardian on file.
CREATE TABLE "Player" (
  "player_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "date_of_birth" date NOT NULL,
  "guardian_id" int NOT NULL
);

-- A team belongs to one season and competes in one age division (10U, 12U, 14U).
-- A new team row is created for each season — the same name in two seasons is two teams.
CREATE TABLE "Team" (
  "team_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "team_name" varchar(255) NOT NULL,
  "division" varchar(255),
  "season_id" int NOT NULL
);

-- A coach can be assigned to one or more teams (handled by CoachTeam below).
-- Email is unique so the same coach isn't accidentally entered twice.
CREATE TABLE "Coach" (
  "coach_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "phone" varchar(255)
);

-- A referee can officiate one or more games (handled by GameReferee below).
-- Certification level helps schedule the right ref for the right age division.
CREATE TABLE "Referee" (
  "referee_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "certification_level" varchar(255)
);


-- GAME TABLE
-- A single scheduled matchup between two teams at a specific gym, date, and time.
-- The CHECK constraint blocks any row where the home team and away team are the same —
-- a team obviously can't play against itself.

CREATE TABLE "Game" (
  "game_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "season_id" int NOT NULL,
  "gym_id" int NOT NULL,
  "home_team_id" int NOT NULL,
  "away_team_id" int NOT NULL,
  "game_date" date NOT NULL,
  "game_time" time NOT NULL,
  "home_score" int DEFAULT 0,
  "away_score" int DEFAULT 0,

  CONSTRAINT "chk_different_teams"
  CHECK ("home_team_id" <> "away_team_id")
);


-- REGISTRATION TABLE
-- Connects a player to a team for a specific season. Each row is one signup.
-- Status tracks where the registration stands (Active, Waitlisted, etc.)

CREATE TABLE "Registration" (
  "registration_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "player_id" int NOT NULL,
  "team_id" int NOT NULL,
  "season_id" int NOT NULL,
  "registration_date" date NOT NULL,
  "status_id" int NOT NULL
);


-- PAYMENT TABLE
-- A financial record tied to a specific registration.
-- The amount column uses decimal(10,2) so dollars and cents are always stored exactly.

CREATE TABLE "Payment" (
  "payment_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "registration_id" int NOT NULL,
  "amount" decimal(10,2) NOT NULL,
  "payment_date" date NOT NULL,
  "status_id" int NOT NULL
);


-- JUNCTION TABLES
-- These connect two entities that have a many-to-many relationship.

-- Links referees to games. One game can have multiple refs; one ref works many games.
-- The composite primary key prevents the same ref from being added twice to one game.
CREATE TABLE "GameReferee" (
  "game_id" int NOT NULL,
  "referee_id" int NOT NULL,

  PRIMARY KEY ("game_id", "referee_id")
);

-- Links coaches to teams. A coach can run multiple teams; a team can have multiple coaches.
-- The composite primary key prevents duplicate coach-team pairings.
CREATE TABLE "CoachTeam" (
  "coach_id" int NOT NULL,
  "team_id" int NOT NULL,

  PRIMARY KEY ("coach_id", "team_id")
);


-- INDEXES
-- Extra rules and lookups added on top of the primary keys.

-- Stops two games from being scheduled at the same gym on the same date and time.
CREATE UNIQUE INDEX "uq_gym_schedule"
ON "Game" ("gym_id", "game_date", "game_time");

-- Stops a player from being registered to two different teams in the same season.
CREATE UNIQUE INDEX "uq_player_season"
ON "Registration" ("player_id", "season_id");


-- FOREIGN KEYS
-- These hook every "child" table up to the table it depends on, so the database
-- won't accept a row that points to something that doesn't exist
-- (e.g., a player linked to a guardian who isn't in the system).

-- Every player has to point to a real guardian.
ALTER TABLE "Player"
ADD FOREIGN KEY ("guardian_id")
REFERENCES "Guardian" ("guardian_id");

-- Every team has to belong to a real season.
ALTER TABLE "Team"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

-- A game has to belong to a real season.
ALTER TABLE "Game"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

-- A game has to be played at a real gym.
ALTER TABLE "Game"
ADD FOREIGN KEY ("gym_id")
REFERENCES "Gym" ("gym_id");

-- The home team has to be a real team.
ALTER TABLE "Game"
ADD FOREIGN KEY ("home_team_id")
REFERENCES "Team" ("team_id");

-- The away team has to be a real team.
ALTER TABLE "Game"
ADD FOREIGN KEY ("away_team_id")
REFERENCES "Team" ("team_id");

-- A registration has to point to a real player.
ALTER TABLE "Registration"
ADD FOREIGN KEY ("player_id")
REFERENCES "Player" ("player_id");

-- A registration has to point to a real team.
ALTER TABLE "Registration"
ADD FOREIGN KEY ("team_id")
REFERENCES "Team" ("team_id");

-- A registration has to point to a real season.
ALTER TABLE "Registration"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

-- The registration status has to come from the RegistrationStatus lookup table.
ALTER TABLE "Registration"
ADD FOREIGN KEY ("status_id")
REFERENCES "RegistrationStatus" ("status_id");

-- A payment has to be tied to a real registration.
ALTER TABLE "Payment"
ADD FOREIGN KEY ("registration_id")
REFERENCES "Registration" ("registration_id");

-- The payment status has to come from the PaymentStatus lookup table.
ALTER TABLE "Payment"
ADD FOREIGN KEY ("status_id")
REFERENCES "PaymentStatus" ("status_id");

-- The game-referee assignment has to point to a real game.
ALTER TABLE "GameReferee"
ADD FOREIGN KEY ("game_id")
REFERENCES "Game" ("game_id");

-- The game-referee assignment has to point to a real referee.
ALTER TABLE "GameReferee"
ADD FOREIGN KEY ("referee_id")
REFERENCES "Referee" ("referee_id");

-- The coach-team assignment has to point to a real coach.
ALTER TABLE "CoachTeam"
ADD FOREIGN KEY ("coach_id")
REFERENCES "Coach" ("coach_id");

-- The coach-team assignment has to point to a real team.
ALTER TABLE "CoachTeam"
ADD FOREIGN KEY ("team_id")
REFERENCES "Team" ("team_id");
