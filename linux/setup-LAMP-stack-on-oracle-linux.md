# Setup LAMP Stack and Wordpress on Oracle Linux

Setup instructions based on Oracle Linux 7.6 running on Amazon EC2. 

Launch an EC2 instance with the official Oracle AMI: **ami-0688148b3659c6d16** or **ami-06e5c2a0f634abeb1**

Log in via ssh then set up some useful aliases...put these at the bottom of ~/.bashrc

```bash
echo "#make ls print out more useful info
alias lh='ls -alh'  2>/dev/null
#useful if you need to see all info about running processes:
alias ps='ps ax o pid,user,group,gid,%cpu,%mem,vsz,rss,tty,stat,start,time,comm'" >> ~/.bashrc
#now reload bashrc
source ~/.bashrc
```

#then run
source ~/.bashrc

Now, become root...

```bash
sudo su
```

Set up some useful aliases...put these at the bottom of ~/.bashrc

```bash
#make ls print out more useful info
alias ls='ls -alh'
#useful if you need to see all info about running processes:
alias ps='ps ax o pid,user,group,gid,%cpu,%mem,vsz,rss,tty,stat,start,time,comm'
```

#then again run
source ~/.bashrc

### Install essential tools

sudo yum -y install wget nano unzip gcc gcc-c++

### Install the latest EPEL repos so we don't have to use Oracle's ancient versions of GIT and other tools...
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

### Install ius repository for the same reason...

wget -O enable-ius.sh https://setup.ius.io/
chmod 700 enable-ius.sh
./enable-ius.sh
yum repolist

### Update our packages

```bash
yum clean all
yum -y update
```

### Enable replacing packages via yum-plugin-replace

```bash
yum -y install yum-plugin-replace
```



### Install MySQL 5.7 (or 5.6)

Oracle Linux repos contains MariaDB 5.6. You should update to version 10.2 - Do not upgrade to a higher version as it is no longer fully compatible with MySql after version 10.2. **Alternately, you can install MySQL 5.6 or MySQL 5.7 but you need to enable the repos that contains it or install the RHEL7 repos directly from the MySQL site.** 

Ensure that mysql and mariadb are completely uninstalled...

```bash
sudo yum -y remove mysql* mariadb* MariaDB*
#remove all data and configs...
rm -rf /var/lib/mysql
rm -f /etc/my.cnf
rm -rf /var/log/mysql
rm -rf /etc/my.cnf.d
rm -rf /var/log/mariadb
rm -f /var/log/mariadb/mariadb.log.rpmsave
rm -rf /var/lib/mysql
rm -rf /usr/lib64/mysql
rm -rf /usr/share/mysql

#remove any versions found by this command...
rpm -qa | grep mariadb
#if any found in previous command remove them like this, but substitute your verison
rpm -e --nodeps "mariadb-libs-5.5.56-2.el7.x86_64"


```



```bash
#cd /etc/yum.repos.d
#sudo wget http://public-yum.oracle.com/public-yum-ol7.repo

#install the mysql community repository from the oracle linux yum server
sudo yum install mysql-release-el7
sudo yum-config-manager --disable ius
sudo yum-config-manager --enable ol7_MySQL57
sudo yum clean all
sudo yum update
sudo yum -y install mysql-community-server
#start the service
sudo service mysqld start
#set mysqld to start on boot
sudo chkconfig --level 35 mysqld on

```

MySQL 5.7 logs the root password to /var/log/mysqld.log on first run, but makes you change it before you can do much. This will handle the full search for that password and will change it to a new randomly generated password and set it up so you can still log in with no password when running locally as root...

