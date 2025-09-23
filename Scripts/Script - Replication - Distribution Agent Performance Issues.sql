-- Replication - Distribution Agent Performance Issues 
    -- step: insert tracer token to check the time taken to reach packets from publisher to distributor

      -- step: check history
      use distributor
      go
      
      
      select * from MSlogreader_history 
      --where time > ''
      order by time desc
      
      
      select * from MSdistribution_history 
      --where time > ''
      order by time desc
      
      -- sp_whoisactive
      
      select * from Msdistribution_agents
      select * from Mslogreader_agents

      
      -- run the below command for several time till we get stats and other related info.
      -- it could be due to blocking / locking for longtime. so check sp_whoisactive. 
      
      select * from MSdistribution_history where time > '[date_and_Time]' and agent_id = [agent_id_123] order by time desc
      












