# Day06
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day06.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content { @'
Time:      7  15   30
Distance:  9  40  200
'@ -split "`n"
        }
    }
    Context 'Part1' {
        It 'should return 288' {
            $result = Day06 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 288
        }
    }
    Context 'Part2' {
        It 'should return 71503' {
            $result = Day06 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 71503
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 2344708' {
            $result = Day06 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 2344708
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            $result = Day06 -InputFile "$PSScriptRoot/inputdata.txt"  -Part2
            $result | Should -Be 2344708
        }
    }
}
