
/* ------------------ REPLICATION SCRIPTS: DISTRIBUTOR -------------------------- 

		ref: https://www.mssqltips.com/sqlservertip/1808/sql-server-replication-scripts-to-get-replication-configuration-information/
		ref: https://www.sqlshack.com/sql-server-replication-overview-of-components-and-topography/



*/


-- Script to run on --------------- Distribution database ------------------------

				USE Distribution 
				GO 
				--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				SELECT
					DS.srvname AS DistributorServer,
					PUB.publisher_db AS PublisherDB
				FROM distribution.dbo.MSpublications PUB
					JOIN distribution.dbo.MSdistribution_agents DA ON PUB.publisher_id = DA.publisher_id
					JOIN master.sys.servers DS ON DA.distributor_id = DS.server_id;


				-- Get the publication name based on article 
						SELECT DISTINCT  
							srv.srvname publication_server  
							, a.publisher_db , p.publication publication_name 
							, a.article , a.destination_object 
							, ss.srvname subscription_server , s.subscriber_db 
							, da.name AS distribution_agent_job_name 
						FROM MSArticles a  
							JOIN MSpublications p ON a.publication_id = p.publication_id 
							JOIN MSsubscriptions s ON p.publication_id = s.publication_id 
							JOIN master..sysservers ss ON s.subscriber_id = ss.srvid 
							JOIN master..sysservers srv ON srv.srvid = p.publisher_id 
							JOIN MSdistribution_agents da ON da.publisher_id = p.publisher_id  
							AND da.subscriber_id = s.subscriber_id 
						ORDER BY 1,2,3 

-- Script to run on: --------------- Publisher database ---------------

				DECLARE @Detail CHAR(1) 
				SET @Detail = 'Y' 
				CREATE TABLE #tmp_replcationInfo ( 
				PublisherDB VARCHAR(128),  
				PublisherName VARCHAR(128), 
				TableName VARCHAR(128), 
				SubscriberServerName VARCHAR(128), 
				) 
				EXEC sp_msforeachdb  
				'use ?; 
				IF DATABASEPROPERTYEX ( db_name() , ''IsPublished'' ) = 1 
				insert into #tmp_replcationInfo 
				select  
				db_name() PublisherDB 
				, sp.name as PublisherName 
				, sa.name as TableName 
				, UPPER(srv.srvname) as SubscriberServerName 
				from dbo.syspublications sp  
				join dbo.sysarticles sa on sp.pubid = sa.pubid 
				join dbo.syssubscriptions s on sa.artid = s.artid 
				join master.dbo.sysservers srv on s.srvid = srv.srvid 
				' 
				IF @Detail = 'Y' 
				   SELECT * FROM #tmp_replcationInfo 
				ELSE 
				SELECT DISTINCT  
				PublisherDB 
				,PublisherName 
				,SubscriberServerName  
				FROM #tmp_replcationInfo 
				DROP TABLE #tmp_replcationInfo 



/*---------------------------------------------------------SUBSCRIBER----------------------------------------------------------------------------*/

				EXEC sp_helpsubscription;
				EXEC sp_helpsubscriberinfo;

				SELECT distinct publisher, publisher_db, publication
				FROM dbo.MSreplication_subscriptions
				ORDER BY 1,2,3

				SELECT
					S.srvname AS SubscriberServer,
					PUB.publisher_db AS PublisherDB,
					SUB.subscriber_db AS SubscriberDB
				FROM
				distribution.dbo.MSsubscriptions SUB
				JOIN distribution.dbo.MSarticles ART ON SUB.article_id = ART.article_id
				JOIN distribution.dbo.MSpublications PUB ON ART.pubid = PUB.pubid
				JOIN master.sys.servers S ON SUB.subscriber_id = S.server_id;


/*---------------------------------------------------------PUBLISHER----------------------------------------------------------------------------*/
-- list all the articles that are published
				SELECT
					 Pub.[publication]    [PublicationName]
					,Art.[publisher_db]   [DatabaseName]
					,Art.[article]        [Article Name]
					,Art.[source_owner]   [Schema]
					,Art.[source_object]  [Object]
				FROM
					[distribution].[dbo].[MSarticles]  Art
					INNER JOIN [distribution].[dbo].[MSpublications] Pub
						ON Art.[publication_id] = Pub.[publication_id]
				ORDER BY
					Pub.[publication], Art.[article]

				SELECT P.srvname AS PublisherServer, PUB.publisher_db AS PublisherDB
				FROM distribution.dbo.MSpublications PUB
					JOIN master.sys.servers P ON PUB.publisher_id = P.server_id;


-- details of articles in transactional or merge SQL Server replication in a published database
				SELECT 
					st.name [published object], st.schema_id, st.is_published , 
					st.is_merge_published, is_schema_published  
				FROM sys.tables st WHERE st.is_published = 1 or st.is_merge_published = 1 or st.is_schema_published = 1  
				UNION  
					SELECT sp.name, sp.schema_id, 0, 0, sp.is_schema_published  
					FROM sys.procedures sp WHERE sp.is_schema_published = 1  
				UNION  
					SELECT sv.name, sv.schema_id, 0, 0, sv.is_schema_published  
					FROM sys.views sv 
					WHERE sv.is_schema_published = 1;



-- To get detailed information about an article in the listed publisher
				DECLARE @publication AS sysname;
				SET @publication = N'PROD_HIST_Pub';
 
				USE <database123>
				EXEC sp_helparticle
				  @publication = @publication;
				GO

-- To get column level details of an article
				USE <database123>
				GO
				sp_helparticlecolumns  @publication = N'PROD_HIST_Pub' ,  @article =  'tb_Branch_Plant'

-- To list the columns that are published in transactional replication in the publication database
				SELECT 
					object_name(object_id) [published table], 
					name [published column] 
				FROM sys.columns sc 
				WHERE sc.is_replicated = 1;


-- Comprehensive Replication Details
			SELECT
				P.srvname AS PublisherServer, DS.srvname AS DistributorServer,
				S.srvname AS SubscriberServer,PUB.publisher_db AS PublisherDB, SUB.subscriber_db AS SubscriberDB
			FROM
				distribution.dbo.MSsubscriptions SUB
				JOIN distribution.dbo.MSarticles ART ON SUB.article_id = ART.article_id
				JOIN distribution.dbo.MSpublications PUB ON ART.pubid = PUB.pubid
				JOIN distribution.dbo.MSdistribution_agents DA ON PUB.publisher_id = DA.publisher_id
				JOIN master.sys.servers S ON SUB.subscriber_id = S.server_id
				JOIN master.sys.servers P ON PUB.publisher_id = P.server_id
				JOIN master.sys.servers DS ON DA.distributor_id = DS.server_id;







