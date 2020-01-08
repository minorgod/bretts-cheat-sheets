# Set up SSL with LetsEncrypt in Nginx on CentOS7 using Google Cloud DNS

This info assumes you've already set up Google Cloud DNS for your domain via:

 https://console.cloud.google.com/net-services  

You might want to check out the PowerShell tools to manage DNS Zones via Windows Powershell:

 https://cloud.google.com/tools/powershell/docs/dns 

Lets assume you've already set up Nginx to host a site called **example.com**. 

## Install certbot plugin for nginx

```bash
sudo yum install -y epel-release && yum update
sudo yum install -y yum-utils
sudo  yum install -y python2-certbot-nginx 
#or for google cloud dns ....
sudo yum -y install python2-certbot-dns-google
```

### Install PIP to allow installing the various certbot plugins (or other plugins)

```bash
# This may be optional depending on what you're doing
sudo yum install -y python-pip
```

Create a google cloud service account or use an existing one and generate a key in JSON format at:  https://console.cloud.google.com/iam-admin/serviceaccounts 

Download and save the private key json file to your server at: 

`~/.secrets/certbot/credentials.json`

**NOTE:** If you copy/pasted the json string into nano you may need to fix some messed up ctrl characters by deleting some bogus newlines. 

## Run certbot with google cloud dns plugin using the service account credentials...

```bash
certbot certonly --dns-google --dns-google-credentials ~/.secrets/certbot/credentials.json -d *.example.com -d example.com
```

Now use certbot to install the cert in Nginx for any domains that already exist. This works best if you haven't already manually set up SSL because it will tweak your Nginx config for you and even take care of redirecting all non SSL traffic to SSL ...just follow the prompts. If it breaks your config, it will roll back automatically to the previous config. 

```bash
certbot --nginx
```

If, somehow, Nginx fails to restart you should make sure that any options such as the ones below are removed from the site config file because certbot includes them in a custom include file located at:

`/etc/letsencrypt/options-ssl-nginx.conf`

```
# These params are already set by the cerbot installer in
# include /etc/letsencrypt/options-ssl-nginx.conf

# ssl_session_cache shared:SSL:1m;
# ssl_session_timeout  10m;
# ssl_ciphers HIGH:!aNULL:!MD5;
# ssl_prefer_server_ciphers on;
```

## Set up Auto-Renew for the certs via a systemwide crontab entry:

```
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | tee -a /etc/crontab > /dev/null
```

Or just add this line to /etc/crontab...

```
0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
```

Congrats, your boss now thinks you are a wizard. 

