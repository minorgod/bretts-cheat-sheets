# Random Linux Stuff

Nope, there's on rhyme or reason to what's in here. 

## Find the sha256 fingerprint of all your ssh keys in a directory or subdir.

This is particularly useful if you are trying to match the fingerprint of a local key to one on GitHub because you didn't have a good naming convention and got confused about which key was which. 

```
 find ./ -type f -name "*" -exec ssh-keygen -E sha256 -lf "{}" \;
```

## Pipe a bunch of commands from a shell script into ssh...

```
ssh -i /path/to/private.key username@hostname 'bash -s' < /path/to/test.sh
```

**NOTE: If you need to look at your systemd config files they will be in:** 

**/etc/systemd/system/multi-user.target.wants/**

If, for some reason mysql/mariadb does not start, you may need to manually init the data dir and set mysql to be daemonized...

### Also, this is not applicable unless you're running mysql8 or higher, but...

In MySQL 8.0, the default authentication plugin has changed from mysql_native_password to caching_sha2_password, and the 'root'@'localhost' administrative account uses caching_sha2_password by default. If you prefer that the root account use the previous default authentication plugin (mysql_native_password), run this...

```bash
sudo mysql -u root -Bse "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
quit;"
```