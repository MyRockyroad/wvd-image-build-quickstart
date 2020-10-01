<###################################################################################
 
  Sepago Azure Monitor for WVD Premium Agent Installation

  Version: 1.0
         : 13 May 2020
     
 ###################################################################################
#>

$ErrorActionPreference = "Stop"
# Turn off Progress bar to try and make the download faster
$ProgressPreference = "SilentlyContinue"
# Azure Storage Account User
$Usr = "AzureAD\" + $env:AppInstallsStorageAccountName

# Create Temp
Write-Host "Creating c:\Temp if it does not exist"
if (!(Test-Path "c:\Temp")) { 
    New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
}

# Import Smbshare module
Import-Module -Name Smbshare -Force -Scope Local

# Map Drive to Azure File Share
Write-Host "Mapping I: to $($env:packaged_app_installs_path)"
New-SmbMapping -LocalPath I: -RemotePath $env:packaged_app_installs_path -Username $Usr -Password $env:AppInstallsStorageAccountKey
Write-Host "I: drive mapped"

# Copy Azure Monitor for WVD - Premium.zip to c:\Temp
Copy-Item "I:\sepago\Azure Monitor for WVD - Premium.zip" "c:\temp\AzureMonitorforWVD.zip"
Write-Host "Copied `"Azure Monitor for WVD - Premium.zip`" to `"c:\Temp`""

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Extract Zip File to C:\Program Files\Azure Monitor for WVD - Premium
Write-host "Extracting AzureMonitorforWVD.zip to C:\Program Files\Azure Monitor for WVD - Premium"
Expand-Archive -path "c:\temp\AzureMonitorforWVD.zip" -DestinationPath $env:ProgramFiles

# Run ITPC-LogAnalyticsAgent.exe -install to register Scheduled Tasks
Write-Output "Running ITPC-LogAnalyticsAgent -install to create scheduled tasks"
$UnattendedArgs = "--CustomerId $($env:LogWorkspaceID) --SharedKey $($env:LogWorkspaceSecret) -i -n -s"
Start-Process "$env:ProgramFiles\Azure Monitor for WVD - Premium\ITPC-LogAnalyticsAgent.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow

# Cleanup Temp
Write-Host "Removing files from c:\Temp"
if (Test-Path "c:\temp") { 
    Get-ChildItem "c:\temp" | Remove-Item -Recurse
}

# UnMap Drive
Remove-SmbMapping -LocalPath I: -Force
Write-Host "I: drive unmapped"

# Set Progress bar back to default
$ProgressPreference = "Continue"

# Reenable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "Defender RealTime scanning enabled"