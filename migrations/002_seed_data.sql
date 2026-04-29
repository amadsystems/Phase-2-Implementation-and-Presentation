-- =============================================================================
-- 002_seed_data.sql
-- Sample data for the Youth Basketball League database.
-- Run this AFTER 001_init.sql — all tables must exist before inserting.
--
-- Theme: team and player names are inspired by the NBA.
-- Age divisions are based on the player's age as of the start of each season:
--   10U = born 2016 or later   (turning 9–10 in Spring 2026)
--   12U = born 2014–2015       (turning 11–12 in Spring 2026)
--   14U = born 2012–2013       (turning 13–14 in Spring 2026)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- LOOKUP TABLES
-- Seed these first — everything else references them.
-- -----------------------------------------------------------------------------

-- Valid payment states. status_id values are used throughout the Payment table.
INSERT INTO `PaymentStatus` (`status_name`) VALUES
  ('Pending'),         -- status_id = 1: payment submitted but not yet processed
  ('Completed'),       -- status_id = 2: payment successfully received
  ('Refunded'),        -- status_id = 3: payment was reversed
  ('Failed'),          -- status_id = 4: card declined or bank error
  ('Waived');          -- status_id = 5: fee forgiven (financial hardship, etc.)

-- Valid registration states. status_id values are used throughout the Registration table.
INSERT INTO `RegistrationStatus` (`status_name`) VALUES
  ('Active'),          -- status_id = 1: player is confirmed on the roster
  ('Waitlisted'),      -- status_id = 2: team is full, player is in the queue
  ('Withdrawn'),       -- status_id = 3: player or guardian cancelled
  ('Pending Review'),  -- status_id = 4: registration flagged for admin review
  ('Inactive');        -- status_id = 5: season ended or player aged out


-- -----------------------------------------------------------------------------
-- SEASONS
-- Five seasons from Spring 2026 through Spring 2027.
-- BR-04 (end_date > start_date) is satisfied for every row.
-- -----------------------------------------------------------------------------

INSERT INTO `Season` (`season_name`, `start_date`, `end_date`) VALUES
  ('Spring 2026', '2026-03-02', '2026-05-30'),  -- season_id = 1
  ('Summer 2026', '2026-06-15', '2026-08-08'),  -- season_id = 2
  ('Fall 2026',   '2026-09-07', '2026-11-21'),  -- season_id = 3
  ('Winter 2027', '2027-01-10', '2027-02-28'),  -- season_id = 4
  ('Spring 2027', '2027-03-01', '2027-05-29');  -- season_id = 5


-- -----------------------------------------------------------------------------
-- GYMS
-- Five real-area facilities in Orange County, CA.
-- -----------------------------------------------------------------------------

INSERT INTO `Gym` (`gym_name`, `address`, `city`, `capacity`) VALUES
  ('Fullerton Community Center Gym', '340 W Commonwealth Ave', 'Fullerton', 275),  -- gym_id = 1
  ('Independence Park Gym',          '801 W Valencia Dr',      'Fullerton', 220),  -- gym_id = 2
  ('Brea Sports Park Gym',           '3333 E Birch St',        'Brea',      300),  -- gym_id = 3
  ('Anaheim Downtown Youth Center',  '250 E Center St',        'Anaheim',   260),  -- gym_id = 4
  ('Placentia Champions Gym',        '143 S Bradford Ave',     'Placentia', 240);  -- gym_id = 5


-- -----------------------------------------------------------------------------
-- GUARDIANS
-- Parents and legal guardians who registered their kids.
-- BR-01: every email is unique.
-- -----------------------------------------------------------------------------

