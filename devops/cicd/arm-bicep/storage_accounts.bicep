param environment string
param project string

@description('The name of the storage account')
param storageAccountName string
param bronzeLayer string
param silverLayer string
param goldLayer string

@description('The location in which the resources should be deployed.')
param location string = resourceGroup().location

var storageAccountName_var = '${environment}${project}${storageAccountName}'

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName_var
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: location
  properties: {
    isHnsEnabled: true
  }
  tags: {
    owner: 'data engineering'
    project: 'lakehouse'
    environment: 'production'
  }
}

resource storageAccountName_default_bronzeLayer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName_resource.name}/default/${bronzeLayer}'
  properties: {
    publicAccess: 'None'
  }
  /*dependsOn: [
    storageAccountName_resource
  ]*/
}

resource storageAccountName_default_goldLayer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName_resource.name}/default/${goldLayer}'
  properties: {
    publicAccess: 'None'
  }
  /*dependsOn: [
    storageAccountName_resource
  ]*/
}

resource storageAccountName_default_silverLayer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName_resource.name}/default/${silverLayer}'
  properties: {
    publicAccess: 'None'
  }
  /*dependsOn: [
    storageAccountName_resource
  ]*/
}
