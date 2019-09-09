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

function ServiceFunction () {
    # Start/Stop a service
    param (
        [parameter(Mandatory=$true)]
        [array]$action,
        [string]$serviceName
    )

    if($action -eq 'Start') {
        if ((Get-Service -Name $serviceName).Status -ne 'Running') {
            Write-Host "Starting service ---> $serviceName"
            Get-Service -Name $serviceName | Start-Service -ErrorAction SilentlyContinue
            $serviceName.WaitForStatus('Running')
            GetServiceStatus($serviceName)
        }
        else {
            Write-Host "Service Named: -- $serviceName -- is already Running `n"
        }
    }

    elseif ($action -eq 'Stop') {
        if ((Get-Service -Name $serviceName).Status -eq 'Running') {
            Write-Host "Stopping service ---> $serviceName"
            Get-Service -Name $serviceName | Stop-Service -ErrorAction SilentlyContinue
            $serviceName.WaitForStatus('Stopped')
            GetServiceStatus($serviceName)
        }
        else {
            Write-Host "Service Named: -- $serviceName -- is not Running `n"
        }
    }

    else {
        Write-Host "Invalid Argument passed -- $action `t $serviceName"
    }
}

function ContinueScript () {
    # Flow Control from User
    [Parameter(Mandatory=$true)]
    [string]$choice
    if ($choice -contains 'Y') {
        Write-Host "`nProceeding...`n"
    }
    else {
        Write-Host "`nExiting Script...`n"
        Exit
    }
}

<###########################################
    BELOW USED TO TEST THE FUNCTIONS
# $testName = "GoogleChromeElevationService"
# GetServiceStatus($testName)
# StopOneService($testName)
# StartOneService($testName)
###########################################>

# Variables
[array]$services = "Kona Backgroud Processor", "Kona JMS Listener", "RabbitMQ"
[int]$counter = 0

# Display what the script is doing and what services will be restarted
Write-Host "This script will restart the following services: "

foreach ($srv in $services) {
    $counter += 1
    Write-Host $counter " --- " $srv
}

$option = Read-Host "`n Do you want to continue with this script? `n Answer (Y/N): "
ContinueScript($option)


# Get Current Status fore each service
foreach ($srv in $services) {
    GetServiceStatus($srv)
}

# Stop each service
foreach ($srv in $services) {
    ServiceFunction('Stop', $srv)
}

Write-Host `n $services
[array]::Reverse($services)
Write-Host `n $services

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