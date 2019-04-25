# Created by Austin Gutierrez
# Get a list of all computers on a domain
# Ref: https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adcomputer?view=win10-ps
# Ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-6


Import-Module ActiveDirectory

Get-ADComputer -Server AGTUEIRREZ.LOCAL -Properties * -Filter * | Export-Csv DomainComputers.csv -NoTypeInformation