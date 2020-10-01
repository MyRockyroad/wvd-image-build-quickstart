<#
    .SYNOPSIS
    Get build storage account 
    .NOTES
    Script is provided as an example, it has no error handeling and is not production ready. App name and permissions is hard coded.
#>

$TenantId = "3d4f945a-01da-4fe7-8b74-b8b31ad43d3a"
$SubscriptionId = "4c053226-84c3-4395-b659-6f857e560087"
$keyVaultName = "kv-wvd-image"
$Storageaccountname = "sgclwvdtestimage"
$StorageaccountRG = "rg-wvd-test-image"

# connecting to Azure Ad
Import-Module AzureRM
Import-Module AzureAD
Connect-AzureAD -TenantId $TenantId

$SGKeys1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $StorageaccountRG -AccountName $Storageaccountname).Value[0]

$SGKeys2 = (Get-AzureRmStorageAccountKey -ResourceGroupName $StorageaccountRG -AccountName $Storageaccountname).Value[1]


# add storage account name to key vault
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "buildStorageAccount" -SecretValue (ConvertTo-SecureString -String $Storageaccountname -AsPlainText -Force)
# add storage account key 1 to key vault
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "buildStorageAccountkey1" -SecretValue (ConvertTo-SecureString -String $SGKeys1 -AsPlainText -Force)
# add storage account key 2 to key vault (for wvd)
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name "buildStorageAccountkey2" -SecretValue (ConvertTo-SecureString -String $SGKeys2 -AsPlainText -Force)

