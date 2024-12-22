function ReadInputData {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    $fileContent = Get-Content $InputFile
    $dataLeft = [int[]]::new($fileContent.Count)
    $dataRight = [int[]]::new($fileContent.Count)
    for ($i = 0; $i -lt $fileContent.Count; $i++) {
        $d = $fileContent[$i] -split ' '
        $null = $dataLeft[$i] = [int]$d[0]
        $null = $dataRight[$i] = [int]$d[-1]
    }
    return $dataLeft, $dataRight
}
function Day01 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    $dataLeft, $dataRight = ReadInputData -InputFile $InputFile
    if ($Part2) {
        # hash the numbers of list 2
        # search for each number in list 1 in the hash table and multiply the number with the number of occurences
        $dataRight = $dataRight | Group-Object -AsHashTable
        $sum = 0
        foreach ($number in $dataLeft) {
            $sum += $number * $dataRight[$number].Count
        }
    } else {
        $dataLeft = $dataLeft | Sort-Object
        $dataRight = $dataRight | Sort-Object
        $sum = 0
        for ($i = 0; $i -lt $dataLeft.Count; $i++) {
            $delta = [System.Math]::Abs($dataLeft[$i] - $dataRight[$i])
            $sum += $delta
        }
    }
    $sum
}