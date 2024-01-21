using namespace System.Collections.Generic
using namespace System.Collections

function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $data = Get-Content $InputFile
    # build an arry, containing blocks (#) and rocks (O)
    $Script:Data = [List[string]]::new($data.Count)
    foreach ($line in $data) {
        $null = $Script:Data.Add($line.ReplaceLineEndings(''))
    }
}

function Invoke-TiltPlattform {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [List[string]]$Data,
        [switch]$Part2
    )

    # tilt means to move Os up until they hit a #, another O or the end of the block
    Try {
        for ($x = 0; $x -lt $Data[$x].Length; $x++) {
            for ($y = 1; $y -lt $Data.Count; $y++) {
                if ($Data[$y][$x] -eq "O") {
                    # this rock can move
                    $hit = $false
                    $newY = $y - 1
                    while ($newY -ge 0) {
                        if ($Data[$newY][$x] -in ("#", "O")) {
                            # we hit a # or another O
                            $hit = $true
                            break
                        }
                        $newY--
                    }
                    if ($hit -or $newY -eq -1) { $newY++ }
                    if ($newY -ne $y -and $Data[$newY][$x] -notin ("#", "O") ) {
                        # we can move the rock
                        Write-Verbose "Moved rock from ($x, $y) to ($x, $newY)"
                        $Data[$y] = $Data[$y].Remove($x, 1).Insert($x, ".")
                        $Data[$newY] = $Data[$newY].Remove($x, 1).Insert($x, "O")
                    }
                }
            }
        }
    } catch {
        $_ | Select * | Out-Host
        Wait-Debugger
    }
}

function CalculateResult {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [List[string]]$Data,
        [switch]$Part2
    )
    $result = 0
    for ($y = 0; $y -lt $Data.Count; $y++) {
        for ($x = 0; $x -lt $Data[$y].Length; $x++) {
            if ($Data[$y][$x] -eq "O") {
                $Result += ($Data.count-$y)
            }
        }
    }
    $result
}

function Day14 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    Get-InputData -InputFile $InputFile -Part2:$Part2
    Invoke-TiltPlattform -Data $Script:Data -Part2:$Part2
    CalculateResult -Data $Script:Data -Part2:$Part2
}