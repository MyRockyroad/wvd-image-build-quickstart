<###################################################################################
 
  Adobe Acrobat Reader Latest Download and Installation
  Classic Track - https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/whatsnewdc.html

  Version: 1.0
         : 29 April 2020
         : Change the $release variable to DC if required
         : 2017 is the Classic Track release cycle
         : DC is the Continuous Track release cycle
  Version: 1.1
         : 30 April 2020
         : Added switch from ftp://ftp.adobe.com to http://ardownload.adobe.com/ after finding packages this is much faster
  Note: Copy the AcrobatReaderDefault.mst file to C:\Windows\Temp before running this script                    
 ###################################################################################
#>

$ErrorActionPreference = "Stop"
# Turn off Progress bar to try and make the download faster
$ProgressPreference = "SilentlyContinue"

#Continuous or Classic Track
#$release = "2017"
$release = "DC"
$PackageName = "AcrobatReader$release"

# Check if MST file exists otherwsie exist installation
if (!(Test-Path "C:\windows\temp\AcrobatReaderDefault.mst")) { 
    Write-Host "Unable to locate `"C:\windows\temp\AcrobatReaderDefault.mst`" please make sure it is copied before executing this script"
    exit 1 
}

# Create Temp
Write-Host "Creating c:\Temp if it does not exist"
if (!(Test-Path "c:\Temp")) { 
    New-Item -ItemType Directory -Force -Path "c:\Temp" | Out-Null 
}

# Adobe FTP Location
Write-Host "Adobe Acrobat Reader $release"
$Url = "ftp://ftp.adobe.com/pub/adobe/reader/win/Acrobat$release/"

# With FtpWebRequest you can't use New-Object as it doesn't have a direct constructor. 
# You have to call the static Create method of System.Net.Webrequest with an argument that shows the protocol being used
Write-Host "Getting Directory list from $Url"
$Req = [System.Net.FtpWebRequest]::Create("$Url")
# ListDirectory Method
$Req.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
$Response = $Req.GetResponse()
$ResponseStream = $Response.GetResponseStream()
# Need a TextReader that reads characters from a byte stream 
$StreamReader = New-Object System.IO.Streamreader -ArgumentList $ResponseStream
# Read to end to list
$DirList = $StreamReader.ReadToEnd()
# Close the Reader and cleanup
$StreamReader.Close()
$StreamReader.Dispose()

# Sort list and get the first entry in list excluding the misc folder and empty lines; splitting by carriage return
$Installer = $DirList -split '[\r\n]' | Where-object { $_ -ne "" -and $_ -ne "misc" } | Sort-Object -Descending | Select-Object -Last 1
$LatestVersion = $DirList -split '[\r\n]' | Where-object { $_ -ne "" -and $_ -ne "misc" } | Sort-Object -Descending | Select-Object -First 1

# Found that the Adobe ftp site was extermely slow; someone suggested changeing the ftp://ftp.adobe.com to http://ardownload.adobe.com/ which is much faster
# Only need the FTP to locate the version and executable and then switch
$url = "http://ardownload.adobe.com/pub/adobe/reader/win/Acrobat$release/"

# Build DownloadURL for Installer
$DownloadURL = "$Url$Installer/AcroRdr$($release)$($Installer)_MUI.exe"
Write-Host "Downloading Adobe Acrobat Reader $release Installer"
Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\temp\AcroRdr$($release)$($Installer)_MUI.exe" -UseBasicParsing
Write-Host "Download of Adobe Acrobat Reader $release Installer complete"

# Build DownloadURL for Latest MSP Patch
$DownloadURL = "$Url$LatestVersion/AcroRdr$($release)Upd$($LatestVersion)_MUI.msp"
Write-Host "Downloading latest Adobe Acrobat Reader $release patch - $LatestVersion"
Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\temp\AcroRdr$($release)Upd$($LatestVersion)_MUI.msp" -UseBasicParsing
Write-Host "Download of latest Adobe Acrobat Reader $release patch complete"

# Extract MSI from exe downloaded
Write-host "Extracting Adobe Acrobat Reader MSI from Adobe Self Extractor"
$UnattendedArgs = "-sfx_o`"C:\Temp\AcroRdr`" -sfx_ne -sfx_nu"
Start-Process "C:\temp\AcroRdr$($release)$($Installer)_MUI.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Extracted Adobe Acrobat Reader MSI from Adobe Self Extractor"

# Disable Defender Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Defender RealTime scanning temporarily disabled"

# Start MSI Installation and Wait
Write-host "Installing Adobe Acrobat Reader $release with MSP patch $LatestVersion"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$UnattendedArgs = "/i c:\Temp\AcroRdr\AcroRead.msi PATCH=`"C:\temp\AcroRdr$($release)Upd$($LatestVersion)_MUI.msp`" TRANSFORMS=`"C:\windows\temp\AcrobatReaderDefault.mst`" REBOOT=`"ReallySuppress`" DISABLE_ARM_SERVICE_INSTALL=1 ADD_THUMBNAILPREVIEW=1 /qn ALLUSERS=1 /norestart /log `"$LogApp`""
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-host "Installation of Adobe Acrobat Reader $release completed"

# Remove Adobe Acrobat Reader Scheduled Tasks
Write-host "Removing Adobe Acrobat Reader Scheduled Tasks"
Unregister-ScheduledTask -TaskName "Adobe Acrobat Update Task" -Confirm:$false -ErrorAction SilentlyContinue

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