# Interview Questions and answers session 8


Video reference: 
- https://drive.google.com/file/d/1BSYn77qCFuoQ6oAyT8aOLE-MMvPY2NJ9/view?usp=drive_link

Video timeline:
--------------
    0:00 - 4:21 // introduction on Cloud services
    4:22 - // difference between Azure, AWS, when to choose Azure MI, Azure SQL?
    29:51 - 32:31// Migrate On-prem dbs to Azure VM(Iaas), Details are as given below 
    34:02 - // Migrate On-prem dbs to Azure SQL(Paas),Azure VM(Iaas) Details are as given below
    32:33 - 34:00// Migrate On-prem dbs to Azure MI(Paas), Details are as given below
    51:10 - 1:16:03 // What if migration is done from On-prem to Azure VM cloud & the performance is slow? What to check & how to approach?



#### 4:22 - // Difference between Azure, AWS
-------------------------------------------------

    AWS EC2: Azure VM’s
    AWS RDS: Mixture of Azure MI & Azure SQL

#### cloud service
------------------------------------------------
- Software Infrastructure service provided over the Internet.
- AWS RDS is a mixture of Azure MI & Azure SQL.
- Basically 3 categories
  - Iaas (Azure VM)
  - Pa  s (Azure MI & Azure SQL)
  -   aas (No service here as of now for DBA)
-   aas: (Azure VM) Instance as a service
- Pass: (Azure MI & Azure SQL)Database as service.

#### When should I choose Azure VM?
- When we have total control of Infra on servers(OS, Patches, etc).
- When we need Operating system support for our app dependencies.
- SSIS, SSRS,SSAS for app use.

#### When should I choose Azure MI?
- Microsoft is providing instance as service in Paas for features like 
	- Instance name
	- System databases
	- Agent jobs, CLR
	- Databases from on-prem with minimal movement to Azure.
	- Can support backup & restore from on-prem to cloud Paas.

#### When should I choose Azure SQL?
- Azure SQL (Database as a service)
- Only database related service & NOT about the server instance level.
- You don't need System Databases.

#### So, if a user needs Windows Authentication for my app, which platform should I choose?
- Iaas (Azure VM with SQL installation like on-prem features uses windows Auth & SQL Auth)
- Azure MI (Paas supports windows Auth & SQL Auth)
- Azure SQL (SQL Auth, Azure AD Auth)

#### How can you connect Azure SQL with Azure AD Auth?
- Azure AD is a new mechanism where users can connect to apps.
- Use either MFA or Password or Integrated (NOT windows Auth)

#### How to create a login on Azure SQL, what is the approach?
- Make use of CLI as we dont have GUI support.
- For SQL Auth login (for Azure SQL, Azure MI, Iaas)
	- **CREATE LOGIN Mylogin123 WITH PASSWORD =’<strong_pwd123>’**
- For Azure AD Auth login for Azure SQL
	- **CREATE LOGIN Mylogin123 FROM EXTERNAL PROVIDER** 
- For Azure AD Auth login for Azure MI (Managed Instance)
	- **CREATE LOGIN Mylogin123 FROM EXTERNAL PROVIDER**

#### How to communicate from one Azure SQL Database to another database in the same Azure SQL?
- We need to use CROSS DATABASE QUERIES (ELASTIC QUERIES).

#### How to communicate from a database in Azure SQL to another database in On-premises?
- EXTERNAL tables.


#### 29:51 - 32:31// Migrate On-prem dbs to Azure VM(Iaas), Details are as given below 
- On-prem (source): SQL 2016
- Destination: Azure VM (Iaas)
- Downtime : < 5 mins
	- DAG (Distributed Availability group)

#### 32:33 - 34:00// Migrate On-prem dbs to Azure MI(Paas), Details are as given below 
- On-prem (source): SQL 2016
- Destination: Azure MI (Paas)
- Downtime : < 5 mins
	- Azure MI link feature

#### 34:02 - // Migrate On-prem dbs to Azure SQL(Paas),Azure VM(Iaas) Details are as given below

**Scenario 1:**

- On-prem (source): SQL 2016
- Destination: Azure SQL(Paas)
- Downtime : good downtime
	- Azure Data studio.
	- BACKPAC (data & Schema)
	- DACPAC (Schema)
	- Transaction Replication

**Scenario 2:**

- On-prem (source): < SQL 2016 (SQL 2008, SQL 2012, SQL 2014)
- Destination: Azure VM(Iaas)
- Downtime : good downtime
	- Log shipping
	- If source=SQL 2012, connectivity from on-prem to Azure VM should be Express routes,Site-to-site VPN(network team) & always On is option explored, then Windows version should be same for clusters in source & destination.
	- For source = sql 2016 & above, we can use DAG as it is compatible with different windows versions in source & destination.

**Scenario 3:**

- On-prem (source): < SQL 2016 (SQL 2008, SQL 2012, SQL 2014)
- Destination: Azure SQL(Paas)
- Downtime : good downtime
- Backup & restore 
	- (while taking backups to Azure storage URL)
	- If No option for backing up to URL, backup to disk, then move to storage container.
- LRS (log replay service) for Azure MI
- Azurer MI Link Feature
- DMS 
- Azure Data Studio (online & Offline)
- Replication.

	**__Note:__**
If source = sql 2017, we cannot use Azure MI link feature. We need to use LRS. but for SQL 2016, SQL 2019 we can use Azure MI Link feature.

#### 51:10 - 1:16:03 // What if migration is done from On-prem to Azure VM cloud & the performance is slow? What to check & how to approach?
- Compatibility level
- Resource comparisons
- Network 
- Disks (it will be different from on-prem to cloud, because each VM will be of different series with certain restrictions on disks, check IOPS)
- <u>Host caching:</u> this has to be **enabled for Data Disks** & __***disabled for Log file disk***__.
- <u>Legacy cardinality estimator:- </u> this has to be same for both On-Prem & Azure VM(from SQL 7.0 till SQL 2012 - same cardinality estimator, from 2014, its different cardinality estimator)
	- Always retain same cardinality on on-prem & cloud, but change the parameter - “legacy cardinality estimator(CE)” to ON which will give older CE from SQL7.o till SQL 2014(default = OFF)
	- Check MAXDOP, if MAXDOP should be changed for specific database, do change under that DB options(dont change MAXDOP at instance level)


