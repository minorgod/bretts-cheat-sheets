# Laravel setup commands

**Install laravel installer and create a new site.**

```
 composer global require laravel/installer
 laravel new blog
 cd blog
```

**Install Laravel Dusk for browser testing**

```
composer require --dev laravel/dusk
php artisan dusk:install
```

**Generate all the tables and stubs...****

```
php artisan key:generate
php artisan cache:table
#php artisan make:auth
php artisan notifications:table
php artisan queue:table
php artisan migrate:fresh
php artisan storage:link
php artisan db:seed
composer dump autoload
php artisan vendor:publish
```

**Add some other packages:** 

```
composer require laravel/ui anahkiasen/former laravelcollective/html bestmomo/filemanager anahkiasen/former
php artisan vendor:publish --provider="Former\FormerServiceProvider"
php artisan vendor:publish --provider="Bestmomo\Filemanager\FilemanagerServiceProvider"
php artisan vendor:publish --provider="Former\FormerServiceProvider"
```

**add scaffolding for vue**

```
php artisan ui vue
// Generate basic scaffolding...
php artisan ui vue
php artisan ui vue --auth
```

