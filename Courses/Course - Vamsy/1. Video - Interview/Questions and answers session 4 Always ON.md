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
        










