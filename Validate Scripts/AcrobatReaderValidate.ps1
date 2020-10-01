<###################################################################################
 
  Adobe Acrobat Reader Installation Validation

  Version: 1.0
         : 1 May 2020

 ###################################################################################
#>

$SoftwareName = "Adobe Acrobat Reader"

#Check if Executable in registry
if (Test-Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe').'(Default)').VersionInfo.FileVersion
    Write-Host "Validated - $SoftwareName $fileVersion"
	
}
else {
    # Fail build if Executable not in registry
    Write-Host "$SoftwareName is not installed."
    exit 1
}