# Better Vault Tools

Special thanks to https://github.com/gites/awesome-vault-tools for helping me find these!

## Vaku

This thing is soooo much better than the standard vault cli it's not even funny. There are several other vault cli tools out there that do similar things, but this one seems to be the nicest by far and is the only one I found that is under active development. 

Github:  https://github.com/Lingrino/vaku

```
brew install lingrino/tap/vaku
```

Recursively list all folders under a given mount

```
vaku folder list my-mount-point --format=json
```

Outputs something like:

```
[
    "some-project",
    "some-other-project",
    "blah-blah-blah",
    "blah-blah-blah/some-service",
    "blah-blah-blah/some-other/service"
]
```

Recursively read all secrets in a folder - good to TEMPORARILY back up your secrets in case you mung things up with one of the other commands. 

```shell
vaku folder read my-mount-point --format=json
vaku folder read my-mount-point --format=text
```

Recursively move all secrets in source folder to destination folder

```
vaku folder move secret/foo secret/bar
```

Move a secret from a source path to a destination path

```
vaku path move secret/foo secret/bar
```

Recursively search all secrets in a folder for a search string (`-p` makes it show the full path)

```
vaku folder search my-mount-point okta -p
```

And sooo much more. See the full docs here: https://github.com/lingrino/vaku/tree/main/docs/cli





## Vault UI

Okay, it's not a cli, but it gives you a pretty web or desktop interface to browse and manipulate your vault. Built with React. It's somewhat outdated, but still does the trick.  

https://github.com/djenriquez/vault-ui



## Writing Values to Vault with standard Vault Cli

```
vault write secret/awskeys access_key=abcd secret_key=zyxvw
```

WARNING: All key/value pairs must be specified as it totally overwrites the path with only the data in the key/value pairs, so if you don't included an existing key/value pari it will disappear from the vault. 