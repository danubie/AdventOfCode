$Script:monkeys = [System.Collections.ArrayList]::new()
$Script:ModuloBorder = [ulong] 1

function Print-Monkey {
    [CmdletBinding()]
    param (
        [int] $Nr,
        $msg
    )

    $m = $Script:monkeys[$nr]
    Write-Verbose "$msg Monkey $Nr, $($m.WorryLevels.Count) items, [$($m.WorryLevels.ToArray())]"
}

function Add-Monkey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $monkeyData
    )
    Write-Verbose "Add-Monkey: $monkeyData"
    $splat = [pscustomobject][ordered]@{
        Nr             = ([int] ($monkeyData[0] -replace "Monkey (\d+):", '$1'))
        Operation      = 'unknown'
        OperationValue = 0
        TestValue      = ([ulong] ($monkeyData[3] -replace "Test: divisible by (\d+)", '$1'))
        ToMonkeyTrue   = ([int] ($monkeyData[4] -replace "If true: throw to monkey (\d+)", '$1'))
        ToMonkeyFalse  = ([int] ($monkeyData[5] -replace "If false: throw to monkey (\d+)", '$1'))
        WorryLevels    = [System.Collections.Queue]::new()
        NbInspections  = 0
    }
    $isMatch = $monkeyData[2] -match "Operation: new = old (?<opcode>\S) (?<value>\S+)"
    if (!$isMatch) { Throw "Operation not matched"}
    $splat.Operation = $Matches.opcode
    $splat.OperationValue = $Matches.value
    # woory levels converted to int[] and then into Queue
    [ulong[]]($monkeyData[1] -replace "(  Starting items: )(.*)", '$2' -split ', ') | ForEach-Object { $splat.WorryLevels.Enqueue($_) }

    $index = $Script:monkeys.Add($splat)
    $Script:ModuloBorder *= $splat.TestValue
    Write-Verbose "Added monkey $index; $($splat)"
}

function Import-Monkeys {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    $data = Get-Content -Path $InputFile
    for ($i = 0; $i -lt $data.Count; ) {
        # read in group of 6
        $inputBlock = $data[$i..($i+5)]
        Add-Monkey $inputBlock
        # skip 1 line
        $i += 7
    }
}

function Invoke-MonkeyThrows {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $monkey,
        [switch] $Part2
    )
    Write-Verbose "Monkey $($monkey.Nr) items: $($monkey.WorryLevels.ToArray()) "
    $StartCount = $monkey.WorryLevels.Count
    for ($i=0; $i -le $StartCount-1; $i++) {
        $monkey.NbInspections++
        $itemLevel = $monkey.WorryLevels.Dequeue()
        if ($monkey.OperationValue -eq 'old') {
            $currOperationValue = $itemLevel
        } else {
            $currOperationValue = $monkey.OperationValue
        }
        switch ($monkey.Operation) {
            '+' { $newLevel = [ulong] ($itemlevel + $currOperationValue) }
            '*' { $newLevel = [ulong] (($itemlevel * $currOperationValue) % $Script:ModuloBorder) }
            Default { Throw "Unknown operation $($monkey.Operation)" }
        }
        if (!$Part2) {
            $newLevel = [ulong] ([System.Math]::Floor($newLevel / 3))
        }
        if ($newlevel % $monkey.TestValue -eq 0) {
            $throwingTo = $monkey.ToMonkeyTrue
        } else {
            $throwingTo = $monkey.ToMonkeyFalse
        }
        Write-Verbose "    $itemLevel -> $newLevel -> throwing to $throwingTo"
        $Script:monkeys[$throwingTo].WorryLevels.Enqueue($newLevel)
        Print-Monkey -Nr $throwingTo -Msg "     "
    }
}

function Day11 {
    [CmdletBinding()]
    param (
        [string] $InputFile,
        [int] $Rounds,
        [switch] $Part2
    )
    $Script:ModuloBorder = 1
    Import-Monkeys -InputFile $InputFile
    for ($i=0; $i -lt $Rounds; $i++) {
        Write-Verbose "Round $($i+1)"
        foreach ($monkey in $Script:monkeys) {
            Invoke-MonkeyThrows -monkey $monkey -Part2:$Part2
        }
        Write-Verbose "These are the intermediate results:"
        $Script:monkeys
            | ForEach-Object { Print-Monkey -Nr $_.Nr -Msg "     " }
    }
    # calc Part 1 result
    $Multiplier = 1
    $Script:monkeys.NbInspections
    | Sort-Object -Descending
    | Select-Object -First 2
    | ForEach-Object { $Multiplier *= $_ }
    $result = [PSCustomObject]@{
        Part1 = $Multiplier
    }
    $result
}

