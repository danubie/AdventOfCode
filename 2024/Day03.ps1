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

function Day03b {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    $s = Get-Content -Path $InputFile
    $regex = [regex]::new("((?<op>mul)\((?<x>\d+),(?<y>\d+)\))|(?<disable>don\'t())|(?<enable>do())")
    $sum = 0
    $enabled = $true
    $regex.Matches($s) | ForEach-Object {
        if ($_.Groups["enable"].Success) {
            $enabled = $true
            return
        }
        if ($_.Groups["disable"].Success) {
            $enabled = $false
            return
        }
        if ($enabled -eq $false) { return }
        $sum += [int]$_.Groups["x"].Value * [int]$_.Groups["y"].Value
    }
    $sum
}