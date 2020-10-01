<###################################################################################
 
  Microsoft Visual Studio Code Latest Download and Installation

  Version: 1.0
        : 15 June 2020
                     
 ###################################################################################
#>

$ErrorActionPreference = "Stop"

$RSATTools = @(
    @{
        Name        = "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
        DisplayName = "Active Directory Domain Services and Lightweight Directory Services Tools"
    }
    <#    @{
        Name        = "Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0"
        DisplayName = "BitLocker Drive Encryption Administration Utilities"
    }#>
    <#     @{
        Name        = "Rsat.CertificateServices.Tools~~~~0.0.1.0"
        DisplayName = "Active Directory Certificate Services Tools"
    } #>
    <#     @{
        Name        = "Rsat.DHCP.Tools~~~~0.0.1.0"
        DisplayName = "DHCP Server Tools"
    } #>
    @{
        Name        = "Rsat.Dns.Tools~~~~0.0.1.0"
        DisplayName = "DNS Server Tools"
    }
    <#     @{
        Name        = "Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0"
        DisplayName = "Failover Clustering Tools"
    } #>
    <#     @{
        Name        = "Rsat.FileServices.Tools~~~~0.0.1.0"
        DisplayName = "File Services Tools"
    } #>
    @{
        Name        = "Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0"
        DisplayName = "Group Policy Management Tools"
    }
    <#     @{
        Name        = "Rsat.IPAM.Client.Tools~~~~0.0.1.0"
        DisplayName = "IP Address Management (IPAM) Client"
    } #>
    <#     @{
        Name        = "Rsat.LLDP.Tools~~~~0.0.1.0"
        DisplayName = "Data Center Bridging LLDP Tools"
    } #>
    <#     @{
        Name        = "Rsat.NetworkController.Tools~~~~0.0.1.0"
        DisplayName = "Network Controller Management Tools"
    } #>
    <#     @{
        Name        = "Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0"
        DisplayName = "Network Load Balancing Tools"
    } #>
    <#     @{
        Name        = "Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0"
        DisplayName = "Remote Access Management Tools"
    } #>
    <#     @{
        Name        = "Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0"
        DisplayName = "Remote Desktop Services Tools"
    } #>
    @{
        Name        = "Rsat.ServerManager.Tools~~~~0.0.1.0"
        DisplayName = "Server Manager"
    } 
    <#     @{
        Name        = "Rsat.Shielded.VM.Tools~~~~0.0.1.0"
        DisplayName = "Shielded VM Tools"
    } #>
    <#     @{
        Name        = "Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0"
        DisplayName = "Storage Migration Service Management Tools"
    } #>
    <#     @{
        Name        = "Rsat.StorageReplica.Tools~~~~0.0.1.0"
        DisplayName = "Storage Replica Module for Windows PowerShell"
    } #>
    <#     @{
        Name        = "Rsat.SystemInsights.Management.Tools~~~~0.0.1.0"
        DisplayName = "System Insights Module for Windows PowerShell"
    } #>
    <#     @{
        Name        = "Rsat.VolumeActivation.Tools~~~~0.0.1.0"
        DisplayName = "Volume Activation Tools"
    } #>
    <#     @{
        Name        = "Rsat.WSUS.Tools~~~~0.0.1.0"
        DisplayName = "Windows Server Update Services Tools"
    }  #>     
)

# Write the items to be installed out to a json file so we can validate this install in the Validation Script
try {
    Write-Host "Outputting the selected RSAT Tools to ${env:windir}\temp\RSATTools.json"
    $RSATTools | ConvertTo-Json | Out-File "${env:windir}\temp\RSATTools.json" -Force
}
catch {
    Write-Host "Failed to output the list of RSAT Tools to install - Failing the build!"
    exit 1
}

# Found that tools would not install due to Windows Update default setting
# Save current setting to be used later
$AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (Get-ItemProperty -Path $AUPath -Name "UseWUServer" -ErrorAction SilentlyContinue) {
    $currentWU = Get-ItemProperty -Path $AUPath -Name "UseWUServer" | Select-Object -ExpandProperty UseWUServer
    Set-ItemProperty -Path $AUPath -Name "UseWUServer" -Value 0 -Force | Out-Null
    # Record that key already existed
    $keycreated = $false
}
else {
    New-Item $AUPath -Force | Out-Null
    New-ItemProperty $AUPath -Name "UseWUServer" -Value 0 | Out-Null
    # Record that key had to be created
    $keycreated = $true
}
Restart-Service wuauserv

# Install Tools
foreach ($RSATTool in $RSATTools) {
    try {
        Write-Host "Installing: $($RSATTool.DisplayName)"
        Add-WindowsCapability -Name $RSATTool.Name -Online | Out-Null
    }
    catch {
        Write-Host "Error Installing: $($RSATTool.DisplayName) - Failing the build!"
        Write-Host $_.Exception.Message
        exit 1
    }
}

# Set Windows Update Setting back to default
if ($keycreated) {
    Remove-ItemProperty -Path $AUPath -Name "UseWUServer"
}
else {
    Set-ItemProperty -Path $AUPath -Name "UseWUServer" -Value $currentWU 
}

Restart-Service wuauserv

Write-Host "Installation of RSAT Tools Complete."
