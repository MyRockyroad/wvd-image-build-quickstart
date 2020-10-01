<###################################################################################
 
  Office 365 Installation Validation

  Version: 1.0
         : 1 May 2020

 ###################################################################################
#>

$SoftwareName = "Office 365"

#Check if Executable in registry - decided Word should be enough to check
if (Test-Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe').'(Default)').VersionInfo.FileVersion
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}