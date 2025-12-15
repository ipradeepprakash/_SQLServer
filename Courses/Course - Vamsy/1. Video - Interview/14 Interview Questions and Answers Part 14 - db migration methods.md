# Interview Questions and Answers Part 14 - db migration methods to Iaas

##### Reference: https://www.youtube.com/watch?v=7EdmT5qiQGU

Remember:
-----------

Requirement :

    - When it comes to DB migration, we need to focus on the target.
    - If target is IaaS & source is on-prem: there is OS (operating system) 
    What are all the options?
    If the source versions = 2008 / 2012
    And destination version = SQL 2022

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

## Scenario 1 
1) if Source = SQL server 2008... SQL 2016
		
        log shipping:
		- is possible but depends on 2 modes of logshipping.
		i.e 
            1) Standby Mode (Not possible, from SQL 2012 to SQL 2022)
            2) NoRecovery Mode (Yes, Possible)
2) if source = SQL 2017 & above with stand-alone server

	  - instead of traditional answers like Backup/Restores, Logshipping, there are advanced 
     technologies that can be implemented.
	  - if my source = SQL 2017, how to move it to SQL 2022 with very min downtime(< 1 
     min), also this is a stand-alone server.
		>> we can use DAG (Distributed availability Groups) with no cluster, no Always on config required. once DAG is done on both sides, we need to failover the databases during downtime.
        (before SQL 2017, we did not have DAG for clusterless AG. i.e. SQL 2016 had DAG but not clusterless)
3) if source = SQL 2017 & has Always On configured already, Target = SQL 2022.

		- we can use Rolling upgrade technique: works only for operating system   .
        version is (N-1) rule at the destination server.
        
        (if source OS = windows 2016 & destination OS = windows 222, it will not work, as previous version of windows 2022 is windows 2019, so windows 2016 is not compatible for rolling upgrade technique.)

        For example:

        if Node1 , Node2 are part of Source (Cluster_name = cluster_2017, 
              Listener_name = Listener_2017) with OS = windows 2017

        if Node3, Node4 are part of Destination/Target with OS = windows 2019

        During Rolling Upgrade process, destination Node3,Node4 will be part of 
              source cluster cluster_2017 (infra team or DBA team can do this step, 
        
        i.e install failover service and add node3, node4 to the existing source 
              cluster.(Node1,Node2,Node3,Node4))

                - during this phase, cluster validation reports should NOT be executed.
                - Now, add Node3, Node 4 to the existing database AG setup.
                - now, 3 secondary replicas will be there at Source (Node2,Node3,Node4)
                - No Need to change the listener's name.
                - we need to failover from node1 to Node3, Node2 to Node4
                - Initially, add nodes in Sync mode as ASYNC. later, during      
                . Go-Live, when there is NO Data Loss, failover and make it  
                  SYNChronous.
                - once failover happens from source -> destination (i.e. from 
                  lower version to Higher version, there will be NO Log records 
                  moving back to lower version), so Node3 will be New Primary & 
                  node4 will be secondary.
                - decommission of old cluster nodes is by removing databases from 
                  always ON, then remove the nodes from the cluster and finally 
                  decommission all nodes.


## Scenario 2

Source

- OS: windows 2012
- SQL Server: SQL server 2016/2017

Destination

- OS: windows 2019 or windows 2022
- SQL Server: SQL server 2022
- Downtime: <1 min>
- Listener name can be changed.

**Approach:**

		- No Rolling upgrade option can be used, since OS compatibility issues(N-1 at 
          destination).
		- On destination, we will create new cluster with nodes with new listener.
		- We are doing Rolling upgrade with DAG using source & destination servers.
		- Once everything is fine, break the set up in Source & establish 
          Destination using failover from source.
		- Difference here is, Unlike in usual rolling upgrade with Always on AG, we   
          add new nodes to existing Source cluster & migrate. But in Rolling upgrade with 
          DAG, we will create a new cluster in destination server & 
          perform migration.


    **Lift & shift method**

    - When db servers are involved, DBA have very few tasks.
    - This method can be used to move DB servers with
      - Stand-alone
      - Always on

    - DBA steps are
      - Stop the SQL services during downtime.
      - If the environment is clusters, make sure cluster service is running fine.
      - In new clusters (destination), IP of DB Server nodes will change.
      - Configure new IP
      - Start SQL services
      - Ensure binding is there btw new IP & old windows cluster name
      - On source (on-premises) there will be support for MAC Address, 
        broadcasting protocol is supported, so that is the reason DNN is supported 
        on on-premises.
      - Once DB server moved to Azure VM, Azure does NOT support broadcasting     
        protocols, so either DNN or VNN should be used.
      - If app team requires any help for port numbers for only 1433 & app string 
        not willing to user listener with port number then they have to use Load 
        balancer.(because DNN cannot use 1433, but need to use other port)


Summary
----------
- If DB stand-alone server:
    - Not much DBA task involved except for STOP & RESTART SQL services.
- If DB servers are in Always on
    - Ensure you need to go with DNN or VNN
    - If client is NOT willing to pass port number with listener, then we need to use LOAD BALANCER (not DNN, its only when client agrees for using listener name with port 1433)





