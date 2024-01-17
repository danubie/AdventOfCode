BeforeAll {
    . $PSScriptRoot/BinarySearchTemplate.ps1
}

Describe 'BinarySearchTemplate' {
    It 'Returns the index of the target' {
        $array = 1..10
        $target = 4
        $expected = 4
        $TestFunction = {
            param($x) if ($x -eq $target) { 0 } elseif ($x -lt $target) { -1 } else { 1 } }
        $result = BinarySearchTemplate2 -LowBoundary 1 -HighBoundary 10 -Test $TestFunction
        $result | Should -Be $expected
    }
    It 'Returns -1 if the target is not found' {
        $array = 1..10
        $target = 11
        $expected = $null
        $TestFunction = {
            param($x) if ($x -eq $target) { 0 } elseif ($x -lt $target) { -1 } else { 1 } }
        $result = BinarySearchTemplate2 -LowBoundary 1 -HighBoundary 10 -Test $TestFunction
        $result | Should -Be $expected
    }
}
