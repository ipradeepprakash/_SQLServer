-- SQL Server Version Information
			DECLARE @version NVARCHAR(4000);
			SELECT @version = 
				'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128)) + ', ' +
				'Edition: ' + CAST(SERVERPROPERTY('Edition') AS NVARCHAR(128));

			-- Print SQL Server Version Information
			select @version as SQL_Server_instance_info;

-- Features Information
DECLARE @features NVARCHAR(MAX);

SET @features = '';

-- Always On Availability Groups
			IF EXISTS (
				SELECT * FROM sys.dm_hadr_availability_group_states
			)
			BEGIN
				SET @features = @features + 'Always On Availability Groups, ';
			END

-- Database Mirroring
			IF EXISTS (
				SELECT * FROM sys.database_mirroring
			)
			BEGIN
				SET @features = @features + 'Database Mirroring, ';
			END

-- Linked Servers
			IF EXISTS (
				SELECT * FROM sys.servers WHERE is_linked = 1
			)
			BEGIN
				SET @features = @features + 'Linked Servers, ';
			END

-- Change Data Capture (CDC)
			IF EXISTS (
				SELECT * FROM sys.databases WHERE is_cdc_enabled = 1
			)
			BEGIN
				SET @features = @features + 'Change Data Capture (CDC), ';
			END

-- Replication
			
			IF EXISTS (
				SELECT * FROM sys.databases WHERE is_published = 1 OR is_subscribed = 1 OR is_merge_published = 1
			)
			BEGIN
				SET @features = @features + 'Replication, ';
			END

-- Failover Clustering
			IF SERVERPROPERTY('IsClustered') = 1
			BEGIN
				SET @features = @features + 'Failover Clustered, ';
				SET @features = @features + 'Cluster Node Count: ' + CAST(SERVERPROPERTY('NumNodes') AS NVARCHAR(10)) + ', ';
				SET @features = @features + 'Cluster Node Names: ';
    
				DECLARE @nodeName NVARCHAR(128);
				DECLARE clusterNodes CURSOR LOCAL FOR 
					SELECT name FROM sys.dm_hadr_cluster_nodes;
				OPEN clusterNodes;
				FETCH NEXT FROM clusterNodes INTO @nodeName;
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @features = @features + @nodeName + ', ';
					FETCH NEXT FROM clusterNodes INTO @nodeName;
				END
				CLOSE clusterNodes;
				DEALLOCATE clusterNodes;
			END

-- Print Features Information
			IF LEN(@features) > 0
			BEGIN
				SET @features = LEFT(@features, LEN(@features) - 2); -- Remove trailing comma and space
				Select 'Enabled Features: ' + @features as Enabled_features;
			END
			ELSE
			BEGIN
				select  'No special features enabled.';
			END;

-- Memory Information
			SELECT 
				(total_physical_memory_kb / 1024 / 1024) AS Total_Physical_Memory_GB,
				(available_physical_memory_kb / 1024 / 1024) AS Available_Physical_Memory_GB,
				system_memory_state_desc AS Memory_State_Description
			FROM 
				sys.dm_os_sys_memory;

-- CPU Information
			SELECT 
				cpu_count AS Total_CPU_Cores,
				hyperthread_ratio AS Logical_Cores_Per_Physical_Core,
				cpu_count * hyperthread_ratio AS Total_Logical_Cores
			FROM 
				sys.dm_os_sys_info;

-- Disk Information
			IF OBJECT_ID('tempdb..#DiskInfo') IS NOT NULL DROP TABLE #DiskInfo;

			CREATE TABLE #DiskInfo (
				DriveLetter CHAR(1),
				FreeSpaceMB DECIMAL(10,2)
			);

-- Insert results from xp_fixeddrives into the temporary table
			INSERT INTO #DiskInfo (DriveLetter, FreeSpaceMB)
			EXEC xp_fixeddrives;

-- Convert MB to GB for better readability
			SELECT 
				DriveLetter,
				(FreeSpaceMB / 1024) AS FreeSpaceGB
			FROM #DiskInfo;

-- Cleanup
			DROP TABLE #DiskInfo;
