$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day14.ps1

    $Testdata = @"
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 0' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 136
        }
#         It 'should return 0 (other test input)' {
#             Mock Get-Content {@"
# "@ -split "`n"
#             }
#             $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
#             $result | Should -Be 0
#         }
    }
    Context 'real data' {
        It 'should return 110128' {
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 110128
        }
    }
}
Describe 'Part 2' -Skip {
    Context 'Testdata' {
        It 'should return 0' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be -1
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            $result = Day14 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be -1
        }
    }
}