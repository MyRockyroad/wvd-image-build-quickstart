<###################################################################################
 
  Final Cleanup

  Version: 1.0
         : 4 May 2020
         : Clean up WinSxS
                     
 ###################################################################################
#>

Write-Host "Cleanup WinSxS"
$UnattendedArgs = "/online /Cleanup-Image /StartComponentCleanup /ResetBase"
Start-Process "$env:systemroot\system32\Dism.exe" -ArgumentList $UnattendedArgs -Wait -NoNewWindow
Write-Host "Cleanup of WinSxS complete"
