BeforeAll {
    . $PSScriptRoot\Day04.ps1
}

Describe 'Testing' {
    BeforeAll {
        Mock Get-Content { @(
            '2-4,6-8'
            '2-3,4-5'
            '5-7,7-9'
            '2-8,3-7'
            '6-6,4-6'
            '2-6,4-8'
            )
        }
    }
    It 'Part 1 should return 2' {
        $result = Day04 -Input $PSScriptRoot/InputData.txt
        $result | Where FullyContains -eq $true | Should -HaveCount 2
    }
    It 'Part 2 should return 4' {
        $result = Day04 -Input $PSScriptRoot/InputData.txt
        $result | Where HasOverlap -eq $true | Should -HaveCount 4
    }
}
Describe 'Real Data' {
    It 'Part 1 should return 475' {
        $result = Day04 -Input $PSScriptRoot/InputData.txt
        $result | Where FullyContains -eq $true | Should -HaveCount 475
    }
    It 'Part 2 should return 825' {
        $result = Day04 -Input $PSScriptRoot/InputData.txt
        $result | Where HasOverlap -eq $true | Should -HaveCount 825
    }

}