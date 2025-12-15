# Interview Questions and Answers Part 14 - db migration methods

##### Reference: https://www.youtube.com/watch?v=7EdmT5qiQGU

Remember:
-----------

Requirement :

    When it comes to DB migration, we need to focus on the target.
    If target is IaaS & source is on-prem: there is OS (operating system) 
    What are all the options?
    If the source versions are 2008 / 2012
    And destination version is SQL 2022

Approach:
---------------
- If Side-by-side migration/upgrade Normal backup & restore strategy: YES
https://www.sqlskills.com/blogs/paul/you-can-upgrade-from-any-version-2005-to-any-other-version/

If In-place upgrade

- N-2 rule applicable to In-Place upgrade.

Note:
------
- Remember the below table for any in-place or side-by-side upgrade task.

    https://drive.google.com/file/d/1eifS3Gb0ZHmyeZYmpKJs9DY6QZYmwkpd/view?usp=drive_link

below approach works Only ENTERPRISE Version, not for Dev / Standard versions 

Scenario 1 
1) if Source = SQL server 2008... SQL 2016
		
        log shipping:
		- is possible but depends on 2 modes of logshipping.
		i.e 
            1) Standby Mode (Not possible, from SQL 2012 to SQL 2022)
            2) NoRecovery Mode (Yes, Possible)
