<###################################################################################
 
  Microsoft Visual Studio Code Latest Download and Installation

  Version: 1.0
        : 15 June 2020
                     
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

# Work out latest Stable Visual Studio Code version to download
Write-Host "Downloading Microsoft Visual Studio Code Version API"
# Download Microsoft Visual Studio Code Version API API as JSON File
$APIUrl = "https://update.code.visualstudio.com/api/update/win32-x64/stable/VERSION"
$JSON = (Invoke-WebRequest -uri $APIUrl -UseBasicParsing).Content | ConvertFrom-Json

$version = $JSON.productVersion
$URI = $JSON.url

# Download Microsoft Visual Studio Code installer
Write-host "Downloading Latest Stable Microsoft Visual Studio Code Installer - $($version)"
Invoke-WebRequest -Uri $URI -OutFile "c:\temp\VSCodeSetup-x64-1.46.0.exe" -UseBasicParsing
Write-host "Download of Latest Stable Microsoft Visual Studio Code Installer complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Start MSI Installation and Wait
Write-host "Installing Microsoft Visual Studio Code"
$UnattendedArgs = "/VERYSILENT /NORESTART /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"
Start-Process "c:\temp\VSCodeSetup-x64-1.46.0.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft Visual Studio Code completed"

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