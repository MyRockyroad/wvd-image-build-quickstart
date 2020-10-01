<###################################################################################
 
  Microsoft Teams Download and Installation

  Version: 1.0
         : 23 April 2020
         : https://docs.microsoft.com/en-us/microsoftteams/teams-for-vdi#deploy-the-teams-desktop-app-to-the-vm
                     
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

# Work out latest Microsoft Teams link to download
Write-Host "Downloading Teams link to latest download"
$versionuri = "https://teams.microsoft.com/desktopclient/installer/windows/x64" 
$versionlink = (Invoke-WebRequest -uri $versionuri -UseBasicParsing).Content
#replace EXE with MSI
$versionlink = $versionlink -replace ".exe", ".msi"

# Download Microsoft Teams installer
Write-host "Downloading Microsoft Teams"
Invoke-WebRequest -Uri $versionlink -OutFile "c:\temp\Teams_windows_x64.msi" -UseBasicParsing
Write-host "Download of Microsoft Teams complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Enable Teams per-machine installation
Write-host "Setting Registry key for Teams per-machine installation"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Teams"
$Name = "IsWVDEnvironment"
$value = "1"
New-Item -Path $registryPath -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

# Start MSI Installation and Wait
Write-host "Installing Microsoft Teams"
$LogApp = "${env:SystemRoot}" + "\Temp\MicrosoftTeams.log"
$UnattendedArgs = "/i `"c:\temp\Teams_windows_x64.msi`" /qn ALLUSER=1 ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft Teams completed"

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
