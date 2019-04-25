<#-------------------------------------------------
 Created By: S0U1L3S5
 Import file from user for active directory
 Verify file extension and appropriate action
 Perform the appropriate action indiated by user
 Checks the action type "Add, Remove"
-------------------------------------------------
Script 3: Modify Security Group Membership
Action (Add | Remove)
-------------------------------------------------
#>

# Import Modules for script
Import-Module ActiveDirectory

# Welcome Message
Write-Host "This Script will Update Security Groups"
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
    $eAction=$item.Action
    $eUname=$item.Username
    $eGroupName=$item.GroupName

    
    # Update GroupMember in AD
    if ($eAction -contains 'Add')
    {
        #Check if Member exists in Group exists and create Group is needed
        if ((Get-ADGroupMember $eGroupName) -match $eUname)
        {
            Write-Output "$eUname is already a member of that group: $eGroupName! `n"
        }
        else 
        {
            # Statement to add Member to Group
            Add-ADGroupMember `
                -Identity $eGroupName `
                -Memberss $eUname
            
            # Display message for each update
            Write-Output "$eUname has been add to $eGroupName `n"
        }  
    }
    #Remove Group
    elseif($eAction -contains 'Remove')
    {
        #Check if Group exists for deletion, throw error if Group not found
        if ((Get-ADGroupMember $eGroupName) -notmatch $eUname)
        {
            Write-Output "$eUname does not exists in group $eGroupName, unable to delete"
            Write-Output "Please verify the information is correct in csv file"
            Write-Output "Error occured on line $LineNumber `n"
        }
        #Remove Group that exists
        else 
        {
            Remove-ADGroupMember -Identity $eGroupName -Members $eUname -Confirm:$false

            Write-Output "$eUname has beem removed from $eGroupName"
        }
    }
    # Throw line error if information error in CSV file
    else 
    {
        Write-Output "Information error:`n Please check line number $LineNumber in csv file "   
    }
}
