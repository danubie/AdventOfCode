# Day
$PesterPreference = New-PesterConfiguration
$PesterPreference.Output.Verbosity = 'Detailed'
BeforeAll {
    . $PSScriptRoot\Get-RangeIntersect.ps1
}

Describe 'Testdata' {
    BeforeAll {
        Mock Get-Content {@(

        )
        }
    }
    it 'should find no overlap' {
        $result = Get-RangeIntersect -aStart 1 -aEnd 2 -bStart 4 -bEnd 5
        $result | Should -Be $null
    }
    it 'should find no overlap 2' {
        $result = Get-RangeIntersect -aStart 4 -aEnd 5 -bStart 1 -bEnd 2
        $result | Should -Be $null
    }
    it 'should find overlap 1' {
        $result = Get-RangeIntersect -aStart 1 -aEnd 5 -bStart 4 -bEnd 6
        $result.Start           | Should -Be 4
        $result.End             | Should -Be 5
        $result.Length          | Should -Be 2
        $result.RelativeStartInB  | Should -Be 0
        # test the uncovered parts
        $result.Uncovered | Should -HaveCount 2
        $result.Uncovered[0].Start  | Should -Be 1
        $result.Uncovered[0].End    | Should -Be 3
        $result.Uncovered[0].Length | Should -Be 3
        $result.Uncovered[1].Start  | Should -Be $null
    }
    it 'should find overlap 2' {
        $result = Get-RangeIntersect -aStart 4 -aEnd 6 -bStart 1 -bEnd 5
        $result.Start           | Should -Be 4
        $result.End             | Should -Be 5
        $result.Length          | Should -Be 2
        $result.RelativeStartInB  | Should -Be 3
        # test the uncovered parts
        $result.Uncovered | Should -HaveCount 2
        $result.Uncovered[0]        | Should -Be $null
        $result.Uncovered[1].Start  | Should -Be 6
        $result.Uncovered[1].End    | Should -Be 6
        $result.Uncovered[1].Length | Should -Be 1
    }
    it 'should find overlap 3' {
        $result = Get-RangeIntersect -aStart 1 -aEnd 5 -bStart 4 -bEnd 5
        $result.Start           | Should -Be 4
        $result.End             | Should -Be 5
        $result.Length          | Should -Be 2
        $result.RelativeStartInB  | Should -Be 0
        # test the uncovered parts
        $result.Uncovered | Should -HaveCount 2
        $result.Uncovered[0].Start  | Should -Be 1
        $result.Uncovered[0].End    | Should -Be 3
        $result.Uncovered[0].Length | Should -Be 3
        $result.Uncovered[1].Start  | Should -Be $null
    }
    it 'should find overlap 4' {
        $result = Get-RangeIntersect -aStart 4 -aEnd 5 -bStart 1 -bEnd 5
        $result.Start           | Should -Be 4
        $result.End             | Should -Be 5
        $result.Length          | Should -Be 2
        $result.RelativeStartInB  | Should -Be 3
        # test the uncovered parts
        $result.Uncovered | Should -HaveCount 2
        $result.Uncovered[0]    | Should -Be $null
        $result.Uncovered[1]    | Should -Be $null
    }
    it 'should find overlap 5' {
        $result = Get-RangeIntersect -aStart 1 -aEnd 5 -bStart 2 -bEnd 4
        $result.Start           | Should -Be 2
        $result.End             | Should -Be 4
        $result.Length          | Should -Be 3
        $result.RelativeStartInB  | Should -Be 0
        # test the uncovered parts
        $result.Uncovered | Should -HaveCount 2
        $result.Uncovered[0].Start  | Should -Be 1
        $result.Uncovered[0].End    | Should -Be 1
        $result.Uncovered[0].Length | Should -Be 1
        $result.Uncovered[1].Start  | Should -Be 5
        $result.Uncovered[1].End    | Should -Be 5
        $result.Uncovered[1].Length | Should -Be 1
    }
}

