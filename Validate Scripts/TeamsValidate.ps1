<###################################################################################
 
  Microsoft OneDrive Installation Validation

  Version: 1.0
         : 20 May 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft Teams"

#Check if Executable exists
if (Test-Path "${env:ProgramFiles(x86)}\Microsoft\Teams\current\Teams.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item "${env:ProgramFiles(x86)}\Microsoft\Teams\current\Teams.exe").VersionInfo.FileVersion
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build if Executable found
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}