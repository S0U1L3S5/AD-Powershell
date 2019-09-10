<###########################################
    Created by: Austin Gutierrez
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
        [String]$action,
        [string]$serviceName
    )
    if($action -eq 'Start') {
        if ((Get-Service -Name $serviceName).Status -ne 'Running') {
            Write-Host "Starting service ---> $serviceName"
            Get-Service -Name $serviceName | Start-Service -ErrorAction SilentlyContinue
            (Get-Service -Name $serviceName).WaitForStatus('Running')
            GetServiceStatus($serviceName)
        }
        else {
            Write-Host "Service Named: -- $serviceName -- is already Running `n"
        }
    }
    elseif ($action -eq 'Stop') {
        if ((Get-Service -Name $serviceName).Status -ne 'Stopped') {
            Write-Host "Stopping service ---> $serviceName"
            Get-Service -Name $serviceName | Stop-Service -ErrorAction SilentlyContinue
            (Get-Service -Name $serviceName).WaitForStatus('Stopped')
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
    param(
        [Parameter(Mandatory=$true)]
        [string]$choice
    )
        if ($choice -contains 'Y') {
        Write-Host "`nProceeding...`n"
    }
    else {
        Write-Host "`nExiting Script...`n"
        Exit
    }
}

<###########################################
    ----FUNCITON TESTS----
    $testName = "Fax"
    GetServiceStatus($testName)
    ServiceFunction -action "Start" -serviceName $testName
    ServiceFunction -action "Stop" -serviceName $testName
###########################################>

# Kona Services
[array]$services = "Kona Backgroud Processor", "Kona JMS Listener", "RabbitMQ"

# Display selected services and thier status
Write-Host "This script will restart the following services: "
foreach ($srv in $services) {
    Write-Host $services.IndexOf($srv) " ---  " $srv
    GetServiceStatus($srv)
}

# Verify with user to continue
$option = Read-Host "`n Continue to shutdown these services? `n Answer (Y/N): "
ContinueScript($option)

# Stop each service
foreach ($srv in $services) {
    Write-Host $services.IndexOf($srv) " ---  " $srv
    ServiceFunction `
        -action "Stop" `
        -serviceName $testName
}

# Verify with user to continue
$option = Read-Host "`n Continue to restart these services? `n Answer (Y/N): "
ContinueScript($option)

# Start each service in reverse order
[array]::Reverse($services)
foreach ($srv in $services) {
    Write-Host $services.IndexOf($srv) " ---  " $srv
    ServiceFunction `
        -action "Start" `
        -serviceName $testName
}
