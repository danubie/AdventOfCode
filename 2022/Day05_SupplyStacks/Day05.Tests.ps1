BeforeAll {
    . $PSScriptRoot\Day05.ps1

    $exampleData = @(
        '    [D]     '
        '[N] [C]     '
        '[Z] [M] [P] '
        ' 1   2   3 '
        ''
        'move 1 from 2 to 1'
        'move 3 from 1 to 3'
        'move 2 from 2 to 1'
        'move 1 from 1 to 2'
    )
}

Describe 'Part 1' {
    It 'should create stacks' {
        $cratesDef, $movementsDef = Split-CratesFromMovement $exampleData

        $stacks = CreateStacks $cratesDef

        $stacks.Count | Should -Be 3
        $stacks[0].Count | Should -Be 2
        $stacks[1].Count | Should -Be 3
        $stacks[2].Count | Should -Be 1
    }
    It 'should move it' {
        $cratesDef, $movementsDef = Split-CratesFromMovement $exampleData

        $stacks = CreateStacks $cratesDef
        DoMovements $stacks $movementsDef
        $result = GetResultPart1 $stacks
        $result | Should -Be 'CMZ'
    }
    It 'using real data' {

        $result = Day05 -InputFile $PSScriptRoot\inputData.txt
        $result | Should -Be 'GRTSWNJHH'
    }
}

Describe 'Part 2' {
    It 'using example data' {
        $cratesDef, $movementsDef = Split-CratesFromMovement $exampleData

        $stacks = CreateStacks $cratesDef
        DoMovements $stacks $movementsDef -IsCrateMover9001
        $result = GetResultPart1 $stacks
        $result | Should -Be 'MCD'
    }
    It 'using real data' {
        $result = Day05 -InputFile $PSScriptRoot\inputData.txt -IsCrateMover9001
        $result | Should -Be 'QLFQDBBHM'
    }
}