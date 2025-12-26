# Interview questions on 
- Logins
- Groups
- Security
- Proxy accounts



### what is a proxy account in SQL server?
- Whenever Non-System Admins need to Run Non-TSQL job steps, then they need Proxy accounts.

### Trace flag 2312, 9481
- SQL Server trace flag 2312 is used to force the query optimizer to use the SQL Server 2014 (version 120) or later cardinality estimator (CE)


### Can we have AD group for Job Owner?
- No


### Can we have DB owner as AD group?
- No

### Will sp_change_users_login report gives back orphan users at windows level?
- No. sp_change_users_login will give orphan users at SQL level.
but sp_validate_logins will give orphan logins at windows level.



