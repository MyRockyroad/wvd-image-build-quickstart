<###################################################################################
 
  Microsoft FSLogix Apps Installation

  Version: 1.0
         : 4 May 2020
                     
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

# Download Microsoft FSLogix Apps installer
Write-host "Downloading Microsoft FSLogix Apps"
Invoke-WebRequest -Uri "https://aka.ms/fslogix_download" -OutFile "c:\Temp\FSLogix.zip" -UseBasicParsing
Write-host "Download of Microsoft FSLogix Apps complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

#Extract FSLogix.zip to c:\Temp
Write-host "Extracting FSLogix.zip to c:\Temp"
Expand-Archive -Path "C:\Temp\FSLogix.zip" -DestinationPath "c:\Temp\FSLogix\"


#Install FSLogix
Write-host "Installing Microsoft FSLogix Apps"
$UnattendedArgs = "/install /quiet /norestart"
Start-Process "C:\Temp\FSLogix\x64\Release\FSLogixAppsSetup.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft FSLogix Apps completed"

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