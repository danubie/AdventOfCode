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
        # Split the game record into it's components by regex
        # "Game <index>: list of number and color joined by a semicolon"
        $null = $gameRecord -match "Game (?<index>\d+): (?<cubes>.+)"
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

function Day02 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $cubesInBag,
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    $result = Get-Content $InputFile | Get-GameIndexIfIsValid -cubesInBag $cubesInBag -Part2:$Part2 | Measure-Object -Sum
    $result.Sum
}