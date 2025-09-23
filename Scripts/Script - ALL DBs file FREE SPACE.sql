
/*
Check free space in 2 Methods
- Database Files


*/



/*--------------------Method1: CHECK: Free space in ALL Database files --------------------------*/
                DECLARE @databaseList as CURSOR;
                DECLARE @databaseName as NVARCHAR(500);
                DECLARE @tsql AS NVARCHAR(2000);
                  
                CREATE TABLE ##FreeSpace
                (
                    [DbName] varchar(1000),
                    [FreeSpaceInMb] DECIMAL(12,2),
                    [Name] varchar(1000),
                    [Filename] varchar(1000)
                );
                 
                SET @databaseList = CURSOR  LOCAL FORWARD_ONLY STATIC READ_ONLY 
                FOR
                        SELECT QUOTENAME([name])
                       FROM master.dbo.sysdatabases -- FOR SQL Server 2000 if you are doing archeological sql work. there is no sys.databases
                       WHERE DATABASEPROPERTYEX([name], 'Status') = 'ONLINE' -- version will be zero if the database is offline.
                       and [name] <> 'tempdb'
                        
                OPEN @databaseList;
                FETCH NEXT FROM @databaseList into @databaseName;
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    SET @tsql = N'
                    USE ' + @databaseName + ';
                    INSERT INTO ##FreeSpace
                SELECT ''' + @databaseName + ''' as DbName,
                        CAST(CONVERT(DECIMAL(12,2),
                            Round((t1.size-Fileproperty(t1.name,''SpaceUsed''))/128.000,2)) AS VARCHAR(10)) AS [FreeSpaceMB],
                       CAST(t1.name AS VARCHAR(500)) AS [Name], 
                       Filename
                FROM ' + @databaseName + '.dbo.sysfiles t1;';
                    EXECUTE (@tsql);
                 
                    FETCH NEXT FROM @databaseList into @databaseName;
                END
                CLOSE @databaseList;
                DEALLOCATE @databaseList;
                 
                 
                SELECT * FROM ##FreeSpace
                ORDER BY 
                --FreeSpaceInMb desc;
                dbname 
                
                DROP TABLE ##FreeSpace;


/*--------------------Method2: CHECK: Free space in ALL Database files --------------------------*/

				CREATE TABLE #FileSize
				(dbName NVARCHAR(128), 
					FileName NVARCHAR(128), 
					type_desc NVARCHAR(128),
					CurrentSizeMB DECIMAL(10,2), 
					FreeSpaceMB DECIMAL(10,2)
				);
    
				INSERT INTO #FileSize(dbName, FileName, type_desc, CurrentSizeMB, FreeSpaceMB)
				exec sp_msforeachdb 
				'use [?]; 
				 SELECT DB_NAME() AS DbName, 
						name AS FileName, 
						type_desc,
						size/128.0 AS CurrentSizeMB,  
						size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 AS FreeSpaceMB
				FROM sys.database_files
				WHERE type IN (0,1);';
    
				SELECT dbName, FreeSpaceMB,CurrentSizeMB,FileName
				FROM #FileSize
				WHERE dbName NOT IN ('distribution', 'master', 'model', 'msdb')
				order by dbName 
				--AND FreeSpaceMB > ?;
    
				DROP TABLE #FileSize;


