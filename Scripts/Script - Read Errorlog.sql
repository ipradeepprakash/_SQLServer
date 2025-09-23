
-- Checking the current SQL Server instance and SQL Agent logs:
		xp_readerrorlog 0,1 -- Remember 1 for SQL Server instance
		xp_readerrorlog 0,2 -- Remember 2 fro SQL Server Agent


-- Checking for failed logins in our SQL Server instance:
		xp_readerrorlog 0,1,'Login failed' --For SQL Server 2012 and below
		xp_readerrorlog 0,1,"Login failed" --For SQL Server 2014 onwards
 
-- Checking for TempDB related entries in our SQL Server instance:
		xp_readerrorlog 0,1,'TempDB' --For SQL Server 2012 and below
		xp_readerrorlog 0,1,"TempDB" --For SQL Server 2014 onwards

