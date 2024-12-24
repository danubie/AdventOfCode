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
Describe 'Part 2' {
    Context 'Testdata' {
        BeforeAll {
            $pathTestdata = "$PSScriptRoot/inputdata.txt"
        }
        AfterAll {
            if (Test-Path $pathTestdata) { Remove-Item $pathTestdata }
        }
        It 'should return 4' {
            Set-Content -Path $pathTestdata -Value $Testdata
            $result = Day02 -InputFile $pathTestdata -Part2
            $result | Should -Be 4
        }
        It 'sample data <TestCase>' -ForEach @(
            # @{ TestCase = '1';  Expected = 1; Data = "1 2 3 4 5" }
            @{ TestCase = '2';  Expected = 1; Data = '22 25 27 28 30 31 32 29' } #last
            @{ TestCase = '3';  Expected = 1; Data = '5 3 4 5 6' }  #first
            @{ TestCase = '4';  Expected = 1; Data = '72 74 75 77 80 81 81' } #first 81
        ) {
            Set-Content -Path $pathTestdata -Value $PSItem.Data
            $result = Day02 -InputFile $pathTestdata -Part2
            $result | Should -Be $PSItem.Expected
        }
    }
    Context 'real data' {
        It '651 is too low' -Skip {
            $result = Day02 -InputFile "$PSScriptRoot/Data/02.txt" -Part2
            $result | Should -Be 674
        }
    }
}