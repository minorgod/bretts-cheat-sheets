# PSR-7 and PSR-15

Server Requests and Server Request Handlers

## What is Middleware?

I found [this great succinct explanation of middleware](https://github.com/mindplay-dk/middleman#middleware) in the documentation for a DI container implementation called "middleman" and it was such a good and brief explanation I'm saving it below for posterity just in case it disappears from its current home on GitHub. Also, check out [this great collection of PSR-15 middleware](https://github.com/middlewares) on GitHub. 

### Middleware?

Middleware is a powerful, yet simple control facility.

If you're new to the concept of middleware, the following section will provide a basic overview.

In a nutshell, a middleware component is a function (or [MiddlewareInterface](https://github.com/mindplay-dk/middleman/blob/master/src/MiddlewareInterface.php) instance) that takes an incoming (PSR-7) `RequestInterface` object, and returns a `ResponseInterface` object.

It does this in one of three ways: by *assuming*, *delegating*, or *sharing* responsibility for the creation of a response object.

#### 1. Assuming Responsibility

A middleware component *assumes* responsibility by creating and returning a response object, rather than delegating to the next middleware on the stack:

```php
use Zend\Diactoros\Response;

function ($request, $next) {
    return (new Response())->withBody(...); // next middleware won't be run
}
```

Middleware near the top of the stack has the power to completely bypass middleware further down the stack.

#### 2. Delegating Responsibility

By calling `$next`, middleware near the top of the stack may choose to fully delegate the responsibility for the creation of a response to other middleware components further down the stack:

```php
function ($request, $next) {
    if ($request->getMethod() !== 'POST') {
        return $next($request); // run the next middleware
    } else {
        // ...
    }
}
```

Note that exhausting the middleware stack will result in an exception - it's assumed that the last middleware component on the stack always produces a response of some sort, typically a "404 not found" error page.

#### 3. Sharing Responsibility

Middleware near the top of the stack may choose to delegate responsibility for the creation of the response to middleware further down the stack, and then make additional changes to the returned response before returning it:

```php
function ($request, $next) {
    $result = $next($request); // run the next middleware

    return $result->withHeader(...); // then modify it's response
}
```

The middleware component at the top of the stack ultimately has the most control, as it may override any properties of the response object before returning.