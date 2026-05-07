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
