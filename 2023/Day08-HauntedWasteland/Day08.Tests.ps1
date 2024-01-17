# Day08
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day08.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@"
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"@ -split "`n"
        }
    }
    Context 'Part1' {
        It 'should return 2' {
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 2
        }
        It 'should return 6' {
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
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 11567' {
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 11567
        }
    }
    Context 'Part2' {
        It 'should return 0' -Skip {
            # $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
