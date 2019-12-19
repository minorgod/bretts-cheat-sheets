# Change Default Editor to Nano on Centos 7

## Disable Word Wrap

nano, by default, enables word wrap. While nice in a normal document, this is generally undesirable in a configuration file.

```
echo "set nowrap" >>/etc/nanorc
```

## System Default Editor

During login, a number of scripts are run to setup the environment. In CentOS, a file for each subject is used. These are stored in a system profile directory, /etc/profile.d/. There are two environment variables that control which editor to use.

```
cat <<EOF >>/etc/profile.d/nano.sh
export VISUAL="nano"
export EDITOR="nano"
EOF
```

## Per User Default

If a user wishes to set the default editor for themselves, it can be, instead, be done in the user's bash profile.

```
cat <<EOF >>~/.bash_profile
export VISUAL="nano"
export EDITOR="nano"
EOF
```