# Day09
BeforeAll {
    . $PSScriptRoot\Day09.ps1
}

Describe 'Part 1' {
    Context 'Moving tests' {
        It 'Move right' {
            $rope = [Rope]::new(0,0,0,0)
            $rope.MoveCommand("R 3")
            $rope.PosHead.X | Should -Be 3
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 2
            $rope.PosTail.Y | Should -Be 0

            $rope = [Rope]::new(4,1,3,0)
            $rope.MoveCommand("R 2")
            $rope.PosHead.X | Should -Be 6
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 5
            $rope.PosTail.Y | Should -Be 1
        }
        It 'Move left' {
            $rope = [Rope]::new(9,9,9,9)
            $rope.MoveCommand("L 3")
            $rope.PosHead.X | Should -Be 6
            $rope.PosHead.Y | Should -Be 9
            $rope.PosTail.X | Should -Be 7
            $rope.PosTail.Y | Should -Be 9

            # 1 ....H
            # 0 ...T
            # L 2 means head moves, tail stays (is permanently in touch)
            $rope = [Rope]::new(4,1,3,0)
            $rope.MoveCommand("L 2")
            $rope.PosHead.X | Should -Be 2
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 3
            $rope.PosTail.Y | Should -Be 0

            # 0 ...TH
            # L 2 movements like above
            $rope = [Rope]::new(4,0,3,0)
            $rope.MoveCommand("L 2")
            $rope.PosHead.X | Should -Be 2
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 3
            $rope.PosTail.Y | Should -Be 0
        }
        It 'Move up' {
            $rope = [Rope]::new(1,0,0,0)
            $rope.MoveCommand("U 3")
            $rope.PosHead.X | Should -Be 1
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 1
            $rope.PosTail.Y | Should -Be 2

            # 1 HT
            # 0
            # means head moves, tail stays 1 time, then moves diagonally
            $rope = [Rope]::new(0,1,1,1)
            $rope.MoveCommand("U 2")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2

            # 1
            # 0 HT
            # same as above
            $rope = [Rope]::new(0,0,1,0)
            $rope.MoveCommand("U 3")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 3
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2
        }
        It 'Move down' {
            # 3 .H
            # 2 T
            $rope = [Rope]::new(1,3,0,3)
            $rope.MoveCommand("D 3")
            $rope.PosHead.X | Should -Be 1
            $rope.PosHead.Y | Should -Be 0
            $rope.PosTail.X | Should -Be 1
            $rope.PosTail.Y | Should -Be 1

            # 3 H.
            # 2 T.
            # means head moves, tail stays
            $rope = [Rope]::new(0,3,0,2)
            $rope.MoveCommand("D 2")
            $rope.PosHead.X | Should -Be 0
            $rope.PosHead.Y | Should -Be 1
            $rope.PosTail.X | Should -Be 0
            $rope.PosTail.Y | Should -Be 2
        }
    }
    Context 'Testdata' -Skip {
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
        It 'should return 0' -skip {
            $matrix =  New-Object 'int[,]' 5,5
            $splat = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Matrix    = $matrix
                Length    = 5
            }
            $result = Day09 $splat
            $result | Should -Be 0
        }
    }

}
