#Script tested on VMware App Volumes 4.0 and Veeam V12
# You should run this lines at least once
#Set-PowerCLIConfiguration -Scope User -ParticipateInCeip $true -Confirm:$false
#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

#vCenter URL and Credentials to establish connection

$vCenterServer= "vcenter.vmware.com" #vCenter FQDN
$User = "user@domain.com"
$Passwd = "******"

Connect-VIServer -Server $vCenterServer -User $User -Password $Passwd


# Name of the VM which disks will be mounted on
$VMName = "DummyVM_Name"

#Script Start

# Obtain VM Data
$vm = Get-VM -Name $VMName
Write-Host "VM: " $vm.Name



# Remove all Disks from VM
Get-HardDisk -VM $vm | Remove-HardDisk -Confirm:$false
Write-Host "Disks removed" `n -ForegroundColor Red
Write-Host "Task finished" -ForegroundColor Yellow


# Disconnect from vCenter server Instance
Disconnect-VIServer -Confirm:$false