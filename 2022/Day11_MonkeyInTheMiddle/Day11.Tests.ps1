# Day11
BeforeAll {
    . $PSScriptRoot\Day11.ps1
}

Describe 'Testdata' {
    Beforeall {
        Mock Get-Content {@(
  '  Monkey 0:'
  '  Starting items: 79, 98'
  '  Operation: new = old * 19'
  '  Test: divisible by 23'
  '    If true: throw to monkey 2'
  '    If false: throw to monkey 3'
'  '
  'Monkey 1:'
  '  Starting items: 54, 65, 75, 74'
  '  Operation: new = old + 6'
  '  Test: divisible by 19'
  '    If true: throw to monkey 2'
  '    If false: throw to monkey 0'
'  '
  'Monkey 2:'
  '  Starting items: 79, 60, 97'
  '  Operation: new = old * old'
  '  Test: divisible by 13'
  '    If true: throw to monkey 1'
  '    If false: throw to monkey 3'
'  '
  'Monkey 3:'
  '  Starting items: 74'
  '  Operation: new = old + 3'
  '  Test: divisible by 17'
  '    If true: throw to monkey 0'
  '    If false: throw to monkey 1'
        )
        }
    }
    Context 'Part 1' {
        It 'should return correct result for round 1' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 1
                Verbose   = $true
            }
            $result = Day11 @SplatDay11
            $Script:Monkeys[0].WorryLevels.Count | Should -Be 4
            $Script:Monkeys[1].WorryLevels.Count | Should -Be 6
            $Script:Monkeys[2].WorryLevels.Count | Should -Be 0
            $Script:Monkeys[3].WorryLevels.Count | Should -Be 0
        }
        It 'should return correct result for 20 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 20
                Verbose   = $true
            }
            $result = Day11 @SplatDay11
            $Script:Monkeys[0].WorryLevels.Count | Should -Be 5
            $Script:Monkeys[1].WorryLevels.Count | Should -Be 5
            $Script:Monkeys[2].WorryLevels.Count | Should -Be 0
            $Script:Monkeys[3].WorryLevels.Count | Should -Be 0

            $Script:Monkeys[0].NbInspections | Should -Be 101
            $Script:Monkeys[1].NbInspections | Should -Be 95
            $Script:Monkeys[2].NbInspections | Should -Be 7
            $Script:Monkeys[3].NbInspections | Should -Be 105

            $Result.Part1 | Should -Be 10605
        }
    }
    Context 'Part 2' {
        It 'should return correct result for 1 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 1
                Part2     = $true
                Verbose   = $true
            }
            $result = Day11 @SplatDay11

            $Script:Monkeys[0].NbInspections | Should -Be 2
            $Script:Monkeys[1].NbInspections | Should -Be 4
            $Script:Monkeys[2].NbInspections | Should -Be 3
            $Script:Monkeys[3].NbInspections | Should -Be 6
        }
        It 'should return correct result for 20 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 20
                Part2     = $true
                Verbose   = $false
            }
            $result = Day11 @SplatDay11

            $Script:Monkeys[0].NbInspections | Should -Be 99
            $Script:Monkeys[1].NbInspections | Should -Be 97
            $Script:Monkeys[2].NbInspections | Should -Be 8
            $Script:Monkeys[3].NbInspections | Should -Be 103

            $result.Part1 | Should -Be 10197
        }
        It 'should return correct result for 1000 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 1000
                Part2     = $true
                Verbose   = $false
            }
            $result = Day11 @SplatDay11

            $Script:Monkeys[0].NbInspections | Should -Be 5204
            $Script:Monkeys[1].NbInspections | Should -Be 4792
            $Script:Monkeys[2].NbInspections | Should -Be 199
            $Script:Monkeys[3].NbInspections | Should -Be 5192

            $Result.Part1 | Should -Be 2713310158
        }

    }
}
Describe 'Real data' {
    Context 'Part 1' {
        It 'should return correct result for 20 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 20
                Verbose   = $false
            }
            $result = Day11 @SplatDay11
            $Result.Part1 | Should -Be 54036
        }
    }
    Context 'Part 2' {
        It 'should return correct result for 1000 rounds' {
            $Script:Monkeys = [System.Collections.ArrayList]::new()
            $splatDay11 = @{
                InputFile = "$PSScriptRoot\inputdata.txt"
                Rounds    = 1000
                Verbose   = $false
            }
            $result = Day11 @SplatDay11
            $Result.Part2 | Should -Be 2713310158
        }
    }
}
