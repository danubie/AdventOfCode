function ReadInputData {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    Get-Content $InputFile | ForEach-Object {
        $array = $_ -split ' ' | ForEach-Object { [int]$_ }
        (,$array)
    }
}

function CheckReport {
    [CmdletBinding()]
    param (
        [int[]] $Report
    )
    $fail = -1
    if ($report[0] -lt $report[1]) {
        foreach ($i in 0..($report.Length - 2)) {
            # it must be a ascending list and the max difference allowed is 3
            if ($report[$i] -ge $report[$i + 1]) {$fail = $i; break }
            if ($report[$i+1] - $report[$i] -gt 3) {$fail = $i; break }
        }
    } else {
        # it must be an descending list
        foreach ($i in 0..($report.Length - 2)) {
            # it must be an descending list and the max difference allowed is 3
            if ($report[$i] -le $report[$i + 1]) {$fail = $i; break }
            if ($report[$i] - $report[$i + 1] -gt 3) {$fail = $i; break }
        }
    }
    $fail
}
function Day02 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    $reportList = ReadInputData -InputFile $InputFile
        # for each report: check if the sorted list is the same as the original list
    $validReports = foreach ($report in $reportList) {
        $result = CheckReport -Report $report
        if ($result -isnot [int]) { (,$report) }
    }
    $validReports.Count
}