-- 004_views.sql
-- View to show player, team, registration, and payment info.

CREATE OR REPLACE VIEW "PlayerInfoView" AS
SELECT
  p."first_name" AS "player_first",
  p."last_name" AS "player_last",
  t."team_name",
  rs."status_name" AS "registration_status",
  ps."status_name" AS "payment_status"
FROM "Player" p
JOIN "Registration" r ON p."player_id" = r."player_id"
JOIN "Team" t ON r."team_id" = t."team_id"
JOIN "RegistrationStatus" rs ON r."status_id" = rs."status_id"
JOIN "Payment" pay ON r."registration_id" = pay."registration_id"
JOIN "PaymentStatus" ps ON pay."status_id" = ps."status_id";
