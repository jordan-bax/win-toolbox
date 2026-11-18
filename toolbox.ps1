<#
.SYNOPSIS
    Displays a menu or runs a toolbox action.

.DESCRIPTION
    The toolbox switchboard provides Windows system, network, process, and help
    actions. Run without -Action for an interactive menu.

.PARAMETER Action
    system - Show computer information.
    network - Show network configuration.
    processes - List running processes.
    help - Show usage examples.

.EXAMPLE
    .\toolbox.ps1

.EXAMPLE
    .\toolbox.ps1 -Action network
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("system", "network", "processes", "help")]
    [string]$Action
)

function Show-SystemInfo {
    if (Get-Command Get-ComputerInfo -ErrorAction SilentlyContinue) {
        Get-ComputerInfo
    } else {
        Get-CimInstance -ClassName Win32_OperatingSystem |
            Select-Object Caption, Version, BuildNumber, OSArchitecture
    }
}

function Show-NetworkInfo {
    if (Get-Command Get-NetIPConfiguration -ErrorAction SilentlyContinue) {
        Get-NetIPConfiguration
    } else {
        Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True" |
            Select-Object Description, IPAddress, IPSubnet, DefaultIPGateway, DNSServerSearchOrder
    }
}

function Show-Processes {
    Get-Process |
        Sort-Object CPU -Descending |
        Select-Object -First 20 Id, ProcessName, CPU
}

function Show-Usage {
    Write-Host "Usage:"
    Write-Host "  .\toolbox.ps1"
    Write-Host "  .\toolbox.ps1 -Action system"
    Write-Host "  .\toolbox.ps1 -Action network"
    Write-Host "  .\toolbox.ps1 -Action processes"
    Write-Host "  .\toolbox.ps1 -Action help"
}

function Invoke-SelectedAction {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("system", "network", "processes", "help")]
        [string]$Choice
    )

    switch ($Choice) {
        "system" {
            Show-SystemInfo
        }
        "network" {
            Show-NetworkInfo
        }
        "processes" {
            Show-Processes
        }
        "help" {
            Show-Usage
        }
    }
}

if ($Action) {
    Invoke-SelectedAction -Choice $Action
    return
}

do {
    Write-Host ""
    Write-Host "Windows Toolbox"
    Write-Host "1. System information"
    Write-Host "2. Network information"
    Write-Host "3. Running processes"
    Write-Host "4. Help"
    Write-Host "Q. Quit"

    $Choice = Read-Host "Choose an option"

    switch ($Choice.Trim().ToLowerInvariant()) {
        "1" { Invoke-SelectedAction -Choice "system" }
        "2" { Invoke-SelectedAction -Choice "network" }
        "3" { Invoke-SelectedAction -Choice "processes" }
        "4" { Invoke-SelectedAction -Choice "help" }
        "q" { Write-Host "Goodbye." }
        "quit" { Write-Host "Goodbye." }
        default { Write-Host "Unknown option: $Choice" }
    }
} while ($Choice.Trim().ToLowerInvariant() -notin @("q", "quit"))
