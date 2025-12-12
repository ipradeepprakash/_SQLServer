# Interview Questions and answers session 3
#### Video link: https://drive.google.com/file/d/1-KbzGO1sHTtgntexwIDgf5myGpI9PgdA/view?usp=drive_link

## Performance related interview questions

### Scenario 1:
----------------
**Questions:** App team is complaining about slowness for a query.

Approach:

    Check what's happening on SQL Server i.e.
    Is Anti-virus running
    What activities are running apart from Database activities
    Check Memory
    For experienced DBA, dont say “we check Task Manager”, it should be “we check Resource Manager”
    In “resource manager” check the latency parameters like response time, it should be < 20 ms. if its more than that then we need to investigate.
    Then, we will look into sp_whoisactive results 
    OR
    USe DMV like exec_request, process related to find the query texts that are currently running.
    Check blockings (use DMV sys.dm_exec_requests or sp_whoisactive). For exp DBA, try remembering the tsql query (select * from sys.dm_exec_requests cross apply sys.dm_exec_SQL_text (sql_handle) where session_id > 50)
    Check long running queries, using sp_whoisactive
    If you find a problematic line of code inside an Stored proc of 1000 lines of code, then to find the exact code that is causing issue can be analysed by using sp_whoisactive & referring to column sql_text (gives currently executing line of code).
    If not sp_whoisactive, then we can use statement_start_offset & statement_end_offset columns using sys.dm_exec_requests DMV


### Scenario 2:

**Question:** imagine you went out for a break for 1 hr & after coming back, the app team says during the last 1 hr there was slowness. How to approach?

Approach: 

    Use Query_store (if SQL 2016 & if its enabled)
    Log the info of sp_whoisactive to a table.
    Schedule a job to capture the blocking details (check vamshi’s script in SQL 2022 Paid)
    https://sqlserverentire.blogspot.com/2020/06/performance-issue-with-lengthy-stored.html


**Question:**  Will index rebuild update the statistics?

    Yes, only update index stats
    To check
    Sp_autostatistics, 
    dbcc show statistics: 
    sys.dm_db_stats_properties
    
    What is Full Scan, sampling in statistics?
    Full scan : 
    all the records of the table will be scanned & updated.
    Check dbcc show statistics & verify if Rows column & rows sampled, if they are same then Full scan has happened.
    For any slow queries, if you see the difference in Actual no of rows with estimated no of rows, then stats is not Updated. So run Update stats.
    Update statistics can be done in 
    FULL SCAN (update statistics <table_name> with fullscan)
    SAMPLE (update statistics <table_name> with sample Percent/Rows)































