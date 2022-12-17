
# $Script:matrix = [ordered]@{}         # the hill
$Script:xmax = 0
$Script:ymax = 0
$Script:path = [System.Collections.Stack]::new()               # current path
$script:movement = @{}
$Script:First = $null               # start position
$Script:validPaths = [System.Collections.ArrayList]::new()     # all paths leading to the end
$script:NbMoves = 0

function BuildHill {
    [CmdletBinding()]
    param (
        [string[]] $Inputdata
    )
    $Matrix = @{}
    $Script:xmax = $Inputdata[0].Length - 1
    $Script:ymax = $Inputdata.Count - 1
    $lineNr = $Inputdata.Count - 1
    foreach ($line in $inputdata) {
        for ($x = 0; $x -lt $line.Length; $x++) {
            $coord = "$x;$lineNr"
            $Matrix.Add($coord, [byte][char]($line[$x]))
            if ($line[$x] -ceq 'S') {
                $Script:First = $coord
                $matrix[$coord] = ([byte][char]'a')-1       # to make it possible to do char subraction at the start
            }
            if ($line[$x] -ceq 'E') {
                $matrix[$coord] = ([byte][char]'z')+1       # to make it possible to do char subraction at the start
            }
        }
        $lineNr--
    }
    return $matrix
}

function PrintHill {
    [CmdletBinding()]
    param (
        [hashtable] $Matrix
    )
    for ($y = $Script:ymax; $y -ge 0; $y--) {
        $s = "$y "
        for ($x = 0; $x -lt $Script:xmax; $x++) {
            $coord = "$x;$y"
            if ($Script:path.Contains($coord)) {
                $s += $script:movement[$coord]
            } else {
                $s += [char]$Matrix[$coord]
            }
        }
        Write-Host $s
    }
    Write-Host '------------------------------------------'
}

function ClimbHill {
    [CmdletBinding()]
    param (
        [hashtable] $Matrix,
        $Start
    )
    # try 1
    # look at the current point, if it is 'E' return 1
    # from a current point go +1 in x and look if the letter is max. 1 ahead of the current point
    # if so, go there and repeat with try 1
    # if not, go -1 in y and look if the letter is max. 1 ahead of the current point
    # if so, go there and repeat with try 1
    # if not, go +1 in y and look if the letter is max. 1 ahead of the current point
    # if so, go there and repeat with try 1
    # if not, go -1 in x and look if the letter is max. 1 ahead of the current point
    # if so, go there and repeat with try 1
    # if it is not, return 1
    $script:NbMoves++
    $x, $y = $Start.Split(';')
    $x = [int] $x
    $y = [int] $y
    if ($Matrix["$x;$y"] -ceq ([byte][char]'z')+1) {
        Write-Verbose "Found the end"
        PrintHill -Matrix $Matrix
        [void] $Script:validPaths.Add(($Script:Path).Count)
        return
    }
    $operation = ""
    if ([Math]::Abs($Matrix["$($x+1);$y"] - $Matrix["$x;$y"]) -le 1 -and -not ($Script:Path).Contains("$($x+1);$y")) {
        $operation = "right"
        Write-Verbose "Try $operation"
        $wayPoint = "$x;$y"
        $Script:path.Push($wayPoint)
        $script:movement.Add($wayPoint, '>')
        ClimbHill -Matrix $Matrix -Start "$($x+1);$y"
        $script:movement[$wayPoint] = $null
        $script:movement.Remove($waypoint)
        $Script:path.Pop()
    }
    if ([Math]::Abs($Matrix["$x;$($y+1)"] - $Matrix["$x;$y"]) -le 1 -and -not $Script:Path.Contains("$x;$($y+1)")) {
        $operation = "up"
        Write-Verbose "Try $operation"
        $wayPoint = "$x;$y"
        $Script:path.Push($wayPoint)
        $script:movement.Add($wayPoint, '^')
        ClimbHill -Matrix $Matrix -Start "$x;$($y+1)"
        $script:movement.Remove($waypoint)
        $Script:path.Pop()
    }
    if ([Math]::Abs($Matrix["$($x-1);$y"] - $Matrix["$x;$y"]) -le 1 -and -not $Script:Path.Contains("$($x-1);$y")) {
        $operation = "left"
        Write-Verbose "Try $operation"
        $wayPoint = "$x;$y"
        $Script:path.Push($wayPoint)
        $script:movement.Add($wayPoint, '<')
        ClimbHill -Matrix $Matrix -Start "$($x-1);$y"
        $script:movement.Remove($waypoint)
        $Script:path.Pop()
    }
    if ([Math]::Abs($Matrix["$x;$($y-1)"] - $Matrix["$x;$y"]) -le 1 -and -not $Script:Path.Contains("$x;$($y-1)")) {
        $operation = "down"
        Write-Verbose "Try $operation"
        $wayPoint = "$x;$y"
        $Script:path.Push($wayPoint)
        $script:movement.Add($wayPoint, 'v')
        ClimbHill -Matrix $Matrix -Start "$x;$($y-1)"
        $Script:path.Pop()
        $script:movement.Remove($waypoint)
    }
    if ($operation -eq "") {
        # PrintHill -Matrix $Matrix
        return
    }

}

function Day12 {
    [CmdletBinding()]
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )

    $matrix= BuildHill -InputData (Get-Content $InputFile)
    PrintHill -Matrix $matrix
    ClimbHill -Matrix $matrix -Start $Script:First # -Verbose
    $Script:validPaths
    Write-Verbose "NbMoves: $Script:NbMoves" -Verbose
}
