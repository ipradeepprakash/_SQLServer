# Concepts of Locks

- Multiple users accessing the same information in the same database as the same time introduces the possibility of conflicts. so, Database MAnagement needs a method to eliminate the locks or reduce the impact as much as possile. This is acheived by locks.

- Locks are key to managing the transactions in all DBMS.
- The Idea is here to mark the transaction as NOT UNAVAILABLE while transaction is processing.
            
        for example:
            - when there is an update operation happening on EMPLOYEE table, Locks will held on that transaction & other transactions CANNOT interfere to update the same record.
            
        
## Scope of Lock
- The lock granularity refers to the size of the data structure to which the lock is applied.
 

