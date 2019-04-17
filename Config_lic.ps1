#-------------------------------------------------
# Created By: Austin Gutierrez
# Help was recieved from Daniel with troublehooting
# Verify ENV Registry key
# Update existing key
# Creat Key if does not exist
#-------------------------------------------------

#set variables
$envName = "LM_LICENSE_KEY"
$regkey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

#check if env variable exists in regkey
if ((Get-ItemProperty -Path $regkey) -match $envName)
{
    #check value of regkey
    if((Get-ItemPropertyValue -Path $regkey -Name $envName) -match "27000@AGUTIERREZ.LOCAL")
    {
        Write-Host "Value is alread included inside registry key"
    }
    #add value if not in key
    else
    {
        $curValue = Get-ItemPropertyValue -Path $regkey -Name $envName
        $newValue = "$curValue; 27000@AGUTIERREZ.LOCAL"

        Set-ItemProperty `
        -Path $regkey `
        -Name $envName `
        -Value = $newValue
    }
}
#create env 
else 
{
    New-ItemProperty `
    -Path $regkey `
    -Name $envName `
    -PropertyType String `
    -Value "27000@AGUTIERREZ.LOCAL"
}