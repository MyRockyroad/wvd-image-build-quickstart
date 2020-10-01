<###################################################################################
 
  Notepad++ Installation

  Version: 2.0
         : 24 April 2020
         :Rewrite to fetch Latest from Notepad++ Site
                     
 ###################################################################################
#>
$ErrorActionPreference = "Stop"
# Turn off Progress bar to try and make the download faster
$ProgressPreference = "SilentlyContinue"

# Create Temp
Write-Host "Creating c:\Temp if it does not exist"
if (!(Test-Path "c:\Temp")) { 
    New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
}

# Notepad++ Download Website redirects to github so we will go there directly via its API site
Write-Host "Connecting to Notepad++ GitHub API to locat url for Latest Notepad++ asset"
$api = (Invoke-WebRequest -Uri "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest" -UseBasicParsing).Content | ConvertFrom-Json
# Find the Latest x64 bit asset
$file = $api.assets | Where-Object { $_.name -like "*.x64.exe*" -and $_.name -notlike "*.x64.exe.sig" } | Select-Object name, browser_download_url
# Find Checksums File
$checksumfile = $api.assets | Where-Object { $_.name -like "*checksums.sha256*" -and $_.name -notlike "*checksums.sha256.sig"} | Select-Object name, browser_download_url
#Downloading Files
Write-Host "Downloading $($file.name)"
Invoke-WebRequest -Uri $file.browser_download_url -OutFile "c:\temp\$($file.name)" -UseBasicParsing
Write-Host "Downloading $($checksumfile.name)"
Invoke-WebRequest -Uri $checksumfile.browser_download_url -OutFile "c:\temp\$($checksumfile.name)"
Write-Host "Download of Notepad++ complete"

# Confirm File checksum and Fail if no match
# Get exe filehash
Write-Host "Checking File Hash"
$checksum = Get-FileHash "c:\temp\$($file.name)" | select-object Hash
# Read checkksums file and find the line with the checksum to our exe
$downloadedchecksum = (Get-Content -Path "c:\temp\$($checksumfile.name)" | Select-String -Pattern $($file.name)).tostring()
$checksumarr = $downloadedchecksum.Split(" ")
# Compare Checksums and Fail if not matching
if ($checksumarr[0] -ne $checksum.Hash)
{
    write-host "Downloaded File $($file.name) does not match the Hash in $($checksumfile.name) - Aborting build"
    exit 1
}
Write-Host "File Hash - ok."
# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

#Install Notepad++
Write-host "Installing Notepad++"
$UnattendedArgs = "/S"
Start-Process "C:\Temp\$($file.name)" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-Host "Installation of Notepad++ completed"

# Cleanup Temp
Write-Host "Removing files from c:\Temp"
if (Test-Path "c:\temp") { 
    Get-ChildItem "c:\temp" | Remove-Item -Recurse
}

# Set Progress bar back to default
$ProgressPreference = "Continue"

# Reenable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "Defender RealTime scanning enabled"