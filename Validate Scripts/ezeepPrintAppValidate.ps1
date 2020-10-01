<###################################################################################

  ezeep Print App Installation Validation

  Version: 1.0
         : 1 May 2020

 ###################################################################################
#>

$SoftwareName = "ezeep Print App"

#Check if Executable in registry
if (Test-Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\TPAutoConnect.exe") {
    
    # Get File Version Info from TPSelfService.exe as this seems to be the closest in version numbers
    if (Test-Path "C:\Program Files\Common Files\ThinPrint\TPSelfService\TPSelfService.exe") {
        $fileVersion = (Get-Item (Get-ItemProperty "C:\Program Files\Common Files\ThinPrint\TPSelfService\TPSelfService.exe")).VersionInfo.FileVersion   
        Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
    }
    else {
        # Fail build if Executable not in registry
        Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
        exit 1    
    }
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}