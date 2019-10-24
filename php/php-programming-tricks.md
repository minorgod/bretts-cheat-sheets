# Some useful PHP tricks

## Check if a php script was invoked by cli versus a normal web request.

You might think you could just use ....

 ```return php_sapi_name() === 'cli'```

..however you would be wrong since there are many ways the php interpreter can be invoked via command line and have it return something other than "cli". So your best bet is to check the return value of http_response_code() like this:

```php
function isCliRequest(){
    return php_sapi_name() == 'cli' || php_sapi_name() == 'cgi-fcgi' || http_response_code() == false;
}
```

With web requests  http_response_code() will always return an integer. For cli requests you will always get a boolean false, or if you pass a response code to http_response_code(200) you will get back a boolean true. 

See: https://www.php.net/http_response_code

## Unserialize Exceptions

Use this pattern to fix unserialize errors caused by saving UTF8 characters in a table with Latin1 collation

```php
// assume $value is some object you retrieved from a db 
// containing sessiondata as a php serialized string.

if(!empty($value->sessiondata) && is_string($value->sessiondata)){

    try{
        $value->sessiondata = unserialize($value->sessiondata);
     }catch(Exception $e){
         //use preg_replace_callback to pass an inline function that fixes the string...you'll lose whatever the special UTF8 chars were, but you'll at least be able to unserialize the data. 
        $value->sessiondata = preg_replace_callback (
            '!s:(\d+):"(.*?)";!',
            function($match) {
                return ($match[1] == strlen($match[2])) ? $match[0] : 's:' . strlen($match[2]) . ':"' . $match[2] . '";';
            }, 
            $value->sessiondata
        );

        //now you should be able to unserialize the string             
        $value->sessiondata = unserialize($fixed_serialized_data);
        //print_r($value->sessiondata);
        //exit;
    }

}
```
