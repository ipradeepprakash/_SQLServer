

/*Make sure temp table doesn't exist*/

IF OBJECT_ID(N'tempdb.dbo.#FSFiles', N'U') IS NOT NULL
    DROP TABLE #FSFiles;
/*Create temp table*/
CREATE TABLE #FSFiles
  (  [DatabaseID]    [SMALLINT] NULL,
     [FSFilesCount]  [INT] NULL,
     [FSFilesSizeGB] [NUMERIC](15, 3) NULL);

/*Cursor to get FILESTREAM files and their sizes for databases that use FS*/
		DECLARE @DBName  NVARCHAR(128),
				@ExecSQL NVARCHAR(MAX); 

		DECLARE DBsWithFS CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
		SELECT DISTINCT DB_NAME(database_id)
		FROM   sys.master_files
		WHERE  [type] = 2;

		OPEN DBsWithFS; 

		FETCH NEXT FROM DBsWithFS INTO @DBName;

		WHILE @@FETCH_STATUS = 0
		  BEGIN
			  SET @ExecSQL = N'USE ['+@DBName+N'];
			  INSERT INTO #FSFiles ([DatabaseID],[FSFilesCount],[FSFilesSizeGB])
			  SELECT DB_ID(),
			   COUNT([type]),
			   CAST(SUM([size] * 8 / 1024.00 / 1024.00) AS NUMERIC(15, 3)) 
			   FROM sys.database_files
			   WHERE  [type] = 2
			   GROUP  BY [type];';
			  EXEC (@ExecSQL);
			  FETCH NEXT FROM DBsWithFS INTO @DBName;
		  END;

		CLOSE DBsWithFS;
		DEALLOCATE DBsWithFS;

/*Return database files and size info*/
		SELECT d.[name] AS [Database],
			   d.[state_desc] AS [DatabaseState],
			   SUM(CASE
					 WHEN f.[type] = 0 THEN 1
					 ELSE 0
				   END) AS [DataFiles],
			   CAST(SUM(CASE
						  WHEN f.[type] = 0 THEN ( f.size * 8 / 1024.00 / 1024.00 )
						  ELSE 0.00
						END) AS NUMERIC(15, 3))  AS [DataFilesSizeGB],
			   SUM(CASE
					 WHEN f.[type] = 1 THEN 1
					 ELSE 0
				   END)                          AS [LogFiles],
			   CAST(SUM(CASE
						  WHEN f.[type] = 1 THEN ( f.size * 8 / 1024.00 / 1024.00 )
						  ELSE 0.00
						END) AS NUMERIC(15, 3))  AS [LogFilesSizeGB],
			   ISNULL(fs.FSFilesCount, 0)        AS [FILESTREAMContainers],
			   ISNULL(fs.FSFilesSizeGB, 0.000)   AS [FSContainersSizeGB],
			   CAST(SUM(f.size * 8 / 1024.00 / 1024.00) AS NUMERIC(15, 3))
			   + ISNULL(fs.FSFilesSizeGB, 0.000) AS [DatabaseSizeGB]
		FROM   sys.master_files AS f
			   INNER JOIN sys.databases AS d ON f.database_id = d.database_id
			   LEFT JOIN #FSFiles AS fs ON f.database_id = fs.DatabaseID
		GROUP  BY d.[name], d.[state_desc], fs.FSFilesCount,fs.FSFilesSizeGB
		ORDER BY [DatabaseSizeGB] DESC;

/*Drop temp table*/
IF OBJECT_ID(N'tempdb.dbo.#FSFiles', N'U') IS NOT NULL
    DROP TABLE #FSFiles;
