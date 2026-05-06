-- =============================================================================
-- 002_seed_data.sql
-- Sample data for the Youth Basketball League database.
-- =============================================================================


-- PAYMENT STATUS

INSERT INTO "PaymentStatus" ("status_name") VALUES
('Pending'),
('Completed'),
('Refunded'),
('Failed'),
('Waived');


-- REGISTRATION STATUS

INSERT INTO "RegistrationStatus" ("status_name") VALUES
('Active'),
('Waitlisted'),
('Withdrawn'),
('Pending Review'),
('Inactive');


-- SEASONS

INSERT INTO "Season" ("season_name", "start_date", "end_date") VALUES
('Spring 2026', '2026-03-02', '2026-05-30'),
('Summer 2026', '2026-06-15', '2026-08-08'),
('Fall 2026', '2026-09-07', '2026-11-21'),
('Winter 2027', '2027-01-10', '2027-02-28'),
('Spring 2027', '2027-03-01', '2027-05-29');


-- GYMS

INSERT INTO "Gym" ("gym_name", "address", "city", "capacity") VALUES
('Fullerton Community Center Gym', '340 W Commonwealth Ave', 'Fullerton', 275),
('Independence Park Gym', '801 W Valencia Dr', 'Fullerton', 220),
('Brea Sports Park Gym', '3333 E Birch St', 'Brea', 300),
('Anaheim Downtown Youth Center', '250 E Center St', 'Anaheim', 260),
('Placentia Champions Gym', '143 S Bradford Ave', 'Placentia', 240);


-- GUARDIANS

INSERT INTO "Guardian" ("first_name", "last_name", "email", "phone") VALUES
('Maribel', 'Torres', 'maribel.torres26@gmail.com', '714-555-0142'),
('Kevin', 'Nguyen', 'kevin.nguyen.oc@gmail.com', '714-555-0188'),
('Andrea', 'Williams', 'andrea.williams.family@gmail.com', '657-555-0119'),
('Jose', 'Ramirez', 'jramirez.home@gmail.com', '714-555-0164'),
('Lena', 'Park', 'lena.park22@gmail.com', '562-555-0197'),
('Samuel', 'Chen', 'samuel.chen.fam@gmail.com', '714-555-0213'),
('Diana', 'Garcia', 'diana.garcia.oc@gmail.com', '657-555-0231'),
('Marcus', 'Lee', 'marcus.lee.hoops@gmail.com', '949-555-0246');


-- PLAYERS

INSERT INTO "Player" ("first_name", "last_name", "date_of_birth", "guardian_id") VALUES
('Bronny', 'Torres', '2016-05-11', 1),
('Jaylen', 'Nguyen', '2014-08-24', 2),
('Steph', 'Williams', '2016-02-03', 3),
('Devin', 'Ramirez', '2012-10-19', 4),
('Luka', 'Park', '2014-12-07', 5),
('Kyrie', 'Chen', '2015-03-22', 6),
('Zion', 'Garcia', '2013-07-04', 7),
('Damian', 'Lee', '2013-01-15', 8);


-- TEAMS

INSERT INTO "Team" ("team_name", "division", "season_id") VALUES
('Lakers Jr.', '10U', 1),
('Celtics Select', '12U', 1),
('Bulls Academy', '10U', 1),
('Heat Elite', '14U', 1),
('Warriors Youth', '14U', 1),
('Nets Select', '12U', 1),
('Suns Youth', '10U', 2),
('Bucks Jr.', '12U', 2);


-- COACHES

INSERT INTO "Coach" ("first_name", "last_name", "email", "phone") VALUES
('Marcus', 'Reed', 'coach.reed@gmail.com', '714-555-0210'),
('Tyler', 'Brooks', 'tylerbrooks.hoops@gmail.com', '714-555-0221'),
('Rafael', 'Santos', 'rsantosbasketball@gmail.com', '657-555-0204'),
('Derek', 'Miller', 'derek.miller.coach@gmail.com', '714-555-0233'),
('Anthony', 'Flores', 'afloresyouthsports@gmail.com', '562-555-0248');


-- REFEREES

INSERT INTO "Referee" ("first_name", "last_name", "email", "certification_level") VALUES
('Brian', 'Coleman', 'brian.coleman.ref@gmail.com', 'Level 1'),
('Sam', 'Patel', 'sam.patel.ref@gmail.com', 'Level 2'),
('Victor', 'Hernandez', 'victor.hernandez.ref@gmail.com', 'Certified'),
('Owen', 'Foster', 'owen.foster.ref@gmail.com', 'Level 1'),
('Malik', 'Johnson', 'malik.johnson.ref@gmail.com', 'Certified');


-- GAMES

INSERT INTO "Game" ("season_id", "gym_id", "home_team_id", "away_team_id", "game_date", "game_time", "home_score", "away_score") VALUES
(1, 1, 1, 3, '2026-03-14', '09:30:00', 38, 34),
(1, 2, 3, 1, '2026-03-28', '09:30:00', 31, 40),
(1, 3, 2, 6, '2026-03-14', '11:00:00', 45, 41),
(1, 4, 6, 2, '2026-03-28', '11:00:00', 37, 43),
(1, 5, 4, 5, '2026-03-21', '10:15:00', 52, 49),
(1, 1, 5, 4, '2026-04-04', '10:15:00', 55, 50);


-- REGISTRATIONS

INSERT INTO "Registration" ("player_id", "team_id", "season_id", "registration_date", "status_id") VALUES
(1, 1, 1, '2026-02-10', 1),
(2, 2, 1, '2026-02-11', 1),
(3, 3, 1, '2026-02-12', 1),
(4, 4, 1, '2026-02-13', 1),
(5, 6, 1, '2026-02-14', 1),
(6, 2, 1, '2026-02-15', 2),
(7, 5, 1, '2026-02-16', 1),
(8, 4, 1, '2026-02-17', 4);


-- PAYMENTS

INSERT INTO "Payment" ("registration_id", "amount", "payment_date", "status_id") VALUES
(1, 140.00, '2026-02-10', 2),
(2, 155.00, '2026-02-11', 2),
(3, 140.00, '2026-02-12', 2),
(4, 165.00, '2026-02-13', 2),
(5, 155.00, '2026-02-14', 1),
(6, 155.00, '2026-02-15', 4),
(7, 165.00, '2026-02-16', 2),
(8, 165.00, '2026-02-17', 1);


-- GAME REFEREES

INSERT INTO "GameReferee" ("game_id", "referee_id") VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 3),
(3, 5),
(4, 1),
(4, 2),
(5, 4),
(6, 5);


-- COACH TEAMS

INSERT INTO "CoachTeam" ("coach_id", "team_id") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(2, 6),
(1, 7),
(3, 8);
