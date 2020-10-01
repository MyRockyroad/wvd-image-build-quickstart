<###################################################################################
 
  Disk Cleanup

  Version: 1.0
         : 4 May 2020
         : Clean up WinSxS folder and run Cleanmgr.exe
                     
 ###################################################################################
#>

$ErrorActionPreference = "Stop"

Write-Host "Cleanup WinSxS"
$UnattendedArgs = "/online /Cleanup-Image /StartComponentCleanup /ResetBase"
Start-Process "$env:systemroot\system32\Dism.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-Host "Cleanup of WinSxS complete"

<# Commented out as work in progress seems to hang packer build on Azure but works fine when running locally
$RegKeys = @(
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Diagnostic Data Viewer database files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files\",
  # "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files\",
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files\"
)

Write-Host "Creating Cleanmgr SAGESET:11 in registry"
Foreach ($RegKey in $RegKeys) {
  New-ItemProperty -Path "$RegKey" -Name "StateFlags0011" -PropertyType "DWORD" -Value "2" -Force | Out-Null
}
Write-Host "Starting Disk Cleanup with SAGERUN:11"
Start-Process C:\Windows\System32\Cleanmgr.exe -ArgumentList "SAGERUN:11" -Wait
Write-Host "Completed Disk Clean up"
#>