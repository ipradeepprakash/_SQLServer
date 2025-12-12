# Migration Videos - Always on between On-prem and Azure VM

### Video drive link: 
- https://drive.google.com/file/d/1Sl4ZVVGZdZrFQ18cyoT3TR8uOR6PPrA0/view

## Basic requisites
1. Connectivity between Op-Prem server & Azure Vm
2. Site-to-site VPN connection

## Scenario: 
**Primary** 	- On-Premises
**Secondary** 	- Azure VM

### Add nodes in cluster service
1. Run Cluadmin or open failover cluster manager.
![1 Run Cluadmin or open failover cluster manager](https://drive.google.com/file/d/1nu9rIMJPeLIEi7W6KS2CIpPJGbpQ4ezg/view?usp=drive_link)
2. Select BROWSE and nodes (trust between domain was selected for the 2 nodes participating)
3. Verify the nodes detail (entire directory is selected in this scenario) ![3 Verify the nodes detail](https://drive.google.com/file/d/1BaxbvGuWHkr6POgE5umv1PJUT5RzHFvV/view?usp=drive_link)
4. Press OK & select Advanced option.![4 Press OK and select Advanced option](https://drive.google.com/file/d/17lIUSzzMr0Y4CKvqmH2VHmG-xeH3wcOZ/view?usp=drive_link)
5. Select ‘Find now’ ![5 Select - Find now](https://drive.google.com/file/d/1t0TnyVHyTAdicZ8u1iVqhQJkdBJcMiOJ/view?usp=drive_link)
6. We could see nodes ![6 We could see nodes](https://drive.google.com/file/d/1yGw4JuEJMgagaQ0GMJ33u2ZaJyoiirqC/view?usp=drive_link)
7. Press OK and follow the same procedure to add the 2nd node.
8. Got error - ‘you do not have Administrator permission on server ‘xyz’ ’
9. So as per error and scenario, we need to add op-prem account on azure administrator group.
10. Add on-prem account to azure as per screenshot ![10 Add on-prem account to azure as per screenshot](https://drive.google.com/file/d/1JPAXNinCcYQv4bc1m0XAvqv0lf1PnR9m/view?usp=drive_link)
11. Still getting the same error while configuring clusters, so it could be due to different times in each node participating.
12. Once above issue is resolved, proceed with next steps in same cluster installation.
Cluster name: we can choose any name (from SQL 2019, it will automatically take DNN), but in our scenario, we have On-Prem: SQL 2016 & Azure VM: SQL 2019 So, in our case, cluster installation is of different SQL versions.
IP selection for On-Prem will take automatically, so it for Azure VM.
13. Uncheck the below option
- Allow all eligible storage to cluster ![13 Uncheck below option](https://drive.google.com/file/d/1SHS8KskBNHf3sywnXzVX19QwyBLIrwEN/view?usp=drive_link)
14. Got an error now because when creating clusters, azure will take DHCP protocol. ![14 error in clusters, azure will take DHCP protocol](https://drive.google.com/file/d/1c_lVeALIrOtoq8DE8eU2Vrsad_QqzmwU/view?usp=drive_link)
15. Error: related to IP Range as shown below ![15 Error related to IP Range as shown below](https://drive.google.com/file/d/16BRLz5sWpYqfGYC2MGbgV0TE2e8lbVM5/view?usp=drive_link)
16. Script to create Static IP.
- **Background of error:** by default Azure will work on DHCP protocol, on-prem works on static IP. so make sure, azure VM also takes static IP.
17. Due to different Operating systems in both Source & destination, cluster validation failed. ![Due to different Operating systems in both Source & destination, cluster validation failed.](https://drive.google.com/file/d/1K_VLEzesuKjmoLuuhaPIQOc78OZ_KkGB/view?usp=drive_link)
18. If IP 168.63.129.16 is seen as shown below, then our server cannot be added to Domain controller. 
19. In this video, new servers are being built due to incompatible issues from SQL server 2016.. SQL server 2019 (windows versions for cluster was different, so error
On-prem: windows 2016, Azure cloud VM: windows 2019, so we cannot create a cluster)
20. How to change DNS for server? Its at virtual network level-> subnets-> DNS server->custom. So if we change here, all the VM under the subnet will get reflected.
21. For individual server, go to that server->networking->Network interface card->DNS servers->custom (add DC IP here)
22. Update the domain name in VM.(My computer->properties->change settings->update the domain name as shown below. ![22 Update the domain name in VM](https://drive.google.com/file/d/1uEMfiFXtvnBj0mcWiqbl8Cyp78MHPK2f/view?usp=drive_link)
23. Now configure cluster with nodes for validation. ![23 Now configure cluster with nodes for validation](https://drive.google.com/file/d/1f2Pjs-DuFpmexHEZhgxgf96X5PE0EMQB/view?usp=drive_link)



















  












































