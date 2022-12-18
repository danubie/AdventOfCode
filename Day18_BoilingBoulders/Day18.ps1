function Read-CubeList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InputFile
    )
    begin {
        $script:cubeList = @()
        $script:squareList = @{}
    }
    process {
        foreach ($line in Get-Content -Path $InputFile) {
            Write-Verbose "Line: $line"
            $x, $y, $z = [int[]]$line.Split(',')
            $cubePosition = [pscustomobject]@{
                X = $x
                Y = $y
                Z = $z
            }
            $script:cubeList += $cubePosition
            # mark left lower corner of a cubes surface
            $square = "$($x   ),$($y  ),$($z  );$($x+1  );$($y    );$($z+1  )" # front
            $script:squareList[$square] += 1
            $square = "$($x+1 ),$($y  ),$($z  );$($x+1  );$($y+1  );$($z+1  )" # right
            $script:squareList[$square] += 1
            $square = "$($x   ),$($y+1),$($z  );$($x+1  );$($y+1  );$($z+1  )" # back
            $script:squareList[$square] += 1
            $square = "$($x   ),$($y  ),$($z  );$($x    );$($y+1  );$($z+1  )" # left
            $script:squareList[$square] += 1
            $square = "$($x   ),$($y  ),$($z+1);$($x+1  );$($y+1  );$($z+1  )" # top
            $script:squareList[$square] += 1
            $square = "$($x   ),$($y  ),$($z  );$($x+1  );$($y+1  );$($z  )" # bottom
            $script:squareList[$square] += 1
        }
    }
    end {
        return [PSCustomObject]@{
            Cubes = $script:cubeList
            Squares = $script:squareList.Values | Where-Object { $_ -eq 1 }
        }
    }
}

function Day18 {
    [CmdletBinding()]
    param (
        [string]$InputFile = "$PSScriptRoot/inputdata.txt"
    )

    $result = Read-CubeList -InputFile $InputFile
    Write-Verbose "Nb of cubes: $($result.Cubes.Count)"
    Write-Verbose "Nb of squares: $($result.Squares.Count)"
    $result
}