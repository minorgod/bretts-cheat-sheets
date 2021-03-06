# WSL Cheat Sheet

## Install WSL

Open Powershell as admin and type

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

That will install WSL1. To install WSL2 now type

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Restart your machine then open powershell as admin again and type

```powershell
wsl --set-default-version 2
```

You might see this message after running that command: `WSL 2 requires an update to its kernel component. For information please visit https://aka.ms/wsl2kernel`. Please follow the link (https://aka.ms/wsl2kernel) and install the MSI from that page to install a Linux kernel on your machine for WSL 2 to use. Then try running the above command again and it should work. 

## Set Hypervisor Launch Type

This will Enable or Disable VT-X so you can run VMs that don't play nice with Hyper-V (Note: this will break WSL until you re-enable it and reboot!!!!) Open an elevated command prompt and run these commands to....

### View your hypervisorlaunchtype setting

`bcdedit`

### Disable hypervisorlaunchtype (which enables VT-X)

`bcdedit /set {current} hypervisorlaunchtype off`

### Enable hypervisorlaunchtype (which disables VT-X)

`bcdedit /set {current} hypervisorlaunchtype Auto`

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

## Fix bad default permissions on files and directories

Add this to ~/.profile

```bash
# Fix bad default permissions - mask out the group and others
# write bit for both files and directories
if [[ "$(umask)" = "0000" ]]; then
  umask 0022
fi
```

