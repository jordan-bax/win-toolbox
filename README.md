# win-toolbox

A collection of beginner-friendly Windows PowerShell scripts.

## Documentation

- [PowerShell syntax library](SYNTAX.md) - variables, arguments, operators,
  control statements, common commands, and command options.
- [PowerShell tutorial](TUTORIAL.md) - create variables and functions, write
  a script, and use the toolbox switchboard.

## Toolbox switchboard

Run the main menu from Windows PowerShell or PowerShell 7:

```powershell
.\toolbox.ps1
```

You can also open one menu action directly:

```powershell
.\toolbox.ps1 -Action system
.\toolbox.ps1 -Action network
.\toolbox.ps1 -Action processes
.\toolbox.ps1 -Action help
```

Use `Get-Help .\toolbox.ps1 -Full` to read the script's built-in help.
