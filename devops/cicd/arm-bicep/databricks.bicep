param environment string
param project string

@description('The name of the storage account')
param databricksWorkspaceName string

@description('The location in which the resources should be deployed.')
param location string = resourceGroup().location

var databricksWorkspaceName_var = '${environment}-${project}-${databricksWorkspaceName}'
var managedResourceGroupName = 'databricks-rg-${databricksWorkspaceName_var}-${uniqueString(databricksWorkspaceName, resourceGroup().id)}'

resource databricksWorkspaceName_resource 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: databricksWorkspaceName_var
  location: location
  sku: {
    name: 'trial'
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
  }
}