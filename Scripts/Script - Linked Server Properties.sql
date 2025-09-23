-- Script to check Linked Servers and their properties
SELECT 
    name AS LinkedServerName,
    product AS Provider,
    provider_string AS ProviderString,
    data_source AS DataSource,
    location AS Location,
    provider AS ProviderName,
    is_linked AS IsLinked,
    is_remote_login_enabled AS IsRemoteLoginEnabled,
    is_rpc_out_enabled AS IsRpcOutEnabled,
    is_data_access_enabled AS IsDataAccessEnabled,
    modify_date AS ModifyDate
FROM sys.servers;


