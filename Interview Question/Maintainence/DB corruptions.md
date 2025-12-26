

## Inetrview Questions: DB Corruptions

1. When we need to keep DB in emergency møde? Do we need to do this for all DB corruptions?
    - only if the database is NOT Reachable/SUSPECT/NOT connecting we need to put the DB in EMERGENCY.


2. if the corruption happened and you ran repair allow data loss how will ensure that there is no loss inside your database?
OR
How will you ensure there is no Data Loss after Repair?
    - use ROWCOUNT() BEFORE and AFTER THE REPAIR LOSS. if there is any difference we can say there is data loss.

