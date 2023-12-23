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
