<###################################################################################
 
  Microsoft RSAT Tools Installation Validation

  Version: 1.0
         : 15 June 2020

 ###################################################################################
#>

$SoftwareName = "Microsoft RSAT Tools"

#Check if JSON exists - this was created as part of the installation
if (Test-Path "${env:windir}\temp\RSATTools.json") {
    $RSATTools = Get-Content "${env:windir}\temp\RSATTools.json" | ConvertFrom-Json
    foreach ($RSATTool in $RSATTools) {
        $installed = Get-WindowsCapability -Name $RSATTool.Name -Online | Where-Object { $_.State -eq "Installed" }
        If (!$installed) {
            Write-Host "$($RSATTool.Name) is not installed but was listed in the RSAT Tools install script. Failing Build." -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "Validated - $SoftwareName $fileVersion" -ForegroundColor Green
}
else {
    # Fail build as json not found - this was created as part of the installation
    Write-Host "$SoftwareName are not installed correctly as unable to find ${env:windir}\temp\RSATTools.json. Failing Build." -ForegroundColor Red
    exit 1
}