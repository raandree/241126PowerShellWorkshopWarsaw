enum CarMake
{
    Toyota
    Honda
    Ford
    Chevrolet
}

enum CarColor
{
    Red
    Blue
    Green
    Black
    White
}

function New-Car
{
    param(
        [CarMake]$Make,
        [string]$Model,
        [int]$Year,
        [CarColor]$Color
    )

    #New-InternalCar -Color $Color -Make $Make -Model $Model -Year $Year
    $PSBoundParameters.Remove('Year')
    New-InternalCar @PSBoundParameters
}

function New-InternalCar
{
    param(
        [CarMake]$Make,
        [string]$Model,
        [string]$Color
    )

    $PSBoundParameters
}

New-Car -Model 'Corolla' -Year 2018 -Color 'Red' -make 'Toyota'