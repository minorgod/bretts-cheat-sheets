# Set up Nginx as an rtmp stream server on Alpine Linux

```bash
# update repository
apk update
# install openrc, nginx, nano, etckeeper, ffmpeg, faac
apk add openrc nginx nano etckeeper ffmpeg faac

#make the run dir for the nginx pid and lock file
mkdir -p /run/nginx

mkdir /www
chown -R www:www /var/lib/nginx
chown -R www:www /www

# commit your your config to a git repository
etckeeper commit "Initial config in /etc"
# etckeeper will auto-commit your /etc dir once a day, but if you want
# it more often, just move the cron script from 
# /etc/periodic/daily/etckeeper
# to
# /etc/periodic/hourly/etckeeper
# or one of the other periodic folders


# create user for nginx
#adduser -g 'Nginx www user' -h /home/www-data/ www-data
adduser -D -g 'www' www

#set up nginx-mod-rtmp
apk add nginx-mod-rtmp
or
apk add nginx-rtmp-module


#make a directory for hls and dash streaming
mkdir /tmp/hls
mkdir /tmp/dash


#make nginx start on boot
rc-update add nginx default
# or manually start nginx via
# rc-service nginx start


```

