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
        [string[]] $InputObject
    )

    begin {

    }

    process {
        foreach ($line in $InputObject) {
            $result = Get-InputData -line $line
            # get mycards that win (intersect with winningNumbers)
            $cardsInWinning = $result.MyCards | Where-Object { $result.winningNumbers -contains $_ }
            $result | Add-Member -MemberType NoteProperty -Name 'myCardsThatWin' -Value ($cardsInWinning ? $cardsInWinning : @()) -PassThru
        }
    }

    end {

    }
}

function Day04 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputFile
    )

    begin {

    }

    process {
        $inputData = Get-Content -Path $InputFile
        $allDraws = Get-CardsThatWin -InputObject $inputData
        $scores = foreach ($draw in $allDraws) {
            switch ($draw.myCardsThatWin.Count) {
                0 { 0  }
                1 { 1 }
                default { $([math]::Pow(2,$_-1)) }
            }
        }
        $scores | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    }

    end {

    }
}