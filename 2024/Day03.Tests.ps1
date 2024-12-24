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
        It 'should return correct result' {
            Set-Content -Path $pathTestdata -Value "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
            $result = Day03b -InputFile $pathTestdata
            $result | Should -Be 48
        }
    }
    Context 'real data' {
        It 'should return correct result' {
            $result = Day03b -InputFile "$PSScriptRoot/Data/03.txt"
            $result | Should -Be 107069718
        }
    }
}