```bash
#find the auto-generated mysql root password
MYSQL_ROOT_PASSWORD=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
echo "MySQL root password:" "$MYSQL_ROOT_PASSWORD" 
#generate a new random password for use in mysql_secure_installation script...
MYSQL_ROOT_PASSWORD_NEW=$(openssl rand -base64 32)
echo "NEW MySQL root password:" "$MYSQL_ROOT_PASSWORD_NEW" 

# Now since we can't automate the mysql_secure_installation commandline program,
# let's cheat and generate a mysql_secure_installation.sql script that 
# will do exactly the same thing, and then run it as an sql file.
cat > mysql_secure_installation.sql << EOF
# Reset password using alter statement first becuase it has an expired password by default..
SET PASSWORD = PASSWORD('$MYSQL_ROOT_PASSWORD_NEW');
# Make sure that NOBODY can access the server without a password
UPDATE mysql.user SET authentication_string=PASSWORD('$MYSQL_ROOT_PASSWORD_NEW') WHERE User='root';
# Kill the anonymous users
DELETE FROM mysql.user WHERE User='';
# disallow remote login for root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# Kill off the demo database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
# Make our changes take effect
FLUSH PRIVILEGES;
EOF

#execute the secure install script...
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --connect-expired-password <mysql_secure_installation.sql

#now remove the script
rm -f mysql_secure_installation.sql

#now set up mysql client so local commandline connections from root user do not need a root password. 
cat > ~/.my.cnf << EOF
[client]
user=root
password=$MYSQL_ROOT_PASSWORD_NEW
EOF

#lock down that config file.
chmod 400 ~/.my.cnf

#now unset the mysql vars in our commandline since we shouldn't need them anymore
MYSQL_ROOT_PASSWORD=
MYSQL_ROOT_PASSWORD_NEW=

#set mysql to start on boot
chkconfig --level 35 mysqld on
```

### Update php repository info:

```bash
#install the oracle php release repository...
yum -y install oracle-php-release-el7
yum-config-manager --enable ol7_developer_php72
yum update
```

Don't bother trying to include xdebug in this install because nobody bothers to keep up with creating current binaries for Oracle linux. You'll have to install it from source or download a standalone binary and install yourself. 

```bash
sudo yum -y install httpd \
mod_ssl \
php \
php-cli \
php-common \
php-devel \
php-curl \
php-opcache \
php-xml \
php-bz2 \
php-intl \
php-mysqlnd \
php-odbc \
php-mbstring \
php-gd \
php-zip \
phpmyadmin
```

### Start Apache and configure it to run on boot

```bash
service httpd start
chkconfig --level 35 httpd on
```

### Add iptables rules

```bash
#!/bin/bash

#save this file to /root/firewall.sh
#then run: chmod u+x /root/firewall.sh
#then run this file to set up iptables rules.

# Set the default policies to allow everything while we set up new rules.
# Prevents cutting yourself off when running from remote SSH.
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush any existing rules, leaving just the defaults
iptables -F

# Open port 21 for incoming FTP requests...no thanks.
#iptables -A INPUT -p tcp --dport 21 -j ACCEPT

# Open port 22 for incoming SSH connections.
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# Limit to eth0 from a specific IP subnet if required.
#iptables -A INPUT -i eth0 -p tcp -s 192.168.122.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# Open port 80 for incoming HTTP requests.
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# Open port 443 for incoming HTTPS requests. (uncomment if required)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# *** Put any additions to the INPUT chain here.
#
# *** End of additions to INPUT chain.

# Accept any localhost (loopback) calls.
iptables -A INPUT -i lo -j ACCEPT

# Allow any existing connection to remain.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Reset the default policies to stop all incoming and forward requests.
iptables -P INPUT DROP
iptables -P FORWARD DROP
# Accept any outbound requests from this server.
iptables -P OUTPUT ACCEPT

# Save the settings.
service iptables save
# Use the following command in Fedora
#iptables-save > /etc/sysconfig/iptables

# Display the settings.
iptables -L -v --line-numbers
```



# NOW CHECK TO MAKE SURE APACHE IS SERVING THE DEFAULT WEB PAGE

If it's not serving the default page, figure out why before you proceed. 



# Configure Apache and other server software

You need to update some config files in the /etc directory on the new server with versions from the config backup repository:

https:// gitlab.aws.example.com/project-name/oracle-linux76-etc-files

This is a backup of our blog SERVER config files from the instances running on Amazon Linux EC2. They are synced to git repositories running on the qa and prod servers locally, via a server config backup program called "etckeeper". It would be wise to install this same software on the new servers so config files will be backed up an version controlled any time they change. It makes it very easy to recover from configuration mistakes. To do that, look at [these instructions](set-up-etckeeper-to-track-server-config-changes.md).

## Apache Config Files

Copy these files to the corresponding subdirectories in the /etc/ folder on the new server: 

Main Config File: [/etc/httpd/conf/httpd.conf](https:// gitlab.aws.example.com/project-name/oracle-linux76-etc-files/blob/qa/httpd/conf/httpd.conf)

: [/etc/httpd/conf.d/example.com.conf](https:// gitlab.aws.example.com/project-name/oracle-linux76-etc-files/blob/qa/httpd/conf.d/example.com.conf)

You will need to copy the SSL cert from the old server to the new server:

```
/etc/pki/tls/certs/www.qa.example.com-02072017.crt
/etc/pki/tls/private/www.qa.example.com-02072017.key
```

### Enable phpMyAdmin access (optional)

If you need to use phpMyAdmin you will need to edit the config file to allow remote access. You can either enable for all IPs or just your own. Edit 

```
/etc/httpd/conf.d/phpMyAdmin.conf
```

In the <RequireAny> section, for the /usr/share/phpMyAdmin/ directory and the  /usr/share/phpMyAdmin/setup/ directory add:

```
Require all granted
#or add your ip like this...
Require ip 12.69.225.90
```

Then open /etc/phpMyAdmin/config.inc.php. Tweak the settings as needed...

```
sudo sed -i "s/$cfg['Servers'][$i]['AllowRoot']     = FALSE;/s/$cfg['Servers'][$i]['AllowRoot']     = TRUE;/" /etc/phpMyAdmin/config.inc.php
sudo sed -i "s/$cfg['Servers'][$i]['pmadb']         = ''/$cfg['Servers'][$i]['pmadb']         = 'phpmyadmin'/" /etc/phpMyAdmin/config.inc.php
```

The actual phpMyAdmin dir is: /var/lib/phpMyAdmin/upload

```
#give read only access to db and user tables in mysql database
CREATE USER "pma"@"%" IDENTIFIED BY "password";
CREATE USER "pma"@"localhost" IDENTIFIED BY "password";
GRANT SELECT (`Db`, `User`) ON `mysql`.`db` TO 'pma'@'%';
GRANT SELECT (`Db`, `User`) ON `mysql`.`db` TO 'pma'@'localhost';
flush privileges;
quit;

```



### PHP Config File

There is a file from the old server at: 

`/etc/httpd/conf.modules.d/10-php-conf.5.6`

but you probably don't want to use it as-is since it's from a very old version of php. Instead, just open the new php.ini file located at:

```
/etc/php.ini
```

And customize a few variables:

```
#This is ridiculously large, but if you need to upload a mysql dump file via phpMyAdmin it will be useful, otherwise set it to 20M
post_max_size = 200M

# again, for phpMyAdmin uploads if you need them
upload_max_filesize = 200M

#The rest of these are really just for PROD environment. The error_reporting
#value can be tweaked further (add & ~E_WARNING) if you still see unwanted php errors.
display_errors=Off
error_reporting=E_ALL & ~E_DEPRECATED & ~E_STRICT

```

You can edit the files automagically with these commands...

```
sudo sed -i 's/^post_max_size=8M/post_max_size = 200M/' /etc/php.ini
sudo sed -i 's/^upload_max_filesize = 8M/upload_max_filesize=200M/' /etc/php.ini
sudo sed -i 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_STRICT/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/' /etc/php.ini
```



### Install git from ius repos

```bash
yum -y install git2u
```

### Set up the git server

You need a git repository on the new server so you can deploy to the server by pushing your local changes to it and the site can be served from a version-controlled directory. 

```bash
sudo adduser git
su git
#move into git home dir
cd
#set up ssh access for git
mkdir .ssh && chmod 700 .ssh
touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
#now switch back to non-root user
exit
```

### Add the ec2-user's authorized keys to the git user's authorized_keys

```bash
sudo cat /home/ec2-user/.ssh/authorized_keys >> /home/git/.ssh/authorized_keys

mkdir /srv/git
git init --bare /srv/git/carwise-blog.git
chown -R git:git /srv/git/carwise-blog.git/
```

Now set up post-receive hooks to automatically run the frontend build scripts when you push to the remote repository.  Create at post recieve hook file: **/srv/git/carwise-blog.git/hooks/post-receive**

```bash

#!/bin/sh
#
# /srv/git/carwise-blog.git/hooks/post-receive
#

#IMPORTANT!!!
#SET THE BRANCH TO 'develop' in QA or DEV and 'production' in PROD environments
BRANCH="develop"
SITE_NAME="Carwise Blog (QA)"
#IMPORTANT: Make sure this path matches the root directory of the live site
# NOT the public_html directory, but the parent directory of that dir!!!
SITE_PATH="/home/ec2-user/blog"

echo "**** $SITE_NAME [post-receive] hook received."

while read oldrev newrev ref
do
  branch_received=`echo $ref | cut -d/ -f3`

  echo "**** Received [$branch_received] branch."

  # Making sure we received the branch we want.
  if [ $branch_received = $BRANCH ]; then
    cd $SITE_PATH

    # Unset to use current working directory.
    unset GIT_DIR

    echo "**** Pulling changes."
    git pull origin $BRANCH

    # Instead of pulling we can also do a checkout.
    #: '
    #echo "**** Checking out branch."
    #GIT_WORK_TREE=$SITE_PATH git checkout -f $BRANCH
    #'

    # Or we can also do a fetch and reset.
    #: '
    #echo "**** Fetching and reseting."
    #git fetch --all
    #git reset --hard origin/$BRANCH
    #'

  else
    echo "**** Invalid branch, aborting."
    #exit 0

  fi
done

# [Restart/reload webserver stuff here]

echo "**** Done."

exec git-update-server-info

```

Now push your local version of the repository to the remote server...use TortoiseGit or commandline with the remote url in this format: 

```bash
git@ec2-3-84-29-80.compute-1.amazonaws.com:/srv/git/carwise-blog.git
```

# Wordpress Setup

Create wordpress database and user and grant priviliges...note the command is surrounded by single quotes...this is important to prevent unix expansion of dashes in the username...

```bash
sudo mysql -u root -Bse '
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE wordpress;
CREATE USER "wordpress-user"@"%" IDENTIFIED BY "wordpress-user-password";
CREATE USER "wordpress-user"@"localhost" IDENTIFIED BY "wordpress-user-password";
CREATE USER "wordpress-user"@"127.0.0.1" IDENTIFIED BY "wordpress-user-password";
GRANT ALL PRIVILEGES ON wordpress TO "wordpress-user"@"%";
GRANT ALL PRIVILEGES ON wordpress TO "wordpress-user"@"localhost";
GRANT ALL PRIVILEGES ON wordpress TO "wordpress-user"@"127.0.0.1";
flush privileges;
use mysql;
update user set plugin="mysql_native_password" where user="wordpress-user";
flush privileges;
quit'
```

You will want to add the user that will own the web files to the apache group:

```bash
sudo usermod -a -G apache ec2-user
```

IMPORTANT-- MAKE SURE YOU ARE NOT ROOT USER NOW -- execute these commands as ec2-user to prevent permission issues.** 

Now on the remote server, clone the local repository to the `/home/ec2-user/blog` folder or wherever it will be served from ....

```bash
git clone -v --progress file://git@/srv/git/carwise-blog.git /home/ec2-user/blog
cd blog

#Set owner and permissions on the wordpress files...
sudo find . -exec chown ec2-user:apache {} +
sudo chmod -R 750 .
sudo find . -type f -exec chmod 660 {} +
#sudo find . -type d -exec chmod 775 {} +
sudo chmod 660 public_html/wp-config.php
#make the uploads folder group writable...
chmod -R g+w ./public_html/wp-content/uploads
```

Now checkout `develop` branch you're setting up the QA server, or the `production` branch if you're setting up prod. 

```bash
git checkout develop

#install composer dependencies
composer install

#Install Nodejs/npm LTS version (via node version manager)
cd ~
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source ~/.profile     ## Debian based systems 
source ~/.bashrc      ## CentOS/RHEL systems 
nvm install lts/*

#install gulp and bower globally 
npm i -g gulp bower

#build the frontend in the themes directory...
cd ~/blog/public_html/wp-content/themes/sage-8.4.2
npm install
bower install
gulp --production
```

To prevent issues related to the configuration of the Wordpress Wordfence and All In One security plugins you should log into the blog and disable those plugins before making a backup. If you forget to do this, you may need to manually remove the wordfence config from the .htaccess file in the blog/public_html folder to get wordpress working, as well as temporarily renaming the following directories to deactivate the plugins.

Install/Update the Wordpress CLI tool on the old and new servers...this will upgrade the existing wp-cli version if it's there.

```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#check the Phar file to verify that it’s working:
php wp-cli.phar --info
#Make the file executable and move it to somewhere in your PATH. For example:
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
```

Now, deactivate the security plugins on the new server if they aren't already...they can be re-enabled after the blog is up and running and they will reconfigure themselves for the new server. 

```bash
wp plugin list --path=$HOME/blog/public_html/
wp plugin deactivate all-in-one-wp-security-and-firewall --path=$HOME/blog/public_html/
wp plugin deactivate wordfence --path=$HOME/blog/public_html/
```

### Create a backup of the old blog directory and download to your local machine. 

Log into the old prod or qa server in a different ssh session and dump the database. You can either archive the whole wordpress directory with a db dump by running the backup script, or you can quickly generate just the mysql dump file if you just want the database, which is much faster. 

```bash
# Backup the entire blog directory to a tgz file with a name like: blog_${NOW}.tgz
# A copy of this backup script is in the carwise-blog 
# git repository in the server-config folder)
# You can ignore any Permission Denied errors on the wp-content/wflogs 
# directory as these are server-generated log files used by the Wordfence plugin. 

backup_blog_db_and_files.sh

#Or Create just a dump of the database...
mysqldump --host=localhost --user=wordpress-user --password=wordpress-user-password wordpress > ~/wordpress-db-dump.sql
```

### Download the Dump file and images to your local pc and upload them to the new server

You can do this manually via whatever program you want, or use these scripts located in the server-config directory of the git repository:

```
copy-old-db-to-new-server.cmd
copy-images-to-new-server.cmd
```

Set the variables in the scripts above and it will automatically create the dump files, download them to your machine, then upload them to the remote server and load them appropriately. Otherwise, download and open the backup on your machine and upload the sql dump file, and the /wp-content/uploads directory from the archive. 

### Upload the .env file to the /blog folder

**IMPORTANT:** without this file, nothing will work. 

In the backup archive there will be a **.env** file in the root /blog folder. Customize this file for the new environment if needed, and upload it to the new blog server's /blog folder (not the public_html folder!!!). In particular, if you're seeing php notices and errors on parts of the blog, be sure to set `WP_DEBUG=false` in the .env file. 

### **Wordpress Post-Install Setup**

You will likely need to remove the following sections from your ```~/blog/public_html/.htaccess``` file

```bash
# BEGIN All In One WP Security
...remove or comment out everything in here
# END All In One WP Security

# Wordfence WAF
...remove or comment out everything in here
# END Wordfence WAF

```

Run a search/replace on the hostname if you need to make sure stuff points to the new server hostname...

```bash
NEW_WP_HOSTNAME="ec2-54-234-253-55.compute-1.amazonaws.com"
wp search-replace --path=$HOME/blog/public_html 'www.qa.example.com' $NEW_WP_HOSTNAME
wp search-replace --path=$HOME/blog/public_html 'qa.example.com' $NEW_WP_HOSTNAME
```

Create a new wordpress admin user if you need to...

```bash
wp user create newusername newuser@somedomain.com --path=$HOME/blog/public_html --role=administrator --user_pass=newuserpassword --display_name="New User"
```

Now log into the new wordpress server instance via the ec2 hostname:

https://ec2-54-234-253-55.compute-1.amazonaws.com/blog/wp-admin

If everything seems to be working okay, re-enable the security plugins either via the plugins admin page, or by running:

```
wp plugin activate all-in-one-wp-security-and-firewall --path=$HOME/blog/public_html/
wp plugin activate wordfence --path=$HOME/blog/public_html/
```

### Troubleshooting

If you get an "access denied" error or a blank page, you may need to change the directory permissions for your user's home folder to "chmod 755" to allow group read/execute permissions. 

If theme images or js/css files aren't loading, try rebuilding the frontend files:

```
cd /home/ec2-user/blog/public_html/wp-content/themes/sage-8.4.2
npm install
bower install
gulp --production
```

If only the blog post images aren't loading, open the Adaptive Images Plugin settings admin page and click the "save settings" button.

