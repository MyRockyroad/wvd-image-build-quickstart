<###################################################################################
 
  Windows Scheduled Task Cleanup

  Version: 1.0
         : 22 May 2020
         : NOTE only run this script on a Non-persistent image
  Version: 1.1
         : 4 June 2020
         : Rewrote to use splatting as it is easier to read
         
 ###################################################################################
#>

$ErrorActionPreference = "Stop"

# List of Scheduled Tasks to Disable
$ScheduledTaskList = @(
    @{
        TaskName = "AnalyzeSystem"
        TaskPath = "\Microsoft\Windows\Power Efficiency Diagnostics\"
    }
    @{
        TaskName = "BfeOnServiceStartTypeChange"
        TaskPath = "\Microsoft\Windows\Windows Filtering Platform\"
    }
    @{
        TaskName = "BgTaskRegistrationMaintenanceTask"
        TaskPath = "\Microsoft\Windows\BrokerInfrastructure\"
    }
    @{
        TaskName = "Cellular"
        TaskPath = "\Microsoft\Windows\Management\Provisioning\"
    }
    @{
        TaskName = "Consolidator"
        TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"
    }
    @{
        TaskName = "Diagnostics"
        TaskPath = "\Microsoft\Windows\DiskFootprint\"
    }
    @{
        TaskName = "FamilySafetyMonitor"
        TaskPath = "\Microsoft\Windows\Shell\"
    }
    @{
        TaskName = "FamilySafetyRefreshTask"
        TaskPath = "\Microsoft\Windows\Shell\"
    }
    @{
        TaskName = "File History (maintenance mode)"
        TaskPath = "\Microsoft\Windows\FileHistory\"
    }
    @{
        TaskName = "MapsToastTask"
        TaskPath = "\Microsoft\Windows\Maps\"
    }
    @{
        TaskName = "MaintenanceTasks"
        TaskPath = "\Microsoft\Windows\StateRepository\"
    }
    @{
        TaskName = "Microsoft Compatibility Appraiser"
        TaskPath = "\Microsoft\Windows\Application Experience\"
    }
    @{
        TaskName = "Microsoft-Windows-DiskDiagnosticDataCollector"
        TaskPath = "\Microsoft\Windows\DiskDiagnostic\"
    }
    @{
        TaskName = "MNO Metadata Parser"
        TaskPath = "\Microsoft\Windows\Mobile Broadband Accounts\"
    }
    @{
        TaskName = "Notifications"
        TaskPath = "\Microsoft\Windows\Location\"
    }
    @{
        TaskName = "NotificationTask"
        TaskPath = "\Microsoft\Windows\WwanSvc\"
    }
    <# Access denied when disabling PerformRemediation
    @{
        TaskName = "PerformRemediation"
        TaskPath = "\Microsoft\Windows\WaaSMedic\"
    }#>
    @{
        TaskName = "ProgramDataUpdater"
        TaskPath = "\Microsoft\Windows\Application Experience\"
    }
    @{
        TaskName = "ProactiveScan"
        TaskPath = "\Microsoft\Windows\Chkdsk\"
    }
    @{
        TaskName = "ProcessMemoryDiagnosticEvents"
        TaskPath = "\Microsoft\Windows\MemoryDiagnostic\"
    }
    @{
        TaskName = "Proxy"
        TaskPath = "\Microsoft\Windows\Autochk\"
    }
    @{
        TaskName = "QueueReporting"
        TaskPath = "\Microsoft\Windows\Windows Error Reporting\"
    }
    @{
        TaskName = "RecommendedTroubleshootingScanner"
        TaskPath = "\Microsoft\Windows\Diagnosis\"
    }
    @{
        TaskName = "ReconcileFeatures"
        TaskPath = "\Microsoft\Windows\Flighting\FeatureConfig\"
    }
    @{
        TaskName = "ReconcileLanguageResources"
        TaskPath = "\Microsoft\Windows\LanguageComponentsInstaller\"
    }
    @{
        TaskName = "RefreshCache"
        TaskPath = "\Microsoft\Windows\Flighting\OneSettings\"
    }
    @{
        TaskName = "RegIdleBackup"
        TaskPath = "\Microsoft\Windows\Registry\"
    }
    @{
        TaskName = "ResolutionHost"
        TaskPath = "\Microsoft\Windows\WDI\"
    }
    @{
        TaskName = "ResPriStaticDbSync"
        TaskPath = "\Microsoft\Windows\Sysmain\"
    }
    @{
        TaskName = "RunFullMemoryDiagnostic"
        TaskPath = "\Microsoft\Windows\MemoryDiagnostic\"
    }
    # Not Sure
    @{
        TaskName = "ScanForUpdates"
        TaskPath = "\Microsoft\Windows\InstallService\"
    }
    # Not Sure
    @{
        TaskName = "ScanForUpdatesAsUser"
        TaskPath = "\Microsoft\Windows\InstallService\"
    }
    @{
        TaskName = "Scheduled"
        TaskPath = "\Microsoft\Windows\Diagnosis\"
    }
    @{
        TaskName = "Scheduled Start"
        TaskPath = "\Microsoft\Windows\WindowsUpdate\"
    }
    @{
        TaskName = "ScheduledDefrag"
        TaskPath = "\Microsoft\Windows\Defrag\"
    }
    @{
        TaskName = "SilentCleanup"
        TaskPath = "\Microsoft\Windows\DiskCleanup\"
    }
    <# Access denied when disabling sihpostreboot
    @{
        TaskName = "sihpostreboot"
        TaskPath = "\Microsoft\Windows\WindowsUpdate\"
    }#>    
    @{
        TaskName = "SpeechModelDownloadTask"
        TaskPath = "\Microsoft\Windows\Speech\"
    }
    @{
        TaskName = "SmartRetry"
        TaskPath = "\Microsoft\Windows\InstallService\"
    }
    @{
        TaskName = "SpaceAgentTask"
        TaskPath = "\Microsoft\Windows\SpacePort\"
    }
    @{
        TaskName = "SpaceManagerTask"
        TaskPath = "\Microsoft\Windows\SpacePort\"
    }
    @{
        TaskName = "Sqm-Tasks"
        TaskPath = "\Microsoft\Windows\PI\"
    }
    @{
        TaskName = "SR"
        TaskPath = "\Microsoft\Windows\SystemRestore\"
    }
    @{
        TaskName = "StartupAppTask"
        TaskPath = "\Microsoft\Windows\Application Experience\"
    }
    @{
        TaskName = "StartComponentCleanup"
        TaskPath = "\Microsoft\Windows\Servicing\"
    }
    @{
        TaskName = "StorageSense"
        TaskPath = "\Microsoft\Windows\DiskFootprint\"
    }
    <# Access denied when disabling SyspartRepair
    @{
        TaskName = "SyspartRepair"
        TaskPath = "\Microsoft\Windows\Chkdsk\"
    }#>     
    @{
        TaskName = "UninstallDeviceTask"
        TaskPath = "\Microsoft\Windows\Bluetooth\"
    }
    @{
        TaskName = "UpdateLibrary"
        TaskPath = "\Microsoft\Windows\Windows Media Sharing\"
    }
    <# Access denied when disabling UpdateModelTask
    @{
        TaskName = "UpdateModelTask"
        TaskPath = "\Microsoft\Windows\UpdateOrchestrator\"
    }#>      
    @{
        TaskName = "UsbCeip"
        TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"
    }
    @{
        TaskName = "VerifyWinRE"
        TaskPath = "\Microsoft\Windows\RecoveryEnvironment\"
    }
    @{
        TaskName = "WiFiTask"
        TaskPath = "\Microsoft\Windows\NlaSvc\"
    }
    @{
        TaskName = "WiFiTask"
        TaskPath = "\Microsoft\Windows\WCM\"
    }
    @{
        TaskName = "WindowsActionDialog"
        TaskPath = "\Microsoft\Windows\Location\"
    }
    @{
        TaskName = "Windows Defender Scheduled Scan"
        TaskPath = "\Microsoft\Windows\Windows Defender\"
    }
    @{
        TaskName = "WinSAT"
        TaskPath = "\Microsoft\Windows\Maintenance\"
    }
    @{
        TaskName = "WsSwapAssessmentTask"
        TaskPath = "\Microsoft\Windows\Sysmain\"
    }
    @{
        TaskName = "XblGameSaveTask"
        TaskPath = "\Microsoft\XblGameSave\"
    }
           
)

# Loop though each task in above array
Write-Host "Disabling Scheduled Tasks"
Foreach ($Task in $ScheduledTaskList) {
    try {
        # Disable Task
        Disable-ScheduledTask @Task 
    }
    catch { 
        Write-Host "Error processing scheduled task: $($Task.TaskName)"
        exit 1
    }
}
Write-Host "Completed disabling Scheduled Tasks"