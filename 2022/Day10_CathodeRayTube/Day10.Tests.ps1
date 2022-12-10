# Day10
BeforeAll {
    . $PSScriptRoot\Day10.ps1
    Set-StrictMode -Version Latest
}

Describe 'using testdata' {
    Beforeall {
        Mock Get-Content {@(
            'addx 15'
            'addx -11'
            'addx 6'
            'addx -3'
            'addx 5'
            'addx -1'
            'addx -8'
            'addx 13'
            'addx 4'
            'noop'
            'addx -1'
            'addx 5'
            'addx -1'
            'addx 5'
            'addx -1'
            'addx 5'
            'addx -1'
            'addx 5'
            'addx -1'
            'addx -35'
            'addx 1'
            'addx 24'
            'addx -19'
            'addx 1'
            'addx 16'
            'addx -11'
            'noop'
            'noop'
            'addx 21'
            'addx -15'
            'noop'
            'noop'
            'addx -3'
            'addx 9'
            'addx 1'
            'addx -3'
            'addx 8'
            'addx 1'
            'addx 5'
            'noop'
            'noop'
            'noop'
            'noop'
            'noop'
            'addx -36'
            'noop'
            'addx 1'
            'addx 7'
            'noop'
            'noop'
            'noop'
            'addx 2'
            'addx 6'
            'noop'
            'noop'
            'noop'
            'noop'
            'noop'
            'addx 1'
            'noop'
            'noop'
            'addx 7'
            'addx 1'
            'noop'
            'addx -13'
            'addx 13'
            'addx 7'
            'noop'
            'addx 1'
            'addx -33'
            'noop'
            'noop'
            'noop'
            'addx 2'
            'noop'
            'noop'
            'noop'
            'addx 8'
            'noop'
            'addx -1'
            'addx 2'
            'addx 1'
            'noop'
            'addx 17'
            'addx -9'
            'addx 1'
            'addx 1'
            'addx -3'
            'addx 11'
            'noop'
            'noop'
            'addx 1'
            'noop'
            'addx 1'
            'noop'
            'noop'
            'addx -13'
            'addx -19'
            'addx 1'
            'addx 3'
            'addx 26'
            'addx -30'
            'addx 12'
            'addx -1'
            'addx 3'
            'addx 1'
            'noop'
            'noop'
            'noop'
            'addx -9'
            'addx 18'
            'addx 1'
            'addx 2'
            'noop'
            'noop'
            'addx 9'
            'noop'
            'noop'
            'noop'
            'addx -1'
            'addx 2'
            'addx -37'
            'addx 1'
            'addx 3'
            'noop'
            'addx 15'
            'addx -21'
            'addx 22'
            'addx -6'
            'addx 1'
            'noop'
            'addx 2'
            'addx 1'
            'noop'
            'addx -10'
            'noop'
            'noop'
            'addx 20'
            'addx 1'
            'addx 2'
            'addx 2'
            'addx -6'
            'addx -11'
            'noop'
            'noop'
            'noop'
            )
        }
    }
    It 'Part 1 should return 13140' {
        $result = Day10 -InputFile "$PSScriptRoot/inputdata.txt"
        $result.Part1 | Should -Be 13140
    }
    It 'Part 2 should show correct pixels' {
        $result = Day10 -InputFile "$PSScriptRoot/inputdata.txt"
        $result.Part2[0] | Should -Be '##..##..##..##..##..##..##..##..##..##..'
        $result.Part2[1] | Should -Be '###...###...###...###...###...###...###.'
        $result.Part2[2] | Should -Be '####....####....####....####....####....'
        $result.Part2[3] | Should -Be '#####.....#####.....#####.....#####.....'
        $result.Part2[4] | Should -Be '######......######......######......####'
        $result.Part2[5] | Should -Be '#######.......#######.......#######.....'
    }
}

Describe 'Using real data' {
    Context 'Part 1' {
        It 'should return correct result' {
            $result = Day10 -InputFile "$PSScriptRoot/inputdata.txt"
            $result.Part1 | Should -Be 15680
            foreach ($line in $result.Part2) {
                Write-Host $line
            }
        }
        It 'Part 2 should show correct pixels' {
            $result = Day10 -InputFile "$PSScriptRoot/inputdata.txt"
            $result.Part2[0] | Should -Be '####.####.###..####.#..#..##..#..#.###..'
            $result.Part2[1] | Should -Be '...#.#....#..#.#....#..#.#..#.#..#.#..#.'
            $result.Part2[2] | Should -Be '..#..###..###..###..####.#....#..#.#..#.'
            $result.Part2[3] | Should -Be '.#...#....#..#.#....#..#.#.##.#..#.###..'
            $result.Part2[4] | Should -Be '#....#....#..#.#....#..#.#..#.#..#.#....'
            $result.Part2[5] | Should -Be '####.#....###..#....#..#..###..##..#....'
        }
    }
}






