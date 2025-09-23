	
/*
select 'use [master]'
select 'go'
select 'Restore database' + ' ' + name + ' with RECOVERY;' + CHAR(10) from sys.sysdatabases
where dbid > 4
*/

-- dynamic SQL
declare @sql nvarchar(max) = ''

select @sql = @sql + 
'Use MASTER' +char(10)+'GO'+char(10)+
'Restore Database ' + QUOTENAME(name) + '' + ' Set Recovery' +char(10) + 'GO'+char(10)
from sys.databases
where database_id > 4

print @sql
