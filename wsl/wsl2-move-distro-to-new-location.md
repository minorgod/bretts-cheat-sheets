# Moving a Linux Distro in WSL1 or WSL2

A utility called **lxrunoffline** can be used to relocate a distro. It used to only work with WSL1 and required converting a WSL2 image to a WSL1 image first, but now it works with both types of images. Here's the commands to install it via Chocolatey and then use it to move a distro.  

```powershell
# Install lxrunoffline via chocolatey. You could also use Scoop.sh if you prefer.
# Once installed you will likely need to close and reopen your command prompt for
# lxrunoffline to be available as a command. 
choco install lxrunoffline

# List your distros so you know what the exact name of the distro is you are 
# trying to move...
lxrunoffline list

# Move your distro. Be sure to move it to a subdirectory of the new location 
# or you'll end up with all your distro's files in the root \wsl directory 
# which will cause issues if you want to keep multiple distros there. 
lxrunoffline move -n kali-linux -d C:\wsl\kali-linux\
```

WARNING: If you move a distro into the root \wsl folder rather than a subfolder and then you try to move it directly from there to a subfolder, you may get a crazy recursive loop where the filesystem keeps duplicating the image into a new subdirectory and fills up your entire hard drive. I did this with kali-linux. I initially move it via this command...

```powershell
lxrunoffline move -n kali-linux -d C:\wsl\
```

then when I ran this command

```
lxrunoffline move -n kali-linux -d C:\wsl\kali-linux\
```

I ended up with this....

```powershell
C:\wsl\kali-linux\kali-linux\kali-linux\kali-linux\kali-linux\kali-linux\....
# This just kept on going until my drive was full. EEEK! 
```

So, if you need to move a distro that has been accidentally moved into the root \wsl folder without a subdirectory, first move it to a different root directory with the desired subdirectory structure such as:

```
lxrunoffline move -n kali-linux -d C:\wsl-temp\kali-linux\
```

then move it to the final destination...

```
lxrunoffline move -n kali-linux -d C:\wsl\kali-linux\
```

