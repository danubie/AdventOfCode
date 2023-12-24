function Get-CalibrationValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputObject,
        [switch] $Part2
    )

    begin {

    }

    process {
        if ($Part2) {
            $digitNames = @('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine')

            $regexLastDigit = [regex] '(?=(\d|zero|one|two|three|four|five|six|seven|eight|nine))'
            $m = $regexLastDigit.Matches($InputObject)
            $firstdigit = $m[0].Groups[1].Value
            $lastdigit = $m[-1].Groups[1].value

            if ($firstdigit -in $digitNames) {
                $firstdigit = $digitNames.IndexOf($firstdigit)
            }
            else {
                $firstdigit = [int]$firstdigit
            }
            if ($lastdigit -in $digitNames) {
                $lastdigit = $digitNames.IndexOf($lastdigit)
            }
            else {
                $lastdigit = [int]$lastdigit
            }
            return $firstdigit * 10 + $lastdigit
        }
        else {
            $regexFirstDigit = [regex] '^[^\d]*(\d)'
            $firstdigit = $regexFirstDigit.Match($InputObject).Groups[1].Value
            $regexLastDigit = [regex] '(\d)[^\d]*$'
            $lastdigit = $regexLastDigit.Match($InputObject).Groups[1].Value
            return ([int]$firstdigit) * 10 + ([int]$lastdigit)
        }
    }

    end {

    }
}

function Day01 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    $result = Get-Content $InputFile | Get-CalibrationValue -Part2:$Part2 | Measure-Object -Sum
    $result.Sum
}