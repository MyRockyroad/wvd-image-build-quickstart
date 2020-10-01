<###################################################################################
 
  Microsoft Teams WebSocket Service for Media Optimisation Installation Validation

  Version: 1.0
         : 2 June 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft Teams WebSocket Service for Media Optimisation"

# Remote Desktop Services WebRTC Redirector

#Check if Executable exists
if (Test-Path "${env:ProgramFiles}\Remote Desktop WebRTC Redirector\MsRdcWebRTCSvc.exe") {
	
    # Get File Version Info
    $fileVersion = (Get-Item "${env:ProgramFiles}\Remote Desktop WebRTC Redirector\MsRdcWebRTCSvc.exe").VersionInfo.FileVersion
    
    #Check Scheduled Task exists
    $service = Get-Service -name "RDWebRTCSvc" -ErrorAction SilentlyContinue
    
    if (! $service) {
        Write-Host "$SoftwareName is not installed. Service does not exist. Failing Build." -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
    } 
}
else {
    # Fail build if Executable not found
    Write-Host "$SoftwareName is not installed. Failing Build." -ForegroundColor Red
    exit 1
}