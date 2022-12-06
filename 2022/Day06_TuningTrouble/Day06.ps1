function Find-StartMarker {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$stream,
        [int] $MarkerLength = 4
    )
    foreach ($line in $stream) {
        for ($i = 0; $i -lt ($line.Length-$MarkerLength); $i++) {
            $packOf4 = $line.Substring($i, $MarkerLength)
            $splitted = $packOf4 -split ''
            $count = $splitted | Select-Object -Unique | Measure-Object | Select-Object -ExpandProperty Count
            if ($count -eq ($MarkerLength + 1)) {
                # 5 because -split ''' inserts an empty string at the beginning
                return $i + $MarkerLength
            }
        }
    }
}


function Day06 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot\inputdata.txt",
        [switch] $Part2
    )

    $s = Get-Content $InputFile
    if ($Part2) {
        Find-StartMarker $s -MarkerLength 14
    } else {
        Find-StartMarker $s
    }
}