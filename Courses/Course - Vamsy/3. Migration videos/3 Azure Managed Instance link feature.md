# PART 1: Azure Managed Instance link feature
### Video link: 
- Part1: Youtube link: https://www.youtube.com/watch?v=MRTb7f0kcJg
- Part2: G drive: https://drive.google.com/file/d/1FPd3SKkoFbJmZlOZE-c2DkBiHF7ApUoa/view
### Reference: 
- https://techcommunity.microsoft.com/blog/azuresqlblog/managed-instance-link-%e2%80%93-connecting-sql-server-to-azure-reimagined/2911614/replies/3250803

In the youtube video, Vamsy has installed SQL 2019 on Azure VM & SQL instance on Azure MI Instance.
- No cluster on Azure VM
- There is NO Always On Icon/Folder on Azure MI Instance, so We CANNOT configure Always on to Azure MI Instance. But Vamsy did DAG between Azure VM & Azure MI instance.

**Scenario: For a DB Migration(from SQL 2016 onwards) to Azure MI Instance that has**
- DOWNTIME in less than a few seconds.
- Leverage READ-ONLY workloads to Azure MI instance.

### Steps demonstrated in video
------------------------------
- Created a test DB on Azure VM instance and took a fresh FULL Backup.
- Right click of TEST db and chose ‘Azure SQL Managed instance Link’ (this feature helps to configure DAG from On-Prem / Azure VM to Azure MI Instance)
- ![1.1 Azure MI link in SSMS] (https://drive.google.com/file/d/1jQcFBr1KAs82WK9e0X0XmOBqOb5chTLk/view?usp=drive_link)
- ![1.2 Select ‘Replicate Database’ as shown](https://drive.google.com/file/d/1cCEBOcBdO3ZE64cneHeI0Cpxi-9SFjYD/view?usp=drive_link)
- 1.21 Press ‘Next’ ![](https://drive.google.com/file/d/1tkjBJkNfgGk-l8RUA9aClob7Mcy_fZYN/view?usp=drive_link)
- 1.22 Performs certain checks (https://drive.google.com/file/d/1npwFAKPRMj9SyrZV0zvy1Lv52ibpNDe0/view?usp=drive_link)
- 1.23 (https://drive.google.com/file/d/1KbKOHLdo5tdWp0im946SN_YFUqr7wQVD/view?usp=drive_link)
- 1.24 In next screen, we need to ‘sign in’ to azure account (https://drive.google.com/file/d/1X-luvVAvaI5x3-G_gY05flw5_giMrgb2/view?usp=drive_link)
- 1.25 (https://drive.google.com/file/d/1oKs_co2UUe4fsl3--HLsZpI24i7ir1Dx/view?usp=drive_link)
- 1.26 In the beginning, below components are created (https://drive.google.com/file/d/1G0_CMjSHsPz4EC7r_1UiUg-tge7Ffio4/view?usp=drive_link)
    - Endpoints 
    - Master key & certificate (in master DB)
    - 1.261 (https://drive.google.com/file/d/198eZRkA3ksdWwOIDkni98vW7j8IXqP59/view?usp=drive_link)
    - 1.262 (https://drive.google.com/file/d/1kTNuyn1cAZN_fxeTZmwO6jyb-oKN1dpW/view?usp=drive_link)
    - 1.263 (https://drive.google.com/file/d/1wamQ_STtJfrmnPwGYE7lH2LUcjvO_LT9/view?usp=drive_link)
- 1.27 Testing a script that does insert every second and validate if that same record is replicating to Azure MI Instance.
    --Script
  
        Use TEST
        GO
        create table synctest(sname datetime)
        TRUNCATE TABLE SyncTest
        WHILE 1=1
        BEGIN
        INSERT INTO synctest VALUES (GETDATE())
        WAITFOR DELAY '00:00:01'
        ENd

- 1.28 so, using the “Azure Managed Instance Link” feature we are able to successfully replicate the records between Azure VM & Azure MI instance. (https://drive.google.com/file/d/1MPcYLHcDmb3wjbOtPyPxhFpA5x-4piIW/view?usp=drive_link)
- this Demo with Failover is only 1-sided, i.e. Failover from On-Prem / Azure VM (SQL 2019) to Azure MI Instance.

**Note: 
Failback from Azure MI instance to Azure VM / On-Prem only possible if SQL version is from SQL 2022 and higher (SQL 2025 etc)**

- Once the data is sync between On-Prem / Azure VM & Azure MI instance, we can do FAILOVER to Azure Instance, DB will be live in Azure MI.


# PART 2: Azure Managed Instance link feature

### PROS 
- Scaling out Read-workloads to Azure cloud from On-Prem or Azure IaaS
- Seamless and instance Database migration to Azure MI (in geographically different regions for each databases)

### CONS 
- Azure MI can host only up to 100 Databases. I.e 1 link per database

#### Note:
1. If there is a requirement of migrating Azure Managed instance (MI) to On-Prem, then the SQL instance on On-Prem must be SQL server 2022 Version because reverse failover from Azure MI is only possible for SQL server 2022.
2. We can take a backup of Azure Managed instance (MI) & Restore the same to SQL server 2022 instance.
3. To create managed linked feature on On-prem SQL server as per link
   - https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/managed-instance-link-preparation?view=azuresql&tabs=ssms
       - SQL 2016: we may need to install sp3 
       - SQL 2019: we need to implement the trace flags T1800,T9567
       - Check the below screenshot for CU that needs to be installed before implementing the Managed instance link feature.
    ![1.1 CU For MI instance link feature](https://drive.google.com/file/d/1wJ_ucVwgGcN9JiLzmCimyajR1q7avR2V/view?usp=drive_link)













