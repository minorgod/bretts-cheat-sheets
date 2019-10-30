# URL Regex Matchers

These were all stolen from  http://urlregex.com/ 

## PHP (use with [preg_match](http://php.net/manual/en/function.preg-match.php))

```
%^(?:(?:https?|ftp)://)(?:\S+(?::\S*)?@|\d{1,3}(?:\.\d{1,3}){3}|(?:(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)(?:\.(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)*(?:\.[a-z\x{00a1}-\x{ffff}]{2,6}))(?::\d+)?(?:[^\s]*)?$%iu
```

## PHP (with [validate filter](http://php.net/manual/en/filter.filters.validate.php))

```
if (filter_var($url, FILTER_VALIDATE_URL) !== false)...
```

## Python

```
http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+
```

## Javascript

```
/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/
```

## HTML5

```
<input type="url" />
```

Below is the regex used in type=”url” from [RFC3986](https://www.ietf.org/rfc/rfc3986.txt):

```
^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
```

## Perl

```
^(((ht|f)tp(s?))\://)?(www.|[a-zA-Z].)[a-zA-Z0-9\-\.]+\.(com|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk)(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*$
```

## Ruby

```
/\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i
```

## Go (use the govalidator [IsURL()](hhttps://github.com/asaskevich/govalidator/blob/master/validator.go#L49))

```
package main
 import (
         "fmt"
         "github.com/asaskevich/govalidator"
 )
 func main() {
         str := "http://www.urlregex.com"
         validURL := govalidator.IsURL(str)
         fmt.Printf("%s is a valid URL : %v \n", str, validURL)
 }
```

## Objective-C

```
(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+
```

## Swift

```
((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?
```

Use it in a function:

```
func canOpenURL(string: String?) -> Bool {
    let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
    return predicate.evaluateWithObject(string)
}
```

Usage:

```
if canOpenURL("http://www.urlregex.com") {
    print("valid url.")
} else {
    print("invalid url.")
}
```



## Swift (use [canOpenURL](https://developer.apple.com/reference/uikit/uiapplication/1622952-canopenurl))

```
UIApplication.sharedApplication().canOpenURL(urlString)
```

## Java

```
^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]
```

## VB.NET

```
(http(s)?://)?([\w-]+\.)+[\w-]+[.com]+(/[/?%&=]*)?
```

## C#

```
^(ht|f)tp(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?$
```

## MySQL

```
SELECT field FROM table 
WHERE field 
REGEXP "^(https?://|www\\.)[\.A-Za-z0-9\-]+\\.[a-zA-Z]{2,4}
```

------

### Bonus: What does the following regex do?

```
/^1?$|^(11+?)\1+$/
```