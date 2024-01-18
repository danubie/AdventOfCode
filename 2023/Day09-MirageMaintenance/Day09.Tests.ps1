$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day09.ps1

    $Testdata = @"
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 114' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day09 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 114
        }
#         It 'should return 0 (other test input)' {
#             Mock Get-Content {@"
# "@ -split "`n"
#             }
#             $result = Day09 -InputFile "$PSScriptRoot/inputdata.txt"
#             $result | Should -Be -1
#         }
    }
    Context 'real data' {
        It 'should return 1934898178' {
            $result = Day09 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 1934898178
        }
    }
}
Describe 'Part 2' -Skip {
    Context 'Testdata' {
        It 'should return 0' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day09 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 0
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            $result = Day09 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 0
        }
    }
}