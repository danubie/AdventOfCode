function BuildForrest {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $length
    )
    $i=0
    $j=0
    Get-Content -Path $InputFile
        | ForEach-Object { $_.ToCharArray() }
        | ForEach-Object {
            $matrix[$i,$j] = [int]$_ - 48
            $j++
            if ($j -ge $length) {
                $j = 0
                $i++
            }
        }
}

# check if the tree is visible
# visible means that all of its left, right, top or bottom trees are smaller than it
# each loop ends, if there is a tree at least the size of the current tree
function IsVisibleTree {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $x,
        [int] $y
    )

    # all outhermost trees are visible
    if ($x -eq 0 -or $x -eq ($Length-1) -or $y -eq 0 -or $y -eq ($Length-1)) {
        return $true
    }
    $currentSize = $matrix[$x,$y]
    $isVisible = $true
    # check the trees to the left
    for ($i = 0; $i -lt $x; $i++) {
        if ($matrix[$i,$y] -ge $currentSize) {
            $isVisible = $false
        }
    }
    if ($isVisible) { return $true }
    # check the trees to the right
    $isVisible = $true
    for ($i = $x+1; $i -lt $Length; $i++) {
        if ($matrix[$i,$y] -ge $currentSize) {
            $isVisible = $false
        }
    }
    if ($isVisible) { return $true }
    # check the trees above
    $isVisible = $true
    for ($i = 0; $i -lt $y; $i++) {
        if ($matrix[$x,$i] -ge $currentSize) {
            $isVisible = $false
        }
    }
    if ($isVisible) { return $true }
    # check the trees below
    $isVisible = $true
    for ($i = $y+1; $i -lt $Length; $i++) {
        if ($matrix[$x,$i] -ge $currentSize) {
            $isVisible = $false
        }
    }
    return $isVisible
}

function Get-NbVisibleTrees {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $length
    )

    $i = 0
    $j = 0
    $nbTrees = 0
    while ($i -lt $length) {
        while ($j -lt $length) {
            if (IsVisibleTree -Matrix $matrix -x $i -y $j) {
                $nbTrees++
            }
            $j++
        }
        $i++
        $j=0
    }
    $nbTrees
}

function Day08 {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $length,
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )

    BuildForrest -Matrix $matrix -Length $length
    $result = Get-NbVisibleTrees -Matrix $matrix -Length $length
    $result
}