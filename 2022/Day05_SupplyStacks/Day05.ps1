function CreateStacks {
    [CmdletBinding()]
    param (
        [string[]] $stackData
    )
    # the last element contains the number of stacks
    $nbStacks = ($stackData[-1] -split ' ')
    | Where-Object { $_ -ne '' }
    | Sort-Object -Descending
    | Select-Object -First 1

    # create the stacks
    $stacks = [System.Collections.ArrayList]::new()
    for ($i = 0; $i -lt $nbStacks; $i++) {
        $null = $stacks.Add([System.Collections.Stack]::new())
    }

    # now fill stacks from last to first
    # we have to extract the characters
    # starting with index1 every 4 characters

    for ($i = $stackData.Count - 2; $i -ge 0; $i-- ) {
        $line = $stackData[$i].PadRight(4*$nbStacks)     # so we don't have to care of shorter strings
        for ($j = 0; $j -lt $nbStacks; $j++) {
            $crateLetter = $line[1 + $j*4]
            if (' ' -ne $crateLetter) {
                $stacks[$j].Push($crateLetter)
            }
        }
    }

    $stacks
}

function Split-CratesFromMovement {
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string[]] $data
    )
    $doStackdata = $true
    $stackData = @()
    $movementData = @()
    foreach ($line in $data) {
        if ('' -eq $line.Trim()) {
            $doStackdata = $false
            continue
        }
        if ($doStackdata) {
            $stackData += $line
        } else {
            $movementData += $line
        }
    }
    $stackData, $movementData
}

function DoMovements {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.Stack[]] $stacks,
        [string[]] $movementDefs,
        [switch] $IsCrateMover9001
    )

    # I like to move it, move it. I like to move it, move it :-)
    foreach ($line in $movementDefs) {
        $number, $from, $to = $line -replace '\D+(\d+)\D+(\d+)\D+(\d+)','$1,$2,$3' -split ','
        Write-Verbose "should be moving $number from $from to $to"

        if ($IsCrateMover9001) {
            # this time we move $number elements in "one block"
            # by popping them into a temporary stack
            # and then pushing them back in the destination stack
            $tempStack = [System.Collections.Stack]::new()
            for ($i = 0; $i -lt $number; $i++) {
                $item = $stacks[$from-1].pop()
                $tempStack.Push($item)
            }
            for ($i = 0; $i -lt $number; $i++) {
                $item = $tempStack.pop()
                $stacks[$to-1].push($item)
            }

        } else {
            for ($i = 0; $i -lt $number; $i++) {
                $item = $stacks[$from-1].pop()
                $stacks[$to-1].push($item)
            }
        }
    }
}

function GetResultPart1 {
    param (
        [System.Collections.Stack[]] $stacks
    )

    $result = ''
    foreach ($stack in $stacks) {
        $result += $stack.Peek()
    }
    $result
}

function Day05 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $InputFile,
        [switch] $IsCrateMover9001
    )

    $stackData = Get-Content $InputFile

    $cratesDef, $movementsDef = Split-CratesFromMovement $stackData

    $stacks = CreateStacks $cratesDef
    DoMovements $stacks $movementsDef -IsCrateMover9001:$IsCrateMover9001
    GetResultPart1 $stacks
}