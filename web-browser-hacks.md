# Web Browser Hacks

Just random stuff on web browsers.

## Chrome / Chromium SSL Cert Warning Bypass

Chome has  a secret word you can type to bypass the SSL Cert problems when using an invalid SSL cert during development. It changes periodically and is not properly documented anywhere that I know of, but you can find it out by opening your javascript console and pasting this snippet:

```javascript
console.log(window.atob('dGhpc2lzdW5zYWZl'))
```

You should see this output the string "thisisunsafe", or whatever the current secret passphrase is. So, if you need to bypass the ssl cert warning on a page, just type that string immediately after trying to load the page at it will continue loading the page normally. 

You can see the Chromium source code that is responsible for this [here](https://chromium.googlesource.com/chromium/src/+/refs/heads/master/components/security_interstitials/core/browser/resources/interstitial_large.js).

