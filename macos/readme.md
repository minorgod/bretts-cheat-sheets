# MacOS - OSX Tricks

## Change the default text editor 

and file association for unknown file types (w/o restarting)

Install "duti"

```shell
brew install duti
```

Tsave a filetype like this as:

```shell
duti -s com.sublimetext.3 public.plain-text all
```

The changes should be applied immediately, so you don't have to restart like when editing `com.apple.LaunchServices.plist`.

To also change the default application for executable scripts with no filename extension, add a line like this:

```shell
duti -s com.sublimetext.3 public.unix-executable all
```

Some files are also considered 'public.data', not 'public.plain-text', so you can do this as well:

```shell
duti -s com.sublimetext.3 public.data all
```

## Rebuld Launch Services (file associations)

Run this command:

```shell
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

## Find the package an app is called

To change the file association for a given type you may need to find out the application bundle identifier to target the preferred app. Here's an example for doing this for VSCode...

```
/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' /Applications/Visual\ Studio\ Code.app/Contents/Info.plist
```

