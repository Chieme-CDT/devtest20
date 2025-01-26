// main.bicep

param keyVaultName string = 'devtest-k8-keyvault-02'
param secretName string = 'sshPublicKey'

resource existing_keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

module vnet './vnet.bicep' = {
  name: 'vnetdeployment'  
}

module aks './aks.bicep' = {
    name: 'aksdeployment'
    params: {
      vnetSubnetID: vnet.outputs.private_subnetId
      keydata: existing_keyVault.getSecret(secretName)
    }    
}
