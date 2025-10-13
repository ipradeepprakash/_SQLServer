


/*------------- Backup Location-----------------*/

SELECT  
    database_name,  
    backup_finish_date,  
    CASE msdb..backupset.type  
        WHEN 'D' THEN 'Database'  
        WHEN 'L' THEN 'Log'  
    END AS backup_type,  
    physical_device_name
	--, device_type  
FROM msdb.dbo.backupmediafamily  
INNER JOIN msdb.dbo.backupset  
    ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
--WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 1)  
ORDER BY database_name,backup_finish_date 

/*------------- backup loctaion -------------
select  
		top 500 a.server_name, 
		a.database_name,backup_start_date, backup_finish_date, 
		 --a.backup_size,
        		CASE a.[type] -- Let's decode the three main types of backup here
        		 WHEN 'D' THEN 'Full'
        		 WHEN 'I' THEN 'Differential'
        		 WHEN 'L' THEN 'Transaction Log'
        		 ELSE a.[type]
        		END as BackupType
        		 ,b.physical_device_name  ,a.name
 from 
		msdb.dbo.backupset a join msdb.dbo.backupmediafamily b on a.media_set_id = b.media_set_id
where 
		a.database_name Like '%model%' 
		and 
		a.type like 'D'
		order by a.backup_finish_date desc
		
		
