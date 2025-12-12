# Distributed Always on Availability Group (DAG) between On-prem and Azure VM

# Video link: 
- https://drive.google.com/file/d/1UmOp3dAO8iR20HZpUlkN3eMMCOJilrV7/view?usp=drive_link

Use DAG if the source (on-Prem with difft domain) & destination (Azure with difft domain) window OS is different & want to do cutover with very little downtime.

- DAG works/supports from SQL 2016 version.
- DAG works between 2/more different clusters.

![DAG Basic Criteria](https://drive.google.com/file/d/1xeAHjAyeOprCilZtMuK2yXINuNQ3ce7i/view?usp=drive_link)


## First things first

1. Create a windows failover cluster at On-Prem Server.
2. Create a windows failover cluster at Azure VM Server.

### Create cluster with Node/s in On-prem

------------------------------------------------------
### 1. Select cluadmin from windows & proceed to add nodes to cluster with all details
![1 Select cluadmin from windows - proceed to add nodes](https://drive.google.com/file/d/1IgKz3YO_NFwTQRWzMByWuRzIOnHzPrXL/view?usp=drive_link)

Note: same screen will not  be visible in Azure VM since it follows DHCP protocol & allocates any of the IP’s available with its node.

### 2. Create a different cluster on Azure VM
—-------------------------------------------------
- 2.1 Similar steps as above, but at below step, we need to validate & correct the IP as Azure VM will follow DHCP protocol & takes any of the Nodes IP. ![2 correct the IP as Azure VM will follow DHCP protocol](https://drive.google.com/file/d/1mqp1qnlBxOWL8NsBHAqEmUsu_mbJMQEq/view?usp=drive_link)
- 2.2 In Azure VM, while configuring cluster, NO IP will be asked, instead it asks for cluster name. I.e. it goes with DNN (distributed Network Name) ![it goes with DNN](https://drive.google.com/file/d/1hbNrUAaPuii1zTWzmJXBLEi6PolBJ8AA/view?usp=drive_link)
- 2.3 Its the nature of windows on Azure VM

**Note:**
**- if you are working on DAG and migrating databases from On-Prem to Azure, ensure you failover cluster is not created like the above (DNN), because DAG will not be supported on DNN. so DNN muts be modified to have an IP in the above figure (so, a normal Cluster should be created in Azure VM similar to On-Prem server)**

  - 2.33 ![2.33 DNN modification](https://drive.google.com/file/d/1zoOCg0HaC66zZCrRc4JcknfapX5od9qO/view?usp=drive_link)
- 2.4 So, to create a cluster with pacific IP on Azure VM, we need to use Powershell command shown below
# Powershell command: To create a Cluster in Azure VM with IP
----------------------------------------------------------
  ```New-Cluster -Name <Cluster_Name123> -Node <Node123.site123.com>,<Node456.site456.com> -staticAddress <IP_Address> -NoStorage -AdministrativeAccessPoint ActiveDirectoryAndDns -ManagementPointNetworkType singleton```
- 2.41 create cluster in Azure VM with IP (https://drive.google.com/file/d/14-gkMKjkjBnLUdCSUFP0ud0QHyRdr6LW/view?usp=drive_link)
- 2.5 Press OK (for Cluster on Server) ![Press OK](https://drive.google.com/file/d/1EHV4ut77ArrKwNp1WrD8QtpGWTppmg9u/view?usp=drive_link)
- 2.51 https://drive.google.com/file/d/1cUFPsyyKC-AsSyXw2o5_w1MCftEfg5fL/view?usp=drive_link
- 2.6 For SQL server, DAG will not work if Windows server has DNN. however, for Windows level, DNN does not matter as it used LOAD BALANCER.
- 2.7 Once cluster are configured on On-prem & Azure VM. we will see if Normal AG database configuration works or not? ![2.7 Normal AG](https://drive.google.com/file/d/15_zEO_2IIkD7GBCw4FiS2d-4RvB1j611/view?usp=drive_link)
- 2.8 Since in our scenario, only 1 node at On-Prem we cant add another Replica & also NEXT Button is Greyed out.
- 2.9 So CANCEL & proceed for next Alternative.![Cancel](https://drive.google.com/file/d/1RXpWStJ9qx9KlEjxPxKOAPwb-8dDMUaR/view?usp=drive_link)
- 3.0 In the above screenshot, we cannot have Endpoint created, so manually have to take care. ![Manual Endpoint](https://drive.google.com/file/d/1f0jcNfaNhxvAkECxsuOSS6ui89JNf34v/view?usp=drive_link)
- 3.1 Create LISTENER Manually
- 3.2 also ensure Seeding mode = AUTOMATIC ![3.2 Automatic Seeding mode](https://drive.google.com/file/d/1ufGI6wLLln-Wb0oGl5kIclfE_V3mT9y3/view?usp=drive_link)
- 3.3 Add listener with details ![3.3 Add listener](https://drive.google.com/file/d/11GomYr1IpEE2Zw-pLOs_pVe0zqV8BOU-/view?usp=drive_link)
    - Lets check ENDPOINT
    - Enter PORT number
    - Enter LISTENER NAME
    - Enter STATIC IP address
    - We need to have connect permissions to our end
- 3.3 Create Always ON on Azure VM ![3.3 Create Always ON on Azure VM](https://drive.google.com/file/d/11GomYr1IpEE2Zw-pLOs_pVe0zqV8BOU-/view?usp=drive_link)
    - Follow the similar steps done on On-Prem server.
    - Except that NO DATABASE should be selected for DAG while configuring Always ON as shown.
    - Once Always on is created, all the databases will be created from On-Prem to Azure VM, also ensure Seeding mode = AUTOMATIC
- 3.4 ![ Create LISTENER on Azure VM ](https://drive.google.com/file/d/1uuZ2aiAGHpdiMnXzGNDp6WjgnXmaM8YJ/view?usp=drive_link)
- 3.5 Since we created LISTENER in Azure VM, we need to create a LOAD BALANCER with associated powershell commands.
- 3.6 DAG will work only when LOAD BALANCERS are created.
- 3.7 Create LOAD BALANCER ![Create LOAD BALANCER](https://drive.google.com/file/d/1rnHYw3CfT-IdywKdPjT-V1vFdjM7siWp/view?usp=drive_link)
- 3.8 load balancer creation ![3.8 load balancer creation](https://drive.google.com/file/d/1J9TK_7jO02hF6-RrAPxwD_F8r4RP5ql5/view?usp=drive_link)
- 3.9 load balancer creation2![3.9 load balancer creation](https://drive.google.com/file/d/1S22vlnA9s1-SaZ9m3Ij1pk0QknBKRhaR/view?usp=drive_link)
- 3.10 load balancer creation ![load balancer creation 3.10](https://drive.google.com/file/d/1pux2fr3GP8VHlb6iTU093djtMqgV7T1x/view?usp=drive_link)
- 3.11 load balancer creation ![load balancer creation 3.11](https://drive.google.com/file/d/1-8RUmcpu-MTWnkShcEPRMRH2QPOjZvR8/view?usp=drive_link)
- 3.12 load balancer creation ![3.12 load balancer creation ](https://drive.google.com/file/d/1ntK10QKChFUnLKbm8cIIExSBBgMy0Y2V/view?usp=drive_link)
- 3.13 load balancer creation ![3.13 load balancer creation](https://drive.google.com/file/d/1IZQWaq2ILbFMrptV8aynp2E9ARc5ewqy/view?usp=drive_link)
- 3.14 load balancer creation ![3.14 load balancer creation](https://drive.google.com/file/d/1ZC1cq8l6HTtb8W6hDyakqwhq6lqBv45j/view?usp=drive_link)
- 3.15 load balancer creation ![3.15 load balancer creation ](https://drive.google.com/file/d/1--qqxi5OdJOkj30BEgPKs0I3l9K66DuX/view?usp=drive_link)
- 3.16 Create a new HEALTH PROBE as shown
- 3.17 ![3.17](https://drive.google.com/file/d/10xrLfUU0LDLnWNBlPS9WAr0YKbNhOYsE/view?usp=drive_link)
- 3.18 ![3.18](https://drive.google.com/file/d/1nN2vQxKxhe47QyAaQHl-tgJNXtjh_RHA/view?usp=drive_link)
- 3.19 ![3.19](https://drive.google.com/file/d/11FMCRFfBYmt96bNY5K_Gr7HKKZiYbP1l/view?usp=drive_link)
- 3.20 ![3.20](https://drive.google.com/file/d/18__wpr6BSmb6m-y4PxL3x_5uku2e1rnu/view?usp=drive_link)
- 3.21 Forgotten point: We need to add special rule for 5022 for DAG ![3.21](https://drive.google.com/file/d/1uryqnOD5mOiQRm4u73FPHdksM6DO8toy/view?usp=drive_link)
  - https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/availability-group-load-balancer-portal-configure?view=azuresql
  - So add 1 more rule to LOAD BALANCER.
- 3.22 # Powershell command: For DAG creation, make changes to cluster config via powershell (make necessary changes to the parameters according to your Server IP, config details)
- ```
    SClusterNetworkNane = "Cluster Network 1"
    SIPResourceName - "AGTEST2_10.10.10.57"
    SListenerILBIP = "10,10.10.57"
    [int] $ListenerProbePort = 59999

    Import-Module failoverclusters

    Get-ClusterResource SIPResourceName | Set-clusterparameter -Multiple @{
    "Address" = "SListenerILBIP" ; "ProbePort" = "SListenerProbePort" ; "SubnetMask" = "255.255.255.255" ; "Network" = "SClusterNetworkName" ; "EnableDhcp = 0
} ```

- 3.23 Now, create a DAG via TSQL commands (primary = On-Prem server, Secondary = Azure VM)
``` ALTER AVAILABILITY GROUP [agtest1] GRANT CREATE ANY DATADASE
      CREATE AVAILABILITY GROUP [distributedag]
      WITH (DISTRIEUTED)
      AVAILABILITY GROUP ON
      'AGONPREM' WITH
      {
      
      LTSTENER_URL - 'tcp://192.168.0.78:5022',
      AWAILABILITY_MODE - ASYNCHRONOUS_COMNIT,
      FAILOVER_NODE - MANUAL,
      SEEDING_MODE - AUTOMATIC
      },
      
      'AGAZURE' WITH
      {
      LISTENER_URL - 'tcp://10.10.10.57:5022",
      AWAILABILITY_MODE - ASYNCHRONOUS_COMNIT,
      FAILOVER_MODE - MANJAL
      SEEDING_MODE - AUTOMATIC
      };
      GO
select * from sys.availability_group_listeners
sp_readerrorlog
drop availability group [distributedag] ```





































