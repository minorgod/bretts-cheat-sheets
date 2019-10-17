# MySQL 5.7 Tweaks

Ubuntu / Debian

For compatibility with older apps, you may need to add something like this to your mysqld config...in Ubuntu or other Debian based releases this is in:

 `/etc/mysql/mysql.conf.d/mysqld.cnf`

```mysql
#The commented out line is what MySQL 5.7 defaults to in case you want to restore it. 
#sql_mode = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

#The important change here is the removal of ONLY_FULL_GROUP_BY and STRICT_TRANS_TABLES. The first one fixes errors in GROUP BY clauses that technically violate SQL standards (and can be found in x-cart SQL patches, and the 2nd one prevents errors when inserting empty values in NOT NULL columns which will normally throw an error even if a default value is defined in the table definition -- which also breaks x-cart sql patches.
sql_mode = NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

You could also put something like this in an SQL file if you just want to temporarily override some of the default mysql config vars:

```mysql
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

# --- Now run your queries here

# --- Now restore the default settings...

SET FOREIGN_KEY_CHECKS=@ORIGINAL_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@ORIGINAL_UNIQUE_CHECKS;
SET SQL_MODE=@ORIGINAL_SQL_MODE;
```

