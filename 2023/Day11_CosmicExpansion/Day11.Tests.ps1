$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day11.ps1

    $Testdata = @"
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"@
}

Describe 'Part 1' {
    BeforeAll {
        $Script:ExpansionRate = 1
    }
    Context 'Testdata' {
        It 'should return 374' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt" #-Verbose
            $result | Should -Be 374
        }
#         It 'should return -1 (other test input)' {
#             Mock Get-Content {@"
# "@ -split "`n"
#             }
#             $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt"
#             $result | Should -Be -1
#         }
    }
    Context 'real data' {
        It 'should return 9647174' {
            $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 9647174
        }
    }
}
Describe 'Part 2' {
    Context 'Testdata' {
        It 'should return 1030' {
            $Script:ExpansionRate = 10
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt" -Part2 -Verbose
            $result | Should -Be 1030
        }
        It 'should return 8410' {
            $Script:ExpansionRate = 100
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 8410
        }
    }
    Context 'real data' {
        It 'should return -1' -Skip {
            $Script:ExpansionRate = 1000000
            $result = Day11 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be -1     # 377319269864. Too high.
        }
    }
}