$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day02.ps1

    $Testdata = @"
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 2' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day02 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 2
        }
    }
    Context 'real data' {
        It 'should return 639' {
            $result = Day02 -InputFile "$PSScriptRoot/Data/02.txt"
            $result | Should -Be 639
        }
    }
}
Describe 'Part 2' -Skip {
    Context 'Testdata' {
        It 'should return 31' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day02 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 31
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            $result = Day02 -InputFile "$PSScriptRoot/Data/02.txt" -Part2
            $result | Should -Be 0
        }
    }
}