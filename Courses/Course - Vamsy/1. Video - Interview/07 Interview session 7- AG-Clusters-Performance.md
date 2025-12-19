# Interview Questions and answers session 7 - AG-Clusters-Performance

### Learning resources:
- https://youtu.be/tb6yX4x7WIk
- How to Troubleshoot Different scenarios in Always on Availability Groups: (https://www.youtube.com/watch?v=h1Su_qyqXVE&list=PLCdpaLUxG1_RUjYBcKkRqAqEh1BkXAmnd&index=3)
- How to Troubleshoot Always on when they are not in Sync Part 2: https://www.youtube.com/watch?v=agCOjmDeqi8&list=PLCdpaLUxG1_RUjYBcKkRqAqEh1BkXAmnd&index=2
- Troubleshooting Always on Availability Groups Part-3: https://www.youtube.com/watch?v=n5J0bQgb0Eg&list=PLCdpaLUxG1_RUjYBcKkRqAqEh1BkXAmnd

Video timeline:
-----------------
    0:00 - 2:50 // what happens if we DON'T use multisubnet failover = True for your connection string?
    2:51 - 9:09 // where should DBCC CHECKDB be executed? Primary or secondary?
    9:13 - 19:15 // secondary replicas are not in healthy shape. What actions should you take?
    19:16 - 36:05 // what if AG looks fine but 1 of the databases are having issues in the AG group?
    36:06 - 38.41// what are the logs you check for AG issues.
    38:42 - 40:09 // where will you check failover history for always on?
    40:10 - 1:14:21 // High CPU usage

## 2: 51 - 9:09 : where should DBCC CHECKDB be executed? Primary or secondary?

- We can run on both depending on if DB is huge on primary, run on Secondary, else if db size is small, we can run on secondaries (License required on secondary till 2016, from 2019 its different) also.

## 9:13 - 19:15 // secondary replicas are not in healthy shape. What actions should you take?
- check if NODES are up & running.
- check the error msgs & take action accordingly.
- check if all replicas are in CONNECTED status.
- check if Algorithms are the same in all nodes for AG, if not, there will be sync issues.
- check ENDPOINTS is stopped.
- permissions for SERVICE ACCOUNTS on the endpoints.
- check for any firewall issues.
- if PRIMARY SERVER has status: QUARENTINE(happens from WINDOWS 2016)
- Quarantine is triggered for a node if the node ungracefully leaves the cluster three times within an hour. By default, that node will stay in Quarantine state for 2 hours, during which time it is not
allowed to rejoin the cluster nor host cluster resources

	> START -clusternode -clearQuarentine

## 19:16 - 36:05 // what if AG looks fine but 1 of the databases are having issues in the AG group?

- Log files may be full due to the high volume of data in the database.
- If any db which is part of TDE to the AG, if steps are not followed then there will be sync issues.
- For some space issues, if we add a file in primary & not in secondary replicas, sync issues occur.
- The option “database level health detection” works if 1 particular database has issue, that db will get replicated to other secondary replica, but keep in mind that in real world the grouping of dbs are for app/business specific reasons, if only one database has issue and gets failover to other secondary replicas, then app string with listener details will have issue as 1 db is failed over & other is in same primary server, so it becomes issue w.r.t app access to reading databases of same apps.

![enable DB Health ](https://drive.google.com/file/d/1ag1d8VHu4-VUxjRO2TaoC-X-FgpjWl10/view?usp=drive_link)


## 36:06 - 38.41// what are the logs you check for AG issues.
- Error logs
- Extended events 
    - Always On health sessions: same msg as seen in error logs.
    - SQL diagnostic files : 
    - System health session :
- Windows cluster logs
- So, troubleshoot the issues at 
    - Node levels
    - Network levels
    - Replicas levels
    - Database levels


## 38:42 - 40:09 // where will you check failover history for always on?
- Use respected DMV’s for always ON

## 40:10 - 1:14:21 // High CPU usage

**Scenario 1:** 

cpu was high long back & users are asking for investigation.
- We use 3rd party tools to investigate.
- General steps
    1. Check if SQL server was causing high CPU, else if non-sql server was used for high cpu, then engage concerned app, wintel team.
    2. For earlier cpu high use, use ring buffers dmv(4 hour cpu history can be checked).
    3. Finding queries using high cpu, use 3rd party tools.

**Scenario 2:**

cpu is NOW high long back & users are asking for investigation.

- Use sp_whoisactive, activity monitor
- General steps
    1. Check if SQL server is causing high CPU, else if non-sql server is being used for high cpu, then engage concerned app, wintel team.
    2. Finding queries using high cpu using activity monitor->active queries or use sp_whoisactive to order usage by cpu.
    3. Querystore, if SQL version is 2016 & beyond.
    4. hrs CPU history from ring buffers.
    Functions used in left side of = will always result in scan.



















