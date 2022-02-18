param environment string
param project string
param location string = resourceGroup().location
param factoryName string

var factoryName_var = '${environment}-${project}-${factoryName}'

resource factoryName_resource 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName_var
  location: location
  properties: {}
  identity: {
    type: 'SystemAssigned'
  }
}

output dataFactoryObjectID string = 'test'