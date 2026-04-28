CREATE TABLE `PaymentStatus` (
  `status_id` int PRIMARY KEY AUTO_INCREMENT COMMENT 'Surrogate PK',
  `status_name` varchar(255) UNIQUE NOT NULL COMMENT 'Pending | Completed | Refunded'
);

CREATE TABLE `RegistrationStatus` (
  `status_id` int PRIMARY KEY AUTO_INCREMENT,
  `status_name` varchar(255) UNIQUE NOT NULL COMMENT 'Active | Waitlisted | Withdrawn'
);

CREATE TABLE `Season` (
  `season_id` int PRIMARY KEY AUTO_INCREMENT,
  `season_name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL COMMENT 'Must be > start_date (BR-04)'
);

CREATE TABLE `Gym` (
  `gym_id` int PRIMARY KEY AUTO_INCREMENT,
  `gym_name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `capacity` int COMMENT 'Max spectator / player capacity'
);

CREATE TABLE `Guardian` (
  `guardian_id` int PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL COMMENT 'BR-01: must be unique',
  `phone` varchar(255)
);

CREATE TABLE `Player` (
  `player_id` int PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `guardian_id` int NOT NULL
);

CREATE TABLE `Team` (
  `team_id` int PRIMARY KEY AUTO_INCREMENT,
  `team_name` varchar(255) NOT NULL,
  `division` varchar(255) COMMENT 'e.g., 10U, 12U, 14U',
  `season_id` int NOT NULL
);

CREATE TABLE `Coach` (
  `coach_id` int PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL COMMENT 'BR-02: must be unique',
  `phone` varchar(255)
);

CREATE TABLE `Referee` (
  `referee_id` int PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `certification_level` varchar(255) COMMENT 'e.g., Level 1, Level 2, Certified'
);

CREATE TABLE `Game` (
  `game_id` int PRIMARY KEY AUTO_INCREMENT,
  `season_id` int NOT NULL,
  `gym_id` int NOT NULL,
  `home_team_id` int NOT NULL,
  `away_team_id` int NOT NULL COMMENT 'BR-07: must != home_team_id',
  `game_date` date NOT NULL COMMENT 'BR-05: must fall within season dates',
  `game_time` time NOT NULL COMMENT 'BR-06: no double-booking at same gym+date+time',
  `home_score` int DEFAULT 0,
  `away_score` int DEFAULT 0
);

CREATE TABLE `Registration` (
  `registration_id` int PRIMARY KEY AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `team_id` int NOT NULL,
  `season_id` int NOT NULL,
  `registration_date` date NOT NULL,
  `status_id` int NOT NULL
);

CREATE TABLE `Payment` (
  `payment_id` int PRIMARY KEY AUTO_INCREMENT,
  `registration_id` int NOT NULL COMMENT 'BR-08: must reference valid registration',
  `amount` decimal NOT NULL,
  `payment_date` date NOT NULL,
  `status_id` int NOT NULL COMMENT 'BR-09: controlled by lookup'
);

CREATE TABLE `GameReferee` (
  `game_id` int NOT NULL,
  `referee_id` int NOT NULL,
  PRIMARY KEY (`game_id`, `referee_id`)
);

CREATE TABLE `CoachTeam` (
  `coach_id` int NOT NULL,
  `team_id` int NOT NULL,
  PRIMARY KEY (`coach_id`, `team_id`)
);

CREATE UNIQUE INDEX `uq_gym_schedule` ON `Game` (`gym_id`, `game_date`, `game_time`);

CREATE UNIQUE INDEX `uq_player_season` ON `Registration` (`player_id`, `season_id`);

ALTER TABLE `PaymentStatus` COMMENT = 'Lookup table — valid payment states';

ALTER TABLE `RegistrationStatus` COMMENT = 'Lookup table — valid registration states';

ALTER TABLE `Season` COMMENT = 'Represents a single competitive season (e.g., Spring 2025)';

ALTER TABLE `Gym` COMMENT = 'Physical facility where games are played';

ALTER TABLE `Guardian` COMMENT = 'Parent or legal guardian who registers players';

ALTER TABLE `Player` COMMENT = 'Minor athlete participating in the league';

ALTER TABLE `Team` COMMENT = 'A team competes within one season and division';

ALTER TABLE `Coach` COMMENT = 'Coaching staff member; may manage multiple teams';

ALTER TABLE `Referee` COMMENT = 'Official who may be assigned to one or more games';

ALTER TABLE `Game` COMMENT = 'A single scheduled matchup between two teams';

ALTER TABLE `Registration` COMMENT = 'M:N junction — Player ↔ Team per Season (BR-03)';

ALTER TABLE `Payment` COMMENT = 'Financial record tied to a specific registration';

ALTER TABLE `GameReferee` COMMENT = 'M:N junction — Game ↔ Referee (BR-11)';

ALTER TABLE `CoachTeam` COMMENT = 'M:N junction — Coach ↔ Team (a coach may manage multiple teams)';

ALTER TABLE `Player` ADD FOREIGN KEY (`guardian_id`) REFERENCES `Guardian` (`guardian_id`);

ALTER TABLE `Team` ADD FOREIGN KEY (`season_id`) REFERENCES `Season` (`season_id`);

ALTER TABLE `Game` ADD FOREIGN KEY (`season_id`) REFERENCES `Season` (`season_id`);

ALTER TABLE `Game` ADD FOREIGN KEY (`gym_id`) REFERENCES `Gym` (`gym_id`);

ALTER TABLE `Game` ADD FOREIGN KEY (`home_team_id`) REFERENCES `Team` (`team_id`);

ALTER TABLE `Game` ADD FOREIGN KEY (`away_team_id`) REFERENCES `Team` (`team_id`);

ALTER TABLE `Registration` ADD FOREIGN KEY (`player_id`) REFERENCES `Player` (`player_id`);

ALTER TABLE `Registration` ADD FOREIGN KEY (`team_id`) REFERENCES `Team` (`team_id`);

ALTER TABLE `Registration` ADD FOREIGN KEY (`season_id`) REFERENCES `Season` (`season_id`);

ALTER TABLE `Registration` ADD FOREIGN KEY (`status_id`) REFERENCES `RegistrationStatus` (`status_id`);

ALTER TABLE `Payment` ADD FOREIGN KEY (`registration_id`) REFERENCES `Registration` (`registration_id`);

ALTER TABLE `Payment` ADD FOREIGN KEY (`status_id`) REFERENCES `PaymentStatus` (`status_id`);

ALTER TABLE `GameReferee` ADD FOREIGN KEY (`game_id`) REFERENCES `Game` (`game_id`);

ALTER TABLE `GameReferee` ADD FOREIGN KEY (`referee_id`) REFERENCES `Referee` (`referee_id`);

ALTER TABLE `CoachTeam` ADD FOREIGN KEY (`coach_id`) REFERENCES `Coach` (`coach_id`);

ALTER TABLE `CoachTeam` ADD FOREIGN KEY (`team_id`) REFERENCES `Team` (`team_id`);
