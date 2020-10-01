<###################################################################################
 
  Disable Windows System Startup Event Traces

  Version: 1.0
         : 22 May 2020
         : https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations

 ###################################################################################
#>

$ErrorActionPreference = "Stop"

# List of Appx Packages to remove
$EventTraces = @(
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AppModel\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\CloudExperienceHostOOBE\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NtfsLog\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot\",
    #"HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TileStore\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM\",
    #"HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WDIContextLog\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSession\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession\",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WinPhoneCritical\"
)

# Loop though each Trace
Write-Host "Disabling Windows System Startup Event Traces"
Foreach ($Trace in $EventTraces) {
    if (Test-Path $Trace) {
        Write-Host "Processing $Trace"  
        New-ItemProperty -Path "$Trace" -Name "Start" -PropertyType "DWORD" -Value "0" -Force | Out-Null
    }
    else {
        Write-Host "No need to process $Trace as not found."
    }
}
Write-Host "Completed disabling Windows System Startup Event Traces"