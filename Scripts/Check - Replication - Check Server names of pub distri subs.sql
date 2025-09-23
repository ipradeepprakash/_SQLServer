-- Publisher Information
SELECT
    P.srvname AS PublisherServer,
    PUB.publisher_db AS PublisherDB
FROM
    distribution.dbo.MSpublications PUB
    JOIN master.sys.servers P ON PUB.publisher_id = P.server_id;

-- Distributor Information
SELECT
    DS.srvname AS DistributorServer,
    PUB.publisher_db AS PublisherDB
FROM
    distribution.dbo.MSpublications PUB
    JOIN distribution.dbo.MSdistribution_agents DA ON PUB.publisher_id = DA.publisher_id
    JOIN master.sys.servers DS ON DA.distributor_id = DS.server_id;

-- Subscriber Information
SELECT
    S.srvname AS SubscriberServer,
    PUB.publisher_db AS PublisherDB,
    SUB.subscriber_db AS SubscriberDB
FROM
    distribution.dbo.MSsubscriptions SUB
    JOIN distribution.dbo.MSarticles ART ON SUB.article_id = ART.article_id
    JOIN distribution.dbo.MSpublications PUB ON ART.pubid = PUB.pubid
    JOIN master.sys.servers S ON SUB.subscriber_id = S.server_id;

-- Comprehensive Replication Details
SELECT
    P.srvname AS PublisherServer,
    DS.srvname AS DistributorServer,
    S.srvname AS SubscriberServer,
    PUB.publisher_db AS PublisherDB,
    SUB.subscriber_db AS SubscriberDB
FROM
    distribution.dbo.MSsubscriptions SUB
    JOIN distribution.dbo.MSarticles ART ON SUB.article_id = ART.article_id
    JOIN distribution.dbo.MSpublications PUB ON ART.pubid = PUB.pubid
    JOIN distribution.dbo.MSdistribution_agents DA ON PUB.publisher_id = DA.publisher_id
    JOIN master.sys.servers S ON SUB.subscriber_id = S.server_id
    JOIN master.sys.servers P ON PUB.publisher_id = P.server_id
    JOIN master.sys.servers DS ON DA.distributor_id = DS.server_id;


