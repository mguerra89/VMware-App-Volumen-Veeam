The following post aims to provide a solution for backing up VMware App Volumes' VMDKs with Veeam Backup.

Requirements:
• Install VMware PowerCLI on the Veeam Backup server
• PowerShell

Solution:
The solution involves creating an empty VM, running a Veeam Backup job that calls a pre-script (mount_disk.ps1) and a post-script (umount_disk.ps1).

![image](https://github.com/mguerra89/VMware-App-Volumen-Veeam/assets/71152467/fd89bb26-0cfa-42e8-93c9-0459aca05fc4)


