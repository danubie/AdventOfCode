# Day18
BeforeAll {
    . $PSScriptRoot\Day18.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(
            # '1,1,1'
            # '2,1,1'
            '2,2,2'
            '1,2,2'
            '3,2,2'
            '2,1,2'
            '2,3,2'
            '2,2,1'
            '2,2,3'
            '2,2,4'
            '2,2,6'
            '1,2,5'
            '3,2,5'
            '2,1,5'
            '2,3,5'
        )
        }
    }
    Context 'Part1' {
        It 'should return 0' {
            $result = Day18 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result.Cubes.Count | Should -Be 2
            # $result.Squares.Count | Should -Be 10
            $result.Cubes.Count | Should -Be 13
            $result.Squares.Count | Should -Be 64
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day18 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 3550' {
            $result = Day18 -InputFile "$PSScriptRoot/inputdata.txt"
            $result.Cubes.Count | Should -Be 2170
            $result.Squares.Count | Should -Be 3550
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day18 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
