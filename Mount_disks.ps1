#Script tested on VMware App Volumes 4.0 and Veeam V12
# You should run this lines at least once
#Set-PowerCLIConfiguration -Scope User -ParticipateInCeip $true -Confirm:$false
#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

#vCenter URL and Credentials to establish connection

$vCenterServer= "vcenter.vmware.com" #vCenter FQDN
$User = "user@domain.com"
$Passwd = "******"

# Name of the Datastore on which vmdk files are located & root path on which Writable Volumes VMDKs are located
$datastoreName = "STORAGE_NAME"
$rootPath = "[STORAGE_NAME]/appvolumes/writables_backup"

# Name of the VM which disks will be mounted on
$VMName = "DummyVM_NAME"


#Script Start


#Establish vCenter Server Instance Connection
Connect-VIServer -Server $vCenterServer -User $User -Password $Passwd

# Obtain Datastore Data
$datastore = Get-Datastore -Name $datastoreName

# Obtain VM Data
$vm = Get-VM -Name $VMName
Write-Host "VM: " $vm.Name


$strDatastoreName = $datastore.name
$ds = Get-Datastore -Name $strDatastoreName | %{Get-View $_.Id}
$fileQueryFlags = New-Object VMware.Vim.FileQueryFlags
$fileQueryFlags.FileSize = $true
$fileQueryFlags.FileType = $true
$fileQueryFlags.Modification = $true
$searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
$searchSpec.details = $fileQueryFlags
$searchSpec.sortFoldersFirst = $true
$dsBrowser = Get-View $ds.browser

Write-Host "Searching path: "$rootPath `n
$searchResult = $dsBrowser.SearchDatastoreSubFolders($rootPath, $searchSpec)

foreach ($folder in $searchResult) {
            foreach ($fileResult in $folder.File) {
                $file = "" | Select-Object Name, FullPath   
                $file.Name = $fileResult.Path
                $strFilename = $file.Name
                #Check that the vmdk is not a snapshot or a Writable Volumes metadata file.
                if ($strFilename -and $strFilename.Contains(".vmdk") -and !$strFilename.Contains(".metadata") -and  !$strFilename.Contains("-flat.vmdk") -and !$strFilename.Contains("delta.vmdk")) {
                    $folderpath = $folder.FolderPath
                    $strFullPath = $folderpath + $strFilename
                    Write-Host "File Path is: " $strFullPath
                    New-HardDisk -VM $vm -DiskPath $strFullPath | Out-Null
                    Write-Host "Disk mounted" `n -ForegroundColor Green
                    }
                }

            }

Write-Host "Task finished" -ForegroundColor Yellow

# Disconnect from vCenter server Instance
Disconnect-VIServer -Confirm:$false