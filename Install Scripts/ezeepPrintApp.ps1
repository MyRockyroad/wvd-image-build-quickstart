<###################################################################################
 
  ezeep Print App Installation

  Version: 1.0
         : 29 April 2020
                     
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
Write-host "Downloading ezeepPrintApp"
Invoke-WebRequest -Uri "https://ezeep.com/products/ezeep/wvd/ezeepPrintApp.exe" -OutFile "c:\Temp\ezeepPrintApp.exe" -UseBasicParsing
Write-host "Download of ezeepPrintApp complete"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

#Extract MSI from ezeePrintApp.exe to c:\temp
Write-host "Extracting ezeepPrintApp MSI to c:\Temp"
$UnattendedArgs = "/s /x /b`"c:\Temp`" /v`"/qn`""
Start-Process "c:\Temp\ezeepPrintApp.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow

#Install ezeep Print App
Write-host "Installing ezeep Print App"
$LogApp = "${env:SystemRoot}" + "\Temp\ezeepPrintApp.log"
$UnattendedArgs = "/i `"c:\temp\ezeep Print App.msi`" /qn ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of ezeep Print App completed"

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