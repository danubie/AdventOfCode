
# $Script:matrix = [ordered]@{}         # the hill
$Script:xmax = 0
$Script:ymax = 0
$Script:path = [System.Collections.Stack]::new()               # current path
$script:movement = @{}
$Script:First = $null               # start position
$Script:validPaths = [System.Collections.ArrayList]::new()     # all paths leading to the end
$script:shortestPath = [int]::MaxValue
$script:NbMoves = 0
$Script:StartCharInMap = [byte][char]'z'+1
$Script:EndCharInMap = [byte][char]'a'-1

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
            if ($line[$x] -ceq 'E') {
                $Script:First = $coord
                $matrix[$coord] = $Script:StartCharInMap       # to make it possible to do char subraction at the start
            }
            if ($line[$x] -ceq 'S') {
                $matrix[$coord] = $Script:EndCharInMap       # to make it possible to do char subraction at the start
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
    $charValue = [byte][char]$Matrix["$x;$y"]
    if (($Script:Path.Count) -ge $script:shortestPath) {
        Write-Verbose "Path too long $($Script:Path.Count) vs $($script:shortestPath)"
        return
    }
    if ($charValue -ceq $Script:EndCharInMap) {
        Write-Verbose "Found the end"
        PrintHill -Matrix $Matrix
        $script:shortestPath = ($Script:Path).Count
        return
    }
    $operation = ""
    # darf nicht höher als 1 gehen, aber tiefer ist erlaubt
    $nextKey = "$($x+1);$y"
    $nextValue = $Matrix[$nextkey]
    if ($null -ne $nextValue -and -not ($Script:Path).Contains($nextkey)) {
        if (($nextValue - $charValue) -ge -1) {
            $operation = "right"
            Write-Verbose "Try $operation"
            $wayPoint = "$x;$y"
            $Script:path.Push($wayPoint)
            $script:movement.Add($wayPoint, '>')
            ClimbHill -Matrix $Matrix -Start $nextkey
            $script:movement[$wayPoint] = $null
            $script:movement.Remove($waypoint)
            $prev = $Script:path.Pop()
        }
    }
    $nextKey = "$x;$($y+1)"
    $nextValue = $Matrix[$nextkey]
    if ($null -ne $nextValue -and -not ($Script:Path).Contains($nextkey)) {
        if (($nextValue - $charValue) -ge -1) {
            $operation = "up"
            Write-Verbose "Try $operation"
            $wayPoint = "$x;$y"
            $Script:path.Push($wayPoint)
            $script:movement.Add($wayPoint, '^')
            ClimbHill -Matrix $Matrix -Start $nextkey
            $script:movement.Remove($waypoint)
            $prev = $Script:path.Pop()
        }
    }
    $nextKey = "$($x-1);$y"
    $nextValue = $Matrix[$nextkey]
    if ($null -ne $nextValue -and -not ($Script:Path).Contains($nextkey)) {
        if (($nextValue - $charValue) -ge -1) {
            $operation = "left"
            Write-Verbose "Try $operation"
            $wayPoint = "$x;$y"
            $Script:path.Push($wayPoint)
            $script:movement.Add($wayPoint, '<')
            ClimbHill -Matrix $Matrix -Start $nextKey
            $script:movement.Remove($waypoint)
            $prev = $Script:path.Pop()
        }
    }
    $nextKey = "$x;$($y-1)"
    $nextValue = $Matrix[$nextkey]
    if ($null -ne $nextValue -and -not ($Script:Path).Contains($nextkey)) {
        if (($nextValue - $charValue) -ge -1) {
            $operation = "down"
            Write-Verbose "Try $operation"
            $wayPoint = "$x;$y"
            $Script:path.Push($wayPoint)
            $script:movement.Add($wayPoint, 'v')
            ClimbHill -Matrix $Matrix -Start $nextKey
            $prev = $Script:path.Pop()
            $script:movement.Remove($waypoint)
        }
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
    # $Script:validPaths
    $Script:shortestPath
    Write-Verbose "NbMoves: $Script:NbMoves" -Verbose
}
