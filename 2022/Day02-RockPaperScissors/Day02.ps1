function Get-RpsScore {
    param(
        [Parameter(Mandatory)]
        [string]$InputFile
    )

    function XlatTool ($c) {
        switch -Regex ($c) {
            'A|X' { 'R' }
            'B|Y' { 'P' }
            'C|Z' { 'S' }
            Default { throw "Unknown character $c" }
        }
    }

    $input = Get-Content -Path $InputFile
    $totalScore = 0
    foreach ($line in $input) {
        $score = 0
        $line = $line -split " "
        $player1 = XlatTool $line[0]
        $playMe = XlatTool $line[1]
        switch ($playMe) {
            "R" { $score += 1 }
            "P" { $score += 2 }
            "S" { $score += 3 }
            Default { Throw "Invalid tool for Me $playerMe" }
        }
        switch ($player1) {
            "R" {
                switch ($playMe) {
                    "R" { $score += 3 }
                    "P" { $score += 6 }
                    "S" { $score += 0 }
                }
            }
            "P" {
                switch ($playMe) {
                    "R" { $score += 0 }
                    "P" { $score += 3 }
                    "S" { $score += 6 }
                }
            }
            "S" {
                switch ($playMe) {
                    "R" { $score += 6 }
                    "P" { $score += 0 }
                    "S" { $score += 3 }
                }
            }
            Default { Throw "Invalid tool $player1" }
        }
        $totalScore += $score
        Write-Verbose "Player1: $player1, PlayMe: $playMe, Score: $Score, TotaLsCORE. $totalScore"
    }
    return $totalScore
}