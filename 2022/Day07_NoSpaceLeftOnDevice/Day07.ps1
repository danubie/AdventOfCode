# accept command lines
# returns tranlated form
function ParseTerminalOutput {
    param (
        [string[]]$Lines
    )
    # '\$ (?<cd>cd) (?<path>\S+)|\$ (?<ls>ls)|(?<dir>dir) (?<dirname>(\S+))|(?<size>\d+) (?<filename>\S+)'
    foreach ($line in $Lines) {

        if ($Line -match '(?<command>\$ (\S+)|dir|(\d+)) ?(?<value>.*)$') {
            $result = [PSCustomObject]@{
                Command = ''
                Value = ''
                Size = 0
            }
            switch ($Matches['command']) {
                '$ cd' {
                    $result.Command = 'cd'
                    $result.Value = $Matches['value']
                }
                '$ ls' {
                    $result.Command = 'ls'
                }
                'dir' {
                    $result.Command = 'dir'
                    $result.Value = $Matches['value']
                }
                default {
                    $result.Command = 'file'
                    $result.Value = $Matches['value']
                    $result.Size = [int]$Matches['command']
                }
            }
            $result
        } else {
            throw "Line '$Line' parsing failed"
        }
    }
}

