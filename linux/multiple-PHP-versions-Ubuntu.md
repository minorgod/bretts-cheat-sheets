

# Setup multiple PHP versions on Ubuntu

**Install python software properties package**

```shell
#this may not be needed, but try it first...
sudo apt install python-software-properties
```

**Add the ppa:ondrej/php repository.** 

```shell
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```

**With Apache (mod-php)...**

```shell
sudo apt-get install php5.6
sudo apt-get install php7.0
sudo apt-get install php7.1
sudo apt-get install php7.2
sudo apt-get install php7.3
sudo apt-get install php7.4
```

**With Nginx (php-fpm)...**

```shell
sudo apt-get install php5.6-fpm
sudo apt-get install php7.0-fpm
sudo apt-get install php7.1-fpm
sudo apt-get install php7.2-fpm
sudo apt-get install php7.3-fpm  
sudo apt-get install php7.4-fpm  
```

To install any PHP modules, simply specify the PHP version and use the auto-completion functionality to view all modules as follows.

```shell
#Note: this does not work for me
------------ press Tab key for auto-completion ------------ 
$ sudo apt install php5.6 
$ sudo apt install php7.0 
$ sudo apt install php7.1
$ sudo apt install php7.2
$ sudo apt install php7.3 
$ sudo apt install php7.4
```

**Set the default version of php**

```shell
sudo update-alternatives --set php /usr/bin/php7.4
```

**For apache2, disable the old version and enable the new version**

```bash
# a2dismod php7.2
# a2enmod php7.3
a2dismod php7.3
a2enmod php7.4
```

**Install typical php-extensions**

```shell
apt-get install php-common php-mbstring php-mysql php-curl php-zip php-xdebug php-bcmath php-json php-tokenizer php-xml php-gd php7.4-opcache php-sqlite3 php-odbc

#or
apt-get install php7.4-common php7.4-mbstring php7.4-mysql php7.4-curl php7.4-zip php7.4-xdebug php7.4-bcmath php7.4-json php7.4-tokenizer php7.4-xml php7.4-gd php7.4-opcache php7.4-sqlite3 php7.4-odbc

```

**Enable xdebug remote debugging if needed**

```shell
echo 'xdebug.remote_enable=1' >> /etc/php/7.4/mods-available/xdebug.ini
```

**Check apache config syntax**

```shell
apache2ctl -t
```

**Restart apache2**

```shell
sudo apache2ctl restart
# or sudo service apache2 restart
```



