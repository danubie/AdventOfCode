function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $line
    )

    begin {

    }

    process {
        # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        # numbers are string by a colon, a pipe and space
        #  Write-Verbose -Message "Processing line: [$line]" -Verbose
        if ($line -match 'Card\s+(?<cardIndex>\d+): (?<winningNumbers>.+) \| (?<myCards>.+)') {
            $result = [PSCustomObject]@{
                CardIndex = $Matches['cardIndex']
                WinningNumbers = $Matches['winningNumbers'] -split ' ' | Where-Object { $_ -ne '' }
                MyCards = $Matches['myCards'] -split ' ' | Where-Object { $_ -ne '' }
            }
            # Now you have $cardIndex, $winningNumbers, and $myCards
        }
        $result
    }

    end {

    }
}

function Get-CardsThatWin {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]] $InputObject,
        [switch] $Part2
    )

    begin {
        # initialize a hashtable to count the cards
        $CardCounts = @{}
        for ($i = 1; $i -le $InputObject.Count; $i++) {
            $CardCounts[$i] = 0
        }
    }

    process {
        foreach ($line in $InputObject) {
            $result = Get-InputData -line $line
            # get mycards that win (intersect with winningNumbers)
            $cardsInWinning = $result.MyCards | Where-Object { $result.winningNumbers -contains $_ }
            # increment the count for the current card; then for each winning card add 1 to the following cards
            $CardCounts[[int]$result.CardIndex]++
            for ($i = 1; $i -le $cardsInWinning.Count; $i++) {
                $idx = [int]$result.CardIndex + $i
                $CardCounts[$idx] = $CardCounts[$idx] + $CardCounts[[int]$result.CardIndex]
            }
            if ($Part2) {
                continue
            }
            $result | Add-Member -MemberType NoteProperty -Name 'myCardsThatWin' -Value ($cardsInWinning ? $cardsInWinning : @()) -PassThru
        }
    }

    end {
        if ($Part2) {
            $CardCounts
        }
    }
}

function Day04 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputFile,
        [switch] $Part2
    )

    begin {

    }

    process {
        $inputData = Get-Content -Path $InputFile
        $allDraws = Get-CardsThatWin -InputObject $inputData -Part2:$Part2
        if ($Part2) {
            $allDraws.GetEnumerator() | Measure-Object -Sum -Property Value | Select-Object -ExpandProperty Sum
        } else {
            $scores = foreach ($draw in $allDraws) {
                switch ($draw.myCardsThatWin.Count) {
                    0 { 0  }
                    1 { 1 }
                    default { $([math]::Pow(2,$_-1)) }
                }
            }
            $scores | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        }
    }

    end {

    }
}