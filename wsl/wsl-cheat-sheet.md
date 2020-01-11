# WSL Cheat Sheet

## Get UID value by specific distro and user.

```
wsl -d <DistroName> -u <UserName> -e id -u
```

## Setting the Default User for a WSL distro via PowerShell

### Command WSL-SetDefaultUser

This is a PowerShell function for setting the default user by distro name and user name. It works both for official distributions (from the MS Store), and for any custom distros.

```
Function WSL-SetDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };
```

**Using:**

```
WSL-SetDefaultUser <DistroName> <UserName>
```

**Example using:**

```
WSL-SetDefaultUser ubuntu-19-04-server merkuriy
```

**Remove function:**

```
Remove-Item Function:WSL-SetDefaultUser
```

### Single-line command with call and remove function

```
Function WSL-SetDefaultUser ($distro="<DistroName>", $user="<UserName>") { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); }; WSL-SetDefaultUser; Remove-Item Function:WSL-SetDefaultUser;
```

Replace `<DistroName>` and `<UserName>` inserts at the begin of the command.

## How to Keep colors in the commandline terminal when switching to root via `sudo su`

Not sure if this woks on all distros, but in Ubuntu on WSL, simply open `/root/.bashrc` and uncomment this line: 

```
#force_color_prompt=no
```

Now your su commands will still be colored if you're using a terminal that supports it such as ConEmu.



