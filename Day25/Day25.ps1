function ConvertFrom-Snafu {
    [CmdletBinding()]
    param (
        [string] $s
    )
    $arr = [System.Collections.ArrayList] ($s -split '')
    $arr.Remove('')
    $arr.Remove('')
    $arr.Reverse()
    $s = "0"
    for ($i = 0; $i -lt $arr.Count; $i++) {
        switch ($arr[$i]) {
            '0' { }
            '1' { $s = $s + "+1*[Math]::Pow(5,$i)" }
            '2' { $s = $s + "+2*[Math]::Pow(5,$i)" }
            '3' { $s = $s + "+3*[Math]::Pow(5,$i)" }
            '4' { $s = $s + "+4*[Math]::Pow(5,$i)" }
            '-' { $s = $s + "-[Math]::Pow(5,$i)" }
            '=' { $s = $s + "-2*[Math]::Pow(5,$i)" }
        }
    }
    Invoke-Expression -Command "[long]($s)"
}

function ConvertTo-Snafu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [long]$value
    )
    $result = ''
    $s = [string]''
    while ($value -gt 0) {
        $remainder = $value % 5
        switch ($remainder) {
            0 { $s += '0' }
            1 { $s += '1' }
            2 { $s += '2' }
            3 { $s += '=' }
            4 { $s += '-' }
        }
        $value = [long]($value / 5)
    }
    $s = ( (($s.Length-1) .. 0) | % { $s[$_] } ) -join ''
    return $s
}

function Day25 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile
    )

    $data = Get-Content -Path $InputFile
    $sum = [long]0
    foreach ($line in $data) {
        $value = ConvertFrom-Snafu -s $line
        $sum += [long]$value
    }
    ConvertTo-Snafu -value $sum
}