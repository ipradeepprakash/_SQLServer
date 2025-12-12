
# Interview Questions and answers session 6(Always ON part 3) 

Video: 
- https://drive.google.com/file/d/1ecPMaPk6z4GwApm-3GEYSlcV4EqobWXy/view?usp=drive_link

References: 
- https://www.apress.com/gp/blog/all-blog-posts/readable-secondaries-in-sql-server/16064064
- https://www.sqlshack.com/isolation-levels-behavior-in-sql-server-always-on-availability-groups/
- https://sqlserverentire.blogspot.com/2018/11/backups-through-maintenance-plans-when.html


Video Timeline
-------------
    0:00 - 1:15 // Basic details
    1:16 - 5:45 // where will you run DBCC CHECKDB? is it on Primary or any secondary replicas?
    5:46 - 13:10// what will be the default  isolation level of DB in Always on?
    13:13 - 21:50 // how does statistics work on secondary replicas?
    can we create statistics on secondary replicas?


1:16 - 5:45// where will you run DBCC CHECKDB? Is it on Primary or any secondary replicas?
--------------------------------------------------------------
- it's ok to run on both nodes,we can run on any of the server.
- its best practice to run on both nodes for same disk layouts on individual nodes.

5:46 - 13:10// what will be the default  isolation level of DB in Always on?
---------------------------------------------------------------------
- for the primary server,its default read-committed. 
- on secondary replicas, it depends on the scenarios below.

    **Scenario1:** 
    
    on Secondary, if you DONT turn on for Read Workloads.
    It is just the transfer of data from primary to secondary replicas.

    **Scenario2:**
    
    On Secondary, if you turn on Read Workloads.
    
    In this case, SQL server adds 14 byte over-head for each row on primary as well as SECONDARY, for constant updated(not insert, delete) row, there will be performance issues.
    - uses SNAPSHOT isolation behind the scenes(ROW-VERSIONING HAPPENS). 

    **Scenario3:**
    
    if primary has SNAPSHOT isolation level(row-version will be used) enabled, but secondary replicas NOT enabled for read workloads
    - in this case, there will be slight performance at the primary since it adds 14 byte over-head & successive load from primary will be carried to secondary, but it does not maintain row-version in tempdb.

    **Scenario4:** 
    
    if primary has SNAPSHOT isolation level (row-version will be used) enabled & SECONDARY, but secondary replicas enabled for read workloads
    - in this case, there will be row-version in tempdb along with 14 byte overhead.
    - the secondary database also gets 14 byte overhead.
    - The secondary database is also available for read access therefore, it also maintains row-version.

**13:13 - 21:50 // how does statistics work on secondary replicas?
Can we create statistics on secondary replicas?**
------------------------------------------------------------
- when we create an index on primary, the same get moved to secondary replicas. 
- In general, we cannot create statistics on secondary.
- for select queries with predicates, SQL Server will create column level statistics.
- if you turn on read workloads on secondary,it will create column level statistics inside the tempdb.


![Ignore_Replica](https://drive.google.com/drive/u/0/folders/1t9ifdKo1n6qsYBY63Jj8z3dlLvIxGVlG)





























































