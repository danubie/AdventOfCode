function Write-Host {}
function SelectDiagonalLeftToRight  {
    [CmdletBinding()]
    param (
        [string[]] $arrString,
        $StartColumn = 0,
        $EndColumn = $arrString[0].Length-1,
        [switch] $WalkDown = $true
    )
    for ($i = $StartColumn; $i -le $EndColumn; $i++) {
        $s = ""
        $j = 0
        while ($j -lt $arrString.Length) {
            $s += $arrString[$j][$i+$j]
            $j++
        }
        $s
    }
    if ($WalkDown) {
        # now walk the left border down
        for ($i = 1; $i -le $arrString.Length-1; $i++) {
            $s = ""
            $j = 0
            while ($j -lt $arrString.Length-$i) {
                $s += $arrString[$j+$i][$j]
                $j++
            }
            $s
        }
    }
}
function SelectDiagonalRightToLeft {
    [CmdletBinding()]
    param (
        [string[]] $arrString,
        $StartColumn = 0,
        $EndColumn = $arrString[0].Length-1,
        [switch] $WalkDown = $true
    )
    for ($i = $StartColumn; $i -le $EndColumn; $i++) {
        $s = ""
        $j = 0
        # while ($j -ge $i) {           # would allow wrap around the left border
        #     $s += $arrString[$j][$i-$j]
        #     $j++
        # }
        while ($i-$j -ge 0 -and  $j -le $arrString.Length-1) {
            $s += $arrString[$j][$i-$j]
            $j++
        }
        $s
    }
    if ($WalkDown) {
        # now walk the right border down
        for ($i = 1; $i -le $arrString.Length-1; $i++) {
            $s = ""
            $j = 0
            while ($i+$j -le $arrString.Length-1) {
                $s += $arrString[$j+$i][$arrString[0].Length-1-$j]
                $j++
            }
            $s
        }
    }
}
function InspectString {
    [CmdletBinding()]
    param (
        [string] $s
    )
    # we have to look for the strings XMAS in any combination
    # but this has to be done for each starting letter in the string
    # because IMHO XXMAS ist valid 2 times X.MAS and .XMAS
    # and the some backards

    $cnt = 0
    $indexX = 0
    do {
        $indexX = $s.IndexOf("XMAS", $indexX)
        if ($indexX -eq -1) { break }
        if ($false) {
                            # debug output
                            $debugString = ("."*$s.Length) #.ToCharArray()
                            $debugString = $debugString.Remove($indexX, 4).Insert($indexX, "XMAS")
                            $debugString += " " + $s
                            Write-Host $debugString -ForegroundColor Cyan
        }
        $cnt++
        $indexX++
    } until ($indexX -lt 0 -or $indexX -ge $s.Length-3)
    $cnt
}
function InspectStringAndReversed {
    [CmdletBinding()]
    param (
        [string] $s
    )
    Write-Host ($s + " inspecting") -ForegroundColor Magenta
    $ret = 0
    $ret = InspectString -s $s
    $revs = $s[-1..-$s.Length] -join ''
    Write-Host ($revs + " reversed") -ForegroundColor Magenta
    $ret += InspectString -s $revs
    $ret
}
function Day04B {
    [CmdletBinding()]
    param (
        [string[]] $thisArray
    )
    # we have to look for the strings XMAS in any combination
    # but this has to be done for each starting letter in the string
    # because IMHO XXMAS ist valid 2 times X.MAS and .XMAS
    # and the some backards

    $cnt = 0
    for ($line = 1; $line -le $thisArray.Count-2; $line++) {
        $col = 1
        while ($col -le $thisArray[$line].Length-2) {
            # check for MAS left above to right below forward and backward
            $col = $thisArray[$line].IndexOf("A", $col)
            if ($col -eq -1) { break }
            $found = $thisArray[$line-1][$col-1] -eq "M" -and $thisArray[$line][$col] -eq "A" -and $thisArray[$line+1][$col+1] -eq "S"
            if (!$found) {
                $found = $thisArray[$line-1][$col-1] -eq "S" -and $thisArray[$line][$col] -eq "A" -and $thisArray[$line+1][$col+1] -eq "M"
            }
            if (!$found) {
                $col++
                continue
            }
            # now we found at least a MAS from left above to right below; now check MAS from right above to left below
            $found = $thisArray[$line-1][$col+1] -eq "M" -and $thisArray[$line][$col] -eq "A" -and $thisArray[$line+1][$col-1] -eq "S"
            if (!$found) {
                $found = $thisArray[$line-1][$col+1] -eq "S" -and $thisArray[$line][$col] -eq "A" -and $thisArray[$line+1][$col-1] -eq "M"
            }
            if ($found) {
                $cnt++
                Write-Host ("Found XMAS at {1},{2}" -f $thisArray[$line], $line, $col) -ForegroundColor Green
            }
            $col++
        }
    }
    $cnt
}
function Day04 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $InputFile,
        [switch] $Part2
    )
    $arrString = Get-Content -Path $InputFile
    if ($Part2) {
        Day04B -thisArray $arrString
        return
    }
    #region Part 1 direct and reversed by line
    # we have to search for XMAS in any combination
    Write-Host "Part 1" -ForegroundColor Yellow
    $cnt = 0
    foreach ($s in $arrString) {
        $ret = InspectStringAndReversed -s $s
        $cnt += $ret
        Write-Host ("Found {0} XMAS in {1}" -f $ret, $s ) -ForegroundColor Green
    }
    Write-Host "Part 1 $cnt XMAS in total" -ForegroundColor Red
    #endregion
    #region Part 2 by column
    Write-Host "Part 2" -ForegroundColor Yellow
    # build a string array combining each nth letter of the strings
    $thisArray = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $arrString[0].Length; $i++) {
        $s = ""
        for ($j = 0; $j -lt $arrString.Length; $j++) {
            $s += $arrString[$j][$i]
        }
        [void] $thisArray.Add($s)
    }
    foreach ($s in $thisArray) {
        $ret = InspectStringAndReversed -s $s
        $cnt += $ret
        Write-Host ("Found {0} XMAS in {1}" -f $ret, $s ) -ForegroundColor Green
    }
    Write-Host "Part 2 $cnt XMAS in total" -ForegroundColor Red
    #endregion
    #region Part 3 by diagonal from top left to bottom right
    Write-Host "Part 3" -ForegroundColor Yellow
    $thisArray = SelectDiagonalLeftToRight -arrString $arrString
    foreach ($s in $thisArray) {
        $ret = InspectStringAndReversed -s $s
        $cnt += $ret
        Write-Host ("Found {0} XMAS in {1}" -f $ret, $s ) -ForegroundColor Green
    }
    Write-Host "Part 3 $cnt XMAS in total" -ForegroundColor Red
    #endregion
    #region Part 4 by diagonal from top right to bottom left
    Write-Host "Part 4" -ForegroundColor Yellow
    $thisArray = SelectDiagonalRightToLeft -arrString $arrString
    foreach ($s in $thisArray) {
        $ret = InspectStringAndReversed -s $s
        $cnt += $ret
        Write-Host ("Found {0} XMAS in {1}" -f $ret, $s ) -ForegroundColor Green
    }
    Write-Host "Part 4 $cnt XMAS in total" -ForegroundColor Red
    #endregion

    $cnt
}