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
function Day02 {
    [CmdletBinding()]
    param (
        [string] $InputFile = "$PSScriptRoot/../Input.txt",
        [switch] $Part2
    )
    $reportList = ReadInputData -InputFile $InputFile
        # for each report: check if the sorted list is the same as the original list
    $validReports = foreach ($report in $reportList) {
        $fail = $false
        if ($report[0] -gt $report[1]) {
            # it must be a descending list
            foreach ($i in 1..($report.Length - 1)) {
                # it must be a descending list and the max difference allowed is 3
                if ($report[$i] -ge $report[$i - 1]) { $fail = $true; break }
                if ($report[$i - 1] - $report[$i] -gt 3) { $fail = $true; break }
            }
            if (-not $fail) { (,$report) }
        } else {
            # it must be an ascending list
            foreach ($i in 1..($report.Length - 1)) {
                # it must be an ascending list and the max difference allowed is 3
                if ($report[$i] -le $report[$i - 1]) { $fail = $true; break }
                if ($report[$i] - $report[$i - 1] -gt 3) { $fail = $true; break }
            }
            if (-not $fail) { (,$report) }
        }
    }
    $validReports.Count
}