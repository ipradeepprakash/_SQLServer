# Azure Managed Instance link feature
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

- 