INSERT INTO `Guardian` (`first_name`, `last_name`, `email`, `phone`) VALUES
  ('Maribel', 'Torres',   'maribel.torres26@gmail.com',       '714-555-0142'),  -- guardian_id = 1
  ('Kevin',   'Nguyen',   'kevin.nguyen.oc@gmail.com',        '714-555-0188'),  -- guardian_id = 2
  ('Andrea',  'Williams', 'andrea.williams.family@gmail.com', '657-555-0119'),  -- guardian_id = 3
  ('Jose',    'Ramirez',  'jramirez.home@gmail.com',          '714-555-0164'),  -- guardian_id = 4
  ('Lena',    'Park',     'lena.park22@gmail.com',            '562-555-0197'),  -- guardian_id = 5
  ('Samuel',  'Chen',     'samuel.chen.fam@gmail.com',        '714-555-0213'),  -- guardian_id = 6
  ('Diana',   'Garcia',   'diana.garcia.oc@gmail.com',        '657-555-0231'),  -- guardian_id = 7
  ('Marcus',  'Lee',      'marcus.lee.hoops@gmail.com',       '949-555-0246');  -- guardian_id = 8


-- -----------------------------------------------------------------------------
-- PLAYERS
-- Kids in the league. First names are inspired by NBA players.
-- Date of birth is chosen so each player fits their assigned team's division
-- based on their age at the start of the Spring 2026 season.
-- NOTE: eligibility_status is NOT a column in this schema —
--       registration status is tracked in the Registration table instead.
-- -----------------------------------------------------------------------------

INSERT INTO `Player` (`first_name`, `last_name`, `date_of_birth`, `guardian_id`) VALUES
  ('Bronny',  'Torres',   '2016-05-11', 1),  -- player_id = 1 | age 9  in Spring 2026 → 10U
  ('Jaylen',  'Nguyen',   '2014-08-24', 2),  -- player_id = 2 | age 11 in Spring 2026 → 12U
  ('Steph',   'Williams', '2016-02-03', 3),  -- player_id = 3 | age 10 in Spring 2026 → 10U
  ('Devin',   'Ramirez',  '2012-10-19', 4),  -- player_id = 4 | age 13 in Spring 2026 → 14U
  ('Luka',    'Park',     '2014-12-07', 5),  -- player_id = 5 | age 11 in Spring 2026 → 12U
  ('Kyrie',   'Chen',     '2015-03-22', 6),  -- player_id = 6 | age 11 in Spring 2026 → 12U
  ('Zion',    'Garcia',   '2013-07-04', 7),  -- player_id = 7 | age 12 in Spring 2026 → 14U (plays up)
  ('Damian',  'Lee',      '2013-01-15', 8);  -- player_id = 8 | age 13 in Spring 2026 → 14U


-- -----------------------------------------------------------------------------
-- TEAMS
-- NBA-inspired youth team names.
-- Six teams play in Spring 2026 (season 1) across all three divisions.
-- Two additional teams are seeded in Summer 2026 (season 2) for future games.
-- -----------------------------------------------------------------------------

INSERT INTO `Team` (`team_name`, `division`, `season_id`) VALUES
  ('Lakers Jr.',      '10U', 1),  -- team_id = 1 | Spring 2026
  ('Celtics Select',  '12U', 1),  -- team_id = 2 | Spring 2026
  ('Bulls Academy',   '10U', 1),  -- team_id = 3 | Spring 2026
  ('Heat Elite',      '14U', 1),  -- team_id = 4 | Spring 2026
  ('Warriors Youth',  '14U', 1),  -- team_id = 5 | Spring 2026
  ('Nets Select',     '12U', 1),  -- team_id = 6 | Spring 2026
  ('Suns Youth',      '10U', 2),  -- team_id = 7 | Summer 2026
  ('Bucks Jr.',       '12U', 2);  -- team_id = 8 | Summer 2026


-- -----------------------------------------------------------------------------
-- COACHES
-- Five coaches. Some are assigned to multiple teams across seasons (see CoachTeam).
-- BR-02: every email is unique.
-- -----------------------------------------------------------------------------

INSERT INTO `Coach` (`first_name`, `last_name`, `email`, `phone`) VALUES
  ('Marcus',  'Reed',   'coach.reed@gmail.com',          '714-555-0210'),  -- coach_id = 1
  ('Tyler',   'Brooks', 'tylerbrooks.hoops@gmail.com',   '714-555-0221'),  -- coach_id = 2
  ('Rafael',  'Santos', 'rsantosbasketball@gmail.com',   '657-555-0204'),  -- coach_id = 3
  ('Derek',   'Miller', 'derek.miller.coach@gmail.com',  '714-555-0233'),  -- coach_id = 4
  ('Anthony', 'Flores', 'afloresyouthsports@gmail.com',  '562-555-0248');  -- coach_id = 5


