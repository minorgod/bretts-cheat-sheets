# Set up SSL with LetsEncrypt in Nginx and CentOS7

Install certbot plugin for nginx

```bash
sudo yum install -y epel-release && yum update
sudo yum install -y yum-utils
sudo  yum install -y python2-certbot-nginx 
#or for google cloud dns ....
sudo yum -y install python2-certbot-dns-google
```

Install PIP to allow installing the various certbot plugins (or other plugins)

```bash
# This may be optional depending on what you're doing
sudo yum install -y python-pip
```

Create a google cloud service account and generate a key in JSON format at:  https://console.cloud.google.com/iam-admin/serviceaccounts 

Save the key to your server at: 

`~/.secrets/certbot/credentials.json`

NOTE: If you copy/pasted the json string into nano you may need to fix some messed up ctrl characters by deleting some bogus newlines. 

Run certbot with google cloud plugin using the service account credentials....

```bash
certbot certonly --dns-google --dns-google-credentials ~/.secrets/certbot/credentials.json -d *.example.com -d example.com
```

Now install the cert in NGINX

```bash
certbot --nginx
```

If Nginx fails to restart you should make sure that any options such as these are removed from the site config file because certbot includes them in a custom include file located at:

`/etc/letsencrypt/options-ssl-nginx.conf`

```
# These params are already set by the cerbot installer in
# include /etc/letsencrypt/options-ssl-nginx.conf

# ssl_session_cache shared:SSL:1m;
# ssl_session_timeout  10m;
# ssl_ciphers HIGH:!aNULL:!MD5;
# ssl_prefer_server_ciphers on;
```

Set up Auto-Renew for the certs via a systemwide crontab entry:

```
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | tee -a /etc/crontab > /dev/null
```

Or just add this line to /etc/crontab...

```
0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
```

