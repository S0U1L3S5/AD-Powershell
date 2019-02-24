#-------------------------------------------------
# Created By: S0U1L3S5
# Import file from user for active directory
# Verify file extension and appropriate action
#-------------------------------------------------

# Import Modules for script
Import-Module ActiveDirectory

# Choose what you are adding to the AD (OrgUnit, Group, User)
Write-Host 'Selection what you are adding to the active directory'
Write-Host 'You options are: OU, Grp, Usr, PC, Obj'
Write-Host 'Enter exit to quit the program when prompted'
Write-Host 'Enter Option'
$Opt = Read-Host 
if (($Opt -contains 'OU') -or ($Opt -contains 'Grp') -or ($Opt -contains 'Usr') -or `
    ($Opt -contains 'obj') -or ($Opt -contains 'pc'))
{
    Write-Host "You selected $Opt as your option"
}
elseif ($Opt -match 'exit') {
    Write-Host 'Closing Program'
    Exit    
}
else 
{
    Write-Host "Invalid Option, Closing Program"
    Exit    
}

# Get file from user and check the extension for .csv
$file = Read-Host -Prompt 'Enter the Path to CSV file: '
$extention = [IO.Path]::GetExtension($file)
if ($extention -eq ".csv")
{
    $CSVfile = Import-Csv $file
}
elseif ($file -match 'exit') 
{
    Write-Host 'Closing program'
    Exit    
}
else
{
    Write-Host 'Invalid file extension'
    Exit
}

# Loop through appropriate option for selected file
foreach ($item in $CSVfile)
{
    # Add OU to AD
    if ($Opt -contains 'OU')
    {
        $OUname = $item.Name
        $OUdescription = $item.Description
        $OUpath = $item.Path

        # Check if the OU exists, create if it does not exist
        if ($Uname -eq (Get-ADOrganizationalUnit -Filter {Name -eq $OUname -and (Path -eq $OUpath)}))
        {
            Write-Output "$OUname already exists!"
            Write-Output "    path= $OUpath"
        }
        else 
        {
            # Statement to add OU
            New-ADOrganizationalUnit `
                -Name $OUname `
                -Description "$OUdescription" `
                -path "$OUpath"

            # Display message for each OU created
            Write-Output "$OUname has been created at path $OUpath"
        }
    }
    
    # Add User to AD
    elseif ($Opt -contains 'Usr')
    {
        $Firstname = $item.FirstName
        $Lastname = $item.LastName 
        $Upassword = $item.Password
        $Upath = $item.Path
        $Uname = "$Firstname.$Lastname"

        #Check if Users exists, otherwise create user
        if (($Firstname -and $Lastname) -eq (Get-ADUser -Filter {GivenName -eq $Firstname -and (Surname -eq $Lastname)}))
        {
            Write-Output "$Uname already exists!"
            Write-Output "    path= $Upath"
        }
        else 
        {
            # Statement to add User
            New-ADUser `
                -SamAccountName $Uname `
                -UserPrincipalName "$Uname@AGUTIERREZ.LOCAL" `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $true `
                -DisplayName $Uname `
                -EmailAddress "$Uname@AGUTIERREZ.com" `
                -AccountPassword (ConvertTo-SecureString $Upassword -AsPlainText -Force) `
                -ChangePasswordAtLogon $true `
                -Path $Upath

            # Display message for each User created
            Write-Output "$Uname has been created, path is $Upath"
        }  
    }

    # Add Groups to AD
    elseif ($Opt -contains 'Grp') 
    {
        $Gname = $item.GroupName
        $Gcategory = $item.GroupCategory
        $Gscope = $item.GroupScope
        $Gpath = $item.Path
        $Gdescript = $item.Description

        #Check is group exists, otherwise create group
        if ((Get-ADGroup -Filter {Name -eq $Gname}) -match $Gname)
        {
            Write-Output "$Gname already exists!"
            Write-Output "    path= $Gpath"
        }
        else 
        {
            #statement to add group to OU
            New-ADGroup `
                -Name $Gname `
                -GroupCategory $Gcategory `
                -GroupScope $Gscope `
                -DisplayName $Gname `
                -Path $Gpath `
                -Description $Gdescript
        
            # Display Message for each Group created
            Write-Output "$Gname has been created, path is $Gpath"
        }    
    }

    # Add PC to AD
    elseif ($Opt -contains 'pc')
    {
        $PCname = $item.Name
        $PCdisnam = $item.DisplayName
        $PClocation = $item.Location
        $PCpath = $item.Path
        
        #Check if Computer exists, create otherwise
        if ((Get-ADComputer -Filter {Name -eq $PCname}) -match $PCname)
        {
            Write-Host "$PCname already exists"
            Write-Host "    path= $PCpath"
        }
        else 
        {
            # statement to add computer to OU
            New-ADComputer `
                -Name "$PCname" `
                -DisplayName $PCdisnam `
                -Location $PClocation `
                -Path $PCpath `
            
            # Display Message for each PC created
            Write-Output "$PCname has been created, path is $PCpath"    
        }
    }

    # Add Resource to AD
    elseif ($Opt -contains 'obj')
    {
        $Rname = $item.Name
        $Rtype = $item.Type
        $Rdescript = $item.Description
        $Rdisplay = $item.DisplayName
        $Rpath = $item.Path

        # Check if Computer exists, create otherwise
        if (Get-ADObject -Filter {-Name -eq $Rname})
        {
            Write-Host "$Rname already exists"
            Write-Host "    path= $Rpath"
        }
        else 
        {
            # statement to add resource to OU
            New-ADObject `
                -Name $Rname `
                -Type $Rtype `
                -Description $Rdescript `
                -DisplayName $Rdisplay `
                -Path $Rpath
            
            # Display Message for each Obj created
            Write-Output "$Rname has been created, path is $Rpath"
        }
    }

    # Exit due to inforation error
    else 
    {
        Write-Output "Information error, please check options and file format"
        Exit    
    }
}