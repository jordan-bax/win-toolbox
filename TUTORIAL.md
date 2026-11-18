# PowerShell Beginner Tutorial

This tutorial uses PowerShell 7 or Windows PowerShell. Open a PowerShell window
and navigate to this repository before running examples.

```powershell
Set-Location C:\path\to\win-toolbox
Get-Location
```

## 1. Run commands

A command is the first word of a line. Commands commonly use named arguments
after the command:

```powershell
Get-ChildItem -Path . -Recurse
Get-Content -Path README.md
Get-Help Get-ChildItem -Examples
```

Positional arguments can work, but named arguments are clearer:

```powershell
Get-ChildItem .
Get-ChildItem -Path .
```

Use `Get-Help <command> -Full` when you need every parameter and example.

## 2. Make variables

Assign a value with `=`, beginning the variable name with `$`:

```powershell
$name = "Alex"
$folder = $PSScriptRoot
$count = 3
$running = $true

Write-Output "Hello, $name"
Write-Output "Toolbox folder: $folder"
```

Arrays use `@(...)`. Each item can be read by zero-based index:

```powershell
$tools = @("system", "network", "processes")
$tools[0]
$tools.Count
```

PowerShell may convert values automatically. If needed, declare a type:

```powershell
[int]$number = Read-Host "Enter a number"
[string]$text = Read-Host "Enter some text"
```

## 3. Compare values

PowerShell uses names beginning with `-` for comparisons:

```powershell
$number -eq 10
$number -gt 0
$name -like "A*"
$tools -contains "network"
```

Combine comparisons with `-and`, `-or`, and `-not`:

```powershell
if (($number -gt 0) -and ($name -ne "")) {
    Write-Output "Both values are valid."
}
```

## 4. Make decisions

Use `if`, `elseif`, and `else` for one or more conditions:

```powershell
if ($number -gt 100) {
    Write-Output "The number is large."
} elseif ($number -gt 0) {
    Write-Output "The number is positive."
} else {
    Write-Output "The number is zero or negative."
}
```

Use `switch` for several fixed values:

```powershell
$action = Read-Host "Choose system, network, or processes"

switch ($action) {
    "system"    { Get-ComputerInfo }
    "network"   { Get-NetIPConfiguration }
    "processes" { Get-Process }
    default     { Write-Output "Unknown action." }
}
```

Use `foreach` to repeat work for every item:

```powershell
foreach ($tool in $tools) {
    Write-Output "Available tool: $tool"
}
```

## 5. Create a function

A function groups reusable work:

```powershell
function Get-Greeting {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    "Hello, $Name"
}

Get-Greeting -Name "Alex"
```

Place a `param(...)` block first inside the function. `[Parameter(Mandatory)]`
requires a value, `[ValidateSet(...)]` restricts allowed values, and `[switch]`
creates a Boolean-style option.

## 6. Create a script

Create `example.ps1` with:

```powershell
param(
    [Parameter(Mandatory)]
    [string]$Name,

    [ValidateSet("system", "network")]
    [string]$Action = "system",

    [switch]$Detailed
)

Write-Output "Hello, $Name"

switch ($Action) {
    "system"  { Get-ComputerInfo }
    "network" { Get-NetIPConfiguration }
}
```

Run it from PowerShell:

```powershell
.\example.ps1 -Name "Alex"
.\example.ps1 -Name "Alex" -Action network -Detailed
Get-Help .\example.ps1 -Full
```

If script execution is blocked on your machine, see the execution policy rather
than changing system settings casually:

```powershell
Get-ExecutionPolicy
Get-Help about_Execution_Policies
```

## 7. Use the toolbox

The main switchboard is `toolbox.ps1`. Run it without arguments for an
interactive menu:

```powershell
.\toolbox.ps1
```

Or select an action directly:

```powershell
.\toolbox.ps1 -Action system
.\toolbox.ps1 -Action network
.\toolbox.ps1 -Action processes
.\toolbox.ps1 -Action help
```

The menu is a basic example of `param`, `switch`, `Read-Host`, and `Write-Host`.
Study `toolbox.ps1` to see how it connects each menu choice to a command.

## 8. Filter pipeline output

The pipeline (`|`) sends one command's output to another command:

```powershell
Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 10 Name, CPU
```

- `Where-Object` filters output.
- `Sort-Object` changes the order.
- `Select-Object` limits rows or properties.
- `Out-GridView` shows output in a table on Windows.

Example:

```powershell
Get-Service |
    Where-Object Status -eq "Running" |
    Select-Object Name, DisplayName
```
