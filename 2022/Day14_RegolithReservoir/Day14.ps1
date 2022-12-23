class point1 {
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
    [OutputType([char[,]])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile
    )

    [string[,]]$script:Map = [string[,]]::New(1000,1000)
    [int]$script:MaxY = 0
    foreach ($line in Get-Content $InputFile) {
        $lineEdges = $line -split ' -> '
        $prevX, $prevY = [int[]]$lineEdges[0].Split(',')
        if ($prevY -gt $MaxY) { $MaxY = $prevY }
        $script:Map[$prevX,$prevY] = "#"

        for ($i = 1; $i -le $lineEdges.Length - 1; $i++) {
            $nextX, $nextY = [int[]]$lineEdges[$i].Split(',')
            if ($nextY -gt $script:MaxY) { $script:MaxY = $nextY }
            if ($nextX -eq $prevX) {
                # draw a vertical line
                $minY = [Math]::Min($prevY, $nextY)
                $maxY = [Math]::Max($prevY, $nextY)
                for ($y = $minY; $y -le $maxY; $y++) {
                    $Script:Map[$prevX,$y] = "#"
                }
            } elseif ($nextY -eq $prevY) {
                # draw a horizontal line
                $minX = [Math]::Min($prevX, $nextX)
                $maxX = [Math]::Max($prevX, $nextX)
                for ($x = $minX; $x -le $maxX; $x++) {
                    $Script:Map[$x,$prevY] = "#"
                }
            } else {
                throw "Invalid line: $line"
            }
            $prevX = $nextX
            $prevY = $nextY
            "" | Out-Null
        }
    }
}

# function CreateMap1 {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory=$true)]
#         [string]$InputFile
#     )

#     $script:Map = [hashtable]@{}
#     $script:MaxY = 0
#     foreach ($line in Get-Content $InputFile) {
#         $lineEdges = $line -split ' -> '#  $line.Split(' -> ', [StringSplitOptions]::RemoveEmptyEntries)
#         $prevX, $prevY = $lineEdges[0].Split(',')
#         if ($prevY -gt $MaxY) { $MaxY = $prevY }
#         $Script:Map[$prev] = "#"
#         for ($i = 1; $i -le $lineEdges.Length - 1; $i++) {
#             $nextX, $nextY = $lineEdges[$i].Split(',')
#             if ($nextY -gt $MaxY) { $MaxY = $nextY }
#             if ($nextX -eq $prevX) {
#                 # draw a vertical line
#                 $minY = [Math]::Min($prevY, $nextY)
#                 $maxY = [Math]::Max($prevY, $nextY)
#                 for ($y = $minY; $y -le $maxY; $y++) {
#                     $Script:Map[$prevX, $y] = "#"
#                 }
#             } elseif ($nextY -eq $prevY) {
#                 # draw a horizontal line
#                 $minX = [Math]::Min($prevX, $nextX)
#                 $maxX = [Math]::Max($prevX, $nextX)
#                 for ($x = $minX; $x -le $maxX; $x++) {
#                     $Script:Map[$x, $prevY] = "#"
#                 }
#             } else {
#                 throw "Invalid line: $line"
#             }
#             $prev = $next
#             "" | Out-Null
#         }
#     }
#     $Script:Map
# }

function LetItDrop {
    [CmdletBinding()]
    param (
        [int] $StartX
    )
    # idea: every following sand takes the same way down as the one before
    # until the position before one stopped.
    # this could be the one to start the next exploration of a free field
    $stack = [System.Collections.Stack]::new()
    $itmoved = $true
    $cntSand = 1
    $currX = $StartX
    $currY = 0;
    while ($itmoved) {
        Write-Verbose "currX,currY : ($currX, $currY)"
        "" | Out-Null
        #which on is the next free space?
        while ($currY -le $script:MaxY -and $itmoved) {
            if ($null -eq $Script:Map[$currX,($currY + 1)]) {
                $stack.Push(($currX,$currY))
                $currY += 1
                $itmoved = $true
            } elseif ($null -eq $Script:Map[($currX - 1),($currY + 1)]) {
                $stack.Push(($currX,$currY))
                $currX -= 1
                $currY += 1
                $itmoved = $true
            } elseif ($null -eq $Script:Map[($currX + 1),($currY + 1)]) {
                $stack.Push(($currX,$currY))
                $currX += 1
                $currY += 1
                $itmoved = $true
            } else {
                $itmoved = $false
            }
        }
        if ($curry -ge $script:MaxY) {
            # from here to eternity
            break
        }
        # now currX,currY hod the posisition of this sand
        $script:Map[$currX,$currY] = 'o'
        if ($stack.Count -gt 0) {
            $cntSand +=1
            $currX, $currY = $stack.Pop()
            $itmoved = $true
        }
    }
    ($cntSand - 1)      # -1 because the last one is the one that drops out of the map
}

function Day14 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$InputFile
    )
    CreateMap $InputFile
    $result1 = LetItDrop -StartX 500
    [PSCustomObject]@{
        Part1 = $result1
        Part2 = 0
    }
}