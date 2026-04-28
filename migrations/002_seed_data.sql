
-- 002_seed_data.sql
-- Sample data for the youth basketball league database.

INSERT INTO "PaymentStatus" ("status_name") VALUES
('Pending'),
('Completed'),
('Refunded'),
('Failed'),
('Waived');

INSERT INTO "RegistrationStatus" ("status_name") VALUES
('Active'),
('Waitlisted'),
('Withdrawn'),
('Pending Review'),
('Inactive');

INSERT INTO "Season" ("season_name", "start_date", "end_date") VALUES
('Spring 2026', '2026-03-02', '2026-05-30'),
('Summer 2026', '2026-06-15', '2026-08-08'),
('Fall 2026', '2026-09-07', '2026-11-21'),
('Winter 2027', '2027-01-10', '2027-02-28'),
('Spring 2027', '2027-03-01', '2027-05-29');

INSERT INTO "Gym" ("gym_name", "address", "city", "capacity") VALUES
('Fullerton Community Center Gym', '340 W Commonwealth Ave', 'Fullerton', 275),
('Independence Park Gym', '801 W Valencia Dr', 'Fullerton', 220),
('Brea Sports Park Gym', '3333 E Birch St', 'Brea', 300),
('Anaheim Downtown Youth Center', '250 E Center St', 'Anaheim', 260),
('Placentia Champions Gym', '143 S Bradford Ave', 'Placentia', 240);

INSERT INTO "Guardian" ("first_name", "last_name", "email", "phone") VALUES
('Maribel', 'Torres', 'maribel.torres26@gmail.com', '714-555-0142'),
('Kevin', 'Nguyen', 'kevin.nguyen.oc@gmail.com', '714-555-0188'),
('Andrea', 'Williams', 'andrea.williams.family@gmail.com', '657-555-0119'),
('Jose', 'Ramirez', 'jramirez.home@gmail.com', '714-555-0164'),
('Lena', 'Park', 'lena.park22@gmail.com', '562-555-0197');

INSERT INTO "Player" ("guardian_id", "first_name", "last_name", "date_of_birth", "eligibility_status") VALUES
(1, 'Mateo', 'Torres', '2014-05-11', 'Eligible'),
(2, 'Evan', 'Nguyen', '2013-08-24', 'Eligible'),
(3, 'Jordan', 'Williams', '2015-02-03', 'Eligible'),
(4, 'Daniel', 'Ramirez', '2012-10-19', 'Eligible'),
(5, 'Miles', 'Park', '2014-12-07', 'Needs Waiver Review');

INSERT INTO "Team" ("season_id", "team_name", "division") VALUES
(1, 'Fullerton Falcons', '12U'),
(1, 'Orange County Heat', '12U'),
(1, 'Brea Bulldogs', '10U'),
(1, 'Anaheim Thunder', '14U'),
(1, 'Placentia Panthers', '14U');

INSERT INTO "Coach" ("first_name", "last_name", "email", "phone") VALUES
('Marcus', 'Reed', 'coach.reed@gmail.com', '714-555-0210'),
('Tyler', 'Brooks', 'tylerbrooks.hoops@gmail.com', '714-555-0221'),
('Rafael', 'Santos', 'rsantosbasketball@gmail.com', '657-555-0204'),
('Derek', 'Miller', 'derek.miller.coach@gmail.com', '714-555-0233'),
('Anthony', 'Flores', 'afloresyouthsports@gmail.com', '562-555-0248');

INSERT INTO "CoachTeam" ("coach_id", "team_id", "season_id") VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);

INSERT INTO "Referee" ("first_name", "last_name", "email", "certification_level") VALUES
('Brian', 'Coleman', 'brian.coleman.ref@gmail.com', 'Level 1'),
('Sam', 'Patel', 'sam.patel.ref@gmail.com', 'Level 2'),
('Victor', 'Hernandez', 'victor.hernandez.ref@gmail.com', 'Certified'),
('Owen', 'Foster', 'owen.foster.ref@gmail.com', 'Level 1'),
('Malik', 'Johnson', 'malik.johnson.ref@gmail.com', 'Certified');

INSERT INTO "Registration" ("player_id", "team_id", "season_id", "registration_date", "status_id") VALUES
(1, 1, 1, '2026-02-12', 1),
(2, 2, 1, '2026-02-14', 1),
(3, 3, 1, '2026-02-16', 1),
(4, 4, 1, '2026-02-18', 1),
(5, 5, 1, '2026-02-20', 4);

INSERT INTO "Payment" ("registration_id", "amount", "payment_date", "status_id") VALUES
(1, 155.00, '2026-02-12', 2),
(2, 155.00, '2026-02-14', 2),
(3, 140.00, '2026-02-16', 2),
(4, 165.00, '2026-02-18', 1),
(5, 155.00, '2026-02-20', 1);

INSERT INTO "Game" ("season_id", "home_team_id", "away_team_id", "gym_id", "game_date", "game_time", "home_score", "away_score") VALUES
(1, 1, 2, 1, '2026-03-14', '09:30:00', 38, 34),
(1, 3, 4, 2, '2026-03-14', '11:00:00', 29, 36),
(1, 5, 1, 3, '2026-03-21', '10:15:00', 31, 33),
(1, 2, 3, 4, '2026-03-21', '12:30:00', 41, 28),
(1, 4, 5, 5, '2026-03-28', '01:45:00', 44, 39);

INSERT INTO "GameReferee" ("game_id", "referee_id") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
