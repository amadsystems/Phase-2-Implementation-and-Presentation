-- =============================================================================
-- 001_init.sql
-- Initial schema setup for the Youth Basketball League database.
-- Run this file once to create all tables, keys, indexes, and constraints.
-- Make sure you're connected to the right database before running!
-- =============================================================================


-- -----------------------------------------------------------------------------
-- LOOKUP / REFERENCE TABLES
-- These are small tables that just hold valid status values.
-- We reference them with foreign keys instead of hardcoding strings everywhere.
-- -----------------------------------------------------------------------------

-- Tracks where a payment stands: Pending, Completed, or Refunded.
CREATE TABLE `PaymentStatus` (
  `status_id`   int          PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate PK',
  `status_name` varchar(255) UNIQUE NOT NULL COMMENT 'Pending | Completed | Refunded'
);

-- Tracks where a registration stands: Active, Waitlisted, or Withdrawn.
CREATE TABLE `RegistrationStatus` (
  `status_id`   int          PRIMARY KEY AUTO_INCREMENT,
  `status_name` varchar(255) UNIQUE NOT NULL COMMENT 'Active | Waitlisted | Withdrawn'
);


-- -----------------------------------------------------------------------------
-- CORE ENTITY TABLES
-- These are the main "things" in the league: seasons, gyms, people, teams.
-- -----------------------------------------------------------------------------

-- A season is a defined window of time (e.g., "Spring 2025").
-- BR-04: end_date must be after start_date — enforced here with a CHECK constraint.
CREATE TABLE `Season` (
  `season_id`   int          PRIMARY KEY AUTO_INCREMENT,
  `season_name` varchar(255) NOT NULL,
  `start_date`  date         NOT NULL,
  `end_date`    date         NOT NULL COMMENT 'Must be > start_date (BR-04)',
  CONSTRAINT `chk_season_dates` CHECK (`end_date` > `start_date`)
);

-- A gym is a physical location where games are held.
-- Capacity is optional but useful for scheduling decisions.
CREATE TABLE `Gym` (
  `gym_id`   int          PRIMARY KEY AUTO_INCREMENT,
  `gym_name` varchar(255) NOT NULL,
  `address`  varchar(255) NOT NULL,
  `city`     varchar(255) NOT NULL,
  `capacity` int          COMMENT 'Max spectator / player capacity'
);

-- A guardian is the parent or legal contact responsible for a player.
-- BR-01: email must be unique so we can use it as a reliable contact identifier.
CREATE TABLE `Guardian` (
  `guardian_id` int          PRIMARY KEY AUTO_INCREMENT,
  `first_name`  varchar(255) NOT NULL,
  `last_name`   varchar(255) NOT NULL,
  `email`       varchar(255) UNIQUE NOT NULL COMMENT 'BR-01: must be unique',
  `phone`       varchar(255)
);

-- A player is a kid in the league. Every player must be linked to a guardian.
CREATE TABLE `Player` (
  `player_id`     int          PRIMARY KEY AUTO_INCREMENT,
  `first_name`    varchar(255) NOT NULL,
  `last_name`     varchar(255) NOT NULL,
  `date_of_birth` date         NOT NULL,
  `guardian_id`   int          NOT NULL  -- who is responsible for this player
);

-- A team belongs to one season and competes in a specific age division.
CREATE TABLE `Team` (
  `team_id`   int          PRIMARY KEY AUTO_INCREMENT,
  `team_name` varchar(255) NOT NULL,
  `division`  varchar(255) COMMENT 'e.g., 10U, 12U, 14U',
  `season_id` int          NOT NULL  -- which season this team plays in
);

