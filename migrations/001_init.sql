-- =============================================================================
-- 001_init.sql
-- Youth Basketball League Database
-- PostgreSQL / Supabase version
-- =============================================================================


-- LOOKUP TABLES

CREATE TABLE "PaymentStatus" (
  "status_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "status_name" varchar(255) UNIQUE NOT NULL
);

CREATE TABLE "RegistrationStatus" (
  "status_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "status_name" varchar(255) UNIQUE NOT NULL
);


-- CORE TABLES

CREATE TABLE "Season" (
  "season_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "season_name" varchar(255) NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  
  CONSTRAINT "chk_season_dates"
  CHECK ("end_date" > "start_date")
);

CREATE TABLE "Gym" (
  "gym_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "gym_name" varchar(255) NOT NULL,
  "address" varchar(255) NOT NULL,
  "city" varchar(255) NOT NULL,
  "capacity" int
);

CREATE TABLE "Guardian" (
  "guardian_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "phone" varchar(255)
);

CREATE TABLE "Player" (
  "player_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "date_of_birth" date NOT NULL,
  "guardian_id" int NOT NULL
);

CREATE TABLE "Team" (
  "team_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "team_name" varchar(255) NOT NULL,
  "division" varchar(255),
  "season_id" int NOT NULL
);

CREATE TABLE "Coach" (
  "coach_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "phone" varchar(255)
);

CREATE TABLE "Referee" (
  "referee_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "certification_level" varchar(255)
);


-- GAME TABLE

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

CREATE TABLE "Registration" (
  "registration_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "player_id" int NOT NULL,
  "team_id" int NOT NULL,
  "season_id" int NOT NULL,
  "registration_date" date NOT NULL,
  "status_id" int NOT NULL
);


-- PAYMENT TABLE

CREATE TABLE "Payment" (
  "payment_id" int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "registration_id" int NOT NULL,
  "amount" decimal(10,2) NOT NULL,
  "payment_date" date NOT NULL,
  "status_id" int NOT NULL
);


-- JUNCTION TABLES

CREATE TABLE "GameReferee" (
  "game_id" int NOT NULL,
  "referee_id" int NOT NULL,

  PRIMARY KEY ("game_id", "referee_id")
);

CREATE TABLE "CoachTeam" (
  "coach_id" int NOT NULL,
  "team_id" int NOT NULL,

  PRIMARY KEY ("coach_id", "team_id")
);


-- INDEXES

CREATE UNIQUE INDEX "uq_gym_schedule"
ON "Game" ("gym_id", "game_date", "game_time");

CREATE UNIQUE INDEX "uq_player_season"
ON "Registration" ("player_id", "season_id");


-- FOREIGN KEYS

ALTER TABLE "Player"
ADD FOREIGN KEY ("guardian_id")
REFERENCES "Guardian" ("guardian_id");

ALTER TABLE "Team"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

ALTER TABLE "Game"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

ALTER TABLE "Game"
ADD FOREIGN KEY ("gym_id")
REFERENCES "Gym" ("gym_id");

ALTER TABLE "Game"
ADD FOREIGN KEY ("home_team_id")
REFERENCES "Team" ("team_id");

ALTER TABLE "Game"
ADD FOREIGN KEY ("away_team_id")
REFERENCES "Team" ("team_id");

ALTER TABLE "Registration"
ADD FOREIGN KEY ("player_id")
REFERENCES "Player" ("player_id");

ALTER TABLE "Registration"
ADD FOREIGN KEY ("team_id")
REFERENCES "Team" ("team_id");

ALTER TABLE "Registration"
ADD FOREIGN KEY ("season_id")
REFERENCES "Season" ("season_id");

ALTER TABLE "Registration"
ADD FOREIGN KEY ("status_id")
REFERENCES "RegistrationStatus" ("status_id");

ALTER TABLE "Payment"
ADD FOREIGN KEY ("registration_id")
REFERENCES "Registration" ("registration_id");

ALTER TABLE "Payment"
ADD FOREIGN KEY ("status_id")
REFERENCES "PaymentStatus" ("status_id");

ALTER TABLE "GameReferee"
ADD FOREIGN KEY ("game_id")
REFERENCES "Game" ("game_id");

ALTER TABLE "GameReferee"
ADD FOREIGN KEY ("referee_id")
REFERENCES "Referee" ("referee_id");

ALTER TABLE "CoachTeam"
ADD FOREIGN KEY ("coach_id")
REFERENCES "Coach" ("coach_id");

ALTER TABLE "CoachTeam"
ADD FOREIGN KEY ("team_id")
REFERENCES "Team" ("team_id");
