function Get-InputData {
    [CmdletBinding()]
    param (
        [string[]] $line
    )

    begin {
        $Maps = @{}
    }

    process {
        $convertFrom = 'seed'
        foreach ($l in $line) {
            if ($l.Trim() -eq '') {
                continue
            }
            # 60 56 37 means destination start, source start, range length; use regex
            if ($l -match '^(\d+) (\d+) (\d+)') {
                # we do have a range for the current map
                $regex = [regex] '(\d+)\s+(\d+)\s+(\d+)'
                $m = $regex.Match($l)
                $destinationStart = [int64]$m.Groups[1].Value
                $sourceStart = [int64]$m.Groups[2].Value
                $rangeLength = [int64]$m.Groups[3].Value
                # add this mapping
                $Maps[$convertFrom].Map += [PSCustomObject]@{
                    DestinationStart = $destinationStart
                    SourceStart = $sourceStart
                    RangeLength = $rangeLength
                }
                Write-Verbose "Map: [$convertFrom]  $destinationStart $sourceStart $rangeLength"
                continue
            }
            if ($l -match '(\w+)-to-(\w+) map:') {
                # we get a new mapping e.g. 'seed-to-soil map:'
                $convertFrom = $Matches[1]  # seed
                $obj = [PSCustomObject]@{
                    Name = $Matches[2]     # soil
                    Map = @()
                }
                $Maps[$convertFrom] = $obj
                Write-Verbose "Map: convert $convertFrom to $($obj.Name)"
                continue
            }
            if ($l -match 'seeds:') {
                # this only should be in the first line
                $regex = [regex] '(?=\s+(\d+))'
                $m = $regex.Matches($l)
                $seeds = $m | ForEach-Object { $_.Groups[1].Value }
                Write-Verbose "Seeds: count=$($seeds.Count)"
            }
        }
    }

    end {
        $seeds, $Maps
    }
}

function Get-Result {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int64[]] $seeds,
        [Parameter(Mandatory = $true)]
        [hashtable] $Maps
    )
    foreach ($seed in $seeds) {
        $nextHop = 'seed'
        $result = $seed
        $searchFor = $seed
        do {
            $map = $Maps[$nextHop]
            $nextHop = $map.Name
            foreach ($m in $map.Map) {
                if ($searchFor -ge $m.SourceStart -and $searchFor -lt ($m.SourceStart + $m.RangeLength)) {
                    $result = $m.DestinationStart + ($searchFor - $m.SourceStart)
                    $searchFor = $result
                    break
                }
            }
            if ($null -eq $result) {
                # if we don't find a mapping, than take it as 1:1 mapping
                $searchFor = $seed
            }
            # Write-Host "$nextHop $result"
        } while ($nextHop -ne 'location')
        $result
    }
}

function Day05 {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $InputFile = "$PSScriptRoot/Input.txt"
    )

    begin {

    }

    process {
        $rawData = Get-Content $InputFile
        $seeds, $Maps = Get-InputData -line $rawData # -Verbose
        $result = Get-Result -seeds $seeds -Maps $Maps
        $result | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    }

    end {

    }
}