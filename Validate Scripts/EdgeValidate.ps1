<###################################################################################

  Microsoft Edge Chromium Enterprise Installation Validation

  Version: 1.0
         : 1 May 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft Edge Chromium Enterprise"

#Check if Executable in registry
if (Test-Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.FileVersion
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}