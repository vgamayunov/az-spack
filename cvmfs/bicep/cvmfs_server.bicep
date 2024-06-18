param location string = resourceGroup().location
param vmName string = 'apeserver'
param adminUsername string = 'hpcadmin'
param vnetName string
param subnetName string
param vmSize string = 'Standard_D2s_v3'
param dataDiskSizeGB int = 1024
param adminPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdn4ojMVbTUjwsqeSdIij/1Sng/6xwEr7yseTuOkHTV7nWcf4X/WfqGUbZr3idB9PzzruUBjT+60nW/Ni22157dwEOpw1+DThd45wwGRs91jDQstI3CyjPNmmzKVuZLMgcekdSu0mgZbCAg5vQNAGPmaSK26DOYjcRLwgUjWIfnNGa3FtAKOZQBjGeFkXt1LHzlstAomlYPfQCFp53XLd/bxEA1qFjKM5TBVO1GqMxbqBplVeDyLkhlrq6/+ItSF9xYhhX86qBQVR+CSPsXniolky/TixVLVczF4++RBvm9B+YGIbzUWUJoaM0q0ph+b3XYk9nXn7WKB6qw0w1Tj8WLkeulLXPNN0gYq5doAwuuqBzOVGpIY3yTWy60nxuUVc1zZeraLhOVn0YwaDh6tJDNaLfKyplXRXt4jyjzZW/bHJrNEcaCc6IfBItRStId6avYx9WuE+HMVmbydiVXvQDzkNYk9xfKe7+FFavNL7Y+wjZ07mryTtsQb5IES968S8= victor@DESKTOP-OCEV05U'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  parent: vnet
  name: subnetName
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}-publicIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          publicIPAddress: {
            id: publicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
          }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          lun: 0
          createOption: 'Empty'
          diskSizeGB: dataDiskSizeGB
        }
      ]
    }    
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output vmId string = vm.id
