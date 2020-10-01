<###################################################################################
 
  Microsoft OneDrive Installation Validation

  Version: 1.0
         : 20 May 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft OneDrive"

#Check if Executable in registry
if (Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive") {
	
    # Get Version Info
    $fileVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive').Version
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}