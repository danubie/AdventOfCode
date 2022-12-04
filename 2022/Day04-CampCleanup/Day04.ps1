function Day04 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $InputFile
    )

    $data = Get-Content -Path $InputFile
    foreach ($line in $data) {
        $pairInLine = $line -split ','
        $pair = [PSCustomObject]@{
            FullyContains = $false
            HasOverlap = $false
            Section1 = $null
            Section2 = $null
        }
        $borders = $pairInLine[0] -split '-'
        $pair.Section1 = [pscustomobject]@{ lbound = [int]$borders[0]; ubound = [int]$borders[1] }
        $borders = $pairInLine[1] -split '-'
        $pair.Section2 = [pscustomobject]@{ lbound = [int]$borders[0]; ubound = [int]$borders[1] }
        $pair.FullyContains = ($pair.Section1.lbound -le $pair.Section2.lbound) -and ($pair.Section1.ubound -ge $pair.Section2.ubound)
        $pair.FullyContains = $pair.FullyContains -or (($pair.Section2.lbound -le $pair.Section1.lbound) -and ($pair.Section2.ubound -ge $pair.Section1.ubound))
        $pair.HasOverlap = ($pair.Section1.lbound -le $pair.Section2.lbound) -and ($pair.Section1.ubound -ge $pair.Section2.lbound)
        $pair.HasOverlap = $pair.HasOverlap -or (($pair.Section2.lbound -le $pair.Section1.lbound) -and ($pair.Section2.ubound -ge $pair.Section1.lbound))
        $pair
    }
}