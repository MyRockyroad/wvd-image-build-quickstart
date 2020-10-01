<###################################################################################
 
  Various optimisations and tweaks

  Version: 1.0
         : 4 June 2020

 ###################################################################################
#>

$ErrorActionPreference = "Stop"

# Registry Keys
$RegistryKeys = @(
    # Set up time zone redirection
    @{    
        Path         = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
        Name         = "fEnableTimeZoneRedirection"
        Value        = "1"
        PropertyType = "DWORD"
    }
    # Disable background auto-layout
    @{    
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout"
        Name         = "EnableAutoLayout"
        Value        = "0"
        PropertyType = "DWORD"
    }
    # Disable background disk defragmentation
    @{ 
        Path         = "HKLM:\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction"
        Name         = "Enable"
        Value        = "N"
        PropertyType = "String"
    }
    # Disable default system screensaver
    @{ 
        Path         = "Registry::HKEY_USERS\.DEFAULT\Control Panel\Desktop"
        Name         = "ScreenSaveActive"
        Value        = "0"
        PropertyType = "DWORD"
    }
    # Disable memory dump creation
    @{ 
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"
        Name         = "CrashDumpEnabled"
        Value        = "0"
        PropertyType = "DWORD"
    }
    # Disable NTFS last access timestamps
    @{ 
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
        Name         = "NtfsDisableLastAccessUpdate"
        Value        = "80000001"
        PropertyType = "DWORD"
    }    
    # Disable the Windows First Logon Animation
    @{ 
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name         = "EnableFirstLogonAnimation"
        Value        = "0"
        PropertyType = "DWORD"
    }  
    # Hide hard error messages
    @{ 
        Path         = "HKLM:\System\CurrentControlSet\Control\Windows"
        Name         = "ErrorMode"
        Value        = "2"
        PropertyType = "DWORD"
    }  
    # Increase Disk I/O Timeout to 200 seconds
    @{ 
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Services\Disk"
        Name         = "TimeOutValue"
        Value        = "0x000000C8"
        PropertyType = "DWORD"
    }
    # Turn off Cortana
    @{ 
        Path         = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Name         = "AllowCortana"
        Value        = "0"
        PropertyType = "DWORD"
    }  
    # Disable Hibernate
    @{ 
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
        Name         = "HibernateEnabled"
        Value        = "0"
        PropertyType = "DWORD"
    }  
    # Disable Storage Sense
    @{ 
        Path         = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense"
        Name         = "AllowStorageSenseGlobal"
        Value        = "0"
        PropertyType = "DWORD"
    }  
    # Windows Update
    @{ 
        Path         = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        Name         = "NoAutoUpdate"
        Value        = "1"
        PropertyType = "DWORD"
    }     
    # Disable Automatic Maintenance
    @{ 
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"
        Name         = "MaintenanceDisabled"
        Value        = "1"
        PropertyType = "DWORD"
    }     
)

# Loop though each Registry Key in the above array
Write-Host "Setting Optimisation Registry Keys"
Foreach ($Key in $RegistryKeys) {
    Write-Host "Processing $($Key.Path) Name=$($Key.Name) Value=$($Key.Value) PropertyType=$($Key.PropertyType)"
    if (Test-Path $Key.Path) {
        New-ItemProperty @Key -Force | Out-Null
    }
    else {
        New-Item -Path $Key.Path -Force | Out-Null
        New-ItemProperty @Key -Force | Out-Null
    }
}
Write-Host "Completed setting Optimisation Registry Keys"