using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Collections.Concurrent

function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-Content $InputFile
    foreach ($line in $InputData) {
        # it are all a bunch of numbers
        $numbers = [List[int]] ($line -split '\s+' -match '\d+')
        $report = [PSCustomObject]@{
            Numbers = $numbers
        }
        $report
    }
}

function Get-Prediction {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [List[int]]$Numbers
    )
    # we get a list of numbers, and we need to predict the next one
    # first reverse the list, then build the difference list
    $Numbers.Reverse()
    $finished = $false
    $before = [List[int]] $Numbers.ToArray()
    $diffsOfTheFirstElements = while (-not $finished) {
        $diffs = [List[int]]::new()
        for ($i = 0; $i -lt $before.Count - 1; $i++) {
            $diff = $before[$i] - $before[$i + 1]
            $diffs.Add($diff)
        }
        $diffs[0]
        $finished = $diffs.TrueForAll( {param([int] $x) $x -eq 0})
        $before = $diffs
        # Wait-Debugger
    }
    $sum = $Numbers[0]
    $diffsOfTheFirstElements.foreach({ $sum += $_ })
    $sum
}

function Day09 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    if ($Part2) { Throw "not implemented" }
    $InputData = Get-InputData -InputFile $InputFile -Part2:$Part2
    $sum = 0
    foreach ($arr in $InputData) {
        $result = Get-Prediction -Numbers $arr.Numbers
        $sum += $result
    }
    $sum
}
