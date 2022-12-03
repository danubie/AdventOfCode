# if $Item is found in $ItemList returns
#   Item, SValue
function Find-Item {
    [CmdletBinding()]
    param (
        [string] $Item,
        [string] $ItemList
    )

    if ($ItemList -match $Item) {
        $Item, $SValue = $Matches[1], $Matches[2]
        return $Item, $SValue
    }

}

function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )

    $data = Get-Content -Path $InputFile
    $sum = 0
    foreach ($line in $data) {
        # cut the rucksack into it's 2 compartments
        $comp1 = $line.Substring(0, $line.Length/2)
        $comp2 = $line.Substring($line.Length/2, $line.Length/2)
        # find each item (=character) of comp1 in comp2
        $ItemsToFind = $comp1 -split '' | Select-Object -Unique | Where-Object { $_ -ne '' }
        foreach ($c in $ItemsToFind) {
            # if ($c -eq '') { continue }         # skip empty char at top of the list
            if ($comp2 -cmatch $c) {
                if ([byte][char] $c -gt [byte][char]'a' ) {
                    $value = [byte][char]$c - [byte][char]'a' + 1
                } else {
                    $value = [byte][char]$c -[byte][char]'A' + 27
                }
                $sum += $value
                Write-Verbose "Found $c with value $value in $comp2 => sum = $sum"
            }
        }
    }
    $sum
}