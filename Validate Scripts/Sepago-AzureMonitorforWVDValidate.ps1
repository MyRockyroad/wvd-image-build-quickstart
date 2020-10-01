<###################################################################################
 
  Sepago Azure Monitor for WVD Premium Agent Installation Validation

  Version: 1.0
         : 13 May 2020

 ###################################################################################
#>

$SoftwareName = "Sepago Azure Monitor for WVD Premium Agent"

#Check if Executable exists
if (Test-Path "$env:ProgramFiles\Azure Monitor for WVD - Premium\ITPC-LogAnalyticsAgent.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item "$env:ProgramFiles\Azure Monitor for WVD - Premium\ITPC-LogAnalyticsAgent.exe").VersionInfo.FileVersion
    
    #Check Scheduled Task exists
    $task = Get-ScheduledTask -TaskName "ITPC-LogAnalyticAgent for RDS and Citrix" -ErrorAction SilentlyContinue
    
    if (! $task) {
        Write-Host "$SoftwareName is not installed. Scheduled Task does not exist. Failing Build." -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
    } 
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}