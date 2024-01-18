function Get-InputData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-Content $InputFile
    $direction = ($InputData[0]).ReplaceLineEndings('')
    # now get the 'network'
    $InputData = $InputData[2..($InputData.Length-1)]
    $network = @{}
    foreach ($line in $InputData) {
        # format is: AAA = (BBB, CCC)   means node AAA has children BBB and CCC
        if ($line -match '^(?<Node>\w+)\s*=\s*\((?<Left>\w+),\s*(?<Right>\w+)\)') {
            $network.Add($Matches['Node'],
                [PSCustomObject]@{
                    L = $Matches['Left']
                    R = $Matches['Right']
                }
            )
        }
    }
    [PSCustomObject]@{
        Direction = $direction
        Network = $network
    }
}

function WalkNetwork {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Network,
        [Parameter(Mandatory = $true)]
        [string]$Direction
    )

    begin {

    }

    process {
        $finished = $false
        $currentNode = 'AAA'
        $distance = 0
        $indexDirection = 0
        while (-not $finished) {
            $whichChild = $Direction[$indexDirection]
            $nextNode = $Network[$currentNode].$whichChild
            $distance++
            $currentNode = $nextNode
            $indexDirection = ($indexDirection + 1) % $Direction.Length
            if ($currentNode -eq 'ZZZ') {
                $finished = $true
            }
        }
        $distance
    }

    end {

    }
}

function WalkNetworkPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Network,
        [Parameter(Mandatory = $true)]
        [string]$Direction
    )

    begin {
        # build an hashtable of objects key is nodename (starting with 'A') and value is current node
        $nodes = @{}
        foreach ($nodeName in $Network.Keys) {
            if ($nodeName -notmatch 'A$') {
                continue
            }
            $nodes.Add($nodeName,
                [PSCustomObject]@{
                    CurrentNode = $nodeName
                }
            )
        }
    }

    process {
        Throw "Brute force solution, takes too long"
        $finished = $false
        $distance = 0
        $indexDirection = 0
        while (-not $finished) {
            $nodes.Keys | ForEach-Object {
                $thisNode = $_
                $currentNode = $nodes[$thisNode].CurrentNode
                $whichChild = $Direction[$indexDirection]
                $nextNode = $Network[$currentNode].$whichChild
                $nodes[$thisNode].CurrentNode = $nextNode
            }
            $distance++
            $indexDirection = ($indexDirection + 1) % $Direction.Length
            # we are finished if all nodes end with 'Z'
            # e.g. continue if at least one node does not end with 'Z'
            $finished = $true
            $nodes.Keys | ForEach-Object {
                $thisNode = $_
                $currentNode = $nodes[$thisNode].CurrentNode
                if ($currentNode -notmatch 'Z$') {
                    $finished = $false
                }
            }
        }
        $distance
    }

    end {

    }
}
function Day08 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [switch]$Part2
    )
    $InputData = Get-InputData -InputFile $InputFile -Part2:$Part2
    if ($Part2) {
        $result = WalkNetworkPart2 -Network $InputData.Network -Direction $InputData.Direction
    }
    else {
        $result = WalkNetwork -Network $InputData.Network -Direction $InputData.Direction
    }
    $result
}
