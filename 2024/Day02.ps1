function ReadInputData {
    [CmdletBinding()]
    param (
        [string] $InputFile
    )
    Get-Content $InputFile | ForEach-Object {
        $array = $_ -split ' ' | ForEach-Object { [int]$_ }
        @(,$array)
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
    # ugly but it works for the single line testdata
    if ($reportList[0].Count -eq 1) { $reportList = (,$reportList) }
        # for each report: check if the sorted list is the same as the original list
    $validReports = foreach ($report in $reportList) {
        $result = CheckReport -Report $report
        if ($result -eq -1) {
            @(,$report)      # if the report is valid, return it
            continue
        }
        if ($Part2) {
            # $result points to the last checked index
            # remove this element and check again
            $thisReport = $report[0..($result - 1)]
            if ($result -lt $report.Length - 1) {
                $thisReport += $report[($result + 1)..($report.Length - 1)]
            }
            $thisResult = CheckReport -Report $thisReport
            if ($thisResult -eq -1) {
                @(,$report)  # if the report is valid, return it
                continue
            }
            # if index is 1, it could be the first element which is invalid
            $thisReport = $report[1..($report.Length - 1)]
            $thisResult = CheckReport -Report $thisReport
            if ($thisResult -eq -1) {
                @(,$report)  # if the report is valid, return it
                continue
            }
            # if the report is invalid, remove the element after $result (the original one!)
            $thisReport = $report[0..$result]
            if ($result -lt $report.Length - 2) {
                $thisReport += $report[($result + 2)..($report.Length - 1)]
            }
            $thisResult = CheckReport -Report $thisReport
            if ($thisResult -eq -1) {
                @(,$report)  # if the report is valid, return it
                continue
            }
        }
    }
    if ($null -eq $validReports) { return 0 }
    if ($validReports[0].Count -eq 1) { $validReports = (,$validReports) }
    $validReports.Count
}