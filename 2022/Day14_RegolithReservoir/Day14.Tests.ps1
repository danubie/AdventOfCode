# Day14
BeforeAll {
    . $PSScriptRoot\Day14.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(
            '498,4 -> 498,6 -> 496,6'
            '503,4 -> 502,4 -> 502,9 -> 494,9'
        )
        }
    }
    Context 'Part1' {
        It 'should return 0' {
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            $result.Part1 | Should -Be 24
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return correct result' {
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            $result.Part1 | Should -Be 799
        }
    }
    Context 'Part2' -Skip {
        It 'should return 0' {
            # $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
