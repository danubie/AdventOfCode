using namespace System.Numerics
using namespace System.Numerics.Complex
using namespace System.Collections.Generic
using namespace System.Collections
using namespace System.Linq

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
    $LinesExpanded = foreach ($line in $InputData) {
        $line = $line.ReplaceLineEndings('')
        if ($line -eq "".PadLeft($line.Length,".")) {       # are all characters in the line a dot?
            $line                                           # then expand the universe by one line
        }
        $line
    }
    # now we have to expand the universe by one column if in all lines this column contains a dot
    for ($col = 0; $col -lt $LinesExpanded[0].Length; $col++) {
        $isAll0 = $true
        foreach ($line in $LinesExpanded) {
            if ($line[$col] -ne ".") {
                $isAll0 = $false
                break
            }
        }
        if ($isAll0) {
            $LinesExpanded = foreach ($line in $LinesExpanded) {
                $line.Insert($col, ".")
            }
            $col++
        }
    }
    #endregion Expand the universe
    $Script:Galaxies = @{}
    $Script:SpaceMap = [List[List[int]]]::new()
    $galaxyCounter = 0
    $y = 0
    foreach ($line in $LinesExpanded) {
        $line = $line.ReplaceLineEndings('')
        $galaxyLine = [List[int]]::new($line.Length)
        $x = 0
        foreach ($char in $line.ToCharArray()) {
            if ($char -eq '#') {
                $galaxyCounter++
                $galaxyLine.Add($galaxyCounter)
                $g = [PSCustomObject]@{
                    'Galaxy' = $galaxyCounter
                    'Position' = [Complex]::new($x, $y)
                }
                $Script:Galaxies[$g.Position] = $g
            } else {
                $galaxyLine.Add(0)
            }
            $x++
        }
        $Script:SpaceMap.Add($galaxyLine)
        $y++
    }
    $Script:SpaceMap
}

function Out-Map {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [List[List[int]]]$SpaceMap
    )
    foreach ($line in $SpaceMap) {
        foreach ($char in $line) {
            if ($char -eq 0) {
                Write-Host -NoNewline '.'
            } else {
                Write-Host -NoNewline $char
            }
        }
        Write-Host ''
    }
}

function BuildGalaxyPairs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [List[List[int]]]$SpaceMap,
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

    $map = Get-InputData -InputFile $InputFile -Part2:$Part2
    # Out-Map -SpaceMap $map
    $sumDistances = BuildGalaxyPairs -SpaceMap $map -Galaxies $Script:Galaxies -Part2:$Part2
    # Write-Host '______-'
    # Out-Map -SpaceMap $map
    $sumDistances
}