BeforeAll {
    . "$PSScriptRoot/Day01.ps1"
}
Describe "Basic tests" {
    It "should return 12" {
        Get-CalibrationValue "1abc2" | Should -Be 12
    }
    It "should return 38" {
        Get-CalibrationValue "ab3c8def" | Should -Be 38
    }
    It "should return 15" {
        Get-CalibrationValue "12345" | Should -Be 15
    }
    It "should return 77" {
        Get-CalibrationValue "ab7cde" | Should -Be 77
    }
    It "should return 44" {
        Get-CalibrationValue "4" | Should -Be 44
    }
    It "should return 142" {
$testdata = @'
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
'@
        $testdata | Out-File "$PSScriptRoot/Testdata.txt"
        Day01 -InputFile "$PSScriptRoot/Testdata.txt" | Should -Be 142
        Remove-Item "$PSScriptRoot/Testdata.txt"
    }
}
Describe "Solution tests" {
    It "should return correct value" {
        Day01 -InputFile "$PSScriptRoot/Input.txt" | Should -Be 54990.
    }
}

Describe "Part 2" {
    Context "Basic tests" {
        It "'<toTest>' should return <expected>" -ForEach @(
            @{ toTest = "two1nine"           ; Expected = 29 }
            @{ toTest = "eightwothree"       ; Expected = 83 }
            @{ toTest = "abcone2threexyz"    ; Expected = 13 }
            @{ toTest = "xtwone3four"        ; Expected = 24 }
            @{ toTest = "4nineeightseven2"   ; Expected = 42 }
            @{ toTest = "zoneight234"        ; Expected = 14 }
            @{ toTest = "7pqrstsixteen"      ; Expected = 76 }
        ) {
            Get-CalibrationValue -InputObject $toTest -Part2 | Should -Be $expected
        }

        It "should return 251" {
            $testdata = @'
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
'@
                    $testdata | Out-File "$PSScriptRoot/Testdata.txt"
                    Day01 -InputFile "$PSScriptRoot/Testdata.txt" -Part2 | Should -Be 281
                    Remove-Item "$PSScriptRoot/Testdata.txt"
                }
    }
    Context "Solution tests" {
        It "should return correct value" {
            Day01 -InputFile "$PSScriptRoot/Input.txt" -Part2 | Should -Be 54473
        }
    }
}