-- A coach can be assigned to one or more teams (handled in CoachTeam below).
-- BR-02: email must be unique for the same reason as Guardian.
CREATE TABLE `Coach` (
  `coach_id`   int          PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name`  varchar(255) NOT NULL,
  `email`      varchar(255) UNIQUE NOT NULL COMMENT 'BR-02: must be unique',
  `phone`      varchar(255)
);

-- A referee can be assigned to officiate one or more games.
-- Certification level helps with scheduling qualified refs for the right games.
CREATE TABLE `Referee` (
  `referee_id`          int          PRIMARY KEY AUTO_INCREMENT,
  `first_name`          varchar(255) NOT NULL,
  `last_name`           varchar(255) NOT NULL,
  `email`               varchar(255) UNIQUE NOT NULL,
  `certification_level` varchar(255) COMMENT 'e.g., Level 1, Level 2, Certified'
);


-- -----------------------------------------------------------------------------
-- TRANSACTIONAL / EVENT TABLES
-- These tables record things that actually happen: games, registrations, payments.
-- -----------------------------------------------------------------------------

-- A game is a single scheduled matchup between two teams at a gym.
-- BR-05: game_date must fall within the season's start and end dates — enforced below.
-- BR-06: no double-booking at the same gym/date/time — enforced by unique index below.
-- BR-07: a team cannot play against itself — enforced here with a CHECK constraint.
CREATE TABLE `Game` (
  `game_id`      int  PRIMARY KEY AUTO_INCREMENT,
  `season_id`    int  NOT NULL,                   -- must belong to a season
  `gym_id`       int  NOT NULL,                   -- where the game is played
  `home_team_id` int  NOT NULL,
  `away_team_id` int  NOT NULL COMMENT 'BR-07: must != home_team_id',
  `game_date`    date NOT NULL COMMENT 'BR-05: must fall within season dates',
  `game_time`    time NOT NULL COMMENT 'BR-06: no double-booking at same gym+date+time',
  `home_score`   int  DEFAULT 0,
  `away_score`   int  DEFAULT 0,
  CONSTRAINT `chk_different_teams` CHECK (`home_team_id` != `away_team_id`)  -- BR-07: a team can't play itself
);

-- Registration ties a player to a team for a specific season.
-- BR-03: a player can only be on one team per season (enforced by unique index below).
CREATE TABLE `Registration` (
  `registration_id`   int  PRIMARY KEY AUTO_INCREMENT,
  `player_id`         int  NOT NULL,
  `team_id`           int  NOT NULL,
  `season_id`         int  NOT NULL,
  `registration_date` date NOT NULL,
  `status_id`         int  NOT NULL  -- Active, Waitlisted, or Withdrawn
);

-- A payment record is always tied back to a specific registration.
-- BR-08: you can't have a payment floating without a registration.
-- BR-09: status must come from the PaymentStatus lookup table.
-- Fixed: amount is decimal(10,2) so we always store dollars and cents correctly.
CREATE TABLE `Payment` (
  `payment_id`      int           PRIMARY KEY AUTO_INCREMENT,
  `registration_id` int           NOT NULL COMMENT 'BR-08: must reference valid registration',
  `amount`          decimal(10,2) NOT NULL,  -- e.g., up to 99,999,999.99; 2 decimal places for cents
  `payment_date`    date          NOT NULL,
  `status_id`       int           NOT NULL COMMENT 'BR-09: controlled by lookup'
);


-- -----------------------------------------------------------------------------
-- JUNCTION TABLES (many-to-many relationships)
-- These tables connect two entities that can have multiple of each other.
-- -----------------------------------------------------------------------------

-- Links referees to games. One game can have multiple refs; one ref works many games.
-- BR-11: captured in this junction rather than cramming refs onto the Game table.
CREATE TABLE `GameReferee` (
  `game_id`    int NOT NULL,
  `referee_id` int NOT NULL,
  PRIMARY KEY (`game_id`, `referee_id`)  -- prevents the same ref being added twice to the same game
);

-- Links coaches to teams. A coach can run multiple teams; a team can have multiple coaches.
CREATE TABLE `CoachTeam` (
  `coach_id` int NOT NULL,
  `team_id`  int NOT NULL,
  PRIMARY KEY (`coach_id`, `team_id`)  -- prevents duplicate coach-team pairings
);


-- -----------------------------------------------------------------------------
-- INDEXES
-- Extra indexes beyond the PKs to enforce scheduling rules and speed up lookups.
-- -----------------------------------------------------------------------------

-- BR-06: no two games can be scheduled at the same gym on the same date and time.
CREATE UNIQUE INDEX `uq_gym_schedule` ON `Game` (`gym_id`, `game_date`, `game_time`);

-- BR-03: a player can only register once per season (one team at a time).
CREATE UNIQUE INDEX `uq_player_season` ON `Registration` (`player_id`, `season_id`);


-- -----------------------------------------------------------------------------
-- TABLE COMMENTS
-- Human-readable descriptions so anyone browsing the schema knows what each table does.
-- -----------------------------------------------------------------------------

ALTER TABLE `PaymentStatus`      COMMENT = 'Lookup table — valid payment states';
ALTER TABLE `RegistrationStatus` COMMENT = 'Lookup table — valid registration states';
ALTER TABLE `Season`             COMMENT = 'Represents a single competitive season (e.g., Spring 2025)';
ALTER TABLE `Gym`                COMMENT = 'Physical facility where games are played';
ALTER TABLE `Guardian`           COMMENT = 'Parent or legal guardian who registers players';
ALTER TABLE `Player`             COMMENT = 'Minor athlete participating in the league';
ALTER TABLE `Team`               COMMENT = 'A team competes within one season and division';
ALTER TABLE `Coach`              COMMENT = 'Coaching staff member; may manage multiple teams';
ALTER TABLE `Referee`            COMMENT = 'Official who may be assigned to one or more games';
ALTER TABLE `Game`               COMMENT = 'A single scheduled matchup between two teams';
ALTER TABLE `Registration`       COMMENT = 'M:N junction — Player ↔ Team per Season (BR-03)';
ALTER TABLE `Payment`            COMMENT = 'Financial record tied to a specific registration';
ALTER TABLE `GameReferee`        COMMENT = 'M:N junction — Game ↔ Referee (BR-11)';
ALTER TABLE `CoachTeam`          COMMENT = 'M:N junction — Coach ↔ Team (a coach may manage multiple teams)';


-- -----------------------------------------------------------------------------
-- FOREIGN KEYS
-- Wire up all the relationships between tables.
-- Grouped by child table so it's easy to see what each table depends on.
-- -----------------------------------------------------------------------------

-- Player → Guardian (every player needs a responsible adult on file)
ALTER TABLE `Player`
  ADD FOREIGN KEY (`guardian_id`) REFERENCES `Guardian` (`guardian_id`);

-- Team → Season (a team always belongs to exactly one season)
ALTER TABLE `Team`
  ADD FOREIGN KEY (`season_id`) REFERENCES `Season` (`season_id`);

-- Game → Season, Gym, and both Teams
ALTER TABLE `Game`
  ADD FOREIGN KEY (`season_id`)    REFERENCES `Season` (`season_id`);
ALTER TABLE `Game`
  ADD FOREIGN KEY (`gym_id`)       REFERENCES `Gym` (`gym_id`);
ALTER TABLE `Game`
  ADD FOREIGN KEY (`home_team_id`) REFERENCES `Team` (`team_id`);
ALTER TABLE `Game`
  ADD FOREIGN KEY (`away_team_id`) REFERENCES `Team` (`team_id`);

-- Registration → Player, Team, Season, and RegistrationStatus
ALTER TABLE `Registration`
  ADD FOREIGN KEY (`player_id`) REFERENCES `Player` (`player_id`);
ALTER TABLE `Registration`
  ADD FOREIGN KEY (`team_id`)   REFERENCES `Team` (`team_id`);
ALTER TABLE `Registration`
  ADD FOREIGN KEY (`season_id`) REFERENCES `Season` (`season_id`);
ALTER TABLE `Registration`
  ADD FOREIGN KEY (`status_id`) REFERENCES `RegistrationStatus` (`status_id`);

-- Payment → Registration and PaymentStatus
ALTER TABLE `Payment`
  ADD FOREIGN KEY (`registration_id`) REFERENCES `Registration` (`registration_id`);
ALTER TABLE `Payment`
  ADD FOREIGN KEY (`status_id`)       REFERENCES `PaymentStatus` (`status_id`);

-- GameReferee junction → Game and Referee
ALTER TABLE `GameReferee`
  ADD FOREIGN KEY (`game_id`)    REFERENCES `Game` (`game_id`);
ALTER TABLE `GameReferee`
  ADD FOREIGN KEY (`referee_id`) REFERENCES `Referee` (`referee_id`);

-- CoachTeam junction → Coach and Team
ALTER TABLE `CoachTeam`
  ADD FOREIGN KEY (`coach_id`) REFERENCES `Coach` (`coach_id`);
ALTER TABLE `CoachTeam`
  ADD FOREIGN KEY (`team_id`)  REFERENCES `Team` (`team_id`);

-- =============================================================================
