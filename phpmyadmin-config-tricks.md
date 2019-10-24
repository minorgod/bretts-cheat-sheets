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
