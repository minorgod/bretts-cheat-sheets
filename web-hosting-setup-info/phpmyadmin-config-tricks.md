# phpMyAdmin configuration tricks

phpMyAdmin can be a useful tool, but on RHEL/CentOS/Oracle Linux it is a pain in the ass to set up after you install it because it has very restrictive access controls by default. Also, you often only want to enable it temporarily for a specific remote IP address while you are setting up a new site, then lock it back down afterwards. This also is a pain in the ass. Hence I wrote these 2 scripts while I was working on setting up a LAMP stack on Oracle Linux (don't get me started...it wasn't my choice). They could probably easily be modified to work on Debian based distros such as Ubuntu as well. 

## Enable phpmyadmin remote access from current IP

```bash
#/bin/bash
#enable-phpMyAdmin-access-from-current-ip.sh

CURRENT_USER_IP=$(who am i|grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
echo "Enabling phpMyAdmin Access from your IP address: $CURRENT_USER_IP"

sed -E -i "s/(\s*)(Require ip 127\.0\.0\.1)/\1\2\n\1Require ip $CURRENT_USER_IP/" /etc/httpd/conf.d/phpMyAdmin.conf
sed -E -i "s/(\s*)(Allow from 127\.0\.0\.1)/\1\2\n\1Allow from $CURRENT_USER_IP/" /etc/httpd/conf.d/phpMyAdmin.conf

systemctl restart httpd.service
#or service apache2 restart
#or service httpd restart
#or apache2ctl restart
```

## Disable phpmyadmin remote access from current IP

```bash
#/bin/bash
#disable-phpMyAdmin-access-from-current-ip.sh

CURRENT_USER_IP=$(who am i|grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
ESCAPED_CURRENT_USER_IP=$(sed -E s/\\./\\\\./g <<< "$CURRENT_USER_IP")
echo "Disabling phpMyAdmin Access from your IP address: $CURRENT_USER_IP"
sed -E -i "s/(\s*)Require ip $ESCAPED_CURRENT_USER_IP//" /etc/httpd/conf.d/phpMyAdmin.conf
sed -E -i "s/(\s*)Allow from $ESCAPED_CURRENT_USER_IP//" /etc/httpd/conf.d/phpMyAdmin.conf
sed -E -i 's/\n\n/\n/' /etc/httpd/conf.d/phpMyAdmin.conf

systemctl restart httpd.service
#or service apache2 restart
#or service httpd restart
#or apache2ctl restart
```

## Add PPA source for newer phpmyadmin versions in Ubuntu

Ubuntu 18.04 has an old version of phpMyAdmin that throws php warnings all over the place in PHP 7.3. To upgrade to a newer version without those bugs (but possibly with some security issues), do this:

```shell
sudo add-apt-repository ppa:phpmyadmin/ppa
sudo apt-get update
sudo apt-get install phpmyadmin
```

## Debian Database Config

On Debian based systems (Ubuntu), the db config is auto generated via the settings in `/etc/dbconfig-common/phpmyadmin.conf`

## Helpful Config File Settings

```php
# In Debian linux, edit /etc/phpmyadmin/config.inc.php 
# or create a custom config file in the /etc/phpmyadmin/conf.d/ 
# and add the following stuff to it. 


$cfg['ServerDefault'] = 1; //log into first server by default
$cfg['Servers'][$i]['AllowRoot'] = true; //allow root logins
$cfg['Servers'][$i]['AllowNoPassword'] = true; //allow passwordless logins
$cfg['Servers'][$i]['AllowDeny']['order'] = 'allow,deny'; //deny by default and allow any explicity allowed users
#$cfg['Servers'][$i]['AllowDeny']['rules'][] = "allow % from localhost"; //allow from entire local subnet
#$cfg['Servers'][$i]['AllowDeny']['rules'][] = "allow % from localnetC"; //allow from entire local subnet
$cfg['LoginCookieValidity'] = 86400; //default 1440
$cfg['LoginCookieStore'] = 86400; //default 0
$cfg['ExecTimeLimit'] = 300; //max excecution time 
//The maximum number of table names to be displayed in the main panel’s list (except on the Export page).
$cfg['MaxTableList'] = 300; //default is 250
// table to store phpmyadmin settings in
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
//display server list as links instead of a dropdown...
$cfg['DisplayServersList'] = true;
// The number of first level databases that can be displayed on each page of navigation tree.
$cfg['FirstLevelNavigationItems'] = 100; //default 100
// The number of items (tables, columns, indexes) that can be displayed on each page of the navigation tree.
$cfg['MaxNavigationItems'] = 300; //default 50
// offer navigation tree expansion
$cfg['NavigationTreeEnableExpansion'] = true
// max num of recently used and favorited tables shown in nav tree, set to 0 to disable.
$cfg['NumRecentTables'] =  10; //default 10
$cfg['NumFavoriteTables'] = 10; //default 10
//Enables Zero Configuration mode in which the user will be offered a choice to create phpMyAdmin configuration storage in the current database or use the existing one, if already present. This setting has no effect if the phpMyAdmin configuration storage database is properly created and the related configuration directives (such as $cfg['Servers'][$i]['pmadb'] and so on) are configured.
$cfg['ZeroConf'] = true;
// show verbose info on main page...
$cfg['Servers'][$i]['verbose'] = true;
//show phpinfo
$cfg['ShowPhpInfo'] = true;
// show table structure actions instead of hiding them in a "more" dropdown
$cfg['HideStructureActions'] = false;
// show a "show all link" regardless of table size
$cfg['ShowAll'] = true;
// max rows shown when no limit clause is used
$cfg['MaxRows'] = 500; //default is 25

// show custom export default settings by default instead of 'quick'
$cfg['Export']['method'] = 'custom';
//how many chars to show by default on text cols
$cfg['LimitChars'] = 200; //default is 50
// Default primary key sort mode when no other sort is defined. Acceptable values : [‘NONE’, ‘ASC’, ‘DESC’]
$cfg['TablePrimaryKeyOrder'] = 'ASC';
// upload / save / import dirs...If you want different directory for each user, %u will be replaced with username.
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['TempDir'] = '';

// save queries in a history table in the db
$cfg['QueryHistoryDB'] = true;
$cfg['QueryHistoryMax'] = 2000; //default 25
//open, closed or disabled initial visual slider states
$cfg['InitialSlidersState'] = 'open';
// Activates a tab containing options for developers of phpMyAdmin in user prefs tab.
$cfg['UserprefsDeveloperTab'] = true;
// Enable logging queries and execution times to be displayed in the console’s Debug SQL tab.
// $cfg['DBG']['sql'] = true;



```

