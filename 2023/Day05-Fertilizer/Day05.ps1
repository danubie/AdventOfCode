. "$PSScriptRoot/Get-RangeIntersect.ps1"
function Get-InputData {
    [CmdletBinding()]
    param (
        [string[]] $line,
        [switch] $Part2
    )

    begin {
        $Maps = @{}
    }

    process {
        $convertFrom = 'seed'
        $categoryName = 'seed'

        # seeds are in the first line
        if (!$Part2) {
            $regex = [regex] '(?=\s+(\d+))'
            $m = $regex.Matches($line[0])
            $seeds = $m | ForEach-Object {
                [PSCustomObject]@{
                    SourceStart = [int64]$_.Groups[1].Value
                    SourceEnd = [int64]$_.Groups[1].Value
                    DestinationStart = [int64]$_.Groups[1].Value
                    DestinationEnd = [int64]$_.Groups[1].Value
                    Length = 1
                }
            }
        } else {
            # part 2 has a different format: it are pairs of numbers (start, count)
            $regex = [regex] '\s*(?<Start>\d+)\s+(?<Count>\d+)'
            $m = $regex.Matches($line[0])
            $seeds = $m | ForEach-Object {
                [PSCustomObject]@{
                    SourceStart = [int64]$_.Groups[1].Value
                    SourceEnd = [int64]$_.Groups[1].Value + [int64]$_.Groups[2].Value - 1
                    DestinationStart = [int64]$_.Groups[1].Value
                    DestinationEnd = [int64]$_.Groups[1].Value + [int64]$_.Groups[2].Value - 1
                    Length = [int64]$_.Groups[2].Value
                }
            }
        }
        $mapFrom = [array]$seeds.PsObject.Copy()
        $mapTo = [array]$seeds.PsObject.Copy()
        foreach ($l in $line) {
            # 60 56 37 means destination start, source start, range length; use regex
            if ($l -match '^(\d+) (\d+) (\d+)') {
                # we do have a range for the current map
                $regex = [regex] '(\d+)\s+(\d+)\s+(\d+)'
                $m = $regex.Match($l)
                $destinationStart = [int64]$m.Groups[1].Value
                $sourceStart = [int64]$m.Groups[2].Value
                $rangeLength = [int64]$m.Groups[3].Value
                # add this mapping
                $mapTo += [PSCustomObject]@{
                    SourceStart = $sourceStart
                    SourceEnd = $sourceStart + $rangeLength - 1
                    DestinationStart = $destinationStart
                    DestinationEnd = $destinationStart + $rangeLength - 1
                    Length = $rangeLength
                }
                Write-Verbose "Map: [$convertFrom to $categoryName]  $($mapTo[-1])"
                continue
            }
            if ($l -match '(\w+)-to-(\w+) map:') {
                $categoryName = $Matches[2]
                $result = $intersecMaps | Sort-Object -Property Start
                $mapTo = @()
                Write-Verbose "Starting map to $categoryName"
                continue
            }
            if ($l -match '^$') {
                # we get an empty line, so now it's time to build the intersecMaps
                # first look, if there are consecutive ranges in the mapTo
                # $mapTo = Get-AllRangesConnected -Ranges $mapTo -PropertyStart 'SourceStart' -PropertyEnd 'SourceEnd'
                #
                $intersecMaps = @()
                foreach ($from in $mapFrom) {
                    $interSects = foreach ($to in $mapTo) {
                        $inter = Get-RangeIntersect -aStart $from.SourceStart -aEnd $from.SourceEnd -bStart $to.SourceStart -bEnd $to.SourceEnd
                        if ($null -ne $inter) {
                            [PSCustomObject]@{
                                SourceStart = $inter.Start
                                SourceEnd = $inter.End
                                DestinationStart = $to.DestinationStart + $inter.RelativeStartInB
                                DestinationEnd = $to.DestinationStart + $inter.RelativeStartInB + $inter.Length - 1
                                Length = $inter.Length
                            }
                            foreach ($u in $inter.Uncovered) {
                                if ($null -eq $u) { continue }
                                $mapFrom += [PSCustomObject]@{
                                    SourceStart = $u.Start
                                    SourceEnd = $u.End
                                    DestinationStart = $u.Start
                                    DestinationEnd = $u.End
                                    Length = $u.Length
                                }
                            }
                            break
                        }
                    } # loop MapTo
                    # $intersecMaps += @($interSects).GetEnumerator()
                    $intersecMaps += foreach ($i in $interSects) {
                        $i              # return it
                    }
                    if (!$interSects) {
                        # if we don't find an intersection, than take it as 1:1 mapping
                        $intersecMaps += [PSCustomObject]@{
                            SourceStart = $from.SourceStart
                            SourceEnd = $from.SourceEnd
                            DestinationStart = $from.SourceStart
                            DestinationEnd = $from.SourceEnd
                            Length = $from.Length
                        }
                    }
                }   # loop MapFrom
                    # # loop through all the intersections and find overlapping ranges. If there is an overlap, the range is the sum of the overlapping ranges
                    # # if there is no overlap, then use the 1:1 mapping
                    # $intersecMaps = $intersecMaps | Sort-Object -Property SourceStart
                    # $result = @()
                    # $start = $intersecMaps[0].SourceStart
                    # $end = $intersecMaps[0].SourceEnd
                    # $length = $intersecMaps[0].Length
                    # for ($i = 1; $i -lt $intersecMaps.Length; $i++) {
                    #     if ($intersecMaps[$i].SourceStart -le $end) {
                    #         # there is an overlap
                    #         if ($intersecMaps[$i].SourceEnd -gt $end) {
                    #             $end = $intersecMaps[$i].SourceEnd
                    #         }
                    #         $length = $end - $start + 1
                    #     } else {
                    #         # no overlap
                    #         $result += [PSCustomObject]@{
                    #             SourceStart = $start
                    #             SourceEnd = $end
                    #             Length = $length
                    #         }
                    #         $start = $intersecMaps[$i].SourceStart
                    #         $end = $intersecMaps[$i].SourceEnd
                    #         $length = $intersecMaps[$i].Length
                    #     }
                    # }
                    # # if the last range is not yet added, then add it
                    # if ($result[-1].end -ne $intersecMaps[-1].SourceEnd) {
                    #     $result += [PSCustomObject]@{
                    #         SourceStart = $intersecMaps[-1].SourceStart
                    #         SourceEnd = $intersecMaps[-1].SourceEnd
                    #         Length = $intersecMaps[-1].SourceEnd - $intersecMaps[-1].SourceStart + 1
                    #     }
                    # }
                    # $mapFrom = $result
                $result = $mapFrom = foreach ($i in $intersecMaps) {
                    [PSCustomObject]@{
                        SourceStart = $i.DestinationStart
                        SourceEnd = $i.DestinationEnd
                        Length = $i.Length
                    }
                }
                # Write-Verbose "Map: [$convertFrom to $categoryName]  new map from $($mapFrom.Length) ranges"
                $mapFrom.ForEach({ Write-Verbose "New mappings: [$convertFrom to $categoryName]  $_" })
            }
        }
    }


    end {
        $seeds, $result
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
        [string] $InputFile = "$PSScriptRoot/Input.txt",
        [switch] $Part2 = $false
    )

    begin {

    }

    process {
        $rawData = Get-Content $InputFile
        # $seeds, $Maps = Get-InputData -line $rawData # -Verbose
        # $result = Get-Result -seeds $seeds -Maps $Maps
        $seeds, $result = Get-InputData -line $rawData -Part2:$Part2 # -Verbose
        $result.DestinationStart | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    }

    end {

    }
}