<#
    .SYNOPSIS
    Creates an azure ad application and sets Contributor permissions on subscription and store secret in keyvault
    .NOTES
    Script is provided as an example, it has no error handeling and is not production ready. App name and permissions is hard coded.
#>


$TenantId = "3d4f945a-01da-4fe7-8b74-b8b31ad43d3a"
$SubscriptionId = "4c053226-84c3-4395-b659-6f857e560087"
$ErrorActionPreference = "Continue" # Added cuse of the while loop
$keyVaultName = "kv-wvd-image"


# connecting to Azure Ad
Import-Module AzureRM
Import-Module AzureAD
Connect-AzureAD -TenantId $TenantId


#region App Permissions
# Building resource access objects
# Used get-azureadServicePrincipal -All $true to find the correct api's
## Azure Management API
$AzureMgmtPrincipal = Get-AzureADServicePrincipal -All $true | Where-Object {$_.DisplayName -eq "Windows Azure Service Management API"}
$AzureMgmtAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$AzureMgmtAccess.ResourceAppId = $AzureMgmtPrincipal.AppId

# Permissions
# Explored permissions with 365mgmtPrincipal.AppRoles and .Oauth2Permissions

## Delegated Permissions
# Azure Mgmt
$AzureSvcMgmt = New-Object -TypeName "microsoft.open.azuread.model.resourceAccess" -ArgumentList "41094075-9dad-400e-a0bd-54e686782033", "Scope"


# Add permission objects to the resource access object
$AzureMgmtAccess.ResourceAccess = $AzureSvcMgmt
#endregion



# Create the new apps
$WVDImageBuildApp = New-AzureADApplication -DisplayName "WVD Image Build App"  -RequiredResourceAccess @($AzureMgmtAccess)


# Create and set access key
$WVDImageBuildAppKeySecret = New-AzureADApplicationPasswordCredential -ObjectId $WVDImageBuildApp.ObjectId -CustomKeyIdentifier "Access Key" -EndDate (get-date).AddYears(5)

# Add service principal to our app. Note the tag: https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureadserviceprincipal?view=azureadps-2.0

$WVDImageBuildAppAppSPN = New-AzureADServicePrincipal -AppId $WVDImageBuildApp.AppId -Tags @("WindowsAzureActiveDirectoryIntegratedApp")


# $AzureRMConnection = Add-AzureRmAccount -TenantId $TenantId
# Create a loop to allow azure to create the SPN before setting role


Start-Sleep -Seconds 5
$addRole = New-AzureRmRoleAssignment -ObjectId $WVDImageBuildAppAppSPN.ObjectId -RoleDefinitionName "Contributor" -Scope "/subscriptions/$SubScriptionId"

<#
while ($addRole.DisplayName -ne $WVDImageBuildApp.DisplayName ) {
    Write-Verbose "Waiting for SPN to create"
    Start-Sleep -Seconds 5
    $addRole = New-AzureRmRoleAssignment -ObjectId $WVDImageBuildAppAppSPN.ObjectId -RoleDefinitionName "Contributor" -Scope "/subscriptions/$SubScriptionId"
}
#>

# add tetant id to key vault
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "AzureADTenantId" -SecretValue (ConvertTo-SecureString -String $TenantId -AsPlainText -Force)
# add app id to key vault
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "WVDImageBuildAppClientId" -SecretValue (ConvertTo-SecureString -String $WVDImageBuildApp.AppId -AsPlainText -Force)
# add tetant id to key vault (for wvd)
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "WVDImageBuildAppSecret" -SecretValue (ConvertTo-SecureString -String $WVDImageBuildAppKeySecret.Value -AsPlainText -Force)
# add subscription id to key vault (for wvd)
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "WVDSubscriptionId" -SecretValue (ConvertTo-SecureString -String $SubscriptionId -AsPlainText -Force)
