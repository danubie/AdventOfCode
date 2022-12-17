BeforeAll {
    Set-StrictMode -Version Latest
    . $PSScriptRoot/Day12.ps1
}



Describe 'Testdata' {
    BeforeEach {
        $matrix = [System.Collections.ArrayList]::new()         # the hill
        $path = [System.Collections.Queue]::new()               # current path
        $First = [System.Numerics.Complex]::new(0,0)               # start position
        $validPaths = [System.Collections.ArrayList]::new()     # all paths leading to the end
    }
    BeforeAll {
        Mock Get-Content {
            'Sabqponm'
            'abcryxxl'
            'accszExk'
            'acctuvwj'
            'abdefghi'
        }
    }
    It 'Should do something' {
        Day12 -verbose
        # ($Script:validPaths | Measure-Object -Minimum).Minimum | Should -Be 31
        $Script:shortestPath | Should -Be 31
    }
}

Describe 'real data' {
    BeforeEach {
        $matrix = [System.Collections.ArrayList]::new()         # the hill
        $path = [System.Collections.Queue]::new()               # current path
        $First = [System.Numerics.Complex]::new(0,0)               # start position
        $validPaths = [System.Collections.ArrayList]::new()     # all paths leading to the end
    }
    BeforeAll {
    }
    It 'Should do something' {
        Day12
        ($Script:validPaths | Measure-Object -Minimum).Minimum | Should -Be 31
    }
}
