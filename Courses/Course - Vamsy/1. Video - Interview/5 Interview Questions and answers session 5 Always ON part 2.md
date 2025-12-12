# Interview Questions and answers session 5 Always ON part 2 

**Video:** https://drive.google.com/file/d/1KnRao5ekeljFyCvjUbxwjkpPcXKmlMG7/view?usp=drive_link

**Reference:** - https://sqlserverentire.blogspot.com/2020/04/ola-hallengrens-backup-job-related-to.html


## Video timelines

    0:00 - 2:15 // discussion on questions discussed in last class.
    2:52 - 14:48 // talks about questions on backups
    14:49 - 21:36 // what are the differences between AG & DAG
    33:20 - 45:53 // time-out error between primary & secondary replicas, how to troubleshoot?
    46:33 - 52:30 // while performing DR Drill for TB size database with less time and you thought backups(copy-only full backups) are happening on secondary replicas. You are asked to restore database backups very quickly.
    What kind of backups do you consider?
    52:31 - 54:50 // ola hallengren backup scripts for AG to happen only on secondary. Should there be some tweaks for the automated backups to happen for ola scripts?


**2:52 - 14:48 // talks about questions on backups**

1. Can we take backups on all replicas?

    - Answer: only copy_only full backups allowed.

2. Can we take differential backups on replicas?
    - Answer: No
3. On the primary server, Diff backups are NOT Able to take. Why?
    - Answer: could be because
    - If backups preference is given ‘SECONDARY ONLY’.
    - Ask what is the error msg to interviewers.
    - Ask questions like - are the database under AG or DAG?
    - For DAG, databases in secondary appears as primary(known as FORWARDER i.e the replicas in secondary will be seen as PRIMARY, so diff backups cannot be taken)

**14:49 - 21:36 // what are the differences between AG & DAG**

1. Resources 
    - in AG, Resources are maintained in windows clustered level, 
    - in DAG, resources are maintained at SQL server level.
2. Clusters
    - AG has same failover clusters
    - DAG has 2 different clusters.
3. Log records,
    - In AG, Primary has to send log records to secondary replicas in the same region.
    - In DAG, Secondary replicas in Different clusters appear as primary/FORWARDER. The primary in primary location will send log records to all replicas in its primary region & then to only FORWARDER in different cluster in another region, it will not send log records to other secondary replicas in different cluster in another region.
    - Listener
        - AG has same Listener
        - DAG will have different listeners for each cluster.
        - So any issues in one cluster, app team should have a different connection string for the app connection.

    - SQL versions
        - AG requires same SQL server versions
        - DAG can have different compatible versions in different clusters across regions.


**33:20 - 45:53 // time-out error between primary & secondary replicas, how to troubleshoot?**

Couple of reasons why it could happen
- Network issues between primary & secondary replicas.
- Any changes in firewall rules.
- VMware snapshots: causes the servers/nodes/replicas will freeze when VM level backup happens & nodes will lose connection due to idleness/no response.


**46:33 - 52:30 // while performing DR Drill for TB size database with less time and you thought backups(copy-only full backups) are happening on secondary replicas. You are asked to restore database backups very quickly.
What kind of backups do you consider?**

- On secondary replicas, we cant take differential backup since only copy-only backups are happening.
- We CANNOT go with normal backups as it will take a lot of time.
- We cannot go with copy-only full backup at secondary + Differential backup at primary. It will throw an error.
- We need to go with LOG BACKUPS on primary.

52:31 - 54:50 // ola hallengren backup scripts for AG to happen only on secondary. Should there be some tweaks for the automated backups to happen for ola scripts?

- We need to add COPY-ONLY to the script for modifying the backup preferences.
- As you know the backups would run based on backup preferences . Below is the script of Ola's which needs to be configured if you want to offload your backups. We will talk about the highlighted portion in detail down the line.

```EXECUTE [dbo].[DatabaseBackup]
@Databases = 'USER_DATABASES',
@Directory = N'|\XXXXXXX\SQLBACKUP',
@BackupType = 'FULL',
@copyonly='Y'
```
If we DON'T apply @copyonly='Y' Then backups happen on primary & secondary replicas.









































