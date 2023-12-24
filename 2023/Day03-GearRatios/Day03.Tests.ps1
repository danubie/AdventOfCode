# Day03.Tests.ps1
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day03.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(
            '467  114  '
            '   *      '
            '  35  633 '
            '      #   '
            '617*      '
            '     + 58 '
            '  592     '
            '      755 '
            '   $ *    '
            ' 664 598  '
        )
        }
    }
    Context 'Part1' {
        It 'should return 2 part numbers' {
            $result = '467  114   ' | RegisterPartNumber -LineNumber 1
            $result | Should -HaveCount 2
            $result.LineNumber | Should -Be @(1, 1)
            $result.Type | Should -Be @('P', 'P')
            $result.Value | Should -Be @(467, 114)
            $result.StartIndex | Should -Be @(0, 5)
            $result.TokenLength | Should -Be @(3, 3)
            $result.EndIndex | Should -Be @(2, 7)
        }
        It "should return 2 part numbers and 3 symbols" {
            $result = '|467 114  +*' | RegisterPartNumber -LineNumber 1
            $result | Should -HaveCount 5
            $result.LineNumber | Should -Be @(1, 1, 1, 1, 1)
            $result.Type | Should -Be @('S', 'P', 'P', 'S', 'S')
            $result.Value | Should -Be @('|', 467, 114, '+', '*')
            $result.StartIndex | Should -Be @(0, 1, 5, 10, 11)
            $result.TokenLength | Should -Be @(1, 3, 3, 1, 1)
            $result.EndIndex | Should -Be @(0, 3, 7, 10, 11)
        }
        It 'should count all adjacent part numbers' {
            $result = Day03 -InputFile 'dummy'
            $result | Should -Be 4361
        }
    }
    Context 'Part2' {
        It 'should return sum up products of * adjacent part numbers' {
            $result = Day03 -InputFile 'dummy' -Part2
            $result | Should -Be 467835
        }
    }
}
Describe 'real data' {
    Context 'Part1' {
        It 'should return 0' {
            $result = Day03 -InputFile "$PSScriptRoot/input.txt"
            $result | Should -Be 530849
        }
    }
    Context 'Part2' {
        It 'should return 0' {
            $result = Day03 -InputFile "$PSScriptRoot/input.txt" -Part2
            $result | Should -Be 84900879
        }
    }
}
