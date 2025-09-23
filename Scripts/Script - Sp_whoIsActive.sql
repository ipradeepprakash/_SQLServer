/*


		@filter_type = 
						'login',
						'database*',
						'session'
						'host'
						'program'

		@sort_order : no wild cards aupported

		@get_outer_command = 1; -- gets the outer command that encapsules the underlying queries.
			-- sql_text , @sql_command(outer query/stored proc / batch columns will be displayed


*/

---------------------- FILTER -----------------------------
			-- filter the query with values/specifics
					exec sp_whoisactive
									@filter_type = 'database',
									@filter = 'adventure%',
									@output_column_list = '[database_name][session_id][status][sql_text]',
									@get_outer_command = 1;

--------------- Current query / Outer Query/Stored proc / Batch ------------------------------------

		-- show currently executing sql query and its outer query/parent query/stored proc/batch
				exec sp_whoisactive
								@get_outer_command = 1;

/* ----------------- show Execution plans --------------------*/

			-- Get exec plan for CURRENT statement
					exec sp_whoisactive
									@get_plans = 1;

			-- Get exec plan for ALL queries in the Batch/Stored Proc
					exec sp_whoisactive
									@get_plans = 2;


-------------------------- REAL TIME Monitoring ----------------------------

			-- whats REALLY going on now in SQL instance
						/* Sample Activity (Delta Interval in seconds)*/
		
					exec sp_whoisactive
							@output_column_list = '[%delta][%]',
							@delta_interval = 5;


-- ---------------Log SPace / Tansactional Space ---------------

			-- What Filled up Transaction Logs / LOg space	
					exec sp_whoisactive
							@output_column_list = '[database%][start_time][session_id][tran%][login%][sql_text][%]',
							@get_transaction_info=1;




----------------------------------- tempdb ---------------------------------

------------------------ What Filled up TEMPDB	-----------------------------

				exec sp_whoisactive
						@output_column_list = '[database%][session_id][temp%][sql_text][query_plan][wait_info][%]',
						@get_plans=1,
						@sort_order = '[tempdb_current]Desc'



----------------------------------- MEMORY ---------------------------------

------------------------ What Filled up Memory(V12)-----------------------------

				exec sp_whoisactive
						@output_column_list = '[database%][session_id][start_time][%memory][login%][sql_text][%]',
						@get_memory_info = 1;


------------------------------- Blockings ------------------------

				exec sp_whoisactive
						@output_column_list = '[database%][session_id][status][start_time][block%][login%][sql_text][%]',
						@find_block_leaders = 1,
						@sort_order = '[blocked_session_count] Desc',
						@get_locks = 1,
						@get_additional_info = 1;


------------------- capture the ACTIVITY result in table---------------------------
/*create a table to track Activity*/
			DECLARE
			@destination_table varchar(500) = 'WhoIsActive',
			@schema VARCHAR(MAX);

			exec sp_WhoIsActive
				@get_transaction_info = 1,
				@get_plans = 1,
				@return_schema = 1,
				@schema = @schema OUTPUT;


			 set @schema = REPLACE(@schema,'<table_name_123>',@destination_table);
			 Select @schema

/*create a Index on collection_time*/

		create clustered index cx_collection_time 
		on WhoIsActive (collection_time)



/*create a Job*/

		DECLARE
		@destination_table VARCHAR(500) = 'WhoIsActive';

		exec sp_WhoIsActive
				@get_transaction_info = 1,
				@get_outer_command = 1,
				@get_plans = 1,
				@destination_table = @destination_table;

/*Query the table*/

		select * from whoisactive
		where collection_time BETWEEN '2023-03-12 00:00:00' AND '2023-03-12 01:00:00'


































