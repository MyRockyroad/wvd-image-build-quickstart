<###################################################################################
 
  Disable Windows Services

  Version: 1.0
         : 22 May 2020
         : https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations

 ###################################################################################
#>

$ErrorActionPreference = "Stop"

# List of Services to disable
$services = @(
    "AJRouter", #AllJoyn Router Service - Routes AllJoyn messages for the local AllJoyn clients.
    "ALG", #Application Layer Gateway Service - Provides support for 3rd party protocol plug-ins for Internet Connection Sharing.
    "BcastDVRUserService", #GameDVR and Broadcast user service - This user service is used for Game Recordings and Live Broadcasts
    "BDESVC", #BitLocker Drive Encryption Service - BDESVC hosts the BitLocker Drive Encryption service
    "BTAGService", #Bluetooth Audio Gateway Service - Service supporting the audio gateway role of the Bluetooth Handsfree Profile.
    "BthAvctpSvc", #AVCTP service - This is Audio Video Control Transport Protocol service
    "bthserv", #Bluetooth Support Service - The Bluetooth service supports discovery and association of remote Bluetooth devices.
    "CDPSvc", #Connected Devices Platform Service - This service is used for Connected Devices Platform scenarios. This is per-user service.
    "CDPUserSvc", #Connected Devices Platform User Service - Template Service for users
    "CSC", #Offline Files Driver - The Offline Files service performs maintenance activities on the Offline Files cache, responds to user logon and logoff events, implements the internals of the public API, and dispatches interesting events to those interested in Offline Files activities and changes in cache state.
    "CscService", #Offline Files - The Offline Files service performs maintenance activities on the Offline Files cache, responds to user logon and logoff events, implements the internals of the public API, and dispatches interesting events to those interested in Offline Files activities and changes in cache state.
    "defragsvc", #Optimize drives - Helps the computer run more efficiently by optimizing files on storage drives.
    "DiagTrack", #Connected User Experiences and Telemetry - The Connected User Experiences and Telemetry service enables features that support in-application and connected user experiences.
    "DPS", #Diagnostic Policy Service - The Diagnostic Policy Service enables problem detection, troubleshooting and resolution for Windows components.
    "DusmSvc", #Data Usage - Network data usage, data limit, restrict background data, metered networks.
    "EFS", #Encrypting File System (EFS) - Provides the core file encryption technology used to store encrypted files on NTFS file system volumes.
    "Fax", #Fax - Enables you to send and receive faxes, utilizing fax resources available on this computer or on the network.
    "fdPHost", #Function Discovery Provider Host - The FDPHOST service hosts the Function Discovery (FD) network discovery providers.
    "FDResPub", #Function Discovery Resource Publication - Publishes this computer and resources attached to this computer so they can be discovered over the network.
    "icssvc", #Windows Mobile Hotspot Service - Provides the ability to share a cellular data connection with another device. Recommended by Microsoft to disable: https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations
    "lfsvc", #Geolocation Service - This service monitors the current location of the system and manages geofences (a geographical location with associated events).  If you turn off this service, applications will be unable to use or receive notifications for geolocation or geofences.
    "MapsBroker", #Downloaded Maps Manager - Windows service for application access to downloaded maps. This service is started on-demand by application accessing downloaded maps. Disabling this service will prevent apps from accessing maps.
    "MessagingService", #MessagingService - Service supporting text messaging and related functionality.
    "PeerDistSvc", #BranchCache - This service caches network content from peers on the local subnet.
    "PimIndexMaintenanceSvc", #Contact Data - Indexes contact data for fast contact searching. If you stop or disable this service, contacts might be missing from your search results.
    "RetailDemo", #Retail Demo Service - The Retail Demo service controls device activity while the device is in retail demo mode.
    "SensrSvc", #Sensor Monitoring Service - Monitors various sensors in order to expose data and adapt to system and user state.
    "SharedAccess", #Internet Connection Sharing (ICS) - Provides network address translation, addressing, name resolution and/or intrusion prevention services for a home or small office network
    "ShellHWDetection", #Shell Hardware Detection - Provides notifications for AutoPlay hardware events.
    "SysMain", #Superfetch - Maintains and improves system performance over time. If optimizing a persistent machine you may leave Superfetch enabled. If optimizing a non-persistent machine, disable it.
    "SSDPSRV", #SSDP Discovery - Discovers networked devices and services that use the SSDP discovery protocol, such as UPnP devices. Also announces SSDP devices and services running on the local computer.
    "TrkWks", #Distributed Link Tracking Client - Maintains links between NTFS files within a computer or across computers in a network domain.
    "upnphost", #UPnP Device Host - Allows UPnP devices to be hosted on this computer.
    "VacSvc", #Volumetric Audio Compositor Service - Hosts spatial analysis for Mixed Reality audio simulation.
    "wbengine", #Block Level Backup Engine Service - The WBENGINE service is used by Windows Backup to perform backup and recovery operations.
    "wcncsvc", #Windows Connect Now - Config Registrar - WCNCSVC hosts the Windows Connect Now Configuration which is Microsoft's Implementation of Wi-Fi Protected Setup (WPS) protocol.
    "WdiServiceHost", #Diagnostic Service Host - The Diagnostic Service Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local Service context.
    "WdiSystemHost", #Diagnostic System Host - The Diagnostic System Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local System context.
    "WerSvc", #Windows Error Reporting Service - Allows errors to be reported when programs stop working or responding and allows existing solutions to be delivered. Also allows logs to be generated for diagnostic and repair services. Disable it if logs are not being gathered and analyzed.
    "WlanSvc", #WLAN AutoConfig - The WLANSVC service provides the logic required to configure, discover, connect to, and disconnect from a wireless local area network (WLAN) as defined by IEEE 802.11 standards.
    "WMPNetworkSvc", #Windows Media Player Network Sharing Service - Shares Windows Media Player libraries to other networked players and media devices using Universal Plug and Play.
    "WpcMonSvc", #Parental Controls - Enforces parental controls for child accounts in Windows. If this service is stopped or disabled, parental controls may not be enforced.
    "WwanSvc", #WWAN AutoConfig - This service manages mobile broadband (GSM & CDMA) data card/embedded module adapters and connections by auto-configuring the networks.
    "XblAuthManager", #Xbox Live Auth Manager - Provides authentication and authorization services for interacting with Xbox Live.
    "XblGameSave", #Xbox Live Game Save - This service syncs save data for Xbox Live save enabled games.
    "XboxGipSvc", #Xbox Accessory Management Service - This service manages connected Xbox Accessories.
    "XboxNetApiSvc" #Xbox Live Networking Service - This service supports the Windows.Networking.XboxLive application programming interface.
)

# Loop though each Service
Write-Host "Disabling Windows Services"
Foreach ($service in $services) {
    try {
        Write-Host "Processing service: $service"
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Set-Service $service -StartupType Disabled 
    }
    catch {
        Write-Host "Failed processing $service"
        exit 1
    }
}
Write-Host "Completed disabling Windows Services"