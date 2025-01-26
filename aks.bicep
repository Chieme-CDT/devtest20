param location string = 'West US'
param group_prefix string = 'devtest-k8'
param kubernetesVersion string = '1.30.7'
param vmSize string = 'Standard_DS2_v2'
param agentpool_name string = 'agentpool'
param vnetSubnetID string
param serviceCidr string = '10.0.0.0/16'
@description('''options: azure, kubenet, none''')
param networkPlugin string = 'azure'
@description('''options: azure, calico, cilium, none''')
param networkPolicy string = 'calico'
@description(''' options: 'loadBalancer', 'managedNATGateway', 'none', 
'userAssignedNATGateway', 'userDefinedRouting' ''')
param outboundType string = 'loadBalancer'
param enablePrivateCluster bool = true
@secure()
param keydata string 
param adminUserName string = 'adminUserName'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: '${group_prefix}-aks-cluster'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: 'dnsprefix'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: agentpool_name
        count: 3
        vmSize: vmSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: vnetSubnetID
      }
    ]
    linuxProfile: {
      adminUsername: adminUserName
      ssh: {
        publicKeys: [
          {
            keyData: keydata
          }
        ]
      }
    }
    networkProfile: {
      serviceCidr: serviceCidr
      networkPlugin: networkPlugin
      networkPolicy: networkPolicy
      outboundType: outboundType
    }
    apiServerAccessProfile: {
      enablePrivateCluster: enablePrivateCluster
    }
  }
}
