# Interview Questions on Azure part-1 (Vamsy DBA Training)
Reference: 
- https://drive.google.com/file/d/1tN2Wne_81LgaYxIpC0LdkbbHxYkaOEgm/view
- https://youtu.be/DufC1SQd5bg

## Basic questions

1. What are all the cloud models available w.r.t to database realm?

- Iaas 	: VM, Storage
- Paas 	: Azure SQL DB, Azure MI
- Saas 	: n/a

2. Have you worked on Database Migrations?

A. Iaas (ask more questions)
-       If worked only on Iaas - briefly answer only related to Iaas, if no work done on Paas, its ok.

B. My question to interviewer

        - If client willing to go with the OS (Operating system) (No - rule out the need for PaaS)
        - Does the client need any components like (if Yes and need Pass features  - not native flavours, i.e. Power BI for SSRS, ADF for SSIS, SSAS - Azure datawarehouse / Azure synapse )
            SSIS (supported in Azure VM)
            SSAS  (supported in Azure VM)
            SSRS  (supported in Azure VM)
3. If the app existing one or the New/redesigned app.

        - If an existing app cannot make any code changes then - Azure MI, Azure SQL so, it will be a direct migration step with Backup & restore to MI,Azure SQL. else, it will be a migration to Azure VM similar to on-prem SQL.
        - If a new app - ppl go with Azure SQL.

4. If my source is 
- Source: SQL 2008, Destination : azure VM
- Source:SQL 2012/SQL 2014, Destination : azure VM
- Source:SQL 2016 & greater version, Destination : azure VM

-       Above 3 scenarios can be achieved in 2 ways 
                Take .bak to azure storage and restore to VM.
                Backup the .bak files to URL (storage account)


