$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day01.ps1

    $Testdata = @"
3   4
4   3
2   5
1   3
3   9
3   3
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 11' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day01 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 11
        }
    }
    Context 'real data' {
        It 'should return 1603498' {
            $result = Day01 -InputFile "$PSScriptRoot/Data/01-1.txt"
            $result | Should -Be 1603498
        }
    }
}
Describe 'Part 2' -Skip {
    Context 'Testdata' {
        It 'should return 31' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day01 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 31
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            $result = Day01 -InputFile "$PSScriptRoot/Data/01-1.txt" -Part2
            $result | Should -Be 0
        }
    }
}