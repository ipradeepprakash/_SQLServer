

-- https://www.mssqltips.com/sqlservertip/5784/cleanup-sql-server-query-store-data-after-database-restore/

-- Get number of queries stored in Query Store data
	SELECT 
	COUNT(*) NumQueries 
	from 
	sys.query_store_query
	GO


-- Get current size of Query Store data
		SELECT 
		current_storage_size_mb, 
		actual_state_desc
		FROM 
		sys.database_query_store_options
		GO

-- Cleanup SQL Server Query Store
USE [MASTER]
GO
-- Cleaning up old Query Store data
ALTER DATABASE [OldQueryStoreData] SET QUERY STORE CLEAR
GO

