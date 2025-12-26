# Understanding profiler events and calculating storage IOPS and Interview questions part 11 

Video: https://www.youtube.com/watch?v=kuqT_0yDd6o

### Video Timeline
--------------
0:00 - // set up a TRACE to understand problematic query or stored procedure.


### 0:00 - // set up a TRACE to understand problematic query or stored procedure.
Create a dummy procedure to simulate as a problematic query.

**<U> Sample query</U>**
```sql
Create procedure test as
Begin
Select top 1 * from sys.syslogins

Select top 1 * from sys.sysusers
Select * from sys.syslogins sl 
Join
Sys sys.sysusers su on sl.sid = su.sid
End
```


What are the events that I need to capture in the profiler?

- Under **General**
    
    Open profiler -> 
    connect SQL instance->Trace properties -> 

    Trace name(give your preferred name)

    -> use the template: select **Blank**

- Under **Event Selection**



















































