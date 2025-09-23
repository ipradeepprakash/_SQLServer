/*

-- Tempdb file size increased, troubleshooting steps 
1) check which of the below 3 resource is holding tempdb resources
	i)   Temp User objects : Temp tables, indexes, stored procs, table variables etc
	ii)  Internal Objects  : intermediate result for spools, cursors, sorts, Temp LOB (Large objects) 
	iii) Version store     : under snapshot isolation level, DML queries hold data in tempdb until complete changes are executed.


*/


--check which of the 3 factors is causing issue
USE tempdb;
GO
SELECT
    SUM(user_object_reserved_page_count) AS [user object pages used],
    (SUM(user_object_reserved_page_count) * 1.0 / 128) AS [user object--space in MB],
	SUM(internal_object_reserved_page_count) AS [Internal_Object pages used],
	SUM(internal_object_reserved_page_count)*1.0/128 AS [Internal_Object--space in MB used],
	SUM(version_store_reserved_page_count) AS [version_store pages used],
	SUM(version_store_reserved_page_count)*1.0/128 AS [version_store--space in MB used]

FROM sys.dm_db_file_space_usage;


-- find which session is creating big sized user objects
use master
go

SELECT 
(SUM(unallocated_extent_page_count)*1.0/128) AS [Free space(MB)]
,(SUM(version_store_reserved_page_count)*1.0/128)  AS [Used Space by VersionStore(MB)]
,(SUM(internal_object_reserved_page_count)*1.0/128)  AS [Used Space by InternalObjects(MB)]
,(SUM(user_object_reserved_page_count)*1.0/128)  AS [Used Space by UserObjects(MB)]
FROM tempdb.sys.dm_db_file_space_usage;


--find login time & session status
select login_time, status from sys.dm_exec_sessions where session_id = <session23>

-- find last executed query in session
select * from sys.dm_exec_input_buffer(xyz1,xyz2);


