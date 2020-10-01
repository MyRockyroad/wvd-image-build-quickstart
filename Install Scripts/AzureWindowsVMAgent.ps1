<###################################################################################
 
  Azure Windows VM Agent Check/Installation

  Version: 1.0
         : 18 May 2020
         : The Windows VM Agent should be automativally deployment when provisioing
         : a new VM but I found an issue with build 971 where the Telemetry Service
         : is just missing. This script will check the Azure services and if not
         : installed correctly will download and install the agent
                     
 ###################################################################################
#>
$ErrorActionPreference = "Stop"


#Check Azure VM Agent Services and if not ok install
If ((Get-Service RdAgent -ErrorAction SilentlyContinue) -and (Get-Service WindowsAzureTelemetryService -ErrorAction SilentlyContinue) -and (Get-Service WindowsAzureGuestAgent -ErrorAction SilentlyContinue)) { 
    Write-Host "Azure Windows VM Agent Services (RdAgent, WindowsAzureTelemetryService and WindowsAzureGuestAgent) found - no need to continue installation." 
}
else {
    # Turn off Progress bar to try and make the download faster
    $ProgressPreference = "SilentlyContinue"

    # Create Temp
    Write-Host "Creating c:\Temp if it does not exist"
    if (!(Test-Path "c:\Temp")) { 
        New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
    }

    # Download Azure Windows VM Agent installer
    Write-host "Downloading Azure Windows VM Agent"
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=394789" -OutFile "c:\Temp\WindowsAzureVmAgent.msi" -UseBasicParsing
    Write-host "Download of Azure Windows VM Agent complete"

    # Disable Defender Realtime Monitoring
    Set-MpPreference -DisableRealtimeMonitoring $true
    Write-Host "Defender RealTime scanning temporarily disabled"

    #Install Azure Windows VM Agent
    Write-host "Installing Azure Windows VM Agent"
    $LogApp = "${env:SystemRoot}" + "\Temp\WindowsAzureVmAgent.log"
    $UnattendedArgs = "/i `"c:\temp\WindowsAzureVmAgent.msi`" /qn /log `"$LogApp`""
    Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow

    #Wait for each serivce to be created and running
    $services = @("RdAgent","WindowsAzureTelemetryService","WindowsAzureGuestAgent")
    foreach ($service in $services) {
        $count = 0 
        while ((Get-Service $service -ErrorAction SilentlyContinue).Status -ne 'Running') { 
            $count++
            if ($count -ge 20) {
                Write-Host ("`"$($service))`" - took to long to create and start - failing build.")
                exit 1
            }
            write-output "Waiting for the `"$($service)`" service to be created and start."
            Start-Sleep -s 5 
        }
    }

    Write-host "Installation of Azure Windows VM Agent completed"

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
}