# Day07
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day07.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@"
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"@ -split "`n"
        }
    }
    Context 'Part1' {
        It 'should return 6440' {
            $result = Day07 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 6440
        }
    }
    Context 'Part2' {
        It 'should return 5905' {
            $result = Day07 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 5905
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 246795406' {
            $result = Day07 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 246795406
        }
    }
    Context 'Part2' {
        It 'should return 249356515.' {
            $result = Day07 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 249356515
        }
    }
}
