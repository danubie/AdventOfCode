# Day25
BeforeAll {
    . $PSScriptRoot\Day25.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(
            '1=-0-2'
            '12111'
            '2=0='
            '21'
            '2=01'
            '111'
            '20012'
            '112'
            '1=-1='
            '1-12'
            '12'
            '1='
            '122'
        )
        }
    }
    Context 'Part1' {
        It 'should return correct decimal number'  -Foreach @(
            @{ snafu = '1=-0-2'; value =     1747 }
            @{ snafu = ' 12111'; value =      906 }
            @{ snafu = '  2=0='; value =      198 }
            @{ snafu = '    21'; value =       11 }
            @{ snafu = '  2=01'; value =      201 }
            @{ snafu = '   111'; value =       31 }
            @{ snafu = ' 20012'; value =     1257 }
            @{ snafu = '   112'; value =       32 }
            @{ snafu = ' 1=-1='; value =      353 }
            @{ snafu = '  1-12'; value =      107 }
            @{ snafu = '    12'; value =        7 }
            @{ snafu = '    1='; value =        3 }
            @{ snafu = '   122'; value =       37 }
        ) {
            ConvertFrom-Snafu $snafu.Trim() | Should -Be $value
        }
        It 'Should return Snafu' -Foreach @(
            @{ snafu = '1=-0-2'; value =     1747 }
            @{ snafu = ' 12111'; value =      906 }
            @{ snafu = '  2=0='; value =      198 }
            @{ snafu = '    21'; value =       11 }
            @{ snafu = '  2=01'; value =      201 }
            @{ snafu = '   111'; value =       31 }
            @{ snafu = ' 20012'; value =     1257 }
            @{ snafu = '   112'; value =       32 }
            @{ snafu = ' 1=-1='; value =      353 }
            @{ snafu = '  1-12'; value =      107 }
            @{ snafu = '    12'; value =        7 }
            @{ snafu = '    1='; value =        3 }
            @{ snafu = '   122'; value =       37 }
        ) {
            ConvertTo-Snafu -value $value | Should -Be $snafu.Trim()
        }
        It 'should return correct Result' {
            $result = Day25 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be '2=-1=0'
        }
    }
    Context 'Part2' {
        It 'should return correct snafu string' {
            # $result = Day25 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 0' {
            $result = Day25 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be "2-0-01==0-1=2212=100"
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            # $result = Day25 -InputFile "$PSScriptRoot/inputdata.txt"
            # $result | Should -Be 0
        }
    }
}
