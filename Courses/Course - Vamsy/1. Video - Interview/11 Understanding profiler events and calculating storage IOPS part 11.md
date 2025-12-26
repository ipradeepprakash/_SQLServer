# Understanding profiler events and calculating storage IOPS and Interview questions part 11 

Video: https://www.youtube.com/watch?v=kuqT_0yDd6o

### Video Timeline
--------------
0:00 - // set up a TRACE to understand problematic query or stored procedure.


### 0:00 - // set up a TRACE to understand problematic query or stored procedure.
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

    choose - Stored procedure
        
        - RPC Completed
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

    SQL: StmtCompleted - had 2 entries. one for each query
    SQL: BatchCompleted - had 1 entry, since 2 queries were executed as a Batch



















































