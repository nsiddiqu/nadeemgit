@description('The location where the resources will be deployed.')
param location string = resourceGroup().location

@description('The name of the keyvault that contains the secret.')
param vaultName string

@description('The name of the Database')
param synapseWorkspaceName string
param synapseStorageAccount string
param synapseStorageAccountFilesystem string

@description('The name of the Password secret.')
param adminPasswordsecretName string

@description('The name of the LoginUser secret.')
param adminLoginUsersecretName string

@description('The name of the resource group that contains the keyvault.')
param vaultResourceGroupName string

@description('The name of the subscription that contains the keyvault.')
param vaultSubscription string = subscription().subscriptionId


resource secretMetadata 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: vaultName
  scope: resourceGroup(vaultSubscription, vaultResourceGroupName )
}

module rSynapse './synapse_module.bicep' = {
  name: 'Synapse_Module'
  params: {
    location: location
    synapseWorkspaceName: synapseWorkspaceName
    synapseStorageAccount: synapseStorageAccount
    synapseStorageAccountFilesystem: synapseStorageAccountFilesystem
    adminLoginUser: secretMetadata.getSecret(adminLoginUsersecretName)
    adminPassword: secretMetadata.getSecret(adminPasswordsecretName)
  }
}
