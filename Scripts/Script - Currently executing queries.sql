-- currently executing queries

SELECT 
		T.[text], P.[query_plan], S.[program_name], S.[host_name],
		S.[client_interface_name], S.[login_name], R.*
FROM 
sys.dm_exec_requests R
		INNER JOIN sys.dm_exec_sessions S 
		ON S.session_id = R.session_id
		CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS T
		CROSS APPLY sys.dm_exec_query_plan(plan_handle) As P
GO