-- -----------------------------------------------------------------------------
-- REFEREES
-- Five officials with a mix of certification levels.
-- -----------------------------------------------------------------------------

INSERT INTO `Referee` (`first_name`, `last_name`, `email`, `certification_level`) VALUES
  ('Brian',   'Coleman',   'brian.coleman.ref@gmail.com',   'Level 1'),   -- referee_id = 1
  ('Sam',     'Patel',     'sam.patel.ref@gmail.com',       'Level 2'),   -- referee_id = 2
  ('Victor',  'Hernandez', 'victor.hernandez.ref@gmail.com','Certified'), -- referee_id = 3
  ('Owen',    'Foster',    'owen.foster.ref@gmail.com',     'Level 1'),   -- referee_id = 4
  ('Malik',   'Johnson',   'malik.johnson.ref@gmail.com',   'Certified'); -- referee_id = 5


-- -----------------------------------------------------------------------------
-- GAMES
-- Six games scheduled across Spring 2026 (season 1).
-- Matchups stay within the same division — 10U vs 10U, 12U vs 12U, 14U vs 14U.
-- BR-05: all game_dates fall within the Spring 2026 window (2026-03-02 to 2026-05-30).
-- BR-06: no gym is double-booked on the same date and time (uq_gym_schedule index).
-- BR-07: home_team_id != away_team_id (chk_different_teams constraint).
-- Home/away is flipped for rematches to give both teams a home game.
-- -----------------------------------------------------------------------------

INSERT INTO `Game` (`season_id`, `gym_id`, `home_team_id`, `away_team_id`, `game_date`, `game_time`, `home_score`, `away_score`) VALUES
  -- 10U: Lakers Jr. vs Bulls Academy
  (1, 1, 1, 3, '2026-03-14', '09:30:00', 38, 34),  -- game_id = 1 | Lakers Jr. win
  (1, 2, 3, 1, '2026-03-28', '09:30:00', 31, 40),  -- game_id = 2 | rematch — Bulls host, Lakers win again

  -- 12U: Celtics Select vs Nets Select
  (1, 3, 2, 6, '2026-03-14', '11:00:00', 45, 41),  -- game_id = 3 | Celtics Select win
  (1, 4, 6, 2, '2026-03-28', '11:00:00', 37, 43),  -- game_id = 4 | rematch — Nets host, Celtics win again

  -- 14U: Heat Elite vs Warriors Youth
  (1, 5, 4, 5, '2026-03-21', '10:15:00', 52, 49),  -- game_id = 5 | Heat Elite win
  (1, 1, 5, 4, '2026-04-04', '10:15:00', 55, 50);  -- game_id = 6 | rematch — Warriors host and win


-- -----------------------------------------------------------------------------
-- REGISTRATIONS
-- Each player is registered to one team for their season.
-- Division assignments match player ages (see Player comments above).
-- BR-03: the uq_player_season index prevents any player from appearing
--        in two different teams within the same season.
-- -----------------------------------------------------------------------------

INSERT INTO `Registration` (`player_id`, `team_id`, `season_id`, `registration_date`, `status_id`) VALUES
  (1, 1, 1, '2026-02-10', 1),  -- registration_id = 1 | Bronny Torres → Lakers Jr.     (10U) Active
  (2, 2, 1, '2026-02-11', 1),  -- registration_id = 2 | Jaylen Nguyen → Celtics Select  (12U) Active
  (3, 3, 1, '2026-02-12', 1),  -- registration_id = 3 | Steph Williams → Bulls Academy  (10U) Active
  (4, 4, 1, '2026-02-13', 1),  -- registration_id = 4 | Devin Ramirez → Heat Elite      (14U) Active
  (5, 6, 1, '2026-02-14', 1),  -- registration_id = 5 | Luka Park → Nets Select         (12U) Active
  (6, 2, 1, '2026-02-15', 2),  -- registration_id = 6 | Kyrie Chen → Celtics Select     (12U) Waitlisted (roster full)
  (7, 5, 1, '2026-02-16', 1),  -- registration_id = 7 | Zion Garcia → Warriors Youth    (14U) Active
  (8, 4, 1, '2026-02-17', 4);  -- registration_id = 8 | Damian Lee → Heat Elite         (14U) Pending Review


