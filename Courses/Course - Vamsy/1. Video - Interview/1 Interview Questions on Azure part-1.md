# Interview Questions on Azure part-1

# Interview Questions on Azure part-1 (Vamsy DBA Training)
Reference: 
- https://drive.google.com/file/d/1tN2Wne_81LgaYxIpC0LdkbbHxYkaOEgm/view
- https://youtu.be/DufC1SQd5bg

# Basic questions

## 1. What are all the cloud models available w.r.t to database realm?

- Iaas 	: VM, Storage
- Paas 	: Azure SQL DB, Azure MI
- Saas 	: n/a

## 2. Have you worked on Database Migrations?

## _A. Iaas (ask more questions)_*

### If worked only on Iaas - briefly answer only related to Iaas, if no work done on Paas, its ok.

### My question to interviewer

#### 1. If client willing to go with the OS (Operating system) (No - rule out the need for PaaS)

#### 2. Does the client need any components like (if Yes and need Pass features  - not native flavours, i.e. Power BI for SSRS, ADF for SSIS, SSAS - Azure datawarehouse / Azure synapse )
            SSIS (supported in Azure VM)
            SSAS  (supported in Azure VM)
            SSRS  (supported in Azure VM)
### 3. If the app existing one or the New/redesigned app.

- If an existing app cannot make any code changes then - Azure MI, Azure SQL so, it will be a direct migration step with Backup & restore to MI,Azure SQL. else, it will be a migration to Azure VM similar to on-prem SQL.
- If a new app - ppl go with Azure SQL.

### 4. If my source is 
- Source: SQL 2008, Destination : azure VM
- Source:SQL 2012/SQL 2014, Destination : azure VM
- Source:SQL 2016 & greater version, Destination : azure VM

    ##### 4.1. Above 3 scenarios can be achieved in 2 ways 
    - Take .bak to azure storage and restore to VM.
                Backup the .bak files to URL (storage account).
        
    ##### 4.2. For SQL 2008
    - backups cannot be done to storage account or URL. only way is take backup & copy to azure storage.

    - Use logshipping from on-prem to azure VM.

    - (under Side-by-side upgrade ) Backup restore of SQL 2008 .bak can be restored to SQL 2012/SQL 2014/SQL 2016/SQL 2017/SQL 2019 etc. for (in-place) not possible, as lot of changes to binary/db engine software takes place & leads to complications. (there is thumb rule of n-2 versions for relational DB engine)

    ##### 4.3. For SQL 2012/SQL 2014
    - If there is Always ON between On-Prem & Azure VM, there is a **BIG LIMITATION**. If there is very less downtime for migration, then all the nodes(Node1, Node2) in On-Prem & nodes (Node3, Node4) in Azure VM **SHOULD BE UNDER THE SAME WINDOWS CLUSTER GROUP**. Though very risky, Only then migration will happen.


    #### 4.4. For SQL 2016 and Higher versions >>  
    - If there is always ON between On-prem ( windows cluster1 node1,Node2) & Azure VM ( windows cluster2 Node3,Node4), then we can configure Always on from On-Prem to Azure cloud (also called Distributed AO AG)



### 5. How to choose the right series of CPU, RAM etc?
- Use azure Data studio and input the values in source details, destination details will be analyzed and recommended accordingly.
- For general optimized performance, use E Series : EBS_V4 (memory optimized) for SQL server.
- How to calculate IOPS on an on-prem SQL server to match that of Azure VM?
- There are 2 types of Apps

        CPU bound: look for CPU cycles.
        IO bound: look for IOPS

## _B. PaaS  (ask more questions)_
### What is DB size

1. If size >> 16 TB, cant go with Azure MI instance.(for Business Critical)
2. If size <= 4 TB, only in the General category.

### Are SQL agent jobs required? DB Mail, support for cross db queries, linked servers, windows auth (all these are possible in MI instance, not Azure SQL)

### Native Backups restore from .bak files
- Because Azure SQL does not support .bak restore, but MI instance does.


## Note: 
- Azure MI: Instance as a service
- Azure SQL : database as a service










