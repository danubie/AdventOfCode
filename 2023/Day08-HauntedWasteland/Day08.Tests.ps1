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

Describe 'Part 1'{
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
Describe 'Part 2' {
    BeforeAll {
        $Testdata = @"
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"@
    }
    Context 'Testdata' {
        It 'should return 6' {
            Mock Get-Content { $Testdata -split "`n" }
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 6
        }
    }
    Context 'real data' {
        It 'should return 0' -Skip {
            Throw 'not implemented'
            $result = Day08 -InputFile "$PSScriptRoot/inputdata.txt" -Part2
            $result | Should -Be 0
        }
    }
}
