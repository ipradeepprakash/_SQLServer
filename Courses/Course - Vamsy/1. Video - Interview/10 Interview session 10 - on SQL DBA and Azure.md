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


![Registry Edit](https://itsjusttesting101.blogspot.com/2025/12/sql-server-registry-edit.html)
- A 3rd party tools ![IIS Crypto](https://itsjusttesting101.blogspot.com/2025/12/iis-crypto.html) available to make changes (not suitable for prod tasks, but for learning purpose in local system is fine)








