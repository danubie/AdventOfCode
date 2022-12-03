# if $Item is found in any of the strings in $ItemLists returns
#   Item, SValue
function Get-ItemValue {
    [CmdletBinding()]
    param (
        [string[]] $ItemsToFind,
        [string[]] $ItemLists
    )

    $sum = 0
    foreach ($c in $ItemsToFind) {
        $foundInAll = $true
        foreach ($list in $ItemLists) {
            $foundInAll = $foundInAll -and ($list -cmatch $c)
        }
        if (-Not $foundInAll) {
            continue
        }
        # if ($c -eq '') { continue }         # skip empty char at top of the list
        if ([byte][char] $c -gt [byte][char]'a' ) {
            $value = [byte][char]$c - [byte][char]'a' + 1
        } else {
            $value = [byte][char]$c -[byte][char]'A' + 27
        }
        $sum += $value
        Write-Verbose "Foundx $c with value $value in $comp2 => sum = $sum"
    }
    $sum
}

function Day03 {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )

    $data = Get-Content -Path $InputFile
    $sum = 0
    $sum2 = 0
    foreach ($line in $data) {
        # cut the rucksack into it's 2 compartments
        $comp1 = $line.Substring(0, $line.Length/2)
        $comp2 = $line.Substring($line.Length/2, $line.Length/2)

        # find each item (=character) of comp1 in comp2
        $ItemsToFind = $comp1 -split '' | Select-Object -Unique | Where-Object { $_ -ne '' }
        $value2 = Get-ItemValue -ItemsToFind $ItemsToFind -ItemLists $comp2
        if ($value2 -ne 0) {
            Write-Verbose "Found2 $ItemsToFind with value $value2 in $comp2 => sum = $sum2"
        }

        $sum2 += $value2
    }
    $sum2
}