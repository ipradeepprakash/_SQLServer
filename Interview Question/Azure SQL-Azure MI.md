
# Interview Questions

### Azure MI (Managed Instance)

1. On Azure MI, how many tempdb files would be created?
   - 12

2. do we need to create HIGH AVAILABILITY for Managed instance? if so how?
   - 2 things here
   
      for GENERAL purpose or BUSINESS CRITICAL TIER: NO need to create HA, its there Automatically for user. 
      
      For Business Critical, we get 4 Replicas from Microsoft by default. we are just doing Auto-failover for DR purpose.

3. what is difference between GENERAL Purpose & BUSINESS Critical architectures
      
   - GENERAL purpose: is just like our Failover clusters. 
         
   - BUSINESS Critical: just like our AlwaysOn with 4 replicas (only 1 can be used for Reporting). 
         
   - w.r.t Storage: 
       > locally associated with BUSINESS critical

       > Remotely for General Purpose.

4. what are different ways to connect managed instance?
   - https://www.youtube.com/watch?v=F-JZmE9pWng




### Azure SQL
1. On Azure SQL, how many tempdb files would be created?
   - Default is 2. but, it will get changed if we change the vCores that we choose.
