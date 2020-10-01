<###################################################################################
 
  Microsoft Edge Chromium Enterprise Latest Download and Installation

  Version: 1.0
         : 24 April 2020
                     
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

# Work out latest Stable Edge x64 version to download
Write-Host "Downloading Microsoft Edge Version API"
# Download Edge version API as JSON File into an array
$versionJSON = "https://edgeupdates.microsoft.com/api/products?view=enterprise"
$versions = (Invoke-WebRequest -uri $versionJSON -UseBasicParsing).Content | ConvertFrom-Json
#Filter for only the stable product releases
$stable = $versions | Where-Object {$_.Product -eq "Stable" }
#Filter For Windows x64; sort by product version desc to get the highest first and return it
$latest = $stable.Releases | Where-Object {$_.Platform -eq "Windows" -and $_.Architecture -eq "x64" } | Sort-Object ProductVersion -Descending | Select-Object -First 1

$latestversion = $latest.ProductVersion
# Latest Version URL
$URI = $latest.Artifacts.Location

# Download Edge 64bit installer
Write-host "Downloading Latest Stable Microsoft Edge 64bit - $($latestversion)"
Invoke-WebRequest -Uri $URI -OutFile "c:\temp\MicrosoftEdgeEnterpriseX64.msi" -UseBasicParsing
Write-host "Download of Latest Stable Microsoft Edge 64bit complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Start MSI Installation and Wait
Write-host "Installing Microsoft Edge 64bit"
$LogApp = "${env:SystemRoot}" + "\Temp\Edge Setup $($latestversion).log"
$UnattendedArgs = "/i `"c:\temp\MicrosoftEdgeEnterpriseX64.msi`" /qn ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft Edge 64bit completed"

# Disable Edge Services
Write-Host "Disabling Microsoft Edge Updater Services"
Set-Service edgeupdatem -StartupType Disabled -ErrorAction SilentlyContinue
Set-Service edgeupdate -StartupType Disabled -ErrorAction SilentlyContinue
Set-Service MicrosoftEdgeElevationService -StartupType Disabled -ErrorAction SilentlyContinue
Write-Host "Removing Microsoft Edge Scheduled Tasks"
Unregister-ScheduledTask -TaskName MicrosoftEdgeUpdateTaskMachineCore -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName MicrosoftEdgeUpdateTaskMachineUA -Confirm:$false -ErrorAction SilentlyContinue

# Cleanup Temp
Write-Host "Removing files from c:\Temp"
if (Test-Path "c:\temp") { 
    Get-ChildItem "c:\temp" -Recurse | Remove-Item 
}

# Set Progress bar back to default
$ProgressPreference = "Continue"

# Reenable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "Defender RealTime scanning enabled"
