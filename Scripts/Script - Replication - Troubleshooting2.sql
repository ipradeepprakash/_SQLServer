-- Replication - Troubleshooting steps - Log Reader Agent - 0 of which were marked for replication 
    		use distributor
    		go
    
    		)
    		select * from MSlogreader_history order by time desc
    		select * from MSdistribution_history order by time desc

-- check article_id associated with table name to check what happening on that table 
    		use distributor
    		go
    		select * from msarticles

-- stop log reader agent, so the below cmd will run (at anytime only 1 logreader agent command cane run
    		sp_replcmds @maxrans = 1

-- under the command column we can see which query/commans is executing
    		sp_replshowcmds @maxtrans = 1
    
    		sp_helppublication
    		dbcc loginfo

-- find total records the log
    		select count(*) from ::fn_dblog(null,null)
    		go
-- find the records marked for replication
    		select count(*) from ::fn_dblog(null,null) where Description = 'Replicate'
    		go
    			   		 


-- probable root cause
		-- 1. too many VLF files
		-- 2. too many non-replicable commands at source (on publisher server), so log reader agent has to scan all the records to find replicable transaction.

-- solution: 
		-- 1. Reinitialize subscription
		-- 2. ask if you can skip transaction & perform sp_repldone & then reinitialize the subscription
		-- 3. if app team says, if the above trans is not required, then uncheck the required article from publisher and click OK. the log reader agent will skip this ongoing transaction.
		-- 4. save & close all sessions. restart the log reader agent.

/*********************************REPLICATION AGENTS***********************************


/*
      /*----------------------------------Logreader agent--------------------------------*/
    
    --Following queries list all the log agent jobs, including push subscriptions and pull subscriptions. 
    -- (You may need add more clause to customize your queries). By default, the SQL Server agent job names equal to the log reader agent names.

*/

      use distribution
      
      if not exists(select 1 from sys.tables where name ='MSreplservers')
      
      begin
      
      			select 
      			job.name JobName, a.name AgentName, publisher_db,s.name as publisher
      			From MSlogreader_agents a inner join sys.servers s on a.publisher_id=s.server_id
      			Inner join msdb..sysjobs job on job.job_id=a.job_id
      
      end
      
      	else
      
      			begin
      
      					select 
      					job.name JobName, a.name AgentName, publisher_db,s.srvname as publisher
      					From MSlogreader_agents a inner join MSreplservers s on a.publisher_id=s.srvid
      					Inner join msdb..sysjobs job on job.job_id=a.job_id
      
      			end



/*
		/* -------------------------------- 2.Merge agent----------------------------*/

				-- Following queries list all the merge agent jobs, including push subscriptions and pull subscriptions. 
				-- (You may need add more clause to customize your queries). By default, the SQL Server agent job names equal to the merge agent names.

*/
		use distribution---in distributor server

		if not exists(select 1 from sys.tables where name ='MSreplservers')

		begin

				select 
						job.name JobName, a.name AgentName, a.publisher_db,
						a.publication as publicationName,sp.name as publisherName ,
						ss.name as subscriber,a.subscriber_db, a.local_job 
				From 
						MSmerge_agents a
						inner join sys.servers sp on a.publisher_id=sp.server_id--publisher
						inner join sys.servers ss on a.subscriber_id =ss.server_id--subscriber
						left join msdb..sysjobs job on job.job_id=a.job_id


		end

		else
			begin

					select 
							job.name JobName, a.name AgentName, a.publisher_db,
							a.publication as publicationName,sp.srvname as publisherName ,
							ss.srvname as subscriber, a.subscriber_db,a.local_job 
					From  	MSmerge_agents a
							inner join msreplservers sp on a.publisher_id=sp.srvid--publisher
							inner join msreplservers ss on a.subscriber_id =ss.srvid--subscriber
							left join msdb..sysjobs job on job.job_id=a.job_id
					end


-- For push subscription, you can use the job name directly to find the job in distributor server.
			use subdb6--in subscriber server
			go
				select 
					job.name, 
					sub.publisher,
					sub.publisher_db,
					sub.publication 
			from  
					msdb..sysjobs job 
					inner join msdb..sysjobsteps 
					jobStep on 
					job.job_id=jobStep.job_id
					inner join 
					MSsubscription_properties sub 
					on sub.job_step_uid=jobStep.step_uid


-- For  pull subscriptions(local_job=0), you need to run following query in the subscription database in subscriber server.




