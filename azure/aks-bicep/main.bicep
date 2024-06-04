@description('AKSクラスター名')
param clusterName string = 'myAksCluster'

@description('リソースグループの場所')
param location string = resourceGroup().location

@description('Kubernetes APIサーバーのFQDNで使用するオプションのDNSプレフィックス')
param dnsPrefix string

@description('各エージェントプールのノードにプロビジョニングするディスクサイズ (GB 単位)。この値の範囲は0～1023、0 を指定すると、そのagentVMSize のデフォルトのディスクサイズが適用される')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('エージェントプールの数。各プールは同じVMサイズとOSイメージを使用')
@minValue(1)
@maxValue(50)
param agentCount int = 3

@description('エージェントプールのVMサイズ')
param agentVMSize string = 'standard_b2s'

@description('Linux VMの管理者ユーザー名')
param linuxAdminUsername string

@description('SSH公開キーの値')
param sshRSAPublicKey string

@description('AKSクラスター')
resource aks 'Microsoft.ContainerService/managedClusters@2024-01-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
