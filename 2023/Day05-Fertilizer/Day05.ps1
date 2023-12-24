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
                    DestinationEnd = $destinationStart + $rangeLength - 1
                    SourceStart = $sourceStart
                    SourceEnd = $sourceStart + $rangeLength - 1
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
                $seeds = $m | ForEach-Object {
                    [PSCustomObject]@{
                        SeedStart = [int64]$_.Groups[1].Value
                        SeedEnd = [int64]$_.Groups[1].Value
                        SeedLength = 1
                    }
                }
                Write-Verbose "Seeds: count=$($seeds.Count)"
            }
        }
    }

    end {
        $seeds, $Maps
    }
}

function GetIntersect {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int64] $aStart,
        [Parameter(Mandatory = $true)]
        [int64] $aEnd,
        [Parameter(Mandatory = $true)]
        [int64] $bStart,
        [Parameter(Mandatory = $true)]
        [int64] $bEnd
    )

    begin {}

    process {
        if ($aStart -gt $bEnd -or $aEnd -lt $bStart) {
            # no intersection
            return $null
        }
        $start = $aStart
        if ($aStart -lt $bStart) {
            $start = $bStart
        }
        $end = $aEnd
        if ($aEnd -gt $bEnd) {
            $end = $bEnd
        }
        $length = $end - $start + 1
        $relativeStart = $start - $aStart
        $relativeEnd = $aEnd - $end

        # Create a custom object with the calculated values
        $result = New-Object PSObject -Property @{
            Start = $start
            End = $end
            Length = $length
            RelativeStart = $relativeStart
            RelativeEnd = $relativeEnd
        }

        return $result
    }
}

function Get-Result {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject[]] $seeds,
        [Parameter(Mandatory = $true)]
        [hashtable] $Maps
    )
    foreach ($seed in $seeds) {
        $nextHop = 'seed'
        $searchFor = [PSCustomObject]@{
            Start = $seed.SeedStart
            End = $seed.SeedEnd
            Length = $seed.SeedLength
        }
        $result = $null
        do {
            $map = $Maps[$nextHop]
            $nextHop = $map.Name
            foreach ($m in $map.Map) {
                $inter = GetIntersect -aStart $m.SourceStart -aEnd $m.SourceEnd -bStart $searchFor.Start -bEnd $searchFor.End
                if ($null -eq $inter) {
                    continue
                }
                $searchFor = [PSCustomObject]@{
                    Start = $m.DestinationStart + $inter.RelativeStart
                    End = $m.DestinationStart + $inter.RelativeStart + $inter.Length - 1
                    Length = $inter.Length
                }
                $result = $searchFor
                break
                # if ($searchFor -ge $m.SourceStart -and $searchFor -lt ($m.SourceStart + $m.RangeLength)) {
                #     $result = $m.Desti  nationStart + ($searchFor - $m.SourceStart)
                #     $searchFor = $result
                #     break
                # }
            }
            if ($null -eq $result) {
                # if we don't find a mapping, than take it as 1:1 mapping
                $searchFor = [PSCustomObject]@{
                    Start = $searchFor.Start
                    End = $searchFor.End
                    Length = $searchFor.Length
                }
                $result = $searchFor
            }
            # Write-Host "$nextHop $($result.Start); " -NoNewline         # $($result.SeedStart) $($result.SeedEnd)"
        } while ($nextHop -ne 'location')
        # Write-Host ''
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
        $result.Start | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    }

    end {

    }
}