ReadMe - by: bryant, wasi, arman
Youth Basketball League Management System SQL

System Description:

The Youth Basketball League Management System is the proposed relational database model that is designed to help a youth basketball organization function for its full lifecycle. The Youth Basketball League Management System aims to help with all day to day operational data into a relational schema where coaches, guardians, referees, and league administrators are able to reliably use. The primary users for this database are the league administrators who need to configure and oversee the entire system every season and coaches; whom of which, are assigned to one or multiple teams. These coaches require access to roster information which contain players. Referees are assigned to games based on the availability and certification level or credibility. The database will track players' basic demographics such as age, team composition, coaching assignments, and general game scheduling across physical locations as well as registration and payment transaction histories.

Scope:

Below are the scope of our Youth Basketball League Management System and the following things it will track or function.
·       The system will track player demographics, eligibility status, and guardian contact information for every registered participant.
·       The system will manage team rosters, including player assignments that are scoped to a specific season to preserve historical records.
·       The system will record and enforce multi-season coaching assignments, supporting scenarios where a single coach manages more than one team.
·       The system will schedule games between teams, capturing gym location, date, start time, and final score outcomes.
·       The system will assign one or more certified referees to each scheduled game and maintain a log of referee participation history.
·       The system will track gym availability and prevent the double-booking of a facility at the same date and time.
·       The system will manage guardian-initiated player registrations, including status tracking (Active, Waitlisted, or Withdrawn) throughout the season.
·       The system will record payment transactions associated with each registration, supporting statuses of Pending, Completed, and Refunded.
·       The system will support multiple seasons with full historical data retention, enabling year-over-year reporting on teams, players, and league performance.
·       The system will enforce referential integrity across all related entities, ensuring that no orphaned records exist for payments, registrations, or game assignments.

Database Constraints:

01: Guardian Email Uniqueness 
The email field in the Guardian table must be unique. No two guardians may share the same email address, as email serves as the primary login and communication identifier. 
02: Coach Email Uniqueness 
The email field in the Coach table must be unique across all coach records, ensuring unambiguous identification of each coaching staff member.
03: Seasonal Team Membership 
A player may be registered to only one team per season. The Registration table enforces a composite unique constraint on (player_id, season_id) to prevent duplicate team assignments within the same seasonal period. 
04: Season Date Validity 
A season's end_date must be strictly greater than its start_date. This constraint prevents the creation of invalid or zero-length seasons. 
05: Game Date Within Season 
A game's game_date must fall on or between the start_date and end_date of its associated season. Games cannot be scheduled outside of the active seasonal window.
06: No Gym Double-Booking 
No two games may be scheduled at the same gym_id with the same game_date and game_time. A composite unique constraint on (gym_id, game_date, game_time) in the Game table enforces this restriction. 
07: Self-Play Prevention 
A game's home_team_id and away_team_id must reference two distinct teams. A team cannot be scheduled to play against itself. 08: Payment Referential Integrity A payment record cannot exist without a corresponding valid registration. The registration_id in the Payment table is a foreign key that references Registration.registration_id. 
09: Payment Status Constraint 
The payment_status field must be one of the predefined values in the PaymentStatus lookup table: Pending, Completed, or Refunded. Direct string insertion outside of these values is not permitted. 
10: Registration Status Constraint 
The registration_status field must reference a valid value in the RegistrationStatus lookup table: Active, Waitlisted, or Withdrawn. 
11: Referee Game Assignment 
Every scheduled game must have at least one referee assignment recorded in the GameReferee table before the game's status can be set to Confirmed. This rule is enforced at the application layer during the scheduling workflow.
