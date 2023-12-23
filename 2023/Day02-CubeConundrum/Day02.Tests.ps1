BeforeAll {
    . "$PSScriptRoot/Day02.ps1"
}
Describe "Part 1 basic tests" {
    BeforeAll {
        $cubesInBag = @{
            "red" = 12
            "green" = 13
            "blue" = 14
        }
    }
    Context 'Basic tests' {
        It "should return 1" {
            Get-GameIndexIfIsValid -cubesInBag $cubesInBag -gameRecord "Game 1: 12 red; 13 green; 14 blue" | Should -Be 1
        }
        It "should return null" {
            Get-GameIndexIfIsValid -cubesInBag $cubesInBag -gameRecord "Game 1: 27 red; 13 green; 14 blue" | Should -BeNullOrEmpty
        }
        It "<gameline> should return <expected>" -ForEach @(
                @{ expected = 1     ; gameline = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' }
                @{ expected = 2     ; gameline = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' }
                @{ expected = $null ; gameline = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red' }
                @{ expected = $null ; gameline = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' }
                @{ expected = 5     ; gameline = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green' }
            ) {
            Get-GameIndexIfIsValid -cubesInBag $cubesInBag -gameRecord $gameline | Should -Be $expected
        }
        It "should return sum of valid game indexes" {
            $testdata = @'
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
'@
            $testdata | Out-File "$PSScriptRoot/Testdata.txt"
            $result = Day02 -InputFile "$PSScriptRoot/Testdata.txt" -CubesInBag $cubesInBag
            $result | Should -Be 8
            Remove-Item "$PSScriptRoot/Testdata.txt"
        }
    }
    Context "Solution tests" {
        It "should return correct value" {
            $result = Day02 -InputFile "$PSScriptRoot/Input.txt" -CubesInBag $cubesInBag
            $result | Should -Be 2727.
        }
    }
}

Describe "Part 2" {
    Context "Basic tests" {

        It "<gameline> should return <expected>" -ForEach @(
            @{ expected = 48    ; gameline = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' }
            @{ expected = 12    ; gameline = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' }
            @{ expected = 1560  ; gameline = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red' }
            @{ expected = 630   ; gameline = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' }
            @{ expected = 36    ; gameline = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green' }
            ) {
                Get-PowerOfCubeSet -gameRecord $gameline | Should -Be $expected
            }
        It "should return sum of valid game indexes" {
    $testdata = @'
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
'@
            $testdata | Out-File "$PSScriptRoot/Testdata.txt"
            $result = Day02 -InputFile "$PSScriptRoot/Testdata.txt" -Part2
            $result | Should -Be 2286
            Remove-Item "$PSScriptRoot/Testdata.txt"
        }
    }
    Context "Solution tests" {
        It "should return correct value" {
            $result = Day02 -InputFile "$PSScriptRoot/Input.txt" -Part2
            $result | Should -Be 56580
        }
    }
}
