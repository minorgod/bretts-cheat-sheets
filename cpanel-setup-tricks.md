# WHM / CPanel Setup Tricks

Some common tasks you may want/need to perform on your cpanel server. 

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

