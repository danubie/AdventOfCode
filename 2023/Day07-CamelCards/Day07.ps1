
function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $inputData = Get-Content $InputFile
    $mapValue = @{
        'A' = 14; 'K' = 13; 'Q' = 12; 'J' = 11; 'T' = 10;
        '9' = 9; '8' = 8; '7' = 7; '6' = 6; '5' = 5;
        '4' = 4; '3' = 3; '2' = 2;
    }
    if ($Part2) {
        $mapValue['J'] = 1
    }
    # data is in the format (each line) representing a hand of cards and the bid
    # 32T3K 765
    #
    foreach ($line in $inputData) {
        $regex = '(?<Hand>[A-Z0-9]{5})\s+(?<Bid>[0-9]+)'
        if ($line -match $regex) {
            $cards = @{}
            $RankByPosition = 0
            foreach ($hand in $Matches['Hand']) {
                foreach ($card in $hand.ToCharArray()) {
                    if (-Not $cards.ContainsKey($card)) {
                        $cards[$card] = [PSCustomObject]@{
                            Count = 1
                            Card = $card
                            Value = $mapValue["$card"]
                        }
                    }
                    else {
                        $cards[$card].Count++
                    }
                    $RankByPosition = $RankByPosition * 100 + $cards[$card].Value
                }
                $thisHand = [PSCustomObject]@{
                    Hand = $hand
                    Bid = [int64]$Matches['Bid']
                    Cards = $cards.Values | Sort-Object -Property @{Expression = 'Count'; Descending = $true}, @{Expression = 'Value'; Descending = $true}
                    RankByHand = -1
                    RankByPosition = -$RankByPosition
                }
                if ($thisHand.Cards[0].Count -eq 5) {
                    $thisHand.RankByHand = 8
                } elseif ($thisHand.Cards[0].Count -eq 4) {
                    $thisHand.RankByHand = 7
                } elseif ($thisHand.Cards[0].Count -eq 3 -and $thisHand.Cards[1].Count -eq 2) {
                    $thisHand.RankByHand = 6
                } elseif ($thisHand.Cards[0].Count -eq 3) {
                    $thisHand.RankByHand = 3
                } elseif ($thisHand.Cards[0].Count -eq 2 -and $thisHand.Cards[1].Count -eq 2) {
                    $thisHand.RankByHand = 2
                } elseif ($thisHand.Cards[0].Count -eq 2) {
                    $thisHand.RankByHand = 1
                } else {
                    $thisHand.RankByHand = 0
                }
                if ($thisHand.RankByHand -eq -1) {
                    Throw "RankByHand is -1 for $thisHand ==> should not happen"
                }
                $thisHand
                $msg = "Hand: {0,5}, Bid: {1,4}, RankByHand: $($thisHand.RankByHand), Rank: $($thisHand.RankByPosition), Cards: $($thisHand.Cards | ForEach-Object { $_.Card })" -f $thisHand.Hand, $thisHand.Bid
                Write-Verbose -Message $msg
            }
        }
    }
}

function EvaluateResult {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]]$Data
    )
    $sortProps = @(
        @{Expression = 'RankByHand'; Descending = $false}
        @{Expression = 'RankByPosition'; Descending = $true}
    )
    $sortedData = $Data | Sort-Object -Property $sortProps
    $i = 1
    $thisResult = 0
    foreach ($d in $sortedData) {
        $msg = "Eval {0,4}: Hand: {1,5}, Bid: {2,4}, RankByHand: $($d.RankByHand), Rank: $($d.RankByPosition), Cards: $($d.Cards | ForEach-Object { $_.Card })" -f $i, $d.Hand, $d.Bid
        Write-Verbose -Message $msg
        $thisResult = $thisResult + $d.Bid * $i
        $i++
    }
    $thisResult
}
function Day07 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )

    $inputData = Get-InputData -InputFile $InputFile -Part2:$Part2
    EvaluateResult -Data $inputData
}