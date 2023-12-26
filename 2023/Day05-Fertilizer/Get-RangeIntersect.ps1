# function gets two ranges and returns the intersection of Range A compared to Range B
# the returend object has the following properties:
# Start, End, Length, RelativeStartInB, array of uncovered parts (Start, End, Length)

function Get-RangeIntersect {
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
        $end = $aEnd
        $RelativeStartInB = $start - $bStart
        if ($aStart -lt $bStart) {
            $start = $bStart
            $RelativeStartInB = 0
        }
        $length = $end - $start + 1

        if ($aEnd -gt $bEnd) {
            $end = $bEnd
            $length = $end - $start + 1
        }

        # Create objects for the uncovered parts
        $uncovered = @($null, $null)
        if ($aStart -lt $start) {
            $uncovered[0] = [PSCustomObject] @{
                Start = 1
                End = $start - 1
                Length = $start - $aStart
            }
        }
        if ($aEnd -gt $end) {
            $uncovered[1] = [PSCustomObject] @{
                Start = $end + 1
                End = $aEnd
                Length = $aEnd - $End
            }
        }

        # Create a custom object with the calculated values
        $result = [PSCustomObject] @{
            Start = $start
            End = $end
            Length = $length
            RelativeStartInB = $RelativeStartInB
            Uncovered = $uncovered
        }

        return $result
    }
}