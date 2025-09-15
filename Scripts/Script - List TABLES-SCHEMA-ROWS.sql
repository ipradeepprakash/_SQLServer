/*
Check
- Table Row counts
- Table Constraints
- Table Names
- Schema with Table Names & Indexes
Ref: https://www.sqlshack.com/different-ways-to-search-for-objects-in-sql-databases/#:~:text=We%20can%20use%20system%20catalog,value%20for%20the%20type%20column.

*/


-- Check Table constraints
				use AdventureWorks2019
				go
				SELECT *
				FROM information_schema.CHECK_CONSTRAINTS


/*--List Tables in Database-----------------------*/

				select * 
				from INFORMATION_SCHEMA.tables
				where TABLE_TYPE = 'base table'
				order by TABLE_SCHEMA
		
		
				select distinct (table_schema) from INFORMATION_SCHEMA.tables
		
				select table_schema, count(table_schema) as count
				from 
					INFORMATION_SCHEMA.tables 
					group by table_schema
					order by count DESC


-- Shows all user tables and row counts for the current database 
-- Remove is_ms_shipped = 0 check to include system objects 
-- i.index_id < 2 indicates clustered index (1) or hash table (0) 
				SELECT 
					o.name,	ddps.row_count 
				FROM sys.indexes AS i
		  			INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
		  			INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
		  			AND i.index_id = ddps.index_id 
				WHERE i.index_id < 2  AND o.is_ms_shipped = 0 ORDER BY ddps.row_count desc
				--o.NAME desc


-- List all schema, object name & its associated Indexes

		USE AdventureWorks2019
		GO
		SELECT
				   sc.name as schema_name,
				   so.name as object_name,
				   si.name as index_name
		   FROM 
				   sys.partitions AS p JOIN sys.objects as so on p.object_id=so.object_id
			   JOIN sys.indexes as si on p.index_id=si.index_id and p.object_id=si.object_id
			   JOIN sys.schemas AS sc on so.schema_id=sc.schema_id
		

