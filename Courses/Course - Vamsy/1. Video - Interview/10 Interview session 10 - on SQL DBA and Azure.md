# Interview Questions and Answers Part 10 - on SQL DBA and Azure Part-10

Video tutorial : https://youtu.be/vuxGwbDU1VY

Video timeline
--------------
    0:00 - 25:53 // SQL agent unable to start
    25:55 - 36:37 // how many files are there on tempdb for PaaS (Azure MI & Azure SQL)
    36:41 - 43:27// user is on SQL 2017(on-prem or Iaas), and migrated to SQL 2019, ran the workloads for a week & realized that performance is not good, so the user switched back from SQL 2019 to SQL 2017. What will be the reason to switch back to SQL 2017?
    43:28 - 1:03:04 // what is a proxy account in SQL server?



0:00 - 25:53 // SQL agent unable to start
--------------------------------------
SQL agent fails with below ![SQL Server Restart error](https://itsjusttesting101.blogspot.com/2025/12/sql-server-restarting-error-request.html)


        The request failed or the service did not respond in a timely fashion.
        Consult the event log or other applicable error logs for details. 

Troubleshooting Steps 
-------------------
- Go to error logs & inspect what is there in error logs.
- TLS in different versions will have different values. Both need to have same common algorithm/values.
- Engage wintel team if the values in registry needs to be updated.
- ![Registry Edit](https://itsjusttesting101.blogspot.com/2025/12/sql-server-registry-edit.html)
- A 3rd party tools ![IIS Crypto](https://itsjusttesting101.blogspot.com/2025/12/iis-crypto.html) available to make changes (not suitable for prod tasks, but for learning purpose in local system is fine)

#### Note:
in SQL server 2022 version, we see the below msg “Starting up model_replicatedmaster”


### 25:55 - 36:37 // how many files are there on tempdb for PaaS (Azure MI & Azure SQL)

### <u>For Azure SQL</U>

- In Azure SQL, we can see only Master DB under System Databases.
- No# of Tempdb files depend on the vCore config we chose for the database.(i.e Basic DTU or vCore Model)
- In query editor,execute the below query 
    ```SQL
    Select * from 
    tempdb.sys.database_files
    ```
- Check Tempdb file usage
- https://techcommunity.microsoft.com/blog/azuredbsupport/resolve-tempdb-related-errors-in-azure-sql-database/3597944

    ```SQL
    SELECT [Source] = 'database_files', 
    [TEMPDB_max_size_MB] = SUM(max_size) * 8 / 1027.0, 
    [TEMPDB_current_size_MB] = SUM(size) * 8 / 1027.0, 
    [FileCount] = COUNT(FILE_ID) 
    FROM 
    tempdb.sys.database_files 
    WHERE type = 0 --ROWS```

- Also depends on vCore configuration what we selected.



### <u> For Azure MI</U>
- Default is 12 Tempdb db files & 1 log file


### 36:41 - 43:27 // user is on SQL 2017(on-prem or Iaas), and migrated to SQL 2019, ran the workloads for a week & realized that performance is not good, so the user switched back from SQL 2019 to SQL 2017. What will be the reason to switch back to SQL 2017?

- The issue could be due to compatibility.
- In SQL 2019, we have batch mode on row-store operation similar to that of Columnstore indexes.

    (
        what is batch mode - in exec plans
        
        - From 2012, we have columnstore indexes. 
        We cannot create clustered indexes, so only Non-clustered column store indexes, even then the entire table will become READ-ONLY.
        
        - On the columnstore index,index function is different from traditional indexes. 
        I.e. Traditional indexes will be in B-Tree index format, execution goes Row-by-Row manner from the top level -> Intermediate-Level ->leaf node level.
        
        - For Columnstore indexes, index architecture is completely different. Here there is a BATCH mode for execution plans.

)

### 43:28 - 1:03:04 // what is a proxy account in SQL server?
- Whenever Non-System Admins need to Run Non-TSQL job steps, then they need Proxy accounts.
- Steps to create proxy
    1. Create credential
    2. Go to proxies -> select appropriate component-> right click & select “New Proxy” -> fill with proxy & principle details(select the login that needs proxy account)
    