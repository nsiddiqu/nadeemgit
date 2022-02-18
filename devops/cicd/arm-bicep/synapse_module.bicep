@secure()
param adminLoginUser string

@secure()
param adminPassword string

/*
@minLength(1)
param databaseCollation string = 'SQL_Latin1_General_CP1_CI_AS'
*/

@description('The name of the Database')
param synapseWorkspaceName string
param synapseStorageAccount string
param synapseStorageAccountFilesystem string

/*
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param databaseEdition string = 'Basic'

@description('Enable or disable Transparent Data Encryption (TDE) for the database.')
@allowed([
  'Enabled'
  'Disabled'
])
param transparentDataEncryption string = 'Enabled'
*/

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

resource synapseWorkspaceName_resource 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: synapseWorkspaceName
  location: location
  properties: {
    sqlAdministratorLoginPassword: adminPassword
    sqlAdministratorLogin: adminLoginUser
    defaultDataLakeStorage: {
      accountUrl: 'https://${synapseStorageAccount}${uniqueString(resourceGroup().id)}.dfs.${environment().suffixes.storage}'
      //accountUrl: 'https://${synapseStorageAccount}${uniqueString(resourceGroup().id)}.dfs.core.windows.net'
      filesystem: synapseStorageAccountFilesystem
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource synapseWorkspaceName_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = {
  parent: synapseWorkspaceName_resource
  name: 'allowAll'
  //location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource synapseWorkspaceName_AllowAllWindowsAzureIps 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = {
  parent: synapseWorkspaceName_resource
  name: 'AllowAllWindowsAzureIps'
  //location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource synapseWorkspaceName_default 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2019-06-01-preview' = {
  parent: synapseWorkspaceName_resource
  name: 'default'
  //location: location
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState: 'Enabled'
    }
  }
}
