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
1. Select cluadmin from windows & proceed to add nodes to cluster with all details
![1 Select cluadmin from windows - proceed to add nodes](https://drive.google.com/file/d/1IgKz3YO_NFwTQRWzMByWuRzIOnHzPrXL/view?usp=drive_link)

Note: same screen will not  be visible in Azure VM since it follows DHCP protocol & allocates any of the IP’s available with its node.

### Create a different cluster on Azure VM
—-------------------------------------------------
- Similar steps as above, but at below step, we need to validate & correct the IP as Azure VM will follow DHCP protocol & takes any of the Nodes IP. ![2 correct the IP as Azure VM will follow DHCP protocol](https://drive.google.com/file/d/1mqp1qnlBxOWL8NsBHAqEmUsu_mbJMQEq/view?usp=drive_link)
- In Azure VM, while configuring cluster, NO IP will be asked, instead it asks for cluster name. I.e. it goes with DNN (distributed Network Name) ![it goes with DNN](https://drive.google.com/file/d/1hbNrUAaPuii1zTWzmJXBLEi6PolBJ8AA/view?usp=drive_link)
- 



























