. $PSScriptRoot/BinarySearchTemplate.ps1

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

# implement a generic binary search algorithm
#
function AllWinsBinarySearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int64]$TimeGame,
        [Parameter(Mandatory = $true)]
        [int64]$BestDistance
    )

    begin {

    }

    process {
        $Context = [PSCustomObject]@{
            LowBoundary = 1
            HighBoundary = $TimeGame
            TimeGame = $TimeGame
            Target = $BestDistance
            FirstWin = $TimeGame
            LastWin = 0
        }
        $LowBoundary = 1
        $HighBoundary = $TimeGame
        $Test = {
            param($x, $Context)
            $speed = $TimeHold = $x
            $distance = ($Context.TimeGame - $TimeHold) * $speed
            if ($distance -gt $Context.Target) {
                if ($Context.FirstWin -gt $x) {
                    $Context.FirstWin = $x
                }
                if ($Context.LastWin -lt $x) {
                    $Context.LastWin = $x
                }
                return 1
            }
            return -1
        }
        $resultLow = BinarySearchTemplate2 -LowBoundary $LowBoundary -HighBoundary $HighBoundary -Test $Test -Context $Context
        if ($resultLow -eq -1) {
            Write-Warning "No win found"
            return 0
        }
        Write-Verbose "    First win at $($Context.FirstWin)"
        # Context now contains the first and last win
        # the last win is the start for the search for the upper result
        $LowBoundary = $Context.LastWin
        $HighBoundary = $TimeGame
        $Context.LowBoundary = $Context.LastWin
        $Script:Target = $BestDistance-1
        $Test = {
            param($x, $Context)
            $speed = $TimeHold = $x
            $distance = ($Context.TimeGame - $TimeHold) * $speed
            if ($distance -gt $Context.Target) {
                if ($Context.LastWin -lt $x) {
                    $Context.LastWin = $x
                }
                return -1
            }
            return 1
        }
        $resultHigh = BinarySearchTemplate2 -LowBoundary $LowBoundary -HighBoundary $HighBoundary -Test $Test -Context $Context
        if ($resultHigh -eq -1) {
            Write-Warning "No win found"
            return 0
        }
        $HighBoundary = $result-1
        Write-Verbose "    Last win at $($Context.LastWin)"
        $nbWins = $Context.LastWin - $Context.FirstWin + 1
        $nbWins
    }

    end {

    }
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
        # $nbWins = [int64] (AllWinsLeftAndRight -TimeGame $_.Time -BestDistance $_.Distance)
        $nbWins = [int64] (AllWinsBinarySearch -TimeGame $_.Time -BestDistance $_.Distance)
        $result = [int64] $result * $nbWins
        Write-Verbose "Time: $($_.Time), BestDistance: $($_.Distance) => $nbWins wins"
    }
    $result
}
