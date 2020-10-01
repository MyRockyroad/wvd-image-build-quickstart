<###################################################################################
 
  Microsoft OneDrive Pre-Machine Installation

  Version: 1.0
         : 20 May 2020
         : https://docs.microsoft.com/en-us/onedrive/per-machine-installation
                     
 ###################################################################################
#>
$ErrorActionPreference = "Stop"
# Turn off Progress bar to try and make the download faster
$ProgressPreference = "SilentlyContinue"

# Create Temp
Write-Host "Creating c:\Temp if it does not exist"
if (!(Test-Path "c:\Temp")) { 
    New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
}

# Download ezeepPrintApp installer
Write-host "Downloading Microsoft OneDrive"
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=844652" -OutFile "c:\Temp\OneDriveSetup.exe" -UseBasicParsing
Write-host "Download of Microsoft OneDrive complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

#Install Microsoft OneDrive
Write-host "Installing Microsoft OneDrive"
$UnattendedArgs = "/allusers /silent"
Start-Process "c:\Temp\OneDriveSetup.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft OneDrive"

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