
*** fix unraid parity disk that was corrputed by old Gigabyte HPA bios feature (backing up bios in hidden partition without asking).

Ultimately the only real fix for this is to get a newer Gigabyte motherboard that has HPA disabled by default, or just don't use a Gigabyte motherboard for any RAID or unRaid functionality. 


First, find out which drive has the HPA enabled and whose usable size doesn't match its real size: 

```
hdparm -N /dev/[hs]d[a-z]
```

Then fix it with this commmand...
BE SURE TO USE THE CORRECT NUMBER...this is just an example of setting the size to 1953525168
The "p" before the number makes this change permanent. 

```
hdparm -N p1953525168 
```

Then run this again to see if it worked...

```
hdparm -N /dev/[hs]d[a-z]
```
