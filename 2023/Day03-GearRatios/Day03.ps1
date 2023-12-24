function RegisterPartNumber {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputObject,
        [int] $LineNumber
    )

    begin {}

    process {
        # each line consists of part numbers or symbols with whitespace in between
        # partnumber = 1 or more digits, symbols is exactly 1 character
        # this functions returns an array of objects with the following properties:
        # linenumber, type (partnumber or symbol), value (partnumber or symbol), startindex, length and endindex inside the line
        $regex = [regex] '(?<partnumber>\d+)|(?<symbol>\S)'
        $m = $regex.Matches($InputObject)
        $m | ForEach-Object {
            [pscustomobject]@{
                LineNumber = $LineNumber
                Type = if ($_.Groups["partnumber"].Success) { 'P' } else { 'S' }
                Value = $_.Value
                StartIndex = $_.Index
                TokenLength = $_.Length
                EndIndex = $_.Index + $_.Length - 1
            }
        }
    }

    end {}
}

# Part 2: Only count partnumbers that are adjacent to a symbol '*' and only if there are exactly 2 adjacent partnumbers
function Get-AdjacentPartNumbers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]] $InputObject,
        [switch] $Part2
    )

    begin {
        $fullList = @()
        $LineNumber = 0
    }
    process {
        $fullList += $InputObject | ForEach-Object {
            $LineNumber++
            RegisterPartNumber -LineNumber $LineNumber -InputObject $_
        }
    }
    end {
        # Write-Verbose ("{0:4} lines, {1:6} symbols" -f $LineNumber, $fullList.Count) -Verbose
        $partNumbers = $fullList | Where-Object { $_.Type -eq 'P' } | Group-Object -Property LineNumber -AsHashTable
        $listSymbols = $fullList | Where-Object { $_.Type -eq 'S' }
        if ($Part2) {
            $listSymbols = $listSymbols | Where-Object { $_.Value -eq '*' }     # reduce it to '*' only
        }

        $progress = 0
        $listSymbols | ForEach-Object {
            $progress++
            $msg = "{0} of {1}" -f $progress, $listSymbols.Count, $_.Value
            Write-Progress -Activity "Processing symbols" -Status $msg -PercentComplete ($progress / $listSymbols.Count * 100)
            $thisPart = $_
            $currentLine = $_.LineNumber
            $currentStartIndex = $_.StartIndex
            $currentEndIndex = $_.EndIndex
            $previousLine = $currentLine - 1
            $nextLine = $currentLine + 1

            $listParts = @($partNumbers[$previousLine] | ForEach-Object { $_ })
            $listParts += $partNumbers[$currentLine] | ForEach-Object { $_ }
            $listParts += $partNumbers[$nextLine] | ForEach-Object { $_ }
            $listParts = $listParts | Where-Object {
                $_.Type -eq 'P' -and
                $_.StartIndex -le ($currentStartIndex + 1) -and
                $_.EndIndex -ge ($currentEndIndex - 1)
            }
            if ($Part2) {
                $isAdjacent = $listParts.Count -eq 2
                if ($isAdjacent) {
                    [int]$listParts[0].Value * [int]$listParts[1].Value
                }
            } else {
                $isAdjacent = $listParts.Count -gt 0
                if ($isAdjacent) {
                    $listParts.Value
                }
            }
            # Write-Verbose ("{0:4} {1:6} {2}" -f $_.LineNumber, $isAdjacent, $_.Value) -Verbose
        }
        Write-progress -Activity "Processing partnumbers" -Completed
    }
}

function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/Input.txt",
        [switch] $Part2
    )

    begin {}

    process {
        $lines = Get-Content $InputFile
        $adjacentPartNumbers = $lines | Get-AdjacentPartNumbers -Part2:$Part2
        $adjacentPartNumbers | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    }

    end {}
}