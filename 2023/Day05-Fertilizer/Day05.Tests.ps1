# Day05.Tests.ps1
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day05.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(
'seeds: 79 14 55 13'
''
'seed-to-soil map:'
'50 98 2'
'52 50 48'
''
'soil-to-fertilizer map:'
'0 15 37'
'37 52 2'
'39 0 15'
''
'fertilizer-to-water map:'
'49 53 8'
'0 11 42'
'42 0 7'
'57 7 4'
''
'water-to-light map:'
'88 18 7'
'18 25 70'
''
'light-to-temperature map:'
'45 77 23'
'81 45 19'
'68 64 13'
''
'temperature-to-humidity map:'
'0 69 1'
'1 0 69'
''
'humidity-to-location map:'
'60 56 37'
'56 93 4'
        )
        }
    }
    Context 'Part1' {
        It 'should return 35' {
            $result = Day05 -InputFile "$PSScriptRoot/input.txt"
            $result | Should -Be 35
        }
    }
    Context 'Part2' {
        It 'should return 35' {
            $result = Day05 -InputFile "$PSScriptRoot/input.txt"
            $result | Should -Be 35
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 313045984' {
            $result = Day05 -InputFile "$PSScriptRoot/input.txt"
            $result | Should -Be 313045984
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day05 -InputFile "$PSScriptRoot/input.txt"
            # $result | Should -Be 0
        }
    }
}
