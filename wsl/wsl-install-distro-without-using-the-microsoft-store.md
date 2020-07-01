# Install a Linux Distro without using the Microsoft Store

The wiki for the excellent "lxrunoffline" program keeps a list of alternative distros available at:

https://github.com/DDoSolitary/LxRunOffline/wiki

You can also find a larger list of unofficial distros here:

https://github.com/sirredbeard/Awesome-WSL#unofficial-distributions

You can also find manual distro installation instructions on the Microsoft site, along with the latest official list of available distros:

https://docs.microsoft.com/en-us/windows/wsl/install-manual



## Install Alpine Linux for WSL via PowerShell

Open powershell then...

```powershell
# Create a function to help you get the filename from the url...
Function Get-RedirectedUrl {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )

    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()

    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

# Now get the filename...
$uri = "http://lxrunoffline.apphb.com/download/Alpine"
$fileName = [System.IO.Path]::GetFileName((Get-RedirectedUrl $uri))
$destination = "$env:userprofile\Downloads\wsl-distros\$fileName"
# Now use bitstransfer to get the file (this is more memory efficient than using Invoke-WebRequest because it doesn't buffer the whole thing in memory)
Import-Module bitstransfer
start-bitstransfer -source $uri -destination $destination
#now install the distro 
LxRunOffline i -n alpine-linux -d "c:\WSL\alpine-linux" -f $destination -s
```

