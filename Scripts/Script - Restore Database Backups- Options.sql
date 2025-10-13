
-- Script - Database - Restore history

SELECT 
* 
FROM 
msdb.dbo.restorehistory 
WHERE 
destination_database_name = '%dba%'
order by 
restore_date DESC;



/* -- Check DB file details
restore filelistonly from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks2019\AdventureWorks2019_backup_2024_03_12_160002_0410057..bak'

*/

/*
restore headeronly from 
disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks2019\AdventureWorks2019_backup_2024_03_12_160002_0410057..bak'

*/

/*
RESTORE LABELONLY   
FROM
disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks2019\AdventureWorks2019_backup_2024_03_12_160002_0410057..bak'

*/

/*
--RESTORE Statements - REWINDONLY (Transact-SQL)
RESTORE REWINDONLY   
FROM
disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks2019\AdventureWorks2019_backup_2024_03_12_160002_0410057..bak'


*/

/*
RESTORE VERIFYONLY  
FROM 
disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks2019\AdventureWorks2019_backup_2024_03_12_160002_0410057..bak'
*/
