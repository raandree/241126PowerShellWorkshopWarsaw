<#
      .SYNOPSIS
        Diese Funktion prüft, ob die notwendigen Voraussetzungen für KDialog erfüllt sind.

      .DESCRIPTION
        Diese Funktion prüft, ob die notwendigen Voraussetzungen für KDialog erfüllt sind.

      .EXAMPLE
        Test-KDialog
        Diese Funktion prüft, ob die notwendigen Voraussetzungen für KDialog erfüllt sind.

#>

function Test-KDialog
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]

    $temp = 'c:\temp'
    $kDialogPath = "${env:ProgramFiles(x86)}\KONSENS\KDialog\bobno000.exe"
    $kDialogClientUpdatePath = "$([System.Environment]::GetFolderPath('CommonApplicationData'))\KONSENS\KDialog\Log\kdialogclientupdate.log"
    $bnoInstallPath = "$($env:KD_BNO_INSTALLDIR)\installtime.txt"
    $fpaPath = "${env:ProgramFiles(x86)}\Common Files\KONSENS\KDialog\Fremdprogrammaufrufe"

    $healthService = Get-Service -Name HealthService
    if ($healthService.Status -ne 'Running')
    {
        Write-Host 'SCOM Dienst nicht gestartet'
        return $false
    }

    if (-not (Test-Path -Path $temp\gpupdateresults.txt))
    {
        Write-Host 'gpupdateresults.txt nicht vorhanden'
        return $false
    }

    $search_Cd = '*Die Aktualisierung der Computerrichtlinie wurde erfolgreich abgeschlossen*'
    $search_Ud = '*Die Aktualisierung der Benutzerrichtlinie wurde erfolgreich abgeschlossen*'
    $search_Ce = '*Computer Policy update has completed successfully*'
    $search_Ue = '*User Policy update has completed successfully*'
    $GPUR = Get-Content -Path $temp\gpupdateresults.txt
    if (($GPUR -notlike $search_Cd -or $GPUR -notlike $search_Ud) -or
        ($GPUR -notlike $search_Ce -or $GPUR -notlike $search_Ue))
    {
        Write-Host 'GPO Abarbeitung fehlgeschlagen'
        'GPO Abarbeitung fehlgeschlagen' | Out-File c:\install\mm.txt
        return $false
    }

    if (-not (Test-Path -Path $kDialogPath -PathType Leaf))
    {
        Write-Host 'KDialog nicht installiert'
        'KDialog nicht installiert' | Out-File c:\install\mm.txt
        return $false
    }

    if (-not (Test-Path -Path 'c:\ProgramData\NDL\Schwenk\Log'))
    {
        Write-Host 'Schwenk log nicht vorhanden'
        'Schwenk log nicht vorhanden' | Out-File c:\install\mm.txt
        return $false
    }

    if (-not (Test-Path -Path $kDialogClientUpdatePath))
    {
        Write-Host 'kdialogclientupdate.log nicht vorhanden'
        'kdialogclientupdate.log nicht vorhanden' | Out-File c:\install\mm.txt
        return $false
    }

    if (-not (Test-Path -Path $bnoInstallPath))
    {
        Write-Host 'Installtime.txt nicht vorhanden'
        'Installtime.txt nicht vorhanden' | Out-File c:\install\mm.txt
        return $false
    }

    $servInfoExists = Test-Path -Path "$fpaPath\servinfo.ini"
    $serviceInfoExists = Test-Path -Path "$fpaPath\ServiceInfo.ini"
    $hilfeServiceInfoExists = Test-Path -Path "$fpaPath\hilfe_service-info.ini"

    if ($servInfoExists -and -not
        $serviceInfoExists -and -not
        $hilfeServiceInfoExists)
    {
        Write-Host 'Fremdprogrammaufruf nicht vorhanden'
        'Fremdprogrammaufruf nicht vorhanden' | Out-File c:\install\mm.txt
        return $false
    }

    Write-Host 'Alle Tests erfolgreich'
    return $true
}