BeforeAll {
    . $PSScriptRoot/Day02.ps1
}

Describe 'Part 1' {
    It 'Should return 15' {
       Mock Get-Content { @'
A Y
B X
C Z
'@ -split "`r`n"
    }
        $result = Get-RpsScore -InputFile $PSScriptRoot\InputData.txt
        $result | Should -Be 15
    }
    It 'Should run with real data' {
        $result = Get-RpsScore -InputFile $PSScriptRoot\InputData.txt
        $result | Should -Be 15691
    }
}

Describe 'Part 2' {
    It 'Should return 12' {
        Mock Get-Content { @'
A Y
B X
C Z
'@ -split "`r`n"
         }

        $result = Get-RpsScore -InputFile $PSScriptRoot\InputData.txt -Round2
        $result | Should -Be 12
    }
    It 'Should run with real data' {
        $result = Get-RpsScore -InputFile $PSScriptRoot\InputData.txt -Round2
        $result | Should -Be 15691
    }

}