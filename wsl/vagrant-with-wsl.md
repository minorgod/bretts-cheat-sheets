# Special ENV vars for use with Vagrant and WSL

**See: https://www.vagrantup.com/docs/other/wsl.html**

```
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/temp"
```

Other useful WSL related environment variables:

- [`VAGRANT_WSL_WINDOWS_ACCESS_USER`](https://www.vagrantup.com/docs/other/wsl.html#vagrant_wsl_windows_access_user) - Override current Windows username
- [`VAGRANT_WSL_DISABLE_VAGRANT_HOME`](https://www.vagrantup.com/docs/other/wsl.html#vagrant_wsl_disable_vagrant_home) - Do not modify the `VAGRANT_HOME` variable
- [`VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH`](https://www.vagrantup.com/docs/other/wsl.html#vagrant_wsl_windows_access_user_home_path) - Custom Windows system home path

If a Vagrant project directory is not within the user's home directory on the Windows system, certain actions that include permission checks may fail (like `vagrant ssh`). When accessing Vagrant projects outside the WSL Vagrant will skip these permission checks when the project path is within the path defined in the `VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH` environment variable. For example, if a user wants to run a Vagrant project from the WSL that is located at `C:\TestDir\vagrant-project`:

```shell-session
C:\Users\vagrant> cd C:\TestDir\vagrant-project
C:\TestDir\vagrant-project> bash
vagrant@vagrant-10:/mnt/c/TestDir/vagrant-project$ export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/TestDir"
vagrant@vagrant-10:/mnt/c/TestDir/vagrant-project$ vagrant ssh
```

## [Using Docker](https://www.vagrantup.com/docs/other/wsl.html#using-docker)

The docker daemon cannot be run inside the Windows Subsystem for Linux. However, the daemon *can* be run on Windows and accessed by Vagrant while running in the WSL. Once docker is installed and running on Windows, export the following environment variable to give Vagrant access:

```shell-session
vagrant@vagrant-10:/mnt/c/Users/vagrant$ export DOCKER_HOST=tcp://127.0.0.1:2375
```

