class point {
    [int]$x
    [int]$y
    point([int]$x, [int]$y) {
        $this.x = $x
        $this.y = $y
    }
    [string]ToString() {
        return "($($this.x), $($this.y), $($this.type))"
    }
    [bool]Equals([object]$other) {
        return $this.x -eq $other.x -and $this.y -eq $other.y
    }
    [int]GetHashCode() {
        return $this.x * 1000 + $this.y
    }
}

function CreateMap {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile
    )

    $script:Map = [hashtable]@{}
    foreach ($line in Get-Content $InputFile) {
        $lineEdges = $line -split ' -> '#  $line.Split(' -> ', [StringSplitOptions]::RemoveEmptyEntries)
        $prev = [point]::new($lineEdges[0].Split(',')[0], $lineEdges[0].Split(',')[1])
        $Script:Map[$prev] = "#"
        for ($i = 1; $i -le $lineEdges.Length - 1; $i++) {
            $next = [point]::new($lineEdges[$i].Split(',')[0], $lineEdges[$i].Split(',')[1])
            if ($next.x -eq $prev.x) {
                # draw a vertical line
                $minY = [Math]::Min($prev.y, $next.y)
                $maxY = [Math]::Max($prev.y, $next.y)
                for ($y = $minY; $y -le $maxY; $y++) {
                    $p = [point]::new($prev.x, $y)
                    $Script:Map[$p] = "#"
                }
            } elseif ($next.y -eq $prev.y) {
                # draw a horizontal line
                $minX = [Math]::Min($prev.x, $next.x)
                $maxX = [Math]::Max($prev.x, $next.x)
                for ($x = $minX; $x -le $maxX; $x++) {
                    $p = [point]::new($x, $prev.y)
                    $Script:Map[$p] = "#"
                }
            } else {
                throw "Invalid line: $line"
            }
            $prev = $next
            "" | Out-Null
        }
    }
    $Script:Map
}


function LetItDrop {
    [CmdletBinding()]
    param (
        [hashtable]$Map,
        [point] $StartPoint
    )

    $itmoved = $true
    $letOnMoreDown = $true
    $cntSand = 0
    while ($itmoved) {
        if ($letOnMoreDown) { $curr = $StartPoint; $cntSand +=1 }
        $letOnMoreDown = $false
        $itmoved = $false
        # find the lowest number in Y direction from my current point of view
        $lowest = $map.keys | Where-Object { $_.x -eq $curr.x -and $_.y -gt $curr.y } | Sort-Object -Property y -Top 1
        if ($null -eq $lowest) {
            # Throw "dead end to eternity"
            return [PSCustomObject]@{
                Part1 = $cntSand - 1
                Part2 = $null
            }
        }
        # my current position is lowest.x, lowest.y-1
        $curr = [point]::new($lowest.x, $lowest.y-1)
        # if there is a free space down to the left (x-1, y) or right (x+1, y) of me, move there
        $left = [point]::new($lowest.x - 1, $lowest.y)
        $right = [point]::new($lowest.x + 1, $lowest.y)
        if ($null -eq $map[$left]) {    # is left down free?
            $curr = $left
            $itmoved = $true
        } elseif ($null -eq $map[$right]) { # is right down free?
            $curr = $right
            $itmoved = $true
        } else {
            # if there is no free space down to the left or right of me, so this unit stops
            Write-Verbose "$cntSand stopped at $curr"
            $map[[point]::new($curr.x, $curr.y)] = "o"
            $itmoved = $true
            $letOnMoreDown = $true
        }
    }

}
function Day14 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$InputFile
    )
    $Map = CreateMap $InputFile
    $result = LetItDrop -Map $Map -StartPoint ([point]::new(500, 0))
    $result
}