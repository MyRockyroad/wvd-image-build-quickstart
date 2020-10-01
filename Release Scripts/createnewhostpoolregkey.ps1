

$resourcegroupname = "rg-wvd"
$hostpoolname = "Non Nerdio Test"

New-AzWvdRegistrationInfo -ResourceGroupName $resourcegroupname -HostPoolName $hostpoolname -ExpirationTime $((get-date).ToUniversalTime().AddHours(8).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ'))

$token = Get-AzWvdRegistrationInfo -ResourceGroupName $resourcegroupname -HostPoolName $hostpoolname

