# Day09
BeforeAll {
    . $PSScriptRoot\Day09.ps1
}

Describe 'Part 1' {
    Context 'Moving tests' {
        It 'Move right' {
            $rope = [Rope]::new(10)
            $rope.SetStart(0,0,0,0)
            $rope.MoveCommand("R 3")
            $rope.PosHead.X | Should -Be 3
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 2
            $rope.PosTail.Y | Should -Be 0
            $rope.Part1Result() | Should -Be 3

            $rope.SetStart(4,1,3,0)
            $rope.MoveCommand("R 2")
            $rope.PosHead.X | Should -Be 6
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 5
            $rope.PosTail.Y | Should -Be 1
        }
        It 'Move left' {
            $rope = [Rope]::new(10)
            $rope.SetStart(9,9,9,9)
            $rope.MoveCommand("L 3")
            $rope.PosHead.X | Should -Be 6
            $rope.PosHead.Y | Should -Be 9
            $rope.PosTail.X | Should -Be 7
            $rope.PosTail.Y | Should -Be 9

            # 1 ....H
            # 0 ...T
            # L 2 means head moves, tail stays (is permanently in touch)
            $rope.SetStart(4,1,3,0)
            $rope.MoveCommand("L 2")
            $rope.PosHead.X | Should -Be 2
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 3
            $rope.PosTail.Y | Should -Be 0

            # 0 ...TH
            # L 2 movements like above
            $rope.SetStart(4,0,3,0)
            $rope.MoveCommand("L 2")
            $rope.PosHead.X | Should -Be 2
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 3
            $rope.PosTail.Y | Should -Be 0
        }
        It 'Move up' {
            $rope = [Rope]::new(10)
            $rope.SetStart(1,0,0,0)
            $rope.MoveCommand("U 3")
            $rope.PosHead.X | Should -Be 1
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 1
            $rope.PosTail.Y | Should -Be 2

            # 1 HT
            # 0
            # means head moves, tail stays 1 time, then moves diagonally
            $rope.SetStart(0,1,1,1)
            $rope.MoveCommand("U 2")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2

            # 1
            # 0 HT
            # same as above
            $rope.SetStart(0,0,1,0)
            $rope.MoveCommand("U 3")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2
        }
        It 'Move down' {
            $rope = [Rope]::new(10)

            # 3 .H
            # 2 T
            $rope.SetStart(1,3,0,3)
            $rope.MoveCommand("D 3")
            $rope.PosHead.X | Should -Be 1
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 1
            $rope.PosTail.Y | Should -Be 1

            # 3 H.
            # 2 T.
            # means head moves, tail stays
            $rope.SetStart(0,3,0,2)
            $rope.MoveCommand("D 2")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2
        }
    }
    Context 'Testdata' {
        Beforeall {
            Mock Get-Content {@(
                'R 4'
                'U 4'
                'L 3'
                'D 1'
                'R 4'
                'D 1'
                'L 5'
                'R 2'
                )
            }
        }
        It 'should return 13' {
            $rope = [Rope]::new(10)
            $rope.SetStart(0,0,0,0,$true)
            $splat = @{
                Rope = $Rope
                InputFile = "$PSScriptRoot\inputdata.txt"
            }
            Day09 @splat
            $rope.PrintVisitMap()
            $rope.Part1Result() | Should -Be 13
        }
    }
    Context 'real data' {
        It 'should return more than 3015' {
            $rope = [Rope]::new(1000)
            $rope.SetStart(0,0,0,0)
            $splat = @{
                Rope = $Rope
                InputFile = "$PSScriptRoot\inputdata.txt"
            }
            Day09 @splat
            $rope.Part1Result() | Should -Be 3016
        }
    }

}
