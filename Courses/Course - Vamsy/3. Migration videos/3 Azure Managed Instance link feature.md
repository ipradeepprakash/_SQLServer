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

4. Disk types for Azure MI: Premium SSD

### Steps 
---
1. Create database master key on Source (IaaS)
2. Check if always on availability option is enabled using script
    a. -- Run on SQL Server
    b. -- Is the availability groups feature enabled on this SQL Server

``` DECLARE @IsHadrEnabled sql_variant = (select SERVERPROPERTY('IsHadrEnabled'))
SELECT
    @IsHadrEnabled as 'Is HADR enabled',
    CASE @IsHadrEnabled
        WHEN 0 THEN 'Availability groups DISABLED.'
        WHEN 1 THEN 'Availability groups ENABLED.'
        ELSE 'Unknown status.'
    END
    as 'HADR status'
```

3. Now i have to configure some connectivity to talk to Azure Managed instance.

    3.1) if you are coming outside of Azure cloud, ensure either of below connection
    - site-to-site VPN Connection.
    - Azure ExpressRoute connection

    3.2) if you are coming within Azure cloud & within Same Vnet, you DO NOT need anything 
    3.3) if you are coming within the Azure cloud & outside of a different Vnet, you need Virtual Network Peering.

4. The Network Security Group (NSG) rules on the subnet hosting managed instance needs to allow:
    - Inbound traffic on port 5022 and port range 11000-11999 from the network hosting SQL Server

5. Firewall on the network hosting SQL Server, and the host OS needs-to allow:
    - Inbound traffic on port 5022 from the entire subnet range hosting SQL Managed Instance

6. Test the connection from Source (Iaas) to Azure MI via powershell command
    - Tnc <Azure MI instance> port 5022
7. We cant test the connectivity from Azure MI to source (Iaas/On-Prem), so 
    - Create a test endpoint
    - Use SQL agent with Powershell TNC command to ping Source server.
    - For creating endpoint, we need authentication, for that Auth -> we need certificate -> for certificate, we need DMK(database master Key).
        -- run on SQL Server
        -- Create the certificate meeded for the test endpoint
    ```
            USE MASTER
            CREATE CERTIFICATE TEST_CERT
            WITH SUBJECT = N'Certificate for SQL Server', EXPIRY_DATE = N'3/30/2051'
            Go

            -- Create the test endpoint om SQL Server
                USE MASTER
                CREATE ENDPOINT TEST_ENDPOINT
                STATE=STARTED
                AS TCP (LISTENER_PORT=5022, LISTENER_IP = ALL)
                FOR DATABASE_MIRRORING (
                ROLE=ALL,
                AUTHENTICATION = CERTIFICATE TEST_CERT,
                ENCRYPTION = REQUIRED ALGORITHM AES	
                )

    ```
8. Now, create a SQL agent on SQL Managed instance (MI) with below script (check syntax and Iaas IP Address)
```
-- Run on managed instance
-- SQL_SERVER_IP_ADDRESS should be an IP address that could be accessed from the SQL Managed Instance host mac
DECLARE @SQLServerIpAddress NVARCHAR(MAX) = "<SQL_SERVER_IP_ADDRESS>" -- insert your SQL Server IP address in
DECLARE @tncCommand NVARCHAR(MAX) = 'tnc ' + @SQLServerIpAddress + ' -port 5022 -InformationLevel Quiet'
DECLARE @jobId BINARY(16)

IF EXISTS(select * from msdb.dbo.sysjobs where name = 'NetHelper') THROW 70000, 'Agent job NetHelper already',1

-- To delete NetHelper job run: EXEC msdb.dbo.sp_delete_job @job_name=N'NetHelper'

EXEC msdb.dbo.sp_add_job @job_name=N'NetHelper',
@enabled=1,
@description=N'Test Managed Instance to SQL Server network connectivity on port 5022.',
@category_name=N'[Uncategorized (Local)]',
@owner_login_name=N'cloudSA', @job_id = @jobId OUTPUT

EXEC msdb.dbo.sp_add_jobstep @job_id-@jobId, @step_name=N'TNC network probe from MI to SQL Server',
@step_id=1,
@os_run_priority=@, @subsystem=N'PowerShell',
@command - @tncCommand,
@database_name=N'master',
@flags=40

EXEC msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
```

- Next, Create stored procedure on Azure MI to fetch the above job result details.
```
IF EXISTS(SELECT * FROM sys.objects WHERE name = 'ExecuteletHeIper')
THROW 70001, 'Stored procedure ExecuteNetHelper already exists. Rename or drop the existing procedure before',1
GO

CREATE PROCEDURE ExecuteNetHelper AS
-- To delete the procedure run: DROP PROCEDURE ExecuteNetHelper
BEGIN
-- Start the job.
DECLARE @NetHelperstartTimeUtc datetime = getutcdate()
DECLARE @stop_exec_date datetime = null
EXEC msdb.dbo.sp_start_job @job_name = N'NetHelper'

-- Wait for job to complete and then see the outcome.
WHILE (@stop_exec_date is null)
BEGIN

-- Wait and see if the job has completed.
WAITFOR DELAY '00:00:01'
SELECT @stop_exec_date = sja.stop_execution_date
FROM msdb.dbo.sysjobs sj JOIN msdb.dbo.sysjobactivity sja ON sj.job_id = sja.job_id
WHERE sj.name = 'NetHelper'

-- If job has completed, get the outcome of the network test.
IF (@stop_exec_date is not null)
BEGIN
SELECT 
sj.name JobName, sjsl.date_modified as 'Date executed', sjs.step_name as 'Step executed", sjsl.log as'
FROM
msdb.dbo.sysjobs sj
LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON sj.job_id = sjs.job_id
LEFT OUTER JOIN msdb.dbo.sysjobstepslogs sjsl ON sjs.step_uid = sjsl.step_uid
WHERE
sj.name = 'NetHelper'

END

-- In case of operation timeout (90 seconds), print timeout message.
IF (datediff(second, @NetHelperstartTimeUtc,getutcdate()) > 90)
BEGIN
SELECT 'NetHelper timed out during the network check. Please investigate SQL Agent logs for more in format:'
BREAK;
END
END
END


```

- Run the stored procedure on Azure MI : EXEC ExecuteNetHelper
- Figure1 exec ExecuteNetHelper (https://drive.google.com/file/d/1yfRXzIpHa-SHvYWajNBb8MDijQUzCh2f/view?usp=drive_link)
- Now, on Source (Iaas), select the DB -> right click & select ‘Azure SQL managed Instance Link’ (https://drive.google.com/file/d/1uyIRhln-GR3497P8Zs_m8ruKuvOMr0_U/view?usp=drive_link)
- Now, check connect of port 5022 in Iaas & should show success (check after endpoint is created)
    - Tnc localhost -port 5022 





