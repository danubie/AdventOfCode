BeforeAll {
    . $PSScriptRoot/Day07.ps1
}

Describe 'Part1' {
    It 'should find commands in a different way' {
        $commands = @(
            '$ cd /'
            '$ ls'
            'dir a'
            '14848514 b.txt'
        )
        $result = ParseTerminalOutput -Lines $commands
        $result.Count | Should -Be 4
        $result[0].Command | Should -Be 'cd'
        $result[0].Value | Should -Be '/'
        $result[1].Command | Should -Be 'ls'
        $result[1].Value | Should -BeNullOrEmpty
        $result[2].Command | Should -Be 'dir'
        $result[2].Value | Should -Be 'a'
        $result[3].Command | Should -Be 'file'
        $result[3].Value | Should -Be 'b.txt'
        $result[3].Size | Should -Be '14848514'
    }

}