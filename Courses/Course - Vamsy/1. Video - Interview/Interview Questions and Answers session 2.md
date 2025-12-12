# Interview Questions and Answers session 2
Ref: https://youtu.be/hn_l1PRGRd0



### Video timeline: 


    ##### 0:00 - 4:00 // introduction on type of questions
    ##### 4:01 - 6:49 // index rebuild or Reorg
    ##### 6:50 - 14:17 // Will rebuilding index cause blockings?
    ##### 14:18 - 17:35 //  can we stop/kill Index rebuild? What will be the impact?
    ##### 17:38 - 24:42 // is it possible to track the progress of index Rebuild & Index reorg?
    ##### 24:44 - 25:04 // how many types of statistics are there?
    ##### 25:05 - 36:19 // Will index rebuild update statistics?
    ##### 36:21 - 41:39 // if there is 800 GB table size, what should be the strategy of maintenance for indexing, stats etc?
    ##### 43:51 - 48:17 // how to determine the downtime required for rebuilding indexes for huge database tables?
    ##### 48:23 - 45:13 // what is your approach, if there is a performance issue/slowness?
    ##### 45:15 - 55:26 // what is difference between Blockings & deadlocks?
    ##### 56:21 - 1:03:06 // Find the query running for a long time?

## 4:01 - 6:49 // index rebuild or Reorg
    If frag < 30%, we will go for Reorg the indexes
    If Frag > 30%, we will go for Rebuild the indexes

## 6:50 - 14:17// does rebuild index cause blockings?
### Online rebuild

    - Yes, only during the final phase of index rebuild.
    - Online rebuild index will hold locks(schema-Modification LCK_M) at the last stages (initial stage,intermediate stage & final stage)
    - Once the rebuild reaches the last stage, nobody can access the object/table that is being rebuild on index.

### Offline Rebuild
    Locks (LCK_M) will be held for the majority of the time during rebuild.
#### Does Reorg index cause blockings?
    


## 14:18 - 17:35//  can we stop/kill Jobs of Index Reorg & Index rebuild? What will be the impact?
    If there are 30 tables in DB, index rebuild has done 25 tables rebuild, if we stop the job & start the job, will it start from 1st table or start at 26th table?

    **Index Reorg** : 
        - Can be interrupted and can start from where it stopped.

    **Index rebuild**:
        - cannot be interrupted as restart will again start rebuilding from 1st table.
        - From SQL 2017, there is Resume-online index rebuild feature.
        - Until SQL 2016 versions, all rebuild index operations cannot be interrupted. It is wither full task completion or rollback to the beginning.

## 17:38 - 24:42// is it possible to track the progress of index Rebuild & Index reorg?

### Rebuild job:
    - No Direct method. If we are running a scheduled job, it cannot be tracked for checking progress.
    - But if we are running manually, we CAN track the progress ( by using SET STATISTICS PROFILE ON) using DMV

### Reorg Job:
    - Yes, DMV sys.dm_exec_request can be used to track the progress.
    - Index rebuild cannot be interrupted as restart will again start rebuilding from 1st table.
    - From SQL 2017, there is Resume-online index rebuild feature.
    - Until SQL 2016 versions, all rebuild index operations cannot be interrupted. It is wither full task completion or rollback to the beginning.

## 17:38 - 24:42// is it possible to track the progress of index Rebuild & Index reorg?

### Rebuild job:
    - No Direct method. If we are running a scheduled job, it cannot be tracked for checking progress.
    - But if we are running manually, we CAN track the progress ( by using SET STATISTICS PROFILE ON) using DMV

### Reorg Job:
    - Yes, DMV sys.dm_exec_request can be used to track the progress.

## 24:44 - 25:04// how many types of statistics are there?
    Index statistics
    Column statistics

## 25:05 - 26:12 // Will index rebuild update statistics? 
Yes, only Index statistics.
// Will index Reorg update statistics? 
No, Reorg will not touch any statistics, we need to manually update statistics after Reorg activity.

## 26:13 - 36:19 // usually in FULL recovery Mode, every transaction will be logged, so is INDEX REBUILD activity, AG activity it will also log so many records to the transaction file.

What will be your strategy to implement INDEX REBUILD for Very Huge tables?
Imagine a stand-alone DB of 4 TB size and performing a Rebuild index task, if we change the Recovery from FULL to BULK-LOGGED for index rebuild. Once the activity is done, the next log backup size will be huge.
