$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day03.ps1

    $Testdata = @"
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 2' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day03 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 161
        }
    }
    Context 'real data' {
        It 'should return correct result' {
            $result = Day03 -InputFile "$PSScriptRoot/Data/03.txt"
            $result | Should -Be 189600467
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
            Set-Content -Path $pathTestdata -Value $Testdata "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
            $result = Day03 -InputFile $pathTestdata -Part2
            $result | Should -Be 48
        }
        # It 'sample data <TestCase>' -ForEach @(
        #     # @{ TestCase = '1';  Expected = 1; Data = "1 2 3 4 5" }
        #     @{ TestCase = '2';  Expected = 1; Data = '22 25 27 28 30 31 32 29' } #last
        #     @{ TestCase = '3';  Expected = 1; Data = '5 3 4 5 6' }  #first
        #     @{ TestCase = '4';  Expected = 1; Data = '72 74 75 77 80 81 81' } #first 81
        # ) {
        #     Set-Content -Path $pathTestdata -Value $PSItem.Data
        #     $result = Day03 -InputFile $pathTestdata -Part2
        #     $result | Should -Be $PSItem.Expected
        # }
    }
    Context 'real data' {
        It '651 is too low' -Skip {
            $result = Day03 -InputFile "$PSScriptRoot/Data/03.txt" -Part2
            $result | Should -Be 674
        }
    }
}