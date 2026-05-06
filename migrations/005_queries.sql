-- 005_queries.sql
-- Example queries for the basketball league database.


-- READ 1: players and guardians
SELECT p."first_name", p."last_name",
       g."first_name", g."last_name", g."email"
FROM "Player" p
JOIN "Guardian" g
ON p."guardian_id" = g."guardian_id";


-- READ 2: teams and seasons
SELECT t."team_name", t."division", s."season_name"
FROM "Team" t
JOIN "Season" s
ON t."season_id" = s."season_id";


-- READ 3: players on teams
SELECT p."first_name", p."last_name",
       t."team_name",
       rs."status_name"
FROM "Registration" r
JOIN "Player" p
ON r."player_id" = p."player_id"
JOIN "Team" t
ON r."team_id" = t."team_id"
JOIN "RegistrationStatus" rs
ON r."status_id" = rs."status_id";


-- READ 4: game schedule
SELECT g."game_id",
       h."team_name" AS "home_team",
       a."team_name" AS "away_team",
       g."game_date",
       g."game_time",
       g."home_score",
       g."away_score"
FROM "Game" g
JOIN "Team" h
ON g."home_team_id" = h."team_id"
JOIN "Team" a
ON g."away_team_id" = a."team_id";


-- READ 5: payments
SELECT pay."payment_id",
       p."first_name",
       p."last_name",
       pay."amount",
       ps."status_name"
FROM "Payment" pay
JOIN "Registration" r
ON pay."registration_id" = r."registration_id"
JOIN "Player" p
ON r."player_id" = p."player_id"
JOIN "PaymentStatus" ps
ON pay."status_id" = ps."status_id";


-- READ 6: referees for games
SELECT gr."game_id",
       ref."first_name",
       ref."last_name",
       ref."certification_level"
FROM "GameReferee" gr
JOIN "Referee" ref
ON gr."referee_id" = ref."referee_id";


-- UPDATE 1: change registration status
UPDATE "Registration"
SET "status_id" = 1
WHERE "registration_id" = 8;


-- UPDATE 2: change another registration
UPDATE "Registration"
SET "status_id" = 1
WHERE "registration_id" = 6;


-- UPDATE 3: mark payment completed
UPDATE "Payment"
SET "status_id" = 2
WHERE "payment_id" = 5;


-- UPDATE 4: update game score
UPDATE "Game"
SET "home_score" = 46,
    "away_score" = 42
WHERE "game_id" = 4;


-- UPDATE 5: update guardian phone number
UPDATE "Guardian"
SET "phone" = '714-555-0999'
WHERE "guardian_id" = 1;


-- UPDATE 6: update referee level
UPDATE "Referee"
SET "certification_level" = 'Level 2'
WHERE "referee_id" = 4;


-- DELETE 1: test referee assignment
INSERT INTO "GameReferee" ("game_id", "referee_id")
VALUES (1, 3);

DELETE FROM "GameReferee"
WHERE "game_id" = 1
AND "referee_id" = 3;


-- DELETE 2: test coach assignment
INSERT INTO "CoachTeam" ("coach_id", "team_id")
VALUES (4, 6);

DELETE FROM "CoachTeam"
WHERE "coach_id" = 4
AND "team_id" = 6;


-- DELETE 3: test payment
INSERT INTO "Payment"
("registration_id", "amount", "payment_date", "status_id")
VALUES
(1, 25.00, '2026-03-01', 1);

DELETE FROM "Payment"
WHERE "registration_id" = 1
AND "amount" = 25.00;


-- DELETE 4: test referee
INSERT INTO "Referee"
("first_name", "last_name", "email", "certification_level")
VALUES
('Test', 'Referee', 'test.referee@gmail.com', 'Level 1');

DELETE FROM "Referee"
WHERE "email" = 'test.referee@gmail.com';


-- DELETE 5: test gym
INSERT INTO "Gym"
("gym_name", "address", "city", "capacity")
VALUES
('Test Gym', '999 Test Ave', 'Fullerton', 100);

DELETE FROM "Gym"
WHERE "gym_name" = 'Test Gym';


-- DELETE 6: test guardian
INSERT INTO "Guardian"
("first_name", "last_name", "email", "phone")
VALUES
('Test', 'Guardian', 'test.guardian@gmail.com', '714-555-0000');

DELETE FROM "Guardian"
WHERE "email" = 'test.guardian@gmail.com';
