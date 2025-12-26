# Understanding profiler events and calculating storage IOPS and Interview questions part 11 

Video: https://www.youtube.com/watch?v=kuqT_0yDd6o

References: 

> How to Use CrystalDiskMark - https://www.youtube.com/watch?v=egQJl80J6VE

> How to Measure Storage Performance and IOPS on Windows - https://woshub.com/how-to-measure-disk-iops-using-powershell/


### Video Timeline
--------------
0:00 - 24:06// set up a TRACE to understand problematic query or stored procedure.
24:08 - // Scenario: Migration from On-Prem to Azure VM, we need to calcuate the disk parameters like IOPS,Throughput at On-Prem Level, so that we can match the IOP,throughput on Azure VM. how to calculate?


### 0:00 - 24:08// set up a TRACE to understand problematic query or stored procedure.
Create a dummy procedure to simulate as a problematic query.


**<U> Sample query</U>**
 
        Create procedure test as
        Begin
        Select top 1 * from sys.syslogins

        Select top 1 * from sys.sysusers

        Select * from sys.syslogins sl 
        Join
        Sys sys.sysusers su on sl.sid = su.sid
        End
      


What are the events that I need to capture in the profiler?

- Under **General**
    
    Open profiler 

    -> Connect SQL instance

    -> Trace properties 

    -> Trace name (give your preferred name)

    -> use the template: select **Blank**

- Under **Event Selection**

    choose - Stored procedure (if Requests are coming from app end)
        
        - RPC Completed (Remote procedure call i.e. Java, .Net, Php etc )
        - SP: StmtCompleted (occurs when a remote procedure call has started)
        - SP: Completed (a T-SQL statement within a stored procedure has started)
    
    choose - TSQL
        
        - SQL: BatchCompleted (occurs when a TSQL statement has Completed)
        - SQL: StmtCompleted (Indicates that the SqlClient, ODBC, OLE DB or DB-Library has unprepared (deleted) a prepared T-SQL statement/s )
    
    Choose - **Column filters**

        - select Databasename -Like <DB_Name_123>
    
    Finally
    
        Select -> RUN



let's run the below queries & see what is captured in already running profiler

    select top 1 * from sys.tables
    select top 1 * from sys.schemas

    in the above example, we could see that from the profiler trace

    SQL: StmtCompleted - had 2 entries, one for each query
    SQL: BatchCompleted - had 1 entry, since 2 queries were executed as a Batch

    so, Batch is similar to Multiple transactions executed at once.

    In real world, if there is an AD-HOC Queries running, we can look at individual statements that is contributing under column SQL: StmtCompleted -> Duration.

    if there is a Requirement to check the list of stored procedures names that gets executed during a day, then
        - SP:Completed

     

### 24:08 - // Scenario: Migration from On-Prem to Azure VM, we need to calcuate the disk parameters like IOPS,Throughput at On-Prem Level, so that we can match the IOP,throughput on Azure VM. how to calculate?

    - while building a new server, we can use below Tools: 
        > SQL Stress

        > CyrstalDiskmark

        > SQLIOism

the parameters that should be kept in mind for calculating Disk level perfmon counters

    - Disk Sec/Transfer
    - Disk Transfers/Sec
    - Disk Bytes/Sec
    - Split IO/Sec
    - Avg. Disk Queue Length




























































