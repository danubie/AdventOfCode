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

function Get-AdjacentPartNumbers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]] $InputObject
    )

    begin {
        $fullList = @()
        $LineNumber = 0
    }
    process {
        foreach ($line in $InputObject) {
            $fullList += $line | RegisterPartNumber -LineNumber $LineNumber
            $LineNumber++
        }
    }
    end {
        Write-Verbose ("{0:4} lines, {1:6} symbols" -f $LineNumber, $fullList.Count) -Verbose
        # for each partnumbers, where in the previous line, the current line and the next line is a symbol, that would have it's place inside the same index range than the partnumber
        $partNumbers = $fullList | Where-Object { $_.Type -eq 'P' }
        $listSymbols = $fullList | Where-Object { $_.Type -eq 'S' }
        $progress = 0
        $partNumbers | ForEach-Object {
            $progress++
            Write-Progress -Activity "Processing partnumbers" -Status ("{0:4} of {1:4}" -f $progress, $partNumbers.Count) -PercentComplete ($progress / $partNumbers.Count * 100)
            $thisPart = $_
            $currentLine = $_.LineNumber
            $currentStartIndex = $_.StartIndex
            $currentEndIndex = $_.EndIndex
            $previousLine = $currentLine - 1
            $nextLine = $currentLine + 1
            # check list of symbols in previous line, current line and next line
            $listSymbol = $listSymbols | Where-Object {
                $_.LineNumber -eq $previousLine -and
                $_.Type -eq 'S' -and
                $_.StartIndex -ge ($currentStartIndex-1) -and
                $_.EndIndex -le ($currentEndIndex + 1)
            }
            $isAdjacent = $listSymbol.Count -gt 0
            $listSymbol = $listSymbols | Where-Object {
                $_.LineNumber -eq $currentLine -and
                $_.Type -eq 'S' -and
                $_.StartIndex -ge ($currentStartIndex-1) -and
                $_.EndIndex -le ($currentEndIndex + 1)
            }
            $isAdjacent = $isAdjacent -or $listSymbol.Count -gt 0
            $listSymbol = $listSymbols | Where-Object {
                $_.LineNumber -eq $nextLine -and
                $_.Type -eq 'S' -and
                $_.StartIndex -ge ($currentStartIndex-1) -and
                $_.EndIndex -le ($currentEndIndex + 1)
            }
            $isAdjacent = $isAdjacent -or $listSymbol.Count -gt 0
            if ($isAdjacent) {
                $_.Value
            }
            # Write-Verbose ("{0:4} {1:6} {2}" -f $_.LineNumber, $isAdjacent, $_.Value) -Verbose
        }
        Write-progress -Activity "Processing partnumbers" -Completed
    }
}

function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/Input.txt"
    )

    begin {}

    process {
        $lines = Get-Content $InputFile
        $adjacentPartNumbers = $lines | Get-AdjacentPartNumbers
        $adjacentPartNumbers | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    }

    end {}
}