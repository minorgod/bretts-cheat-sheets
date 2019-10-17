

# Windows Command Line Tricks

**Access a network share as a different user:**

```powershell
#the <domain>\ part is optional
net use \\<server>\<sharename> /USER:<domain>\<username> <password> /PERSISTENT:YES
```

**Create a mapped network drive as a different user:**

```powershell
#the <domain>\ part is optional
net use <driveletter>: \\<server>\<sharename> /USER:<domain>\<username> <password> /PERSISTENT:YES
```

**Delete Windows Icon Cache (Windows 10)**

```powershell
#run cmd.exe as admin then run these commands...
taskkill /f /im explorer. exe
cd /d %userprofile%\AppData\Local\Microsoft\Windows\Explorer attrib –h iconcache_*.db del iconcache_*.db start explorer
```

**Delete Windows Thumbnail Cache (Windows 10)**

```powershell
#run cmd.exe as admin then run these commands...
taskkill /f /im explorer. exe
cd /d %userprofile%\AppData\Local\Microsoft\Windows\Explorer attrib –h thumbcache_*.db del thumbcache_*.db start explorer
```



