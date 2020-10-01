<###################################################################################

  Azure Windows VM agent Installation Validation

  Version: 1.0
         : 18 May 2020

 ###################################################################################
#>

$SoftwareName = "Azure Windows VM Agent"

# Check if services exist
If ((Get-Service RdAgent -ErrorAction SilentlyContinue) -and (Get-Service WindowsAzureTelemetryService -ErrorAction SilentlyContinue) -and (Get-Service WindowsAzureGuestAgent -ErrorAction SilentlyContinue)) { 
  try {
    $fileVersion = (Get-Item (Get-ItemProperty (Get-Process WindowsAzureGuestAgent).Path)).VersionInfo.FileVersion
  }
  catch {
    # error getting file version but ok as services are running
    $fileversion = $null
  }
  Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
  # Fail build if Executable found
  Write-Host "$SoftwareName is not installed correctly. Failing Build." -ForegroundColor Red
  exit 1
}