-- -----------------------------------------------------------------------------
-- PAYMENTS
-- One payment record per registration.
-- 14U fees are slightly higher — longer season, more gym time.
-- Statuses reflect a realistic mix: most paid, one pending, one failed.
-- -----------------------------------------------------------------------------

INSERT INTO `Payment` (`registration_id`, `amount`, `payment_date`, `status_id`) VALUES
  (1, 140.00, '2026-02-10', 2),  -- payment_id = 1 | Bronny Torres   — Completed
  (2, 155.00, '2026-02-11', 2),  -- payment_id = 2 | Jaylen Nguyen   — Completed
  (3, 140.00, '2026-02-12', 2),  -- payment_id = 3 | Steph Williams  — Completed
  (4, 165.00, '2026-02-13', 2),  -- payment_id = 4 | Devin Ramirez   — Completed
  (5, 155.00, '2026-02-14', 1),  -- payment_id = 5 | Luka Park       — Pending (just registered)
  (6, 155.00, '2026-02-15', 4),  -- payment_id = 6 | Kyrie Chen      — Failed (card declined; waitlisted anyway)
  (7, 165.00, '2026-02-16', 2),  -- payment_id = 7 | Zion Garcia     — Completed
  (8, 165.00, '2026-02-17', 1);  -- payment_id = 8 | Damian Lee      — Pending (held while registration is reviewed)


-- -----------------------------------------------------------------------------
-- GAME REFEREES
-- Assigns officials to games. Most games have two refs per standard league rules.
-- BR-11: the junction table keeps this relationship clean.
-- The composite PK prevents the same ref from being double-assigned to one game.
-- -----------------------------------------------------------------------------

INSERT INTO `GameReferee` (`game_id`, `referee_id`) VALUES
  (1, 1),  -- Game 1 (Lakers Jr. vs Bulls Academy)    : Brian Coleman
  (1, 2),  -- Game 1                                  : Sam Patel
  (2, 3),  -- Game 2 (rematch — Bulls host)           : Victor Hernandez
  (2, 4),  -- Game 2                                  : Owen Foster
  (3, 3),  -- Game 3 (Celtics Select vs Nets Select)  : Victor Hernandez
  (3, 5),  -- Game 3                                  : Malik Johnson
  (4, 1),  -- Game 4 (rematch — Nets host)            : Brian Coleman
  (4, 2),  -- Game 4                                  : Sam Patel
  (5, 4),  -- Game 5 (Heat Elite vs Warriors Youth)   : Owen Foster
  (6, 5);  -- Game 6 (rematch — Warriors host)        : Malik Johnson


-- -----------------------------------------------------------------------------
-- COACH TEAMS
-- Links coaches to the teams they manage.
-- NOTE: season_id is NOT a column in CoachTeam — season context comes from
--       the Team table itself (each team already has a season_id).
-- Coach Reed and Coach Brooks return to coach new teams in Summer 2026.
-- -----------------------------------------------------------------------------

INSERT INTO `CoachTeam` (`coach_id`, `team_id`) VALUES
  (1, 1),  -- Marcus Reed    → Lakers Jr.     (Spring 2026)
  (2, 2),  -- Tyler Brooks   → Celtics Select (Spring 2026)
  (3, 3),  -- Rafael Santos  → Bulls Academy  (Spring 2026)
  (4, 4),  -- Derek Miller   → Heat Elite     (Spring 2026)
  (5, 5),  -- Anthony Flores → Warriors Youth (Spring 2026)
  (2, 6),  -- Tyler Brooks   → Nets Select    (Spring 2026) — coaches both 12U teams
  (1, 7),  -- Marcus Reed    → Suns Youth     (Summer 2026) — back for the next season
  (3, 8);  -- Rafael Santos  → Bucks Jr.      (Summer 2026) — back for the next season

-- =============================================================================
