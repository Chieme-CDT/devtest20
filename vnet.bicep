param vnet_name string = 'devtest-k8-vnet'
param location string = 'West US'

var public_subnet1_name = 'Public-Subnet-1'
var private_subnet2_name = 'Private-Subnet-2'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    subnets: [
      {
        name: public_subnet1_name
        properties: {
          addressPrefix: '192.168.0.0/24'
        }
      }
      {
        name: private_subnet2_name
        properties: {
          addressPrefix: '192.168.1.0/24'
        }
      }
    ]
  }
  resource publicsubnet1 'subnets' existing = {
    name: public_subnet1_name
  }

  resource privatesubnet2 'subnets' existing = {
    name: private_subnet2_name
  }
}

output private_subnetId string = virtualNetwork::publicsubnet1.id
output public_subnetId string = virtualNetwork::privatesubnet2.id
output private_subnetName string = virtualNetwork::publicsubnet1.name
output public_subnetName string = virtualNetwork::privatesubnet2.name
output vnetname string = virtualNetwork.name
