function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    $s = Get-Content -Path $InputFile
    $regex = [regex]::new('(?<op>mul)\((?<x>\d+),(?<y>\d+)\)')
    $sum = 0
    $regex.Matches($s) | ForEach-Object {
        $sum += [int]$_.Groups["x"].Value * [int]$_.Groups["y"].Value
    }
    $sum
}