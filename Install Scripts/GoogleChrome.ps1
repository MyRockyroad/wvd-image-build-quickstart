<###################################################################################
 
  Google Chrome Enterprise Latest Download and Installation

  Version: 1.0
         : 22 April 2020
                     
 ###################################################################################
#>

$ErrorActionPreference = "Stop"
# Turn off Progress bar to try and make the download faster
$ProgressPreference = "SilentlyContinue"

$PackageName = "googlechromestandaloneenterprise64"

# Create Temp
Write-Host "Creating c:\Temp if it does not exist"
if (!(Test-Path "c:\Temp")) { 
    New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
}

# Download Google Chrome Standalone Enterprise 64bit installer
Write-host "Downloading Google Chrome Enterprise"
Invoke-WebRequest -Uri "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi" -OutFile "c:\temp\googlechromestandaloneenterprise64.msi" -UseBasicParsing
Write-host "Download of Google Chrome Enterprise complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Start MSI Installation and Wait
Write-host "Installing Google Chrome Enterprise"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$UnattendedArgs = "/i c:\temp\googlechromestandaloneenterprise64.msi NOGOOGLEUPDATING=1 NOGOOGLEUPDATEPING=1 /qn ALLUSERS=1 /norestart /log $LogApp"
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Google Chrome Enterprise completed"

# Disable Chrome Services
Write-host "Disabling Google Updater Services"
Set-Service gupdate -StartupType Disabled -ErrorAction SilentlyContinue
Set-Service gupdatem -StartupType Disabled -ErrorAction SilentlyContinue
#sc.exe config gupdate start= disabled
#sc.exe config gupdatem start= disabled
Write-host "Removing Google Updater Scheduled Tasks"
Unregister-ScheduledTask -TaskName GoogleUpdateTaskMachineCore -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName GoogleUpdateTaskMachineUA -Confirm:$false -ErrorAction SilentlyContinue

# Rename GoogleUpdate.exe
Write-host "Renaming GoogleUpdate.exe to GoogleUpdate.DISABLED"
Get-Process -Name googleupdate -ErrorAction SilentlyContinue | Stop-Process -Confirm:$false -Force -ErrorAction SilentlyContinue | out-null
if (Test-Path "$(${env:ProgramFiles(x86)})\google\update\GoogleUpdate.exe") {
    Rename-Item "$(${env:ProgramFiles(x86)})\google\update\GoogleUpdate.exe" "$(${env:ProgramFiles(x86)})\google\update\GoogleUpdate.DISABLED"
}

# Cleanup Temp
Write-Host "Removing files from c:\Temp"
if (Test-Path "c:\temp") { 
    Get-ChildItem "c:\temp" | Remove-Item -Recurse
}

# Set Progress bar back to default
$ProgressPreference = "Continue"

# Reenable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "Defender RealTime scanning enabled"