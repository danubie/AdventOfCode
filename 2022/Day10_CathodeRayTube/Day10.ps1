function ExecuteInstructions() {
    [CmdletBinding()]
    param (
        [string[]] $Instructions,
        [int] $XRegister = 1
    )
    $CycleCount = 1
    $CrtCount = 0
    $sumSignalStrength = 0

    $CrtLine = ([string]::new('.', 40)).ToCharArray()   # current CRT-Line init with '.'
    $Crt = @()                          # at the end should hold 6 lines

    $result = [PSCustomObject]@{
        Part1 = 0
        Part2 = $null
    }

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
            # Part 1
            if ($CycleCount -in (20,60,100,140,180,220)) {
                $sumSignalStrength += ($XRegister *$CycleCount)
                Write-Verbose "Cycle $CycleCount : $XRegister, current signal: $($XRegister * $CycleCount), sum = $sumSignalStrength"
            }
            # Part 2
            # Sprite is 3 pixels long, XReg represents the middle if a sprite
            if ([Math]::Abs($CrtCount - $XRegister) -le 1) {
                # Pixel should be shown
                Write-Verbose "Pixel $CrtCount should be shown with register $XRegister"
                $CrtLine[$CrtCount] = '#'       # show pixel lit
            }
            $CycleCount++
            if (($CrtCount+1) % 40 -eq 0) {
                # CRT-Line is complete
                $Crt += ($CrtLine -join '')     # return the string
                $CrtLine = ([string]::new('.', 40)).ToCharArray()
            }
            $CrtCount = ($CrtCount + 1) % 40    # CRT is 40pixels wide
        }
        $XRegister += $value
        # if ('' -ne $opCode[1]) { $XRegister += $value }
    }
    $result.Part1 = $sumSignalStrength
    $result.Part2 = $Crt
    $result
}

function Day10 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )
    $Instructions = Get-Content $InputFile
    ExecuteInstructions -Instructions $Instructions
}