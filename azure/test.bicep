param name string = 'dbtteststorageaccount'
param location string = 'eastus'
resource myStorage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: name
  kind: 'BlobStorage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}
