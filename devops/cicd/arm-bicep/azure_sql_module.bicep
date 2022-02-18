@secure()
param adminLoginUser string

@secure()
param adminPassword string

@minLength(1)
param databaseCollation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('The name of the Database')
param databaseName string

/*
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param databaseEdition string = 'Basic'
*/

@description('Enable or disable Transparent Data Encryption (TDE) for the database.')
@allowed([
  'Enabled'
  'Disabled'
])
param transparentDataEncryption string = 'Enabled'

/*
@description('Describes the performance level for Edition')
@allowed([
  'Basic'
  'S0'
  'S1'
  'S2'
  'P1'
  'P2'
  'P3'
])
param databaseServiceObjectiveName string = 'Basic'
*/
param location string
param sqlServerName string

resource sqlServerName_resource 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    displayName: 'SqlServer'
  }
  properties: {
    administratorLogin: adminLoginUser
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}

resource sqlServerName_databaseName 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  parent: sqlServerName_resource
  name: databaseName
  location: location
  tags: {
    displayName: 'Database'
  }
  properties: {
    //edition: databaseEdition
    collation: databaseCollation
    //requestedServiceObjectiveName: databaseServiceObjectiveName
  }
}

resource sqlServerName_databaseName_current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-05-01-preview' = {
  parent: sqlServerName_databaseName
  name: 'current'
  properties: {
    state: transparentDataEncryption
  }
}

resource sqlServerName_AllowAllMicrosoftAzureIps 'Microsoft.Sql/servers/firewallrules@2015-05-01-preview' = {
  parent: sqlServerName_resource
  name: 'AllowAllMicrosoftAzureIps'
  //location: location
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlFQDN string = sqlServerName_resource.properties.fullyQualifiedDomainName
