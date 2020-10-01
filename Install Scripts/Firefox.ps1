<###################################################################################
 
  FireFox Extended Support Release Latest Download and Installation

  Version: 1.0
         : 23 April 2020
                     
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

# Work out latest ESR version to download
Write-Host "Downloading Firefox Version json to find latest ESR to download"
# Download Firefox version JSON File into an array
$versionJSON = "https://product-details.mozilla.org/1.0/firefox_versions.json" 
$FirefoxVersions = (Invoke-WebRequest -uri $versionJSON -UseBasicParsing).Content | ConvertFrom-Json
$ESRVersion = $FirefoxVersions.FIREFOX_ESR

# Build Latest Version URL based on JSON received from Mozilla
$URI = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$($ESRVersion)/win64/en-US/Firefox%20Setup%20$($ESRVersion).msi"
# Download Firefox ESR 64bit installer
Write-host "Downloading Latest Firefox 64bit ESR - $($ESRVersion)"
Invoke-WebRequest -Uri $URI -OutFile "c:\temp\Firefox Setup $($ESRVersion).msi" -UseBasicParsing
Write-host "Download of Latest Firefox 64bit ESR complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Start MSI Installation and Wait
Write-host "Installing Firefox 64bit ESR"
$LogApp = "${env:SystemRoot}" + "\Temp\Firefox Setup $($ESRVersion).log"
$UnattendedArgs = "/i `"c:\temp\Firefox Setup $ESRVersion.msi`" START_MENU_SHORTCUT=true TASKBAR_SHORTCUT=true DESKTOP_SHORTCUT=true OPTIONAL_EXTENSIONS=false INSTALL_MAINTENANCE_SERVICE=false /qn ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Firefox 64bit ESR completed"

# Disable Autoupdate
#
#

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
