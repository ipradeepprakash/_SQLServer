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





























