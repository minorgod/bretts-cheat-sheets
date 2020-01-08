# Generate LetsEncrypt SSL Cert on Windows with POSH ACME powershell client. 

Install the posh acme powershell module - run powershell as administrator or use sudo ([scoop](https://scoop.sh) install sudo)

```powershell
# install for all users (requires elevated privs)
Install-Module -Name Posh-ACME

# install for current user
Install-Module -Name Posh-ACME -Scope CurrentUser
```

Update the powershell module

```
update-module -name Posh-ACME
```

Save this as a powershell script and run it...set the PAServer to LE_STAGE if you want to run this against the LetsEncrypt staging server during testing. 

```powershell
#Set-PAServer LE_STAGE
Set-PAServer LE_PROD
$pArgs = @{GDKey='PUT_YOUR_GODADDY_API_KEY_HERE';GDSecret='PUT_YOUR_GODADDY_SECRET_KEY_HERE'}
New-PACertificate '*.example.com','example.com' -AcceptTOS -Contact someone@example.com -DnsPlugin GoDaddy -PluginArgs $pArgs -Verbose
Get-PACertificate | Format-List
```

**Certs will be saved by default to:** 

Windows: `%LOCALAPPDATA%\Posh-ACME`
Linux: `$HOME/.config/Posh-ACME`
MacOS: `$HOME/Library/Preferences/Posh-ACME`

**If you want to change the default location, set the POSHACME_HOME environment var....**

```powershell
$env:POSHACME_HOME = 'C:\my\path'
Import-Module Posh-ACME -Force
```

See this article for more info and caveats:  [https://github.com/rmbolger/Posh-ACME/wiki/%28Advanced%29-Using-an-Alternate-Config-Location](https://github.com/rmbolger/Posh-ACME/wiki/(Advanced)-Using-an-Alternate-Config-Location) 

If you get an error such as  `No order for ID 246802576` then clear the old order by running: 

```powershell
#use your account number here...
Set-PAAccount 12345678
#use your main domain here or if you set up a wildcard use that
Remove-PAOrder *.example.com
```

