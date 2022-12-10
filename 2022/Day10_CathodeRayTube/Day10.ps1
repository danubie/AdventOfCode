function ExecuteInstructions() {
    [CmdletBinding()]
    param (
        [string[]] $Instructions,
        [int] $XRegister = 1
    )
    $CycleCount = 1
    $sumSignalStrength = 0

    foreach ($Instruction in $Instructions) {
        $opCode, $value = $instruction -split " "
        switch ($opCode) {
            'noop' {
                $nbCycles = 1
            }
            'addx' {
                $nbCycles = 2
            }
        }
        for ($i = 0; $i -lt $nbCycles; $i++) {
            if ($CycleCount -in (20,60,100,140,180,220)) {
                $sumSignalStrength += ($XRegister *$CycleCount)
                Write-Verbose "Cycle $CycleCount : $XRegister, current signal: $($XRegister * $CycleCount), sum = $sumSignalStrength"
            }
            $CycleCount++
        }
        $XRegister += $value
        # if ('' -ne $opCode[1]) { $XRegister += $value }
    }
    $sumSignalStrength
}

function Day10 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )
    $Instructions = Get-Content $InputFile
    ExecuteInstructions -Instructions $Instructions
}