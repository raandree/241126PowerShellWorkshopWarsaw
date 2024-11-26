<#
      .SYNOPSIS
        Diese Funktion beendet den Wartungsmodus für eine VDA-Maschine.

      .DESCRIPTION
        Diese Funktion beendet den Wartungsmodus für eine VDA-Maschine.

      .EXAMPLE
        Disable-CtxMaintenanceMode
        
        Diese Funktion beendet den Wartungsmodus für eine VDA-Maschine.
#>

function Disable-CtxMaintenanceMode
{
    param (
        [Paramter()]
        [string]$DesktopDeliveryController = 'resxaddc1'

    )
    $computerDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().Name.Split('.')[0]
    $vm = "$computerDomain\$($env:Computername)"

    $vm | Set-BrokerMachineMaintenanceMode -MaintenanceMode $false -AdminAddress $DesktopDeliveryController

    Write-Host 'Maintenance Mode beendet'
}
