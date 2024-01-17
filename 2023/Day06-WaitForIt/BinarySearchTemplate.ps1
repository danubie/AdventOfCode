function BinarySearchTemplate1 {
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$Data,
        [Parameter(Mandatory = $true)]
        [int]$Target
    )

    $left = 0           # first element
    $right = $Data.Length - 1   # last element

    # -le might be better than -lt
    # it can be replaced by a function which returns "found", "left", "right"
    while ($left -le $right) {
        $mid = [math]::Floor(($left + $right) / 2)

        if ($Data[$mid] -eq $Target) {
            return $mid
        }
        elseif ($Data[$mid] -lt $Target) {
            $left = $mid + 1
        }
        else {
            $right = $mid - 1
        }
    }

    return -1
}

function BinarySearchTemplate2 {
    [CmdletBinding()]
    param (
        [int] $LowBoundary,
        [int] $HighBoundary,
        [Object] $Context,
        [scriptblock] $Test     # $test takes a number and 0 for found, -1 for too low, 1 for too high
    )

    begin {

    }

    process {
        $left = $LowBoundary
        $right = $HighBoundary
        while ($left -le $right) {
            $mid = [math]::Floor(($left + $right) / 2)
            $result = & $Test $mid $Context
            if ($result -eq 0) {
                return $mid
            }
            elseif ($result -eq -1) {
                $left = $mid + 1
            }
            else {
                $right = $mid - 1
            }
        }
        $left
    }

    end {

    }
}