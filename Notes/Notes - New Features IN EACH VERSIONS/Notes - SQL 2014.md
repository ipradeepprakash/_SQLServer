# Notes - SQL 2014
--------------------
 

## SQL Server : 2014 (12.x) Enhancements
**************************************
- SQL Server 2014 is available in both 32-bit and 64-bit editions. 
- In-memory OLTP (Hekaton):  

- ### AlwaysOn Availability Groups: 
      > One or more databases to fail over as a single unit.  
      > Shared storage was not needed, and replicas could be leveraged to offload backups and reporting workloads from the primary. 
      > Max replicas has increased from Earlier (SQL Server 2012) 4 to 8. 
      > Secondary replica can now be configured on Azure Cloud. 

- ### AlwaysOn Failover cluster instances: 
      > Provides superior instance level protection in clusters using Windows failover cluster & Shared storage . 
      > Earlier each server node should have 1 LUN (disk) which is for failover task, this was imposing limitation when DBAs ran out of Drive letters / mount points. With Cluster Shared Volume (CSV) the issue is addressed. 
      > CSV is used as Shared storage that can be used by many instances as single LUN disk. 

- ### Backups and restore enhancements: 
      > Managed Backups to windows Azure : Backups now can be done on Azure cloud using windows blob storage service. 
      > Backups to URL: Backups done using URL which is associated with Azure storage service. 
      > Encryption for backups: Encryption now supported natively using industry std AES 192, AES 128, AES 256. 

- ### Buffer pool extension: 
      > Non-volatile RAM like SSD (solid state drives) can be added to SQL Server system which will improve I/o performance, reduces latency. 

- ### Resource Governor: 
      > I/O has been added in SQL Server 2014, earlier only CPU, Memory was in Resource governor of previous versions. 

- CardinalityEstimationModelVersion
    > Starting with SQL Server 2014, a new cardinality estimator can be used by the optimizer. You can tell if the plan in question is using the new or the old. 
      The value in Figure 2-8 is 140, signifying the new estimator. If it was 70, it would be the old version from SQL Server 7. 

 

### References:
--------------
      Improved Temp Table Caching in SQL Server 2014:  https://www.sqlpassion.at/archive/2013/06/27/improved-temp-table-caching-in-sql-server-2014/ 
      
      Non-Clustered Indexes on Table Variables in SQL Server 2014:  https://www.sqlpassion.at/archive/2013/06/26/non-clustered-indexes-on-table-variables-in-sql-server-2014/ 
      
      Performance improvements in SQL Server 2014:  https://www.sqlpassion.at/archive/2014/03/18/performance-improvements-in-sql-server-2014/ 
      
      Buffer Pool Extensions in SQL Server 2014:  https://www.sqlpassion.at/archive/2014/03/11/buffer-pool-extensions-in-sql-server-2014/ 
      
  


 

 

 