class Rope {
    $PosHead = [PSCustomObject]@{ X = -1; Y = -1 }
    $PosTail = [PSCustomObject]@{ X = -1; Y = -1 }

    $VisitMap = $null
    $LengthMap = 0      # length of a map line
    $Debug = $false

    Rope ([int] $LengthMap) {
        $This.lengthMap = $LengthMap
        $This.ResetMap($false)
    }

    [void] SetStart([int]$HeadX, [int]$HeadY, [int]$TailX, [int]$TailY) {
        $This.SetStart($HeadX, $HeadY, $TailX, $TailY, $false)
    }

    [void] SetStart([int]$HeadX, [int]$HeadY, [int]$TailX, [int]$TailY, [bool]$Debug) {
        if ($null -eq $This.VisitMap) {
            throw "VisitMap not initialized"
        }
        $This.ResetMap($Debug)
        $this.PosHead = [PSCustomObject]@{ X = $HeadX; Y = $HeadY }
        $this.PosTail = [PSCustomObject]@{ X = $TailX; Y = $TailY }
        # mark the starting position
        $this.VisitMap[($this.PosTail.Y*10)+$this.PosTail.X]++
        $this.PrintVisitMap("Start")
    }

    [void] ResetMap([bool]$Debug = $false) {
        $this.VisitMap = [int[]]::new($This.LengthMap * $This.LengthMap)
        $This.Debug = $Debug
    }

    [void] MoveCommand ([string]$line) {
        $movement = $line -split ' '
        $direction = $movement[0]
        $steps = [int]$movement[1]
        switch ($direction) {
            'R' {
                $This.MoveRight($steps)
            }
            'L' {
                $This.MoveLeft($steps)
            }
            'U' {
                $This.MoveUp($steps)
            }
            'D' {
                $This.MoveDown($steps)
            }
        }
        $this.PrintVisitMap("cmd: $line")
    }

    [void] MoveRight([int] $steps) {
        for ($i = 0; $i -lt $steps; $i++) {
            $this.PosHead.X++       # move head
            # if tail still connects to head, do not move tail
            # => deltax max 1 and deltay max 1
            if ([math]::Abs($this.PosHead.X - $this.PosTail.X) -le 1 -and [math]::Abs($this.PosHead.Y - $this.PosTail.Y) -le 1) {
                continue
            }
            # ok: => tail has to move
            $this.PosTail.X++

            if ($this.PosHead.Y -gt $this.PosTail.Y) {
                # if the head is above the tail, move the tail diagonally
                $this.PosTail.Y++
            } elseif ($this.PosHead.Y -lt $this.PosTail.Y) {
            # if the head is below the tail, move the tail diagonally
                $this.PosTail.Y--
            }
            # mark the visited position
            $this.VisitMap[($this.PosTail.Y*10)+$this.PosTail.X]++
        }
    }

    [void] MoveLeft([int] $steps) {
        for ($i = 0; $i -lt $steps; $i++) {
            $this.PosHead.X--
            # if tail still connects to head, do not move tail
            # => deltax max 1 and deltay max 1
            if ([math]::Abs($this.PosHead.X - $this.PosTail.X) -le 1 -and [math]::Abs($this.PosHead.Y - $this.PosTail.Y) -le 1) {
                continue
            }
            # ok: => tail has to move
            $this.PosTail.X--

            if ($this.PosHead.Y -gt $this.PosTail.Y) {
                # if the head is left of the tail, move tail diagonally
                $this.PosTail.Y++
            } elseif ($this.PosHead.Y -lt $this.PosTail.Y) {
                # if the head is below the tail, move the tail diagonally
                $this.PosTail.Y--
            }
            # mark the visited position
            $this.VisitMap[($this.PosTail.Y*10)+$this.PosTail.X]++
        }
    }

    [void] MoveUp([int] $steps) {
        for ($i = 0; $i -lt $steps; $i++) {
            $this.PosHead.Y++
            # if tail still connects to head, do not move tail
            # => deltax max 1 and deltay max 1
            if ([math]::Abs($this.PosHead.X - $this.PosTail.X) -le 1 -and [math]::Abs($this.PosHead.Y - $this.PosTail.Y) -le 1) {
                continue
            }
            # ok: => tail has to move
            $this.PosTail.Y++

            if ($this.PosHead.X -gt $this.PosTail.X) {
                # if the head is rigth of the tail, move the tail diagonally
                $this.PosTail.X++
            }elseif ($this.PosHead.X -lt $this.PosTail.X) {
                # if the head is left the tail, move the head tail diagonally
                $this.PosTail.X--
            }
            # mark the visited position
            $this.VisitMap[($this.PosTail.Y*10)+$this.PosTail.X]++
        }
    }

    [void] MoveDown([int] $steps) {
        for ($i = 0; $i -lt $steps; $i++) {
            $this.PosHead.Y--
            # if tail still connects to head, do not move tail
            # => deltax max 1 and deltay max 1
            if ([math]::Abs($this.PosHead.X - $this.PosTail.X) -le 1 -and [math]::Abs($this.PosHead.Y - $this.PosTail.Y) -le 1) {
                continue
            }
            # ok: => tail has to move
            $this.PosTail.Y--

            if ($this.PosHead.X -gt $this.PosTail.X) {
                # if the head is rigth of the tail, move the tail diagonally
                $this.PosTail.X++
            } elseif ($this.PosHead.X -lt $this.PosTail.X) {
                # if the head is left the tail, move the head tail diagonally
                $this.PosTail.X--
            }
            # mark the visited position
            $this.VisitMap[($this.PosTail.Y*10)+$this.PosTail.X]++
        }
    }

    [void] PrintVisitMap([string] $context) {
        if (!$This.Debug) { return }
        Write-Host $context
        $This.PrintVisitMap()
    }
    [void] PrintVisitMap() {
        if (!$This.Debug) { return }
        # should print the map with writehost
        # the map hast n elements per line
        # starting with the last line

        for ($i = $this.LengthMap-1; $i -ge 0; $i--) {
            Write-Host ("{0,4} " -f $i) -NoNewline
            for ($j = 0; $j -lt $This.LengthMap; $j++) {
                if ($this.PosHead.X -eq $j -and $this.PosHead.Y -eq $i) {
                    Write-Host -NoNewline "H"
                } elseif ($this.PosTail.X -eq $j -and $this.PosTail.Y -eq $i) {
                    Write-Host -NoNewline "T"
                } elseif ($this.VisitMap[($i*10)+$j] -gt 0) {
                    Write-Host -NoNewline "#"
                } else {
                    Write-Host -NoNewline "."
                }
            }
            Write-Host
        }
        Write-Host "     " -NoNewline
        for ($j = 0; $j -lt $this.LengthMap; $j++) {
            Write-Host ("{0}         " -f  $j)-NoNewline
        }
        Write-Host
        Write-Host "     " -NoNewline
        for ($j = 0; $j -lt $this.LengthMap; $j++) {
            Write-Host ("{0}" -f ($j % 10)) -NoNewline
        }

    }


    [int] Part1Result() {
        $result = 0
        for ($i = 0; $i -lt $this.VisitMap.Length; $i++) {
            if ($this.VisitMap[$i] -gt 0) {
                $result++
            }
        }
        return $result
    }
}
function Day09 {
    [CmdletBinding()]
    param (
        [Rope] $Rope,
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )
    foreach ($line in (Get-Content $InputFile)) {
        $Rope.MoveCommand($line)
    }
}