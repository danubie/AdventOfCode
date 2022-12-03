BeforeAll {
    . $PSScriptRoot\Day03.ps1
}

Describe 'Testing' {
    BeforeAll {
        Mock Get-Content { @(
            'vJrwpWtwJgWrhcsFMMfFFhFp'
            'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL'
            'PmmdzqPrVvPwwTWBwg'
            'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn'
            'ttgJtRGJQctTZtZT'
            'CrZsJsPPZsGzwwsLwLmpwMDw'
            )
    }
    It 'Part 1 should return 157' {
        }
        $result = Day03 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 157
    }
    It 'Part 2 should return 70' {
        $result = Day03Part2 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 70
    }
}
Describe 'with real data' {
    It 'Part 1 should return 7845' {
        $result = Day03 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 7845
    }
    It 'Part 2 should return 2790' {
        $result = Day03Part2 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 2790
    }
}
