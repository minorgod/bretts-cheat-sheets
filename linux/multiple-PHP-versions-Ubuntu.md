

# Setup multiple PHP versions on Ubuntu

**Install python software properties package**

```
#this may not be needed, but try it first...
sudo apt install python-software-properties
```

**Add the ppa:ondrej/php repository.** 

```
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```

**With Apache (mod-php)...**

```
sudo apt-get install php5.6
sudo apt-get install php7.0
sudo apt-get install php7.1
sudo apt-get install php7.2
sudo apt-get install php7.3
```

**With Nginx (php-fpm)...**

```
sudo apt-get install php5.6-fpm
sudo apt-get install php7.0-fpm
sudo apt-get install php7.1-fpm
sudo apt-get install php7.2-fpm
sudo apt-get install php7.3-fpm  
```

To install any PHP modules, simply specify the PHP version and use the auto-completion functionality to view all modules as follows.

```
#Note: this does not work for me
------------ press Tab key for auto-completion ------------ 
$ sudo apt install php5.6 
$ sudo apt install php7.0 
$ sudo apt install php7.1
$ sudo apt install php7.2
$ sudo apt install php7.3 
```

**Set the default version of php**

```
sudo update-alternatives --set php /usr/bin/php7.3
```

**For apache2, disable the old version and enable the new version**

```
a2dismod php7.2
a2enmod php7.3
```

**Install typical php-extensions**

```
apt-get install php-common php-mbstring php-mysql php-curl php-zip php-xdebug php-bcmath php-json php-tokenizer php-xml php-gd php7.3-opcache php-sqlite3 php-odbc
```

**Enable xdebug remote debugging if needed**

```
echo 'xdebug.remote_enable=1' >> /etc/php/7.3/mods-available/xdebug.ini
```

**Check apache config syntax**

```
apache2ctl -t
```

**Restart apache2**

```
sudo apache2ctl restart
# or sudo service apache2 restart
```



