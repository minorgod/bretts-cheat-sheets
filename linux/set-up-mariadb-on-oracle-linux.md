### Install mariadb

Oracle Linux repos contains MariaDB 5.6. You should update to version 10.2 - Do not upgrade to a higher version as it is no longer fully compatible with MySql after version 10.2. **Alternately, you can install MySQL 5.6 or MySQL 5.7 but you need to enable the repos that contains it or install the RHEL7 repos directly from the MySQL site.** 

```
#Remove old verison of MariaDB if installed
sudo mysql -u root -Bse "SET GLOBAL innodb_fast_shutdown=0;quit;"
sudo service mariadb-server stop
sudo service mysql stop
sudo service mysqld stop
sudo yum -y remove mariadb*
#install a newer version of mariadb repository...
sudo curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo sed -i 's/10.4/10.0/' /etc/yum.repos.d/mariadb.repo
sudo yum clean all
sudo yum -y update
sudo yum -y install mariadb-server
sudo service mysql start
#upgrade the db format
sudo mysql_upgrade

#Upgrade from MariaDB 10.0 to 10.1
sudo mysql -u root -Bse "SET GLOBAL innodb_fast_shutdown=0;quit;"
#Stop whichever version is installed...they change this command randomly so try both
sudo service mysql stop
sudo service mysqld stop
sudo yum -y remove MariaDB-*
sudo sed -i 's/10.0/10.1/' /etc/yum.repos.d/mariadb.repo
sudo yum -y update
sudo yum -y install mariadb-server
sudo service mysql start
sudo mysql_upgrade
#set mariadb to start on boot
chkconfig --level 35 mariadb on
chkconfig --level 35 mysql on
chkconfig --level 35 mysqld on


```

