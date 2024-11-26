<#
.SYNOPSIS
This function retrieves the current date.

.DESCRIPTION
The Get-MyDate function returns the current date as a DateTime object.

.EXAMPLE
Get-MyDate
Returns: Monday, February 12, 2024 3:53:53 PM

.INPUTS
None

.OUTPUTS
[System.DateTime]

#>

function Get-MyDate
{
    $date = Get-Date

    if ($date.Year -eq 2023)
    {
        Write-Verbose "Current Year is 2023"
    }

    return $date
}
