## Fix Corrupted Parity Disk caused by Gigabyte HPA bios feature

*** fix unraid parity disk that was corrputed by old Gigabyte HPA bios feature (backing up bios in hidden partition without asking).

Ultimately the only real fix for this is to get a newer Gigabyte motherboard that has HPA disabled by default, or just don't use a Gigabyte motherboard for any RAID or unRaid functionality. 


First, find out which drive has the HPA enabled and whose usable size doesn't match its real size: 

```bash
hdparm -N /dev/[hs]d[a-z]
```

Then fix it with this commmand...
BE SURE TO USE THE CORRECT NUMBER...this is just an example of setting the size to 1953525168
The "p" before the number makes this change permanent. 

```bash
hdparm -N p1953525168 
```

Then run this again to see if it worked...

```bash
hdparm -N /dev/[hs]d[a-z]
```

## Fix SMB Share Permissions in Windows Clients

By default, Windows connects with the user "nobody" the first time you access an SMB share that has no defined credentials. Then when you secure a shared folder in UNRAID, you'll get an "access denied" error when trying to read or modify the protected or private files from your windows machine. To fix this, first make sure you've added the desired user/password in UNRAID admin interface and applied the user to the share in UNRAID. Then to fix the "permission denied" on the Windows machine open the Windows Credential Manager via "Control Panel--->Credential Manager". Add a new windows credential for the username you added in UNRAID with both the IP address and the hostname of the UNRAID server (add 2 credentials). Then disable and re-enable your windows network adapter so it will disconnect with the default "nobody" user and reconnect using the new credentials. Viola!