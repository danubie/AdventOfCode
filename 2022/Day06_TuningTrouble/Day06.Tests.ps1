BeforeAll {
    . $PSScriptRoot\Day06.ps1
}

Describe 'Day06' {
    It 'Find-StartMarker should find the start marker at <expected>' -ForEach @(
        @{ stream = @('abcde'); expected = 4 }
        @{ stream = @('mjqjpqmgbljsphdztnvjfqwrcgsmlb'); expected = 7 }
        @{ stream = @('bvwbjplbgvbhsrlpgdmjqwftvncz'); expected = 5 }
        @{ stream = @('nppdvjthqldpwncqszvftbrmjlhg'); expected = 6 }
        @{ stream = @('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'); expected = 10 }
        @{ stream = @('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'); expected = 11 }
    ) {
        param($stream, $expected)
        Find-StartMarker -stream $stream | Should -Be $expected
    }
    It 'using real data' {
        $ret = Day06
        $ret | Should -Be 1757
    }
}

Describe 'Day06 Part2' {
    It 'Find-StartMarker should find the start marker at <expected>' -ForEach @(
        @{ stream = @('mjqjpqmgbljsphdztnvjfqwrcgsmlb'); expected = 19 }
        @{ stream = @('bvwbjplbgvbhsrlpgdmjqwftvncz'); expected = 23 }
        @{ stream = @('nppdvjthqldpwncqszvftbrmjlhg'); expected = 23 }
        @{ stream = @('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'); expected = 29 }
        @{ stream = @('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'); expected = 26 }
    ) {
        param($stream, $expected)
        Find-StartMarker -stream $stream -MarkerLength 14 | Should -Be $expected
    }
    It 'using real data' {
        $ret = Day06 -part2
        $ret | Should -Be 1757
    }
}