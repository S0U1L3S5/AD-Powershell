


# # Get file inputs
# $F1_path = Read-Host -Prompt 'Enter the path to CSV file #1: '
# $F2_path = Read-Host -Prompt 'Enter the path to CSV file #2: '

# # Get file extension
# $F1_ext = [IO.Path]::GetExtension($file1)
# $F2_ext = [IO.PAth]::GetExtension($file2)

# #verify file extension
# if (($F1_ext -eq ".csv") -and ($F2_ext -eq ".csv"))
# {
#     $file1 = Import-Csv $F1_path
#     $file2 = Import-Csv $F2_path
# }
# else 
# {
#     Write-Host 'Invalid file extension. Files must have a .csv extension.'
# }

# Get Timestamp

# $DT = (Get-Date -UFormat "%Y.%m.%d-%H%M").ToString()
# # $ext = ".csv"
# $f_out = ("diff_results_" + $Dt + ".csv").ToString()
# Compare each line form file 1 to file 2 and print any differences
# Compare-Object -ReferenceObject $(Get-Content C:\Users\austingu\Desktop\Temp\AUSTINGU_PD_QUERY.csv) -DifferenceObject $(Get-Content C:\Users\austingu\Desktop\Temp\DARRANMA_PD_QUERY.csv) > C:\Users\austingu\Desktop\Temp\diff_results'$DT'.csv

# Compare-Object `
#     -ReferenceObject $(Get-Content $file1) `
#     -DifferenceObject $(Get-Content $file2) `
#     > "~\Documents\File_Comp"

$DT = (Get-Date -UFormat "%Y.%m.%d-%H%M").ToString()
$f_out = ("diff_results_" + $Dt + ".csv").ToString()
# This works as intended
Compare-Object `
    -ReferenceObject $(Get-Content C:\Users\austingu\Desktop\Temp\hr_sync_original.csv) `
    -DifferenceObject $(Get-Content C:\Users\austingu\Desktop\Temp\hr_sync_test.csv) `
    | Out-File C:\Users\austingu\Desktop\Temp\$f_out

