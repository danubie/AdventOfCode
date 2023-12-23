function Get-IndexAndCubeListFromRecord {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $GameRecord
    )

    begin {

    }

    process {
        # Split the game record into it's components by regex
        # "Game <index>: list of number and color joined by a semicolon"
        $null = $GameRecord -match "Game (?<index>\d+): (?<cubes>.+)"
        $gameIndex = $Matches["index"]
        $gameCubes = $Matches["cubes"]
        # use regex to split $gameCubes first by semicolon, then by space. return the number of cubes in each color
        $regex = [regex] '\s*(?<count>\d+)\s+(?<color>[^;,]+)'
        $cubesInGame = $regex.Matches($gameCubes) | ForEach-Object {
            [pscustomobject]@{
                Count = [int]$_.Groups["count"].Value
                Color = $_.Groups["color"].Value
            }
        }
        $gameIndex, $cubesInGame
    }

    end {

    }
}
function Get-GameIndexIfIsValid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $cubesInBag,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $gameRecord,
        [switch] $Part2
    )

    begin {

    }

    process {
        $gameIndex, $cubesInGame = Get-IndexAndCubeListFromRecord -GameRecord $gameRecord
        $result = $true
        foreach ($cube in $cubesInGame) {
            if ($cube.Count -gt $cubesInBag[$cube.Color]) {
                $result = $false
                break
            }
        }
        if ($result) {
            $gameIndex
        }
    }

    end {

    }
}

function Get-PowerOfCubeSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $GameRecord
    )
    begin {}
    process {
        $gameIndex, $cubesInGame = Get-IndexAndCubeListFromRecord -GameRecord $GameRecord
        $maxCountOfEachColors = $cubesInGame | Group-Object -Property Color | ForEach-Object {
            # return the maximum count of this group
            $_.Group | Sort-Object -Property Count | Select-Object -Last 1
        }
        $result = 1
        $maxCountOfEachColors | ForEach-Object { $result = $_.Count * $result }
        $result
    }
    end {}
}

function Day02 {
    [CmdletBinding()]
    param (
        [hashtable] $cubesInBag,
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    if ($Part2) {
        $result = Get-Content $InputFile | Get-PowerOfCubeSet | Measure-Object -Sum
        $result.Sum
    } else {
        if ($cubesInBag -eq $null) { Throw "CubesInBag must be specified for part 1" }
        $result = Get-Content $InputFile | Get-GameIndexIfIsValid -cubesInBag $cubesInBag -Part2:$Part2 | Measure-Object -Sum
        $result.Sum
    }
}