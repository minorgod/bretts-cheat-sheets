# WHM / CPanel Setup Tricks

Some common tasks you may want to perform on your cpanel server. 

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

