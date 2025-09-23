-- status of queries on Specific Database

SELECT 
	DB_NAME(r.database_id) AS DatabaseName,
	 s.session_id AS SPID,
	    s.status AS SessionStatus,
    -- r.status AS RequestStatus,
	st.text AS SqlText,
	 r.wait_type AS WaitType,
    s.login_name AS LoginName,
    s.host_name AS HostName,
    s.program_name AS ProgramName,
	--r.command AS Command,
	r.blocking_session_id AS BlockingSPID,
    r.cpu_time AS CpuTime,
    r.total_elapsed_time AS TotalElapsedTime,
    r.reads AS Reads,
    r.writes AS Writes,
    --r.logical_reads AS LogicalReads,
    r.wait_time AS WaitTime,
    r.wait_resource AS WaitResource,
    -- r.last_wait_type AS LastWaitType,
    r.start_time AS RequestStartTime,
    r.percent_complete AS PercentComplete,
   -- r.database_id AS DatabaseID,
    r.sql_handle
    
FROM 
    sys.dm_exec_sessions AS s
LEFT JOIN 
    sys.dm_exec_requests AS r ON s.session_id = r.session_id
OUTER APPLY 
    sys.dm_exec_sql_text(r.sql_handle) AS st
where 
DB_NAME(r.database_id) like '%adventureworks%'
and s.session_id > 50;
--    s.session_id = 75;


	/*
ORDER BY 
    s.session_id;
	*/
