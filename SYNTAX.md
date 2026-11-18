# PowerShell Syntax Library

PowerShell is case-insensitive for commands and variable names. A line comment
starts with `#`; block comments start with `<#` and end with `#>`.

## Variables

Variables start with `$`. PowerShell usually selects a value type automatically.

```powershell
$name = "Alex"
$number = 42
$items = @("Keyboard", "Monitor", "Mouse")
$empty = $null

[int]$count = 3
[string]$computerName = $env:COMPUTERNAME
$type = $items.GetType()
```

Use an environment variable as `$env:VARIABLE_NAME`, for example
`$env:USERNAME`. To print a value, use `Write-Output $name` or
`$name`.

## Script arguments

Put a `param` block at the top of a script:

```powershell
param(
    [Parameter(Mandatory)]
    [string]$Name,

    [ValidateSet("system", "network")]
    [string]$Action = "system",

    [switch]$Detailed
)
```

Run the script with arguments:

```powershell
.\example.ps1 -Name "Alex"
.\example.ps1 -Name "Alex" -Action network -Detailed
```

Inside the script, `$args` contains unnamed arguments and `$PSScriptRoot`
contains the folder containing the script.

## Operators

### Assignment and arithmetic

| Operator | Example | Meaning |
|---|---|---|
| `=` | `$x = 10` | Assign a value |
| `+=` | `$x += 2` | Add and assign |
| `-=`, `*=`, `/=` | `$x -= 1` | Other arithmetic assignments |
| `++`, `--` | `$x++` | Add or subtract one |
| `+`, `-`, `*`, `/`, `%` | `$a + $b` | Arithmetic; `%` is remainder |

### Comparison

PowerShell comparison operators start with `-`. Use `-eq` for equality rather
than `=`. Comparisons are case-insensitive by default.

| Operator | Meaning |
|---|---|
| `-eq`, `-ne` | Equal, not equal |
| `-gt`, `-ge` | Greater than, greater than or equal |
| `-lt`, `-le` | Less than, less than or equal |
| `-like`, `-notlike` | Wildcard string match |
| `-match`, `-notmatch` | Regular-expression match |
| `-contains`, `-notcontains` | Collection contains a value |
| `-in`, `-notin` | Value is in a collection |

```powershell
$ready = $true
$age = 20
$age -ge 18
$name -like "A*"
$items -contains "Mouse"
```

### Logical and pipeline operators

| Operator | Meaning |
|---|---|
| `-and` | True if both sides are true |
| `-or` | True if either side is true |
| `-xor` | True if exactly one side is true |
| `-not`, `!` | Negate a Boolean |
| `|` | Send output to the next command |
| `&&`, `||` | Run the next command when the previous succeeds/fails |

## Operation statements

PowerShell also calls these control statements.

```powershell
if ($age -ge 18) {
    Write-Output "Adult"
} elseif ($age -ge 13) {
    Write-Output "Teen"
} else {
    Write-Output "Child"
}

foreach ($item in $items) {
    Write-Output $item
}

for ($i = 0; $i -lt 3; $i++) {
    Write-Output $i
}

while ($count -gt 0) {
    $count--
}

switch ($Action) {
    "system"  { Get-ComputerInfo }
    "network" { Get-NetIPConfiguration }
    default   { Write-Output "Unknown action" }
}

try {
    Get-Item "missing.txt" -ErrorAction Stop
} catch {
    Write-Error "The file could not be found."
}
```

`break` exits a loop or switch. `continue` skips to the next loop iteration.
Use `return` to leave a function or script.

## Functions

```powershell
function Get-Greeting {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    return "Hello, $Name"
}

Get-Greeting -Name "Alex"
```

PowerShell function names conventionally use a Verb-Noun form, such as
`Get-Greeting`. Use `Get-Verb` to see approved verbs.

## Common commands

| Command | Typical use | Common options |
|---|---|---|
| `Get-Help` | Read command help | `-Full`, `-Examples`, `-Online` |
| `Get-Command` | Find commands | `-Name`, `-Verb`, `-Noun`, `-Syntax` |
| `Get-ChildItem` (`ls`, `dir`) | List files | `-Path`, `-Recurse`, `-Filter`, `-Force` |
| `Set-Location` (`cd`) | Change directory | `-Path`, `-LiteralPath` |
| `Get-Location` (`pwd`) | Show current directory |  |
| `New-Item` | Create a file or folder | `-ItemType`, `-Path`, `-Value`, `-Force` |
| `Copy-Item` | Copy a file or folder | `-Path`, `-Destination`, `-Recurse`, `-Force` |
| `Move-Item` | Move or rename | `-Path`, `-Destination`, `-Force` |
| `Remove-Item` (`rm`) | Delete | `-Path`, `-Recurse`, `-Force` |
| `Get-Content` (`cat`) | Read a text file | `-Path`, `-Tail`, `-Raw` |
| `Set-Content` | Write text | `-Path`, `-Value`, `-Encoding` |
| `Out-File` | Write pipeline output | `-FilePath`, `-Encoding`, `-Append` |
| `Write-Output` | Send a value to output | `-InputObject`, `-NoEnumerate` |
| `Write-Host` | Write directly to the console | `-Object`, `-ForegroundColor` |
| `Select-Object` | Select properties or items | `-Property`, `-First`, `-Last`, `-Unique` |
| `Where-Object` | Filter pipeline objects | `-FilterScript`, `-Property`, `-Match` |
| `Sort-Object` | Sort pipeline objects | `-Property`, `-Descending`, `-Unique` |
| `ForEach-Object` | Process each pipeline object | `-Process`, `-Begin`, `-End` |
| `Measure-Object` | Count or measure values | `-Property`, `-Sum`, `-Average`, `-Maximum`, `-Minimum` |
| `Test-Path` | Check if a path exists | `-Path`, `-PathType`, `-LiteralPath` |
| `Get-Process` | List processes | `-Name`, `-Id`, `-IncludeUserName` |
| `Stop-Process` | Stop a process | `-Name`, `-Id`, `-Force` |
| `Get-Service` | List services | `-Name`, `-Status`, `-RequiredServices` |
| `Start-Service` | Start a service | `-Name`, `-PassThru` |
| `Get-NetIPConfiguration` | View network configuration | `-InterfaceAlias`, `-All` |
| `Get-ComputerInfo` | View system information | `-Property` |

Use command help and discovery:

```powershell
Get-Help Get-ChildItem -Full
Get-Command Get-*Process
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```
