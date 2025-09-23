
-- Check - Replication & CDC if enabled
		SELECT 
				  name AS DatabaseName,
				  state_desc,
				  user_access_desc,
				  recovery_model_desc, 
				  compatibility_level,
				  case 
						when is_read_only = 0 then 'Yes'
						else 'No'
						end as ReadOnly,
				  case
						when is_cdc_enabled = 1 then 'CDC Enabled'
						else 'No'
						end AS CDCEnabled,

				 case 
						when is_encrypted = 0 then 'No'
						else 'Yes'
						end as Encrypt_DB,

				  CASE 
						WHEN is_published = 1 THEN 'Publisher'
						WHEN is_subscribed = 1 THEN 'Subscriber'
						WHEN is_distributor = 1 THEN 'Distributor'
						ELSE 'No'
						END AS ReplicationConfiguration,

				  case
						when [is_published] = 1 then 'Replication(Publisher)'
						else 'No'
						end AS Is_Publisher,

				  case
						when [is_subscribed] = 1 then 'Replication(subscriber)'
						else 'No'
						 end AS Is_subscriber,

				  case
						when [is_distributor] = 1 then 'Replication(distributor)'
						else 'No'
						end AS Is_distributor

		FROM master.sys.databases
		WHERE database_id > 4 -- Exclude system databases

