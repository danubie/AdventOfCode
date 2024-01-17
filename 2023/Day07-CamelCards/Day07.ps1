
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
        $mapValue = @{
            'A' = 14; 'K' = 13; 'Q' = 12; 'J' = 2; 'T' = 11;    # 'J' now is 2!
            '9' = 10; '8' = 9; '7' = 8; '6' = 7; '5' = 6;
            '4' = 5; '3' = 4; '2' = 3;
        }
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
                # count number of Js in the hand
                $countJsInHand = 0
                if ($Part2) {
                    $countJsInHand = ( $thisHand.Hand.ToCharArray() | Where-Object { $_ -eq 'J' } ).Count
                }
                if ($thisHand.Cards[0].Count -eq 5) {
                    $thisHand.RankByHand = 8            # Part 1: 5 of a kind
                } elseif ($thisHand.Cards[0].Count -eq 4) {
                    $thisHand.RankByHand = 7            # Part 1: 4 of a kind
                    if ($countJsInHand -gt 0) {         # there can be only one J in a hand with 4 other cards
                        if ($countJsInHand -notin (1,4)) { Wait-Debugger }        # Assertion
                        $thisHand.RankByHand = 8        # now it's 5 of a kind
                    }
                } elseif ($thisHand.Cards[0].Count -eq 3 -and $thisHand.Cards[1].Count -eq 2) {
                    $thisHand.RankByHand = 6            # Part 1: Full House
                    if ($countJsInHand -gt 0) {         # there can only be 2 or 3 Js in a hand with 3 or 2 other cards
                        if ($countJsInHand -ne 2 -and $countJsInHand -ne 3) { Wait-Debugger }        # Assertion
                        $thisHand.RankByHand = 8        # so it must be 5 of a kind
                    }
                } elseif ($thisHand.Cards[0].Count -eq 3) {
                    $thisHand.RankByHand = 3            # Part 1: 3 of a kind
                    if ($countJsInHand -gt 0) {         # if the 3 cards are 3 Js, then it is 4 cards of the next higher value
                        if ($countJsInHand -ne 3 -and $countJsInHand -ne 1) { Wait-Debugger }        # Assertion
                        $thisHand.RankByHand = 7        # it can't be 2 other cards of the same type, because it would have been full house before
                    }
                } elseif ($thisHand.Cards[0].Count -eq 2 -and $thisHand.Cards[1].Count -eq 2) {
                    $thisHand.RankByHand = 2            # Part 1: 2 pairs
                    if ($countJsInHand -notin (0, 1, 2) ) { Wait-Debugger }       # Assertion
                    if ($countJsInHand -eq 2) {
                        $thisHand.RankByHand = 7        # now it's 4 of a kind
                    } elseif ($countJsInHand -eq 1) {
                        $thisHand.RankByHand = 6        # now it's full house
                    }
                } elseif ($thisHand.Cards[0].Count -eq 2) {
                    $thisHand.RankByHand = 1            # Part 1: 1 pair
                    if ($countJsInHand -gt 0) {         # The 2 cards could be 2 Js, then 3 different cards or 1 J, 1 pair and 2 different cards
                        if ($countJsInHand -ne 1 -and $countJsInHand -ne 2) { Wait-Debugger }        # Assertion
                        $thisHand.RankByHand = 3        # so it has to be 3 of a kind
                    }
                } else {
                    $thisHand.RankByHand = 0            # Part 1: High card
                    if ($countJsInHand -ne 0) {         # 5 different cards, but one of them is a J
                        if ($countJsInHand -ne 1) { Wait-Debugger }        # Assertion
                        $thisHand.RankByHand = 1        # so it has to be 1 pair
                    }
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