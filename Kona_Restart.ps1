<###########################################
    Created by: Austin Gutierrez (AUSTINGU)
    --------------------------------------
    STOP AND RESTART KONA SERVICES
###########################################>

function GetServiceStatus () {
    # Check if service exists & get current status
    param (
        [parameter(Mandatory=$true)]
        [string]$serviceName
    )
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        $serviceStatus = (Get-Service -Name $serviceName).Status
        Write-Host $serviceName "---" $serviceStatus "`n"
    }
    else {
        Write-Host "Service Named: -- $serviceName -- not found `n"    
    }    
}

function StopOneService () {
    param (
        [parameter(Mandatory=$true)]
        [string]$srvToStop
    )
    if ((Get-Service -Name $srvToStop).Status -eq 'Running') {
        Write-Host "Stopping service ---> $srvToStop"
        Get-Service -Name $srvToStop | Stop-Service -ErrorAction SilentlyContinue
        GetServiceStatus($srvToStop)
    }
    else {
        Write-Host "Service Named: -- $srvToStop -- not Running `n"
    }
}

function StartOneSerivce () {
    param (
        [parameter(Mandatory=$true)]
        [string]$srvToStart
    )
    if ((Get-Service -Name $srvToStart).Status -ne 'Running') {
        Write-Host "Starting service ---> $srvToStart"
        Get-Service -Name $srvToStart | Start-Service -ErrorAction SilentlyContinue
        GetServiceStatus($srvToStart)
    }
    else {
        Write-Host "Service Named: -- $srvToStart -- not Running `n"
    }
}

<###########################################
    BELOW USED TO TEST THE FUNCTIONS
# $testName = "GoogleChromeElevationService"
# GetServiceStatus($testName)
# StopOneService($testName)
# StartOneService($testName)
###########################################>

# Display what the script is doing and what services will be restarted
Write-Host "This script will restart the Kona services on this server "
Write-Host "The following services will be restarted: `n1) Kona Background Processor `n2) Kona JMS LIstener `n3) RabbitMQ"

# Verify that this is the right program user wanted to run
Write-Host "Do you want to continue?"
$option = Read-Host -Prompt "Answer (Y/N): "

if ($option -contains 'Y') {
    Write-Host "`nProceeding to restart services...`n"
}
else {
    Write-Host "`nExiting Script...`n"
    Exit
}

# Store services to restart in an array
[array]$services = "Kona Backgroud Processor", "Kona JMS Listener", "RabbitMQ"
# $services.GetType()

# Stop each service
foreach ($srv in $services)
{
    GetServiceStatus($srv)


    Write-Host "$item"
}

Write-Host `n $services
[array]::Reverse($services)
Write-Host `n $services





<#
 -- verify the services are correct
 -- For each service
    -- check check service status
    -- Stop Service
    -- Wait until service is stopped
    -- Display status of service
    -- Move on to next service
-- Once all services are stopped
    -- Restart services one at a time
    -- Display status of service
    -- Wait for service status of "Running" before moving on to next service
    -- Display message once complete
#>