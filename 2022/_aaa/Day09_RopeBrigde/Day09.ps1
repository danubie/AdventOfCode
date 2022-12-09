class Rope {
    $PosHead = [PSCustomObject]@{ X = -1; Y = -1 }
    $PosTail = [PSCustomObject]@{ X = -1; Y = -1 }

    Rope ([int]$HeadX, [int]$HeadY, [int]$TailX, [int]$TailY) {
        $this.PosHead = [PSCustomObject]@{ X = $HeadX; Y = $HeadY }
        $this.PosTail = [PSCustomObject]@{ X = $TailX; Y = $TailY }
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

            # if the head is above the tail, move the tail diagonally
            if ($this.PosHead.Y -gt $this.PosTail.Y) {
                $this.PosTail.Y++
                continue
            }
            # if the head is below the tail, move the tail diagonally
            if ($this.PosHead.Y -lt $this.PosTail.Y) {
                $this.PosTail.Y--
                continue
            }
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

            # if the head is left of the tail, move tail diagonally
            if ($this.PosHead.Y -gt $this.PosTail.Y) {
                $this.PosTail.Y++
                continue
            }
            # if the head is below the tail, move the tail diagonally
            if ($this.PosHead.Y -lt $this.PosTail.Y) {
                $this.PosTail.Y--
                continue
            }
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

            # if the head is rigth of the tail, move the tail diagonally
            if ($this.PosHead.X -gt $this.PosTail.X) {
                $this.PosTail.X++
                continue
            }
            # if the head is left the tail, move the head tail diagonally
            if ($this.PosHead.X -lt $this.PosTail.X) {
                $this.PosTail.X--
                continue
            }
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

            # if the head is rigth of the tail, move the tail diagonally
            if ($this.PosHead.X -gt $this.PosTail.X) {
                $this.PosTail.X++
                continue
            }
            # if the head is left the tail, move the head tail diagonally
            if ($this.PosHead.X -lt $this.PosTail.X) {
                $this.PosTail.X--
                continue
            }
        }
    }

}
function Day09 {
    [CmdletBinding()]
    param (
        $matrix,
        [int] $length,
        [string] $InputFile = "$PSScriptRoot/inputdata.txt"
    )

}