BeforeAll {
    . $PSScriptRoot\Day03.ps1
}

Describe 'Testing' {
    It 'Should return 157' {
        Mock Get-Content { @(
            'vJrwpWtwJgWrhcsFMMfFFhFp'
            'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL'
            'PmmdzqPrVvPwwTWBwg'
            'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn'
            'ttgJtRGJQctTZtZT'
            'CrZsJsPPZsGzwwsLwLmpwMDw'
            )
        }
        $result = Day03 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 157
    }
    It 'Should return 7845' {
        $result = Day03 -Input $PSScriptRoot/InputData.txt
        $result | Should -Be 7845
    }
}