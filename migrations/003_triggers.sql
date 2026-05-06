-- 003_triggers.sql
-- Trigger to make sure game dates are inside the season dates.

CREATE OR REPLACE FUNCTION check_game_date()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW."game_date" < (
    SELECT "start_date"
    FROM "Season"
    WHERE "season_id" = NEW."season_id"
  )
  OR NEW."game_date" > (
    SELECT "end_date"
    FROM "Season"
    WHERE "season_id" = NEW."season_id"
  ) THEN
    RAISE EXCEPTION 'Game date is not in the season';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_game_date_trigger ON "Game";

CREATE TRIGGER check_game_date_trigger
BEFORE INSERT OR UPDATE ON "Game"
FOR EACH ROW
EXECUTE FUNCTION check_game_date();
