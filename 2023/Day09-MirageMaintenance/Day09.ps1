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
    # Part 1: first reverse the list, then build the difference list
    if ($Part2) {
        # do nothing
    } else {
        $Numbers.Reverse()
    }
    $finished = $false
    $before = [List[int]] $Numbers.ToArray()
    $history = [List[int]]::new()
    $diffsOfTheFirstElements = while (-not $finished) {
        $diffs = [List[int]]::new()
        $history.Add($before[0])
        for ($i = 0; $i -lt $before.Count - 1; $i++) {
            if ($Part2) {
                $diff = $before[$i + 1] - $before[$i]
            } else {
                $diff = $before[$i] - $before[$i + 1]
            }
            $diffs.Add($diff)
        }
        $diffs[0]
        $finished = $diffs.TrueForAll( {param([int] $x) $x -eq 0})
        $before = $diffs
        # Wait-Debugger
    }
    if ($Part2) {
        $diff = 0
        $sum = 0
        for ($i = $history.Count-1; $i -ge 0; $i--) {
            $newDiff = $history[$i] - $diff
            $sum += $newDiff
            $diff = $newDiff
        }
        $diff
    } else {
        $sum = $Numbers[0]
        $diffsOfTheFirstElements.foreach({ $sum += $_ })
        $sum
    }
}

function Day09 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-InputData -InputFile $InputFile -Part2:$Part2
    $sum = 0
    foreach ($arr in $InputData) {
        $result = Get-Prediction -Numbers $arr.Numbers
        $sum += $result
    }
    $sum
}
