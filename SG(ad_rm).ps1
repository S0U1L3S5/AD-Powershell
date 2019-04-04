<#-------------------------------------------------
 Created By: S0U1L3S5
 Import file from user for active directory
 Verify file extension and appropriate action
 Perform the appropriate action indiated by user
 Checks the action type "Add, Remove"
-------------------------------------------------
Script 2: Create Security Groups
Action (Add | Remove)
-------------------------------------------------
#>

# Import Modules for script
Import-Module ActiveDirectory

# Welcome Message
Write-Host "This Script will Add / Remove Security Groups"
Write-Host "Please ensure that you select the right csv file for importing"
Write-Host "Is this the correct script that you ment to run Yes/No? `n"

# Verify that this is the right program that you wanted to run
$Opt = Read-Host -Prompt "Answer: "
if ($Opt -contains 'Y')
{
    Write-Host "`nLet us continue`n"
}
elseif ($Opt -contains 'N') 
{
    Write-Host "`nGood Bye`n"
    Exit    
}
else 
{
    Write-Host "`nInvalid Option, Closing Program`n"
    Exit    
}

# Get file from user and check the extension for .csv
$file = Read-Host -Prompt 'Enter the Path to CSV file: '
$extention = [IO.Path]::GetExtension($file)
if ($extention -eq ".csv")
{
    $CSVfile = Import-Csv $file
}
else
{
    Write-Host "Invalid file extension`n"
    Exit
}

$LineNumber = 0
# Loop through appropriate action for selected file
foreach ($item in $CSVfile)
{
    $LineNumber += 1
    eAction=$item.Action
    eGroupName=$item.GroupName
    eGroupCat=$item.GroupCategory
    eGroupScope=$item.GroupScope
    ePath=$item.Path
    eDescription=$item.Description
    
    # Add Group to AD
    if ($eAction -contains 'Add')
    {
        #Check if Group exists and create Group is needed
        if ((Get-ADGroup -Filter {Name -eq $eGroupName}) -match $eGroupName)
        {
            Write-Output "$eGroupName already exists at path: $ePath! `n"
        }
        else 
        {
            # Statement to add Group
            New-ADGroup `
                -Name $eGroupName `
                -GroupCategory $eGroupCat `
                -GroupScope $eGroupScope `
                -DisplayName $eGroupName `
                -Path $ePath `
                -Description $eDescription
            
            # Display message for each Group created
            Write-Output "$eGroupName has been created, path is $ePath `n"
        }  
    }
    #Remove Group 
    elseif($eAction -contains 'Remove')
    {
        #Check if Group exists for deletion, throw error if Group not found
        if ((Get-ADGroup -Filter {Name -eq $eGroupName}) -notmatch $eGroupName)
        {
            Write-Output "$eGroupName does not exists, unable to delete"
            Write-Output "Please verify the information is correct in csv file"
            Write-Output "Error occured on line $LineNumber `n"
        }
        #Remove Group that exists
        else 
        {
            Get-ADGroup -Filter {Name -eq $eGroupName} | Remove-ADGroup -Confirm:$false

            Write-Output "$eGroupName has been removed from the Domain"
            Write-Output "Users PATH was $ePath `n"
        }
    }
    # Throw line error if information error in CSV file
    else 
    {
        Write-Output "Information error:`n Please check line number $LineNumber in csv file "   
    }
}
