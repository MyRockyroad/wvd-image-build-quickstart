<###################################################################################
 
  Appx Package Cleanup

  Version: 1.0
         : 22 May 2020
  Version: 1.1
         : 29 May 2020         
         : Issue with Windows 2004 20H1 - added a try catch and retry of command
                
 ###################################################################################
#>

$ErrorActionPreference = "Stop"

# List of Appx Packages to remove
$AppxPackages = @(
    "Microsoft.BingWeather",
    # "Microsoft.DesktopAppInstaller",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.HEIFImageExtension",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    # "Microsoft.MSPaint",
    "Microsoft.MixedReality",
    "Microsoft.Office.OneNote",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.VP9VideoExtensions",
    "Microsoft.Wallet",
    "Microsoft.WebMediaExtensions",
    "Microsoft.WebpImageExtension",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsAlarms",
    # "Microsoft.WindowsCalculator",
    "Microsoft.WindowsCamera",
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

Foreach ($Item in $AppxPackages) {
    # Wild Card the Package to remove
    $Package = "*$Item*"
    
    $success = $false
    $retryCount = 2 

    #Found with 20H1 that sometimes the removal doesn't always complete successfully - added a retry
    Write-Host "Removing Appx Package: $Item"
    while ((!$success) -and ($retryCount -ge 0)) {
        try {
            Get-AppxPackage | Where-Object { $_.PackageFullName -like $Package } | Remove-AppxPackage
            Get-AppxPackage -AllUsers | Where-Object { $_.PackageFullName -like $Package } | Remove-AppxPackage -AllUsers
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $Package } | Remove-AppxProvisionedPackage -Online
            $success = $true
        }
        catch {
            $retryCount--
            # Sometimes just rerunning the AppProvisionedPackage Removal before the Remove-AppxPackage -AllUsers works
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $Package } | Remove-AppxProvisionedPackage -Online | Out-Null
        }
    }
    
    if (!$success) {
        Write-host $_.Exception.Message
        Write-Host "Unable to remove: $Item - failing the build."
        exit 1
    }
    else {
        Write-Host "Completed removing Appx Package: $Item"
    }
}