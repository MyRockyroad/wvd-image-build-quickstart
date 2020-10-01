<###################################################################################
 
   Microsoft Visual Studio Code Installation Validation

  Version: 1.0
         : 15 June 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft Visual Studio Code"

#Check if Executable exists
if (Test-Path "$env:ProgramFiles\Microsoft VS Code\Code.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item "$env:ProgramFiles\Microsoft VS Code\Code.exe").VersionInfo.FileVersion
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build if Executable found
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}