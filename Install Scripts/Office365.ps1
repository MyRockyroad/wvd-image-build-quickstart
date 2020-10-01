<###################################################################################
 
  Office 365 Download and Installation

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

# Get Microsoft download link to Office Deployment Tool
Write-Host "Getting link to download latest Office Deployment Tool"
$url = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117"
$response = Invoke-WebRequest -UseBasicParsing -Uri $url -ErrorAction SilentlyContinue
# Get link based on the download manually link
$URL = ($response.links | Where-Object {$_.outerHTML -like "*click here to download manually*"}).href

# Download Office Deployment Tool
Write-Host "Downloading from link - $URL"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "c:\Temp\officedeploymenttool.exe"
Write-Host "Download of Office Deployment Tool complete"

# Extartct to C:\temp
Write-Host "Extracting Office Deployment Tool to c:\temp"
$UnattendedArgs = "/quiet /extract:c:\Temp"
Start-Process c:\Temp\officedeploymenttool.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

#Run Office Installation
Write-host "Installing Office 365"
$UnattendedArgsOff ="/configure $($env:systemroot)\temp\configuration-Office365.xml"
Start-Process c:\Temp\setup.exe -ArgumentList $UnattendedArgsOff -Wait -NoNewWindow
Write-host "Installation of Office 365 Completed"

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