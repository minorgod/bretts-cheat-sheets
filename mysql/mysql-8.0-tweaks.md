---
title: MySQL 8.0 Tweaks
description: Some tweaks you might need to make to your MySQL 8.0 settings to make your life easier. 
---

# MySQL 8.0 Tweaks

## Ubuntu / Debian

In MySQL 8.0, the **default authentication plugin has changed** from mysql_native_password to caching_sha2_password, and the 'root'@'localhost' administrative account uses caching_sha2_password by default. If you prefer that the root account use the previous default authentication plugin (mysql_native_password), run this...

```bash
sudo mysql -u root -Bse "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; quit;"
```

For compatibility with older apps, when you upgrade from MySQL 5.6 to 5.7 or higher you might notice some errors related to "GROUP BY" clauses or other SQL errors that previously worked fine in MySQL 5.6 and lower. This is due to the new default **`sql_mode`** settings in MySQL 5.7 and higher. To permanently revert back to the old behavior you may need to edit the **`sql_mode`** variable in your mysqld config. In Ubuntu or other Debian based releases this is in:

 **`/etc/mysql/mysql.conf.d/mysqld.cnf`**

```ini
#The commented out line is what MySQL 5.7 defaults to in case you want to restore it. 
#sql_mode = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

#The important change here is the removal of ONLY_FULL_GROUP_BY and STRICT_TRANS_TABLES. The first one fixes errors in GROUP BY clauses that technically violate SQL standards (and can be found in x-cart SQL patches, and the 2nd one prevents errors when inserting empty values in NOT NULL columns which will normally throw an error even if a default value is defined in the table definition -- which also breaks x-cart sql patches.
sql_mode = NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

You could also put something like this in an SQL file if you just want to temporarily override some of the default mysql config vars:

```sql
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

# --- Now run your queries here

# --- Now restore the default settings...
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET SQL_MODE=@OLD_SQL_MODE;
```
