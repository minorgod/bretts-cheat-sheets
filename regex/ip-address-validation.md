# IP Address Regular Expressions

[TOC]



## IP Address Validation regexes in various languages

### JavaScript IP Address validator

```
/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
```

### PHP IP address validator

```
/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
```

Also in PHP you can validate an IP address with filter_var() function:

```php
$valid = filter_var ( $string, FILTER_VALIDATE_IP );
```

### Java IP address validator

```
(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)
```

### Python IP Address Validator

```
^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$
```

### PERL IP Address validator

```
/^(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$/
```

### Ruby IP Address Validator

```
/^((?:(?:^|\.)(?:\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])){4})$/
```

### C# IP Address validator

```
^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$
```

### MySQL IP Address validator

```mysql
SELECT *
FROM tablename
WHERE 
columnname REGEXP '^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$'
```

### Swift IP address validator

```
^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$
```



## Other Examples

### Match Any IP Address in a Range

(eg: Match any IP address within the range **192.168.1.0** to **192.168.1.255**)

```
#this first one matches any ip starting with 192.168.1. regardless of the last octet
192\.168\.1\.
#this one matches any ip from 192.168.1.0 - 192.168.1.999, which means it will match invalid ips 
192\.168\.1\.\d{1,3}
```

