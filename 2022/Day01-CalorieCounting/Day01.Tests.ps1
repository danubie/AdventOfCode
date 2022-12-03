BeforeAll {
    . $PSScriptRoot/Day01.ps1
}

Describe "Day01" {
    It 'Should return 1 elf with 10 calories' {
        Mock Get-Content { "10" }
        $result = Get-ElfWithMostCalories -InputFile .\InputData.txt
        $result.ElfNumber | Should -Be 1
        $result.TotalCalories | Should -Be 10
    }
    It 'Should return elf 2 with 10 calories' {
        Mock Get-Content { "10", "", "20" }
        $result = Get-ElfWithMostCalories -InputFile .\InputData.txt
        $result.ElfNumber | Should -Be 2
        $result.TotalCalories | Should -Be 20
    }
    It 'Should return elf1 with 30 calories' {
        Mock Get-Content { "10", "20", "", "20" }
        $result = Get-ElfWithMostCalories -InputFile .\InputData.txt
        $result.ElfNumber | Should -Be 1
        $result.TotalCalories | Should -Be 30
    }
    It 'Should run with real data' {
        $result = Get-ElfWithMostCalories -InputFile $PSScriptRoot\InputData.txt
        $result.ElfNumber | Should -Be 128
        $result.TotalCalories | Should -Be 71934
    }
}

Describe 'Day01 - Part 2' {
    It 'Should return 45000' {
        Mock Get-Content { @'
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
'@ -split "`r`n"
    }
        $result = Get-ElfTop3 -InputFile .\InputData.txt
        $result.Sum | Should -Be 45000
    }
    It 'Should run with real data' {
        $result = Get-ElfTop3 -InputFile $PSScriptRoot\InputData.txt
        $result.Sum | Should -Be 211447
    }
}