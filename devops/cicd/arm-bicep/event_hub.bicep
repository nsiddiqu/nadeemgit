param environment string
param project string

@description('The name of the Event Grid custom topic.')
param topicName string

@description('The name of the Event Grid custom topic\'s subscription.')
param subscriptionName string = 'topicSubscription-${uniqueString(resourceGroup().id)}'

@description('The name of the Event Hubs namespace.')
param eventHubNamespace string

@description('The name of the event hub.')
param eventHubName string

@description('The name of the storage account')
param storageAccountName string

@description('The name of the storage account container.')
param storageAccountContainerName string

@description('The location in which the Event Grid resources should be deployed.')
param location string = resourceGroup().location

var eventHubNamespace_var = '${environment}-${project}-${eventHubNamespace}'
var eventHubName_var = '${environment}-${project}-${eventHubName}'
var storageAccountName_var = '${environment}${project}${storageAccountName}'

resource topicName_resource 'Microsoft.EventGrid/topics@2020-06-01' = {
  name: topicName
  location: location
}

resource eventHubNamespace_resource 'Microsoft.EventHub/namespaces@2018-01-01-preview' = {
  name: eventHubNamespace_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    isAutoInflateEnabled: true
    maximumThroughputUnits: 7
  }
}

resource eventHubNamespace_eventHubName 'Microsoft.EventHub/namespaces/EventHubs@2017-04-01' = {
  parent: eventHubNamespace_resource
  name: eventHubName_var
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
  }
}

resource subscriptionName_resource 'Microsoft.EventGrid/eventSubscriptions@2020-06-01' = {
  scope: topicName_resource
  name: subscriptionName
  properties: {
    destination: {
      endpointType: 'EventHub'
      properties: {
        resourceId: eventHubNamespace_eventHubName.id
      }
    }
    filter: {
      isSubjectCaseSensitive: false
    }
  }
  /*dependsOn: [
    topicName_resource
  ]*/
}

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName_var
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: location
  properties: {
    supportsHttpsTrafficOnly: true
  }
  tags: {
    owner: 'data engineering'
    project: 'lakehouse'
    environment: 'development'
  }
}

resource storageAccountName_default_storageAccountContainerName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName_resource.name}/default/${storageAccountContainerName}'
  properties: {
    publicAccess: 'None'
  }
  /*dependsOn: [
    storageAccountName_resource
  ]*/
}

output endpoint string = topicName_resource.properties.endpoint
