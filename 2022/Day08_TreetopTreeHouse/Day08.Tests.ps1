BeforeAll {
    . $PSScriptRoot/Day08.ps1
}

Describe 'Part1' {
    Context 'using sampla data' {
        BeforeAll {
            Mock Get-Content { @(
                '30373'
                '25512'
                '65332'
                '33549'
                '35390'
                )}
        }
        it 'try' {
            $matrix =  New-Object 'int[,]' 5,5
            $splat = @{
                InputFile = "$PSScriptRoot/inputdata.txt"
                Matrix    = $matrix
                Length    = 5
            }
            $ret = Day08 @Splat
            $ret.nbTrees | Should -Be 21
            $ret.MaxVisibility | Should -Be 8
        }
    }
    Context 'using real data' {
        it 'try' {
            $matrix =  New-Object 'int[,]' 99,99
            $splat = @{
                InputFile = "$PSScriptRoot/inputdata.txt"
                Matrix    = $matrix
                Length    = 99
            }
            $ret = Day08 @Splat
            $ret.NbTrees | Should -Be 1851
            $ret.maxVisibility | Should -Be 574080
        }
    }
}