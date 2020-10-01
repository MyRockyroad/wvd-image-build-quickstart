<###################################################################################
 
  Microsoft Teams WebSocket Service for Media Optimisation

  Version: 1.0
         : 2 June 2020
         : https://docs.microsoft.com/en-us/azure/virtual-desktop/teams-on-wvd
                     
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

# Download Latest Microsoft Visual C++ Redistributable
Write-Host "Downloading Latest Microsoft Visual C++ Redistributable"
Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vc_redist.x64.exe" -OutFile "c:\temp\vc_redist.x64.exe" -UseBasicParsing
Write-host "Download of Latest Microsoft Visual C++ Redistributable complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Get FileVerson of downloaded installer
$DownloadedVersion = [version](Get-ItemProperty "c:\temp\vc_redist.x64.exe").VersionInfo.FileVersion

#Work out what version, if any, is currently installed

# Registry Uninstall Paths 64 bit and 32 bit
$UninstallKeys = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
# RegEx Filter to match Microsoft Visual C++ Redistributable
$Filter = "(Microsoft Visual C\+\+).*(\bRedistributable).*"

foreach ($UninstallKey in $UninstallKeys) {
    # Only Get Keys that have a DisplayName Value of the Regex above
    $Entries = Get-ItemProperty -path $UninstallKey | Select-Object DisplayName, DisplayVersion | Where-Object { $_.DisplayName -match $Filter }
}

If ($Entries) {
    # Sort Entries Descending and select the first being the latest
    $LatestInstalled = $Entries | Sort-Object DisplayVersion -Descending | Select-Object DisplayVersion -First 1 -ExpandProperty DisplayVersion
    # Make sure our version information only has 4 fields and make a version variable
    $InstalledVersion = [version]('{0}.{1}.{2}.{3}' -f $LatestInstalled.split('.'))
}
else {
    # If no entries set an installed version of zero
    $InstalledVersion = [Version]"0.0.0.0"
}

If ($InstalledVersion -ge $DownloadedVersion) { 
    Write-Host "The installed version of the Microsoft Visual C++ Redistributable is newer or the same as the downloaded version."
}
else { 
    Write-Host "Installing the newer version of the Microsoft Visual C++ Redistributable"
    $UnattendedArgs = "/install /quiet /norestart"
    Start-Process "c:\temp\vc_redist.x64.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
    Write-Host "The installation of the newer version of the Microsoft Visual C++ Redistributable complete"
}

# Download Microsoft Teams WebSocket Service for Media Optimisation
Write-host "Downloading Microsoft Teams WebSocket Service Installation"
Invoke-WebRequest -Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4vkL6" -OutFile "c:\Temp\MsRdcWebRTCSvc_HostSetup_x64.msi" -UseBasicParsing
Write-host "Download of Microsoft Teams WebSocket Service Installation complete"

# Start MSI Installation and Wait
Write-host "Installing Microsoft Teams WebSocket Service"
$LogApp = "${env:SystemRoot}" + "\Temp\MicrosoftTeamsWebSocketService.log"
$UnattendedArgs = "/i `"c:\Temp\MsRdcWebRTCSvc_HostSetup_x64.msi`" /qn ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Microsoft Teams WebSocket Service completed"

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
