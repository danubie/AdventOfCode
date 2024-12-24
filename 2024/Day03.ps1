function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    $s = Get-Content -Path $InputFile
    $regex = [regex]::new('mul\((\d+),(\d+)\)')
    $sum = 0
    $regex.Matches($s) | ForEach-Object {
        $sum += [int]$_.Groups[1].Value * [int]$_.Groups[2].Value
    }
    $sum
}