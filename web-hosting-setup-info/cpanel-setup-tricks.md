# WHM / CPanel Setup Tricks

Some common tasks you may want/need to perform on your cpanel server. 

## Get various system info:

```bash
#Get the main IP address of the server
cat  /var/cpanel/mainip
cat /var/cpanel/root.accts
cat /var/cpanel/nameserverips.yaml
cat /etc/hosts
```



## Tweak phpMyAdmin config

```bash
cd /usr/local/cpanel/base/3rdparty/phpMyAdmin
nano config.inc.php
# uncomment the lines for the pma username and password, 
# change the password to something long and random such as 'p%7PjDIUkvyUcozoLMpBiN147ee0iGDG', 
# and uncomment all lines for the pma tables. 
# Then in either mysql shell or phpMyAdmin sql editor, 
# run these commands...
```

Then...

```mysql
CREATE DATABASE phpmyadmin;
GRANT ALL PRIVILEGES ON phpmyadmin TO pma@localhost IDENTIFIED BY 'p%7PjDIUkvyUcozoLMpBiN147ee0iGDG';
```

Fix PHP process not found errors after upgrading some packages. 

You may see this type of error when logging into phpMyAdmin in CPanel after upgrading some software, particularly CURL on older CentOS systems, particularly if you used the cityfan repository to update to newer and unsupported system libs. 

> **Internal Server Error**
> 
> 500
> 
> No response from subprocess (php):

To check for the specific lib causing the error, watch the main CPanel error log:

```shell
 tail -f /usr/local/cpanel/logs/error_log
```

While that's running, try loading the problematic phpMyAdmin page. Look for something like this in the logs: 

```
2020-01-08 16:40:21 -0500] info [cpsrvd] version 11.84.0.19 online
/usr/local/cpanel/3rdparty/php/73/bin/php-cgi: error while loading shared libraries: libnghttp2.so.14: cannot open shared object file: No such file or directory
[2020-01-08 16:40:21 -0500] info [cpaneld] Internal Server Error: "GET /cpsess1234567890/3rdparty/phpMyAdmin/index.php HTTP/1.1" 500 No response from subprocess (php):
```

This is likely because a library is missing from /usr/lib64 or wherever you system looks for most of its core libs. FIrst locate the path of the actual lib which will likely be in a CPanel specific lib dir:

```bash
locate libnghttp2.so.14
```

If it's found, it should output something like 

```
/opt/cpanel/nghttp2/lib/libnghttp2.so.14
```

Now create a smylink to it in /usr/lib64 or in /lib64, or possibly in one of the directories listed in the configure command used to build your php version, which you can find at the top of your phpinfo screen if you look for the --libdir or  --with-libdir flags and try one of those dirs. Anyway, in my case I created the link in /usr/lib64.

```shell
cd /usr/lib64
ln -s /opt/cpanel/nghttp2/lib/libnghttp2.so.14 libnghttp2.so.14
```

This is not an ideal solution, but should work in a pinch. 

## Other possible solutions

**As per the "best" solution for this type of issue found here:**

 https://lonesysadmin.net/2013/02/22/error-while-loading-shared-libraries-cannot-open-shared-object-file/ 

**Tell the dynamic linker to look in additional places for the libs.** For example, to have it look in /usr/local/lib, open the config file: /etc/ld.so.conf and add /usr/local/lib to the end of it on its own line.  If you run 

```bash
cat /etc/ld.so.conf
```

the output might look like this:

```shell
include ld.so.conf.d/*.conf
/usr/local/lib
```

Or it might look totally different. Just add the additional lib directory to the end. Then run 

```shell
sudo ldconfig
```

Check it with 

```shell
ldconfig -p | grep local
```

## Enable xdebug for PHP

In WHM, the easiest way to install xdebug is via the php PECL installer built into WHM. Just look for a link called **"module installers"** under the "software" section. Once you locate it, just click the "manage" link in the PHP PECL section. At the bottom of that page you will see a list of any modules already installed, so you should check to be sure it's not installed already. If not, do a search for xdebug via the search box and install it via the GUI. Then, to use it, you'll either need to allow TCP port 9000 through your firewall in both directions, or use an ssh tunnel (preferred). Either way you'll need to tweak your xdebug config file. It will usually be in a php.d subdirectory in the dir where your php.ini file is...

`php -i|grep php.ini`

```bash
#find your php.ini....
php -i|grep php.ini

# you should see output such as....
# Configuration File (php.ini) Path => /opt/cpanel/ea-php73/root/etc
# Loaded Configuration File => /opt/cpanel/ea-php73/root/etc/php.ini
# In this case your config file for xdebug will likely be in 
# /opt/cpanel/ea-php73/root/etc/php.d/zzzzzzz-pecl.ini
# if it was installed via PECL (aka "pickle") it might be configured via
# or in a file suh as
# /opt/cpanel/ea-php73/root/etc/php.d/000-xdebug.ini

nano /opt/cpanel/ea-php73/root/etc/php.ini
```

you should see output such as....

`Configuration File (php.ini) Path => /opt/cpanel/ea-php73/root/etc`
`Loaded Configuration File => /opt/cpanel/ea-php73/root/etc/php.ini`

In this case your config file for xdebug will likely be in 

`/opt/cpanel/ea-php73/root/etc/php.d/zzzzzzz-pecl.ini`

or if it was not installed via PECL it might be in something like

`/opt/cpanel/ea-php73/root/etc/php.d/000-xdebug.ini`

Edit the file: 

`nano /opt/cpanel/ea-php73/root/etc/php.d/zzzzzzz-pecl.ini`

Put the following in to enable remote debug via ssh tunnel....

```
zend_extension="xdebug.so"
xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9000
xdebug.ide_key=PHPSTORM
```

Assuming you're using PUTTY for SSH, you'll need to set up a tunnel on port 9000. In the PUTTY, load a saved session for your server if you have one, or create one and save it. Then be sure it is loaded and then go to the connection options under the SSH section, click the "Tunnels" option. Under the "Source Port" put 9000. Under the destination put "localhost:9000". Click the "remote" radio button. Then click "ADD".    Here's a screenshot of how it should look:

![](https://raw.githubusercontent.com/minorgod/markdown-image-uploads/master/2020/02/07-19-15-09-image-20200207191141359.png)

Save these tunnel settings with your loaded connection settings by scrolling back up and clicking the "Session" option at the top of the settings list, then click "Save". 

If you did not want to use an SSH tunnels (bad idea), then you'll need to make sure that port 9000 is allowed through both your local and remote firewalls, and set up your xdebug config like this:

```ini
zend_extension="xdebug.so"
xdebug.remote_enable=1
xdebug.remote_port=9000
xdebug.ide_key=PHPSTORM
# Put your own ip address here...
xdebug.remote_host=123.456.789.111
# OR enable the remote_connect_back option below 
# to allow connections from any IP
#xdebug.remote_connect_back=1

```



