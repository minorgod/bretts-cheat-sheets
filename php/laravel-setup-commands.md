# Laravel setup commands

## Install laravel installer and create a new site.

```shell
 composer global require laravel/installer
 laravel new blog
 cd blog
```

## Set up SQLite config for quick db testing -- this is so you don't have to hassle with creating a real db just to get started. Otherwise all your migrations and db seeding will fail during setup. 

If you are doing this in windows you need to prefix these linux commands with `wsl -e`. Of course you'll also need to have some default linux distro installed for wsl to support the `touch` and `sed` commands. 

```
touch ./database/database.sqlite
# Change the .env file to use sqlite for the DB_CONNECTION instead of mysql
sed -E -i "s/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/" ./.env
# Comment out the DB_NAME because laravel will look for ./database/database.sqlite if there is no DB_NAME defined. 
sed -E -i "s/(DB_DATABASE=laravel)/#\1/" ./.env
```

## Install Laravel IDE Helper

Check out the [Larvel IDE Helper github project](https://github.com/barryvdh/laravel-ide-helper) for full documentation. 

```bash
composer require --dev barryvdh/laravel-ide-helper
php artisan clear-compiled
# PHPDoc generation for Laravel Facades
php artisan ide-helper:generate
# PHPDocs for models - this only works if you have a db to instrospect for column and relationship info. 
php artisan ide-helper:models
# You can force the phpdoc comments to be written to models by adding --write 
# but be sure you have your files committed to GIT or backed up somewhere first. 
# php artisan ide-helper:models --write
# PhpStorm Meta file
php artisan ide-helper:meta
```

Also add this to your composer "scripts" section:

```json
{
    "scripts": {
        "post-update-cmd": [
            "Illuminate\\Foundation\\ComposerScripts::postUpdate",
            "@php artisan ide-helper:generate",
            "@php artisan ide-helper:meta"
        ]
    },
}
```

You can also publish the config file to change implementations (ie. interface to specific class) or set defaults for --helpers.

```bash
php artisan vendor:publish --provider="Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider" --tag=config
```

## Install Laravel UI package to generate basic scaffolding

```
composer require laravel/ui
```

## Install Laravel Dusk for browser testing

```shell
composer require --dev laravel/dusk
php artisan dusk:install
```

## Generate the app key and all tables and stubs...**

```shell
php artisan key:generate
php artisan cache:table
php artisan notifications:table
php artisan queue:table
php artisan ui:auth
php artisan ui:controllers
php artisan migrate:fresh
php artisan storage:link
php artisan db:seed
php artisan package:discover
# only publish stubs if you want to customize the default stubs when using the artisan "make" commands
# php artisan stub:publish
php artisan vendor:publish
```

## Add some other packages: 

```
composer require laravel/ui anahkiasen/former laravelcollective/html bestmomo/filemanager anahkiasen/former
php artisan vendor:publish --provider="Former\FormerServiceProvider"
php artisan vendor:publish --provider="Bestmomo\Filemanager\FilemanagerServiceProvider"
php artisan vendor:publish --provider="Former\FormerServiceProvider"
```

## Add scaffolding for vue

```bash
// Generate basic scaffolding...
php artisan ui vue
php artisan ui vue --auth
```

## Tidy Up

```sh
composer dump autoload
```

## Install frontend dependencies for bootstrap and add latest free fontawesome

```shell
yarn
yarn add bootstrap jquery popper.js @fortawesome/fontawesome-free
yarn run dev
```

## Install PHP Code Sniffer to help enforce PSR coding standards

```
composer global require "squizlabs/php_codesniffer=*"
```

