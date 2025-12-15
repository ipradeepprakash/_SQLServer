# Questions and answers session 4(Always ON) 

Video
- https://drive.google.com/file/d/1FpxrfQ9OC0Ck7t21npm6QoaUV8LiAl4g/view
- https://n4stack.io/2018/10/30/checklist-sql-always-on-config/
- https://www.sqlshack.com/how-to-configure-read-only-routing-for-an-availability-group-in-sql-server-2016/


### Video Timeline:

    0 - 2:01// basic details on interview questions
    2:15 - 9:51 // Basic Always On Questions
    10:24 - 11:56 // Why is logshipping not preferred for reporting?
    11:57 - 12:23 // why cant we take Database mirroring for reporting activity?
    12:48 - 13:08 // challenges in database snapshots for reporting.
    13:10 - 13:53 // why was Always on introduced?
    14:28 - 17:18 // questions on listener.
    17:20 - 19:50 // what is URL routing for Always ON?
    22:31 - 25:55 // How will you sink the objects that are out of scope for Always on like
    30:41 - 40:13 // Scenario1: changes on primary, but not done on secondary.so, what should be done to make sure jobs run only on PRIMARY?
    42:08 - 46:10 // Have you added SSISDB & sync across all Replicas?
    50:20 - 54:03 // How do you patch the replicas & primary servers?
    54:37 - 1:06:25 // failover readiness value
    57:08: what happens if the log file gets full in always on and if shrinking is not happening on primary, how to check?



#### Use of dbatools: 
copy-dbalogin: 
- to copy logins between primary & secondary servers in Alwas On AG
        https://drive.google.com/file/d/150ne59D8SLRu5cGHmK6sZ9Tuv4Yc2OC2/view?usp=drive_link

- Copy-dbajob: 
    - to copy jobs between primary & secondary servers in Always On AG

- Jobs_creation_alwayson : 
    - A Customised script, if job is on PRIMARY SERVER, IT WILL EXECUTE, ELSE NO.
        https://drive.google.com/file/d/1Q5UvAqnHT4aMNTHgzmBWf_pim3xZkxik/view?usp=drive_link

- Sync-Dbaavailabilitygroup : 
    
        Sync all db settings related to

        - linked servers
        - credentials
        - MAXDOP, DBMail,
        - sp_configure
        


**Before considering Always On, we need to ask few questions to all stake holders:**
- Does our application really need HA or DR? 
- If it is DR, it's in a different Sub-net.
- Does our App require any Reporting tasks?
- What is the RTO & RPO?

**10:24 - 11:56 // Why is logshipping not preferred for reporting?**
- There will be lag/delay at the secondary.
- If STANDY mode is chosen as restoring mode, then users have to be disconnected during restore of logs, which affects the reporting tasks for users.

**11:57 - 12:23 // Why can't we take Database mirroring for reporting activity?**

- Databases in Secondary server will not be available for Reporting purpose during mirroring as the databases will be in NO RECOVERY mode.

**12:48 - 13:08 // What are the challenges in database snapshots for reporting?**
- Not easy to configure(we need to take snapshots based on needs), No GUI support.

Microsoft realized the challenges in above Features & came up with Always On with emphasis on Reporting as a task.

**14:28 - 17:18 // Questions on the listener.** 

- Certain permissions needed on AD level.
- When creating LISTENER, we get the below issue
    - “Listener cannot be brought online as its in OFFLINE state” and the listener cannot be made online,
        - it fails, because we need to do pre-staging 
    - (certain permissions needed at AD Level for cluster service account i.e )
        1) Create Computer object
        2) Read all Properties

**17:20 - 19:50 // What is URL Routing / Read only Routing for Always On and what needs to be done from Database end?**

**22:31 - 25:55 //How will you sink the objects that are out of scope for Always on like**

    - Jobs
    - Logins
    - Linked servers
    - Operators
    - MAXDOP
    - Credentials

- For SQL 2022 & above: Contained Databases
- We can use dbatools (powershell module) using copy-dbalogin
- We can use sp_revlogin script out logins to secondary from primary.

    **Scenario1: Changes on primary, but not done on secondary.** 

    - On the primary server, app team asks to change the schedule of the job. DBA will change the schedule as per request. Now, imagine if the same job on secondary is not changed & after failover, the same job on the new server will run at old time which causes issues. (use copy-dbajob -force)
    - Imagine if DB settings like MAXDOP are changed on PRIMARY and the same was not done on SECONDARY. After a failover to the new primary server, there could be performance issues.
    - How will you check for jobs that should run only on PRIMARY,not SECONDARY? I.e a job that has DML tasks & Select table records, if for some reason it gets activated on secondary. The job fails on secondary 

    - There is a function that can check if a replica is PRIMARY OR NOT. i.e it should be added to every required job, it can be automated via small job step creation (https://drive.google.com/file/d/1Q5UvAqnHT4aMNTHgzmBWf_pim3xZkxik/view?usp=drive_link
    )

    - Sync-Dbaavailabilitygroup : used to sync all PRIMARY SERVER db settings related to SECONDARY db server (run this script in job & schedule).
        - linked servers
        - credentials
        - MAXDOP etc
        - sp_configure

    **Scenario2: Have you added SSISDB & sync across all Replicas for using SSIS packages?**

    - There is dedicated tutorial : Real time issues on SSISDB and sync up jobs in Always ON 
    - All my packages will be in SSISDB and add this DB in always on, so all replicas will have a copy of SSISDB with all packages.

**50:20 - 54:03 // How do you patch the replicas & primary servers?**

- While doing a failover, we have to change to SYNC mode.
- Failover mode should be MANUAL.
- Once patching is done on SECONDARY, wait for Data sync, only then failover to another instance.
- Use GUI for Failover as it checks various parameters in the background.
- Jobs: Make sure no scheduled jobs are executed during patching duration.
- If our servers are NOT PHYSICAL, the windows team can take SNAPSHOT of the entire server.

**54:37 - 1:06:25 // 54:37: failover readiness value**
- In the AG dashboard, if the failover readiness = NO DATA LOSS
- LAST HARDENED LSN: it will be in SYNC if both PRIMARY / SECONDARY are in the same state.
- Replication: The trace flag to sync in replication in an Availability Group (AG) is trace flag 1448, which allows the log reader to replicate transactions that have been hardened on synchronous replicas, not necessarily all synchronous replicas. This can speed up replication, but introduces the risk of data loss if a failover occurs to an asynchronous replica.

**57:08 - // what happens if the log file gets full and is on always on and if shrinking is not happening on primary, how to check?**
- Take log backup & shrink, if it allows. 
- Use DMV, Log_reuse_wait_desc to check why log is used
- Can add another log file in another drive, provided the replica servers also have the same disk layouts.






















