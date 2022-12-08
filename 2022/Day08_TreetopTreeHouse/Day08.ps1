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
    $result = @{
        nbTrees = $nbTrees
    }
    $result
}

# calculate the visibility of a tree
# returns the product of visbility in each direction
function CalculateVisibility {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $row,
        [int] $col
    )
    # trees at the borders have visibility 0, so the product is 0
    if ($row -eq 0 -or $row -eq ($Length-1) -or $col -eq 0 -or $col -eq ($Length-1)) {
        return 0
    }
    $currentSize = $matrix[$row,$col]
    $totalVisibility = 1
    $visibility = 1
    # check the trees to the left
    for ($c = $col-1; $c -gt 0; $c--) {
        if ($matrix[$row,$c] -ge $currentSize) {
            break
        }
        $visibility++
    }
    Write-Verbose "tree at $row,$col; value=$($matrix[$row,$col]); visibility $visibility to the left"
    $totalVisibility *= $visibility
    $visibility = 1
    # check the trees to the right
    for ($c = $col+1; $c -lt ($Length-1); $c++) {
        if ($matrix[$row,$c] -ge $currentSize) {
            break
        }
        $visibility++
    }
    Write-Verbose "tree at $row,$col; value=$($matrix[$row,$col]); visibility $visibility to the right"
    $totalVisibility *= $visibility
    $visibility = 1
    # check the trees above
    for ($r = $row-1; $r -gt 0; $r--) {
        if ($matrix[$r,$col] -ge $currentSize) {
            break
        }
        $visibility++
    }
    Write-Verbose "tree at $row,$col; value=$($matrix[$row,$col]); visibility $visibility to the above"
    $totalVisibility *= $visibility
    $visibility = 1
    # check the trees below
    for ($r = $row+1; $r -lt ($Length-1); $r++) {
        if ($matrix[$r,$col] -ge $currentSize) {
            break
        }
        $visibility++
    }
    Write-Verbose "tree at $row,$col; value=$($matrix[$row,$col]); visibility $visibility to the below"
    $totalVisibility *= $visibility
    Write-Verbose "tree at $row,$col; total $totalVisibility"
    $totalVisibility
}
# this function returns the visibility of each tree in the matrix
# visibility is defined as the distance from the current tree to the nearest tree of a size greater or equal to it
# trees at the boreds have visibility 0 in the direction of the border
function Get-TreeVisibility {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $length
    )
    $x = CalculateVisibility -Matrix $matrix -row 1 -col 2
    $maxVisibility = 0
    for ($row=1; $row -lt ($length-1); $row++) {
        for ($col=1; $col -lt ($length-1); $col++) {
            $vis = CalculateVisibility -Matrix $matrix -row $row -col $col
            if ($vis -gt $maxVisibility) {
                $maxVisibility = $vis
            }
        }
    }
    $maxVisibility
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
    $visibilityResult = Get-TreeVisibility -Matrix $matrix -Length $length
    $result | Add-Member -MemberType NoteProperty -Name MaxVisibility -Value $visibilityResult
    $result
}