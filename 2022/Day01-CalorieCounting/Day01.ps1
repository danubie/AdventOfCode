function Get-ElfCaloriesCounts {
    param(
        [string]$InputFile = "$PSScriptRoot\InputData.txt"
    )

    $data = Get-Content $InputFile
    $elfCount = 1
    $totalCalories = 0
    foreach ($line in $data) {
        if ($line -match "(\d+)") {
            $totalCalories += $Matches[1]
        } else {
            # new elf
            # return the total calories for the previous elf
            [pscustomobject]@{
                ElfNumber = $elfCount
                TotalCalories = $totalCalories
            }
            $elfCount++
            $totalCalories = 0
        }
    }
    # return the last elf
    [pscustomobject]@{
        ElfNumber = $elfCount
        TotalCalories = $totalCalories
    }
}

function Get-ElfWithMostCalories {
    param(
        [string]$InputFile = "$PSScriptRoot\InputData.txt"
    )

    $calories = Get-ElfCaloriesCounts -InputFile $InputFile
    $calories | Sort-Object TotalCalories -Descending | Select-Object -First 1
}

function Get-ElfTop3 {
    param(
        [string]$InputFile = "$PSScriptRoot\InputData.txt"
    )
    $calories = Get-ElfCaloriesCounts -InputFile $InputFile
    $calories | Sort-Object TotalCalories -Descending | Select-Object -First 3 | Measure-Object -Sum TotalCalories
}