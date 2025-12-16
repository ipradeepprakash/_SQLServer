
<h1> SQL Transaction Locks  </h1>

<h2>Course Content</h2>

- Scope of Lock
- Video: Various Levels of locking
- Setting Modes for Locks
- Levels of Locking
- Example of Implementing Locks on Transactions

<h2> Concepts of Locks</h2>

- Multiple users accessing the same information in the same database as the same time introduces the possibility of conflicts. so, Database MAnagement needs a method to eliminate the locks or reduce the impact as much as possile. This is acheived by locks.

- Locks are key to managing the transactions in all DBMS. 

## Scope of Lock
- The locking granularity refers to the size of the data structure to which the lock is applied

**Database**
- This is a process that locks the entire database
- Used when making changes to several tables or to perform maintenance during periods of low usage

**Table**
- This process locks a table
- Used when a large amount of table-specific data isbeing modified

**Page**
- Process locks chunks of data that fit in a sector on a disk
- DBMS may use this process when making changes to a section of data in a table

**Row**
- Process locks a specific row or record
- Useful if making changes to one or several manageable rows

**Column**
- Process locks data at the column level
- Useful when making changes to one column




