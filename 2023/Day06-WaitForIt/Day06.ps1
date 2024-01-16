function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-Content $InputFile
    if ($Part2) {
        $InputData = $InputData -replace ' ', ''
    }
    # data is in the format:
    # Time:      7  15   30
    # Distance:  9  40  200
    # e.g. [PSCustomObject]@{Time=7;Distance=9}, [PSCustomObject]@{Time=15;Distance=40}, [PSCustomObject]@{Time=30;Distance=200}
    $regex = 'Time:\s*(?<Time>.*)'
    if ($InputData[0] -match $regex) {
        $times = [int64[]] $Matches['Time'].Split(' ') | Where-Object { $_ -ne '' }
    }
    if ($InputData[1] -match 'Distance:\s*(?<Distance>.*)') {
        $distances = [int64[]] $Matches['Distance'].Split(' ') | Where-Object { $_ -ne '' }
    }
    for ($i = 0; $i -lt $times.Count; $i++) {
        [PSCustomObject]@{
            Time = $times[$i]
            Distance = $distances[$i]
        }
    }
}

function AllWins {
    param (
        [Parameter(Mandatory = $true)]
        [int64]$TimeGame,
        [Parameter(Mandatory = $true)]
        [int64]$BestDistance
    )
    $IamWinning = $false
    $nBWins = [int64] 0
    for ($i = 1; $i -le $TimeGame; $i++) {
        $speed = $TimeHold = $i
        $distance = ($TimeGame - $TimeHold) * $speed
        # $distance = CalcDistance -TimeHold $i -TimeGame $TimeGame
        if ($IamWinning -and $distance -lt $BestDistance) {
            break
        }
        if ($distance -gt $BestDistance) {
            $IamWinning = $true
            $nBWins++
        }
    }
    $nbWins
}

# this function should return the same number as AllWins
# but the apporach is different
# find the first time you win from 1 to $TimeGame, then find the last time you win from $TimeGame to 1
function AllWinsLeftAndRight {
    param (
        [Parameter(Mandatory = $true)]
        [int64]$TimeGame,
        [Parameter(Mandatory = $true)]
        [int64]$BestDistance
    )
    $firstWin = $lastWin = 0
    $speed = $TimeHold = 1
    $distance = ($TimeGame - $TimeHold) * $speed
    while ($distance -le $BestDistance) {
        $TimeHold++
        $distance = ($TimeGame - $TimeHold) * $TimeHold
    }
    Write-Verbose "    First win at $TimeHold with distance $distance"
    $firstWin = $TimeHold
    $nBWins++
    $speed = $TimeHold = $TimeGame
    $distance = ($TimeGame - $TimeHold) * $speed
    while ($distance -le $BestDistance) {
        $TimeHold--
        $distance = ($TimeGame - $TimeHold) * $TimeHold
    }
    Write-Verbose "    Last win at $TimeHold with distance $distance"
    $lastWin = $TimeHold
    $nBWins = $lastWin - $firstWin + 1
    $nbWins
}

function Day06 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-InputData -InputFile $InputFile -Part2:$Part2
    $result = [int64] 1
    $InputData | ForEach-Object {
        $nbWins = [int64] (AllWinsLeftAndRight -TimeGame $_.Time -BestDistance $_.Distance)
        $result = [int64] $result * $nbWins
        Write-Verbose "Time: $($_.Time), BestDistance: $($_.Distance) => $nbWins wins"
    }
    $result
}
