<###################################################################################
 
  Sepago ITPC Log Analytics Agent Installation

  Version: 1.0
         : 28 April 2020

  Note: Copy the ITPC-LogAnalyticsAgent.exe.config file to C:\Windows\Temp before running this script         
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

# Download Sepago ITPC Log Analytics Agent Zip File
Write-host "Downloading Sepago ITPC Log Analytics Agent Zip File"
Invoke-WebRequest -Uri "http://loganalytics.sepago.com/downloads/ITPC-LogAnalyticsAgent.zip" -OutFile "c:\temp\ITPC-LogAnalyticsAgent.zip" -UseBasicParsing
Write-host "Download of Sepago ITPC Log Analytics Agent Zip File complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Extract Zip File to C:\Program Files\ITPC-LogAnalyticsAgent
Write-host "Extracting ITPC-LogAnalyticsAgent.zip to C:\Program Files\Azure Monitor for WVD"
Expand-Archive -path "c:\temp\ITPC-LogAnalyticsAgent.zip" -DestinationPath $env:ProgramFiles

# Move Config file from C:\windows\temp to C:\Program Files\Azure Monitor for WVD
Write-Host "Moving Configuration file from c:\windows\temp to C:\Program Files\Azure Monitor for WVD"
$SourceFile = "C:\Windows\Temp\ITPC-LogAnalyticsAgent.exe.config"
$Destination = "C:\Program Files\Azure Monitor for WVD\ITPC-LogAnalyticsAgent.exe.config"
if(Test-Path -Path $SourceFile)
{
    Move-Item -Path $SourceFile -Destination $Destination -Force
}

# Run ITPC-LogAnalyticsAgent.exe -install to register Scheduled Tasks
Write-Output "Running ITPC-LogAnalyticsAgent -install to create scheduled tasks"
$UnattendedArgs = "-install"
Start-Process "C:\Program Files\Azure Monitor for WVD\ITPC-LogAnalyticsAgent.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow

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