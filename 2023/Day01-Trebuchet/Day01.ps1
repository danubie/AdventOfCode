function Get-CalibrationValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputObject
    )

    begin {

    }

    process {
        $regexFirstDigit = [regex] '^[^\d]*(\d)'
        $firstdigit = $regexFirstDigit.Match($InputObject).Groups[1].Value
        $regexLastDigit = [regex] '(\d)[^\d]*$'
        $lastdigit = $regexLastDigit.Match($InputObject).Groups[1].Value
        return ([int]$firstdigit)*10 + ([int]$lastdigit)
    }

    end {

    }
}

function Day01 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/../Input.txt"
    )
    $result = Get-Content $InputFile | Get-CalibrationValue | Measure-Object -Sum
    $result.Sum
}