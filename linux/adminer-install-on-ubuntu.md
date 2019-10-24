# Installing Adminer on Apache2

## on Ubuntu 18 in 5 easy commands

```bash
#install adminer via apt-get
sudo apt-get install adminer
#create an adminer.conf file for apache2
sudo echo "Alias /adminer /usr/share/adminer/adminer" | sudo tee /etc/apache2/conf-available/adminer.conf
#enable the config
sudo a2enconf adminer.conf
sudo service apache2 reload
#or sudo apache2ctl reload
```


