--To rename instance we can use the following SP

--1. Check the old server name as follows (LAPTOP-57FE7IRR)

SELECT @@servername
--2. Drop the server and add the new server name

SP_DROPSERVER <old_name>
go
SP_ADDSERVER <new name>, local

--3. Restart the instance
--4. Check the server name again
   SELECT @@servername
