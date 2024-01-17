# Day08
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day08.ps1

    $Testdata = @"
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"@
}

Describe 'Part 1' {
    Context 'Testdata' {
        It 'should return 2' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 2
        }
        It 'should return 6 (other test input)' {
            Mock Get-Content {@"
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"@ -split "`n"
            }
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 6
        }
    }
    Context 'real data' {
        It 'should return 11567' {
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 11567
        }
    }
}
Describe 'Part 2' -Skip {
    Context 'Testdata' {
        It 'should return 0' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt" -Part 2
            $result | Should -Be 0
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt" -Part 2
            $result | Should -Be 0
        }
    }
}
