$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Day04.ps1

    $Testdata = @"
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"@
}

Describe 'Part 1' {
    Context 'Diagonal' {
        BeforeAll {
            $digData = @(
                'ABCDEF'
                '123456'
                'abcdef'
                '789012'
            )
        }
        It ' left to right' {
            $expected = @('A2c0','B3d1','C4e2','D5f','E6','F', '1b9', 'a8', '7')
            $result = SelectDiagonalLeftToRight -arrString ($digData)
            $result | Should -Be $expected
        }
        It ' right to left' {
            $expected = @('A', 'B1', 'C2a', 'D3b7', 'E4c8', 'F5d9', '6e0', 'f1', '2')
            $result = SelectDiagonalRightToLeft -arrString ($digData)
            $result | Should -Be $expected
        }
    }
    Context 'Testdata' {
        It 'should return 18' {
            Mock Get-Content { $Testdata -split "`r`n" }
            $result = Day04 -InputFile "$PSScriptRoot/inputdata.txt"
            $result | Should -Be 18
        }

        It 'should return <expected>' -ForEach @(
            @{ expected = 1; testit = "XMAS" }
            @{ expected = 0; testit = "XxxxXMAAXS" }
            @{ expected = 1; testit = "XMASXMAAXS" }
            @{ expected = 2; testit = "XMASSAMX" }
            @{ expected = 1; testit = "XXMAS" }
            @{ expected = 0; testit = "XMA" }
        ) {
            $result = InspectStringAndReversed -s $testit
            $result | Should -Be $expected
        }
    }
    Context 'real data' {
        It 'should return correct result' {
            $result = Day04 -InputFile "$PSScriptRoot/Data/04.txt"
            $result | Should -Be 2578
        }
    }
}
Describe 'Part 2' {
    Context 'Testdata' {
        BeforeAll {
            $pathTestdata = "$PSScriptRoot/inputdata.txt"
        }
        AfterAll {
            if (Test-Path $pathTestdata) { Remove-Item $pathTestdata }
        }
        It 'should return correct result' {
            Set-Content -Path $pathTestdata -Value $Testdata
            $result = Day04 -InputFile $pathTestdata -Part2
            $result | Should -Be 9
        }
    }
    Context 'real data' {
        It 'should return correct result' {
            $result = Day04 -InputFile "$PSScriptRoot/Data/04.txt" -Part2
            $result | Should -Be 1972
        }
    }
}