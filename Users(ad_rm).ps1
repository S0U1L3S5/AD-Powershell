<#-------------------------------------------------
 Created By: S0U1L3S5
 Import file from user for active directory
 Verify file extension and appropriate action
 Perform the appropriate action indiated by user
 Checks the action type "Add, Remove"
-------------------------------------------------
 Script 1: Add/Remove Users
 Action (Add | Remove)
-------------------------------------------------
#>

# Import Modules for script
Import-Module ActiveDirectory

# Welcome Message
Write-Host "This Script will Add / Remove / Udpate Users Accounts"
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
    Write-Host 'Invalid file extension'
    Exit
}

$LineNumber = 0
# Loop through appropriate option for selected file
foreach ($item in $CSVfile)
{
    $LineNumber += 1
    $eAction = $item.Action
    $eFirstname = $item.FirstName
    $eLastname = $item.LastName
    $ePassword = $item.Password
    $ePath = $item.Path
    $eDescription = $item.Description
    $eUname = "$eFirstname.$eLastname"
    
    # Add User to AD
    if ($eAction -contains 'Add')
    {
        #Check if Users exists, otherwise create user
        if (($Firstname -and $Lastname) -eq (Get-ADUser -Filter {GivenName -eq $Firstname -and (Surname -eq $Lastname)}))
        {
            Write-Output "$eUname already exists! `n"
        }
        else 
        {
            # Statement to add User
            New-ADUser `
                -SamAccountName $eUname `
                -UserPrincipalName "$eUname@AGUTIERREZ.LOCAL" `
                -Name "$eFirstname $eLastname" `
                -GivenName $eFirstname `
                -Surname $eLastname `
                -Enabled $true `
                -Discription $eDescription
                -DisplayName $eUname `
                -EmailAddress "$eUname@AGUTIERREZ.com" `
                -AccountPassword (ConvertTo-SecureString $ePassword -AsPlainText -Force) `
                -ChangePasswordAtLogon $true `
                -Path $ePath

            # Display message for each User created
            Write-Output "$eUname has been created, path is $ePath `n"
        }  
    }
    #Remove user 
    elseif($eAction -contains 'Remove')
    {
        #Check if Users exists, if error does not then through
        if (($Firstname -and $Lastname) -ne (Get-ADUser -Filter {GivenName -eq $Firstname -and (Surname -eq $Lastname)}))
        {
            Write-Output "$eUname does not exists, unable to delete"
            Write-Output "Please verify the information is correct in csv file"
            Write-Output "Error occured on line $LineNumber `n"
        }
        #Remove User that exists
        else 
        {
            Get-ADUser -Filter {Name -eq $eUname} | Remove-ADUser -Confirm:$false
            
            Write-Output "$eUname has been removed from the Domain"
            Write-Output "Users PATH was $ePath `n"
        }
    }
    # Throw line error if information error in CSV file
    else 
    {
        Write-Output "Information error:`n Please check line number $LineNumber in csv file "
    }
}