using namespace System.Numerics
using namespace System.Numerics.Complex
using namespace System.Collections.Generic
using namespace System.Collections
using namespace System.Linq

$Script:ExpansionRate = 1

function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    # buidling a map from a string
    # Input looks like this:
    # ...#......
    # .......#..
    # #.........
    # Meaning: # is a galaxy, . is empty space
    # each galaxy is internally numbered
    # represent this in a list of lists
    $InputData = Get-Content -Path $InputFile
    #region Expand the universe
    # collect the linenumbers that need to be expanded
    $linesToExPandList = [List[int]]::new() # list of line numbers that need to be expanded
    $lineCount = 0
    foreach ($line in $InputData) {
        $line = $line.ReplaceLineEndings('')
        if ($line -eq "".PadLeft($line.Length,".")) {       # are all characters in the line a dot?
            $null = $linesToExPandList.Add($lineCount)
        }
        $line
        $lineCount++
    }
    # collect the column numbers that need to be expanded
    $colsToExPandList = [List[int]]::new()    # list of column numbers that need to be expanded
    for ($col = 0; $col -lt $InputData[0].Length; $col++) {
        $isAll0 = $true
        foreach ($line in $InputData) {
            if ($line[$col] -ne ".") {
                $isAll0 = $false
                break
            }
        }
        if ($isAll0) {
            $null = $colsToExPandList.Add($col)
            $col++
        }
    }
    #endregion Expand the universe
    $Script:Galaxies = @{}
    $galaxyCounter = 0
    $y = 0
    $lineIndex = 0
    $lineExpansionQueue = [Queue[int]]::new($linesToExPandList)
    $nextLineExpanion = $lineExpansionQueue.Dequeue()
    foreach ($inputLine in $InputData) {
        if ($lineIndex -ge $nextLineExpanion) {
            $y += $Script:ExpansionRate
            if ($lineExpansionQueue.Count -gt 0) {
                $nextLineExpanion = $lineExpansionQueue.Dequeue()
            } else {
                $nextLineExpanion = [int]::MaxValue
                Write-Verbose "No more y expansions"
            }
        }
        $x = 0
        $colExpansionQueue = [Queue[int]]::new($colsToExPandList)
        $nextColExpansion = $colExpansionQueue.Dequeue()
        for ($charIndex = 0; $charIndex -lt $InputData[0].Length; $charIndex++) {
            if ($charIndex -ge $nextColExpansion) {
                $x += $Script:ExpansionRate
                if ($colExpansionQueue.Count -gt 0) {
                    $nextColExpansion = $colExpansionQueue.Dequeue()
                } else {
                    $nextColExpansion = [int]::MaxValue
                    Write-Verbose "No more x expansions"
                }
            }
            # Write-Verbose "Processing character $charIndex of line $lineIndex; x = $x, y = $y"
            if ($InputLine[$charIndex] -eq '#') {
                $galaxyCounter++
                $g = [PSCustomObject]@{
                    'Galaxy' = $galaxyCounter
                    'Position' = [Complex]::new($x, $y)
                }
                $Script:Galaxies[$g.Position] = $g
            }
            $x++
        }
        $y++
        $lineIndex++
    }
    if ($VerbosePreference -eq 'Continue') {$Script:Galaxies.Values | Sort-Object -Property Galaxy | Out-Host}
}

function BuildGalaxyPairs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Hashtable]$Galaxies,
        [switch]$Part2
    )
    $allGalaxies = @($Galaxies.Values)
    $numPairs = 0
    $sumPath = 0
    for ($i = 0; $i -lt $allGalaxies.Count; $i++) {
        $g1 = $allGalaxies[$i]
        for ($j = $i + 1; $j -lt $allGalaxies.Count; $j++) {
            $numPairs++
            $g2 = $allGalaxies[$j]
            $delta = [Complex]::Subtract($g1.Position, $g2.Position)
            $distance = [Math]::Abs($delta.Imaginary) + [Math]::Abs($delta.Real)
            $pathToGalaxy = $distance
            Write-Verbose "Pair $numPairs : Galaxy $($g1.Galaxy) and $($g2.Galaxy) : Distance $distance, Pathlength $pathToGalaxy"
            $sumPath += $pathToGalaxy
        }
    }
    $sumPath
}

function Day11 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )

    $null = Get-InputData -InputFile $InputFile -Part2:$Part2
    $sumDistances = BuildGalaxyPairs -Galaxies $Script:Galaxies -Part2:$Part2
    $sumDistances